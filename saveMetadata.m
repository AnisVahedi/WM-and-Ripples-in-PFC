function saveMetadata(Metadata, pathDirectory, fileName)
    fullPath = fullfile(pathDirectory, fileName);
    save(fullPath, 'Metadata', '-v7.3');
end
