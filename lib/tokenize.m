% Takes a string and returns the word tokens as a string array column vector.
% Punctuation, whitespace, and other extra characters are removed (see an
% ascii chart for which characters these are). The string is split at
% whitespace characters. The output is guaranteed to be in the same order
% the tokens appear in the original string. All strings are made lowercase.
%
% Example:
%   str = "This is a string! It has whitespace and punctuation...";
%   tokens = tokenize(str);
%   tokens == ["this", "is", "a", "string", "it", "has", "whitespace", "and", "punctuation"];
function tokens = tokenize(str)
    arguments
        str string;
    end
    
    persistent unwanted; % same unwanted characters every time called, see an ascii chart for list of characters by decimal number
    if (isempty(unwanted))
        unwanted = split(char([1:31, 33:64, 91:96, 123:126]), ''); % unwanted punctuation, etc
        unwanted = unwanted(2: end-1); % first and last are extra empty strings
    end
    
    chars = char(str);
    chars = lower(chars); % turn everything to lower case for uniformity across reviews
    chars = strip(chars); % remove bad whitespaces
    chars = split(chars); % tokenize into words
    
    tokens = erase(chars, unwanted); % remove the unwanted characters
    tokens = join(tokens); % put it all into one char vector
    tokens = split(string(tokens{1})); % make tokens a string array of the words
end
