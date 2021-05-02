function words = rm_fluff(words)
    arguments
        words string;
    end
    
    persistent fluffwords; % fluffwords is always the same (see fluffwords.txt)
    if (isempty(fluffwords))
        str = fileread('fluffwords.txt');
        fluffwords = [tokenize(str); '']; % add empty string to fluff
    end
    
    words = setdiff(words, fluffwords); % remove all the fluff words that don't have much meaning/use
    %uniques = unique(words); % make into a set of only unique words (no repeats)
end
