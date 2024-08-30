 function filteredMetadata = addMatDataToTableOptimized(Metadata, monkeyName, neuron_data_directory, lfp_data_directory)
 % Handle neuron data - Preprocessing
 neuron_files = dir(fullfile(neuron_data_directory, '*.mat'));
 neuron_filenames = {neuron_files.name};
 split_neuron_filenames = cellfun(@(f) split(f, '_'), neuron_filenames, 'UniformOutput', false);
 Filename_2s_neuron = cellfun(@(x) strjoin(x(1:end-1), '_'), split_neuron_filenames, 'UniformOutput', false);
 Neuron_2s = cellfun(@(x) str2double(x{end}(1:end-4)), split_neuron_filenames);
 
 % Handle LFP data - Preprocessing
 lfp_files = dir(fullfile(lfp_data_directory, '*.mat'));
 lfp_filenames = {lfp_files.name};
 split_lfp_filenames = cellfun(@(f) regexp(f, '^(.*?)_CH(\d+)[L]?_S(\d+)\.mat$', 'tokens'), lfp_filenames, 'UniformOutput', false);
 
 % Filter rows for the current monkey to avoid unnecessary comparisons
 monkeyRows = strcmpi(Metadata.Monkey, monkeyName);
 filteredMetadata = Metadata(monkeyRows, :);
 
 % Initialize columns for LFP data if they don't exist
 filenamesWithLFP = {}; % To keep track of filenames for which LFP data has been added
 filenamesWith_lfpKey={};
 sessionTypes = {'S6', 'S7'};
 
 for k = 1:length(lfp_files)
     token = split_lfp_filenames{k};
     if isempty(token)
         continue; % Skip if filename does not match expected pattern
     end
     filename = token{1}{1};
     channel = str2double(token{1}{2});
     sessionType = token{1}{3}; % 'S6' or 'S7'
     lfpKey = sprintf('%s_ch%d_%s',filename, channel, sessionType);
     
     % Dynamically determine the column name for LFP data
     lfpColName = sprintf('LFP_CH%d_%s', channel, sessionType);
     if ~ismember(lfpColName, filteredMetadata.Properties.VariableNames)
         filteredMetadata.(lfpColName) = cell(height(filteredMetadata), 1); % Initialize new column if not exists
     end
     
     % Check if LFP data for this filename has been already added
     if ~ismember(filename,filenamesWith_lfpKey)
         matchIdx = strcmpi(filteredMetadata.Filename, filename);
         if any(matchIdx)
             loadedData = load(fullfile(lfp_data_directory, lfp_filenames{k}));
             lfpFieldName = sprintf('LFPS%s', sessionType); % 'LFPS6' or 'LFPS7'
             % Assign LFP data to the respective new column for the first matching row
             firstMatchIdx = find(matchIdx, 1, 'first');
             filteredMetadata.(lfpColName){firstMatchIdx} = loadedData.(lfpFieldName);
             filenamesWithLFP{end+1} = filename; % Record that LFP data has been added for this filename
             filenamesWith_lfpKey{end+1} = lfpKey;
         end
     end
 end
 
 % Process neuron files only for entries with corresponding LFP data
 for k = 1:length(neuron_files)
     filenameNeuron = Filename_2s_neuron{k};
     neuronNumber = Neuron_2s(k);
     % Check if neuron file's corresponding filename has LFP data
     if ismember(lower(filenameNeuron), lower(filenamesWithLFP))
         matchIdx = strcmpi(filteredMetadata.Filename, filenameNeuron) & filteredMetadata.Neuron == neuronNumber;
         if any(matchIdx)
             loadedData = load(fullfile(neuron_data_directory, neuron_filenames{k}));
             filteredMetadata.MatData(matchIdx) = {loadedData.MatData};
         end
     end
 end
 
 end