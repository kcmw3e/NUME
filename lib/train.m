% Trains a dataset based on Naive Bayes assumption. folder is the path to a
% directory that should contain a set of text files. Each text file will be
% cleaned according to the functions tokenize() and rm_fluff() -- see
% respective *.m files for details.
% There are 4 return values:
%   vocab --> a string array column vector of all the unique words that
%             appear in every text in the directory
%   count --> a column vector of numbers corresponding to the number of
%             times every word in vocab appears between all of the texts in
%             the directory
%   texts --> a cell array column vector consisting of all the string
%             arrays of tokens from each text file in the directory
%             (see tokenize.m for how texts are tokenized)
%   map   --> a MATLAB containers.Map object containing the set of word
%             tokens found in vocab mapped to the frequencies found in
%             count
% Note that the index of a word in vocab corresponds to its frequency in
% count by the same index. If lookup of the frequency of a given word is
% needed for many words among a large voabulary, it is best to use map as
% using vocab and count for this purpose is likely to be extremely
% inefficient. Also, the order of vocab and texts (and by extension
% count)is not guaranteed or defined.
%
% Example:
%   % assuming the following dataset
%   % myfolder/| t1.txt --> 'Hello world!'
%   %          | t2.txt --> 'some text'
%   %          | t3.txt --> 'Goodbye world :('
%
%   [vocab, count, texts, map] = train('[path_to]/myfolder');
%   % vocab = ["hello"; "world"; "some"; "text"; "goodbye"] (not necessarily in that order)
%   % count = [ 1;       2;       1;      1;      1] corresponding to the above vocab
%   % texts = {["hello"; "world"]; ["some", "text"]; ["goodbye", "world"]}
%   % map will be a MATLAB containers.Map as described
function [vocab, count, texts, map] = train(folder)
    arguments
        folder string;
    end
    
    files = dir(fullfile(folder, '*.txt')); % get all the text file names
    
    texts = cell(size(files)); % preallocate texts cell array for efficiency
    counts = containers.Map;
    for i = 1:length(files) % loop through every text file and clean/tokenize it
        file = files(i);
        txt = fileread(fullfile(file.folder, file.name)); % string inside the text file
        
        tokens = tokenize(txt); % all the words in txt
        uniques = unique(tokens); % only unique words
        uniques = rm_fluff(uniques); % remove fluffwords
        
        texts{i} = tokens;
        
        for j = 1:length(uniques) % loop through each unique word, count appearances, add it to counts map
            word = uniques(j);
            n = sum(word == tokens); % frequency in tokens
            if (~isKey(counts, word)); counts(word) = 0; end % if it's not already in counts, create an entry for it
            counts(word) = counts(word) + n; % then add the frequency
        end
    end
    
    vocab = keys(counts)';
    count = values(counts)';
    
    vocab = string(vocab); % keys() gives back cell array of character vectors
    count = cell2mat(count); % values() gives back cell array of numbers
    
    map = counts;
end
