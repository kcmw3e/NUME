function [vocab, count, texts, m] = train(folder)
    files = dir(fullfile(folder, '*.txt')); % get all the text file names
    
    texts = cell(size(files));
    counts = containers.Map;
    for i = 1:length(files)
        file = files(i);
        txt = fileread(fullfile(file.folder, file.name));
        tokens = tokenize(txt);
        uniques = unique(tokens);
        uniques = rm_fluff(uniques);
        
        texts{i} = tokens;
        
        for j = 1:length(uniques)
            word = uniques(j);
            n = sum(word == tokens);
            if (~isKey(counts, word)); counts(word) = 0; end
            counts(word) = counts(word) + n;
        end
    end
    vocab = keys(counts)';
    count = values(counts)';
    
    vocab = string(vocab);
    count = cell2mat(count);
    
    m = counts;
end
