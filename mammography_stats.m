% Elaborazione di Dati Biomedici - Esercitazione n*1.
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

% Acquisizione del grandezza del dataset originale
originalDataLength = height(dataset);

% Classificazione delle variabili
% BIRADS:   ordinale 
% Age:      rapporti  
% Shape:    nominale 
% Margin:   nominale
% Density:  nominale
% Severity: nominale

%% PUNTO n*2 - Controllo di qualit� sui dati del dataset

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
% unit� non ritenute valide.
validStatUnits = height(dataset); 

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

%% PUNTO n*3 - Sintesi delle varie serie di dati attraverso tabelle di freq

% Valutazione del campo di variazione e riassunto deii dati in tabelle 
% di frequenza calcolando dove possibile frequenze assolute, relative 
% e cumulate.
% Commenti: La divisione in classi risulta particolarmente utile nel
% ricavare le tabelle di frequenza delle eta dato l'ampio range, mentre per
% le altre variabili � ragionevole mantenere la classificazione "naturale".

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

%% PUNTO n*4 - Sintesi qualitativa delle informazioni nei due gruppi

% Calcolo delle misure di tendenza centrale sulla variabile BIRADS facendo
% distinzione tra tumori maligni e benigni.
biradsMedianB = nanmedian(dBenign.BIRADS);
biradsMedianM = nanmedian(dMalignant.BIRADS);
biradsModeB = mode(dBenign.BIRADS);
biradsModenM = mode(dMalignant.BIRADS);
% Calcolo delle misure di tendenza centrale sulla variabile Age facendo
% distinzione tra tumori maligni e benigni.
ageMedianB = nanmedian(dBenign.Age);
ageMedianM = nanmedian(dMalignant.Age);
ageMeanB = nanmean(dBenign.Age);
ageMeanM = nanmean(dMalignant.Age);
ageModeB = mode(dBenign.Age);
ageModeM = mode(dMalignant.Age);
% Calcolo delle misure di tendenza centrale sulla variabile Shape facendo
% distinzione tra tumori maligni e benigni.
shapeModeB = mode(dBenign.Shape);
shapeModeM = mode(dMalignant.Shape);
% Calcolo delle misure di tendenza centrale sulla variabile Margin facendo
% distinzione tra tumori maligni e benigni.
marginModeB = mode(dBenign.Margin);
marginModeM = mode(dMalignant.Margin);
% Calcolo delle misure di tendenza centrale sulla variabile Density facendo
% distinzione tra tumori maligni e benigni.
densityModeB = mode(dBenign.Density);
densityModeM = mode(dMalignant.Density);

% Calcolo delle misure di dispersione sulla variabile Age facendo
% distinzione tra tumori maligni e benigni.
ageVarB = var(dBenign.Age);
ageVarM = nanvar(dMalignant.Age);
ageStdB = std(dBenign.Age);
ageStdM = nanstd(dMalignant.Age);



