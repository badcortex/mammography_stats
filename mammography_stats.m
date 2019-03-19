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

% Classificazione delle variabili
% BIRADS:   ordinale 
% Age:      rapporti  
% Shape:    nominale 
% Margin:   nominale
% Density:  nominale
% Severity: nominale

%% PUNTO n*2 - Controllo di qualità sui dati del dataset

% BIRADS: Deve essere compreso tra 1-5.
% Age:    La mammografia viene effettuata dopo lo sviluppo del seno.
% Altro:  Verifica che Shape, Margin, Dnsity e Severity assumano valori
%         consentiti.

% Eliminazione delle unita' statistica con almeno una variabile che assume
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

