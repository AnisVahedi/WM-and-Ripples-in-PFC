function Metadata = processMetadata(csvPath, monkeyName, lfpDataDir, varargin)
    % Load CSV file and convert to a table
    Metadata = readtable(csvPath, 'VariableNamingRule', 'preserve');
    Metadata.MatData = cell(height(Metadata), 1); % Initialize column if it doesn't exist

    % Check if we are processing just LFP data
    if ~isempty(varargin) && islogical(varargin{1}) && varargin{1}
        % Process only LFP data
        Metadata = addMatDataToTableOptimizedJustLFP(Metadata, monkeyName, lfpDataDir);
    else
        % Process both neuron and LFP data
        neuronDataDir = varargin{1}; % Assuming the second argument is neuronDataDir
        Metadata = addMatDataToTableOptimized(Metadata, monkeyName, neuronDataDir, lfpDataDir);
    end

    % Get the subset of the table from the 16th column to the end
    subTable = Metadata(:, 15:end);

    % Remove rows where all entries in a row of subTable are empty
    rowsToRemove = all(cellfun(@isempty, table2cell(subTable), 'UniformOutput', true), 2);
    Metadata(rowsToRemove, :) = [];
end
