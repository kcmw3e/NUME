% Takes a string array of words and removes the words in the file
% fluffwords.txt and returns the unique set of remaining words as a string
% array column vector. flffwords.txt should be a text file containing words
% separated by whitespace (see tokenize.m for detauls on how this is done).
% The output order of words is not guaranteed or defined.
%
% Example:
%   w = ["This", "is", "a", "string", "with", "a", "duplicate"];
%   w = rm_fluff(w);
%   w == ["string", "with", "duplicate"]; % given that flfuffwords.txt contains "this", "a", and "is"
function nofluff = rm_fluff(tokens)
    arguments
        tokens string;
    end
    
    persistent fluffwords; % fluffwords is always the same (see fluffwords.txt)
    if (isempty(fluffwords))
        str = fileread('fluffwords.txt');
        fluffwords = [tokenize(str); '']; % add empty string to fluff
    end
    
    nofluff = strings(size(tokens));
    for i = 1:length(tokens)
        t = tokens(i);
        if (~any(t == fluffwords)); nofluff(i) = t; end
    end
    nofluff = nofluff(nofluff ~= ""); % don't keep empty places
end
