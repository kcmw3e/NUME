function tokens = tokenize(str)
    arguments
        str string;
    end
    
    persistent unwanted; % same unwanted characters every time called, see an ascii chart for list of characters by decimal number
    if (isempty(unwanted))
        unwanted = split(char([1:31, 33:64, 91:96, 123:126]), ''); % unwanted punctuation, etc
        unwanted = unwanted(2: end-1); % first and last are extra empty strings so begone with them
    end
    
    chars = char(str);
    chars = lower(chars); % turn everything to lower case for uniformity across reviews
    chars = strip(chars); % remove bad whitespaces
    chars = split(chars); % tokenize into words

    tokens = erase(chars, unwanted); % remove the unwanted characters
    tokens = join(tokens); % put it all into one char vector
    tokens = split(string(tokens{1})); % make tokens a string array of the words
end
