% Elaborazione di Dati Biomedici - Esercitazione n*1.
% Autore: Andrea Panno

clear;
close all;

%% PUNTO n*1 - Lettura dei dati dal dataset e memorizzazione in tabella

% Lettura dei dati dal dataset "mammographic_masses.txt"
dataset = readtable('mammographic_masses.txt','Delimiter',',',...
                    'HeaderLines',0,'ReadVariableNames',false,'TreatAsEmpty',{'?'});

% Asseganzione dei nomi alle variabili
dataset.Properties.VariableNames{1} = 'BIRADS';   % Classificatore tumore
dataset.Properties.VariableNames{2} = 'Age';      % Eta' del paziente
dataset.Properties.VariableNames{3} = 'Shape';    % Forma della massa tumorale
dataset.Properties.VariableNames{4} = 'Margin';   % Bordi della massa tumorale
dataset.Properties.VariableNames{5} = 'Density';  % Densita' della massa
dataset.Properties.VariableNames{6} = 'Severity'; % Benigno / maligno

% Acquisizione della grandezza del dataset originale
originalDataLength = height(dataset);

% Calcolo del numero di tumori benigni / maligni
numBenign = height(dataset(dataset.Severity == 0,:));
numMalignant = height(dataset(dataset.Severity == 1,:));

% Classificazione delle variabili
% BIRADS:   ordinale 
% Age:      rapporti  
% Shape:    nominale 
% Margin:   nominale
% Density:  nominale
% Severity: nominale

%% PUNTO n*2 - Controllo di qualita sui dati del dataset

% BIRADS: Deve essere compreso tra 1-5.
% Age:    La mammografia viene effettuata dopo lo sviluppo del seno.
% Altro:  Verifica che Shape, Margin, Dnsity e Severity assumano valori
%         consentiti.

% Eliminazione delle unita' statistiche con almeno una variabile che assume
% valori fuori dal dominio dei valori consentiti.
dataset(dataset.BIRADS == 0 | dataset.BIRADS > 5 | ...
        dataset.Age < 18 | dataset.Age > 90 | ...
        dataset.Shape < 1 | dataset.Shape > 4 | ...
        dataset.Margin < 1 | dataset.Margin > 5 | ...
        dataset.Density < 1 | dataset.Density > 4 | ...
        dataset.Severity < 0 | dataset.Severity > 1,:) = [];

% Calcolo dei dati mancanti per ciscuna variabile facendo distinzione tra
% le categorie diagnostiche.
% Split del dataset in base alle due categorie diagnostiche.
dBenign = dataset(dataset.Severity == 0,:);
dMalignant = dataset(dataset.Severity == 1,:);

% Calcolo del numero di unita statistiche valide totali e per ciascuna
% categoria diagnostica.
% Il conteggio delle unita statistiche totali valide viene effettuato
% ricavando la lunghezza del dataset da cui sono state eliminate le 
% unita non ritenute valide. 

validBiradsB = length(find(~isnan(dBenign.BIRADS)));
validAgeB = length(find(~isnan(dBenign.Age)));
validShapeB = length(find(~isnan(dBenign.Shape)));
validMarginB = length(find(~isnan(dBenign.Margin)));
validDensityB = length(find(~isnan(dBenign.Density)));

validBiradsM = length(find(~isnan(dMalignant.BIRADS)));
validAgeM = length(find(~isnan(dMalignant.Age)));
validShapeM = length(find(~isnan(dMalignant.Shape)));
validMarginM = length(find(~isnan(dMalignant.Margin)));
validDensityM = length(find(~isnan(dMalignant.Density)));

% Conteggio dei dati mancanti per ciascuna variabile per le due categorie
% diagnostiche.
missingBiradsB = length(find(isnan(dBenign.BIRADS)));
missingAgeB = length(find(isnan(dBenign.Age)));
missingShapeB = length(find(isnan(dBenign.Shape)));
missingMarginB = length(find(isnan(dBenign.Margin)));
missingDensityB = length(find(isnan(dBenign.Density)));

missingBiradsM = length(find(isnan(dMalignant.BIRADS)));
missingAgeM = length(find(isnan(dMalignant.Age)));
missingShapeM = length(find(isnan(dMalignant.Shape)));
missingMarginM = length(find(isnan(dMalignant.Margin)));
missingDensityM = length(find(isnan(dMalignant.Density)));

% Eliminazione delle unità statistiche con valori mancanti.
dataset(isnan(dataset.BIRADS) | isnan(dataset.Age) | ...
        isnan(dataset.Shape) | isnan(dataset.Margin) | ...
        isnan(dataset.Density) | isnan(dataset.Severity),:) = [];  
% Aggiornamento dataset splittato.
dBenign = dataset(dataset.Severity == 0,:);
dMalignant = dataset(dataset.Severity == 1,:);

validDataLength = height(dataset);

% Generazione dei grafici sulla qualita dataset.
figure(1);
pie([validDataLength,originalDataLength - validDataLength]);
title('Analisi unità statistiche')
validUnits = strcat('# Unità stat. valide:',{' '},string(validDataLength));
invalidUnits = strcat('# Unità stat. non valide:',{' '},string(originalDataLength - validDataLength));
legend({validUnits,invalidUnits},'Location','bestoutside');

figure(2);
pie([height(dBenign),height(dMalignant)]);
title('Suddivisione tumori (dataset validato)');
benign = strcat('# Tumori benigni:',{' '},string(height(dBenign)));
malignant = strcat('# Tumori maligni:',{' '},string(height(dMalignant)));
legend({benign,malignant},'Location','bestoutside');

figure(3);
bar([missingAgeB,missingAgeM; ... 
    missingBiradsB,missingBiradsM; ...
    missingDensityB,missingDensityM; ...
    missingMarginB,missingMarginM; ...
    missingShapeB,missingShapeM]);
set(gca,'XTickLabel',{'Age','Birads','Density','Margin','Shape'});
title('Unità statistiche mancanti');
legend({'Tumori benigni','Tumori maligni'},'Location','bestoutside');

figure(4);
pie([numBenign - height(dBenign),numMalignant - height(dMalignant)]);
title('Numero di unità statistiche non valide');
benign = strcat('# Righe tumori benigni:',{' '},string(numBenign - height(dBenign)));
malignant = strcat('# Righe tumori maligni:',{' '},string(numMalignant - height(dMalignant)));
legend({benign,malignant},'Location','bestoutside');

%% Suddivisione in classi per la variabile Age
% Suddivido i valori assunti dalla variabile Age in classi di ampiezza pari
% a 10 anni. Considerazioni min(dataset)=18 e max(dataset)=88.

% Vettori delle eta suddivisi in classi
bAges = []; % Tumori benigni
mAges = []; % Tumori maligni

bAges = length(discretize(dBenign.Age,18:1:27)) - sum(isnan(discretize(dBenign.Age,18:1:27)));
bAges = [bAges, length(discretize(dBenign.Age,28:1:37)) - sum(isnan(discretize(dBenign.Age,28:1:37)))];
bAges = [bAges, length(discretize(dBenign.Age,38:1:47)) - sum(isnan(discretize(dBenign.Age,38:1:47)))];
bAges = [bAges, length(discretize(dBenign.Age,48:1:57)) - sum(isnan(discretize(dBenign.Age,48:1:57)))];
bAges = [bAges, length(discretize(dBenign.Age,58:1:67)) - sum(isnan(discretize(dBenign.Age,58:1:67)))];
bAges = [bAges, length(discretize(dBenign.Age,68:1:77)) - sum(isnan(discretize(dBenign.Age,68:1:77)))];
bAges = [bAges, length(discretize(dBenign.Age,78:1:88)) - sum(isnan(discretize(dBenign.Age,78:1:88)))];

mAges = length(discretize(dMalignant.Age,18:1:27)) - sum(isnan(discretize(dMalignant.Age,18:1:27)));
mAges = [mAges, length(discretize(dMalignant.Age,28:1:37)) - sum(isnan(discretize(dMalignant.Age,28:1:37)))];
mAges = [mAges, length(discretize(dMalignant.Age,38:1:47)) - sum(isnan(discretize(dMalignant.Age,38:1:47)))];
mAges = [mAges, length(discretize(dMalignant.Age,48:1:57)) - sum(isnan(discretize(dMalignant.Age,48:1:57)))];
mAges = [mAges, length(discretize(dMalignant.Age,58:1:67)) - sum(isnan(discretize(dMalignant.Age,58:1:67)))];
mAges = [mAges, length(discretize(dMalignant.Age,68:1:77)) - sum(isnan(discretize(dMalignant.Age,68:1:77)))];
mAges = [mAges, length(discretize(dMalignant.Age,78:1:88)) - sum(isnan(discretize(dMalignant.Age,78:1:88)))];

% Suddivisione in classi del dataset 
dataAges = [];
dataAges = length(discretize(dataset.Age,18:1:27)) - sum(isnan(discretize(dataset.Age,18:1:27)));
dataAges = [dataAges, length(discretize(dataset.Age,28:1:37)) - sum(isnan(discretize(dataset.Age,28:1:37)))];
dataAges = [dataAges, length(discretize(dataset.Age,38:1:47)) - sum(isnan(discretize(dataset.Age,38:1:47)))];
dataAges = [dataAges, length(discretize(dataset.Age,48:1:57)) - sum(isnan(discretize(dataset.Age,48:1:57)))];
dataAges = [dataAges, length(discretize(dataset.Age,58:1:67)) - sum(isnan(discretize(dataset.Age,58:1:67)))];
dataAges = [dataAges, length(discretize(dataset.Age,68:1:77)) - sum(isnan(discretize(dataset.Age,68:1:77)))];
dataAges = [dataAges, length(discretize(dataset.Age,78:1:88)) - sum(isnan(discretize(dataset.Age,78:1:88)))];

%% PUNTO n*3 - Sintesi delle varie serie di dati attraverso tabelle di freq

% Valutazione del campo di variazione e riassunto deii dati in tabelle 
% di frequenza calcolando dove possibile frequenze assolute, relative 
% e cumulate.
% Commenti: La divisione in classi risulta particolarmente utile nel
% ricavare le tabelle di frequenza delle eta dato l'ampio range, mentre per
% le altre variabili e' ragionevole mantenere la classificazione "naturale".

fTblBiradsB = tabulate(dBenign.BIRADS);
fTblBiradsB = array2table(fTblBiradsB);
fTblBiradsB.Properties.VariableNames = {'Valori','FreqAss','FreqRel'};
fTblBiradsB = [fTblBiradsB,table(cumsum(fTblBiradsB.FreqAss))];
fTblBiradsB.Properties.VariableNames = {'Valori','FreqAss','FreqRel',...
                                        'FreqCumAss'};
fTblBiradsB = [fTblBiradsB,table(cumsum(fTblBiradsB.FreqRel))];
fTblBiradsB.Properties.VariableNames = {'Valori','FreqAss','FreqRel',...
                                        'FreqCumAss','FreqCumRel'};
% fTblAgeB = tabulate(dBenign.Age);
fTblShapeB = tabulate(dBenign.Shape);
fTblShapeB = array2table(fTblShapeB);
fTblShapeB.Properties.VariableNames = {'Valori','FreqAss','FreqRel'};
fTblShapeB = [fTblShapeB,table(cumsum(fTblShapeB.FreqAss))];
fTblShapeB.Properties.VariableNames = {'Valori','FreqAss','FreqRel',...
                                        'FreqCumAss'};
fTblShapeB = [fTblShapeB,table(cumsum(fTblShapeB.FreqRel))];
fTblShapeB.Properties.VariableNames = {'Valori','FreqAss','FreqRel',...
                                        'FreqCumAss','FreqCumRel'};

fTblMarginB = tabulate(dBenign.Margin);
fTblMarginB = array2table(fTblMarginB);
fTblMarginB.Properties.VariableNames = {'Valori','FreqAss','FreqRel'};
fTblMarginB = [fTblMarginB,table(cumsum(fTblMarginB.FreqAss))];
fTblMarginB.Properties.VariableNames = {'Valori','FreqAss','FreqRel',...
                                        'FreqCumAss'};
fTblMarginB = [fTblMarginB,table(cumsum(fTblMarginB.FreqRel))];
fTblMarginB.Properties.VariableNames = {'Valori','FreqAss','FreqRel',...
                                        'FreqCumAss','FreqCumRel'};
fTblDensityB = tabulate(dBenign.Density);
fTblDensityB = array2table(fTblDensityB);
fTblDensityB.Properties.VariableNames = {'Valori','FreqAss','FreqRel'};
fTblDensityB = [fTblDensityB,table(cumsum(fTblDensityB.FreqAss))];
fTblDensityB.Properties.VariableNames = {'Valori','FreqAss','FreqRel',...
                                        'FreqCumAss'};
fTblDensityB = [fTblDensityB,table(cumsum(fTblDensityB.FreqRel))];
fTblDensityB.Properties.VariableNames = {'Valori','FreqAss','FreqRel',...
                                        'FreqCumAss','FreqCumRel'};

fTblBiradsM = tabulate(dMalignant.BIRADS);
fTblBiradsM = array2table(fTblBiradsM);
fTblBiradsM.Properties.VariableNames = {'Valori','FreqAss','FreqRel'};
fTblBiradsM = [fTblBiradsM,table(cumsum(fTblBiradsM.FreqAss))];
fTblBiradsM.Properties.VariableNames = {'Valori','FreqAss','FreqRel',...
                                        'FreqCumAss'};
fTblBiradsM = [fTblBiradsM,table(cumsum(fTblBiradsM.FreqRel))];
fTblBiradsM.Properties.VariableNames = {'Valori','FreqAss','FreqRel',...
                                        'FreqCumAss','FreqCumRel'};
% fTblAgeM = tabulate(dMalignant.Age);
fTblShapeM = tabulate(dMalignant.Shape);
fTblShapeM = array2table(fTblShapeM);
fTblShapeM.Properties.VariableNames = {'Valori','FreqAss','FreqRel'};
fTblShapeM = [fTblShapeM,table(cumsum(fTblShapeM.FreqAss))];
fTblShapeM.Properties.VariableNames = {'Valori','FreqAss','FreqRel',...
                                        'FreqCumAss'};
fTblShapeM = [fTblShapeM,table(cumsum(fTblShapeM.FreqRel))];
fTblShapeM.Properties.VariableNames = {'Valori','FreqAss','FreqRel',...
                                        'FreqCumAss','FreqCumRel'};
fTblMarginM = tabulate(dMalignant.Margin);
fTblMarginM = array2table(fTblMarginM);
fTblMarginM.Properties.VariableNames = {'Valori','FreqAss','FreqRel'};
fTblMarginM = [fTblMarginM,table(cumsum(fTblMarginM.FreqAss))];
fTblMarginM.Properties.VariableNames = {'Valori','FreqAss','FreqRel',...
                                        'FreqCumAss'};
fTblMarginM = [fTblMarginM,table(cumsum(fTblMarginM.FreqRel))];
fTblMarginM.Properties.VariableNames = {'Valori','FreqAss','FreqRel',...
                                        'FreqCumAss','FreqCumRel'};
fTblDensityM = tabulate(dMalignant.Density);
fTblDensityM = array2table(fTblDensityM);
fTblDensityM.Properties.VariableNames = {'Valori','FreqAss','FreqRel'};
fTblDensityM = [fTblDensityM,table(cumsum(fTblDensityM.FreqAss))];
fTblDensityM.Properties.VariableNames = {'Valori','FreqAss','FreqRel',...
                                        'FreqCumAss'};
fTblDensityM = [fTblDensityM,table(cumsum(fTblDensityM.FreqRel))];
fTblDensityM.Properties.VariableNames = {'Valori','FreqAss','FreqRel',...
                                        'FreqCumAss','FreqCumRel'};

% Ortogramma delle frequenze assolute per la variabile "BIRADS".
figure(6);
bar([fTblBiradsB.FreqAss(1),fTblBiradsM.FreqAss(1); ...
     fTblBiradsB.FreqAss(2),fTblBiradsM.FreqAss(2); ...
     fTblBiradsB.FreqAss(3),fTblBiradsM.FreqAss(3); ...
     fTblBiradsB.FreqAss(4),fTblBiradsM.FreqAss(4); ...
     fTblBiradsB.FreqAss(5),fTblBiradsM.FreqAss(5)]);
set(gca,'XTickLabel',{'1','2','3','4','5'});
title('Frequenze BIRADS');
legend({'Tumori benigni','Tumori maligni'},'Location','bestoutside');

% Ortogramma delle frequenze assolute per la variabile "Shape".
figure(7);
bar([fTblShapeB.FreqAss(1),fTblShapeM.FreqAss(1); ...
     fTblShapeB.FreqAss(2),fTblShapeM.FreqAss(2); ...
     fTblShapeB.FreqAss(3),fTblShapeM.FreqAss(3); ...
     fTblShapeB.FreqAss(4),fTblShapeM.FreqAss(4)]);
set(gca,'XTickLabel',{'Round','Oval','Lobular','Irregular'});
title('Frequenze Shape');
legend({'Tumori benigni','Tumori maligni'},'Location','bestoutside');

% Ortogramma delle frequenze assolute per la variabile "Margin".
figure(8);
bar([fTblMarginB.FreqAss(1),fTblMarginM.FreqAss(1); ...
     fTblMarginB.FreqAss(2),fTblMarginM.FreqAss(2); ...
     fTblMarginB.FreqAss(3),fTblMarginM.FreqAss(3); ...
     fTblMarginB.FreqAss(4),fTblMarginM.FreqAss(4); ...
     fTblMarginB.FreqAss(5),fTblMarginM.FreqAss(5)]);
set(gca,'XTickLabel',{'Circumscribed','Microtubulated','Obscured','Ill-defined','Spiculated'});
title('Frequenze Margin');
legend({'Tumori benigni','Tumori maligni'},'Location','bestoutside');

% Ortogramma delle frequenze assolute per la variabile "Density".
figure(9);
bar([fTblDensityB.FreqAss(1),fTblDensityM.FreqAss(1); ...
     fTblDensityB.FreqAss(2),fTblDensityM.FreqAss(2); ...
     fTblDensityB.FreqAss(3),fTblDensityM.FreqAss(3); ...
     fTblDensityB.FreqAss(4),fTblDensityM.FreqAss(4)]);
set(gca,'XTickLabel',{'High','Iso','Low','Fat-containing'});
title('Frequenze Density');
legend({'Tumori benigni','Tumori maligni'},'Location','bestoutside');





