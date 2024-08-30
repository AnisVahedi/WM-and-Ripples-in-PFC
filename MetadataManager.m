


classdef MetadataManager
    properties
        CsvPath
        NeuronDataDirectory
        LFPDataDirectory
        MonkeyName
        JustLFP % Flag to indicate if only LFP data should be processed
    end

    methods
        % Constructor
        function obj = MetadataManager(csvPath, monkeyName, lfpDataDir, neuronDataDir, justLFP)
            obj.CsvPath = csvPath;
            obj.MonkeyName = monkeyName;
            obj.LFPDataDirectory = lfpDataDir;
            obj.NeuronDataDirectory = neuronDataDir; % This can be empty
            if nargin < 5
                obj.JustLFP = false; % Default is to process both LFP and neuron data
            else
                obj.JustLFP = justLFP;
            end
        end

        % Process Metadata
        function Metadata = process(obj)
            if obj.JustLFP
                % Process only LFP data
                Metadata = processMetadata(obj.CsvPath, obj.MonkeyName, obj.LFPDataDirectory, true);
            else
                % Process both neuron and LFP data
                Metadata = processMetadata(obj.CsvPath, obj.MonkeyName, obj.NeuronDataDirectory, obj.LFPDataDirectory);
            end
        end

        % Save Metadata
        function save(obj, Metadata, pathDirectory, fileName)
            saveMetadata(Metadata, pathDirectory, fileName);
        end
    end
end
