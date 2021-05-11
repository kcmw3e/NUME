% t1 and t2 array vectors of string tokens (typically single-word tokens).
% hasgrams determines if t1 contains the tokens in t2 in exactly the same
% order as they are in t2 (i.e. is t2 a subvector of t1) and returns the
% number of times it occurs
function c = hasgrams(tokens, grams)
    arguments
        tokens string;
        grams string;
    end
    
    j = tokens == grams(1); % get potential starting points
    n = length(grams);
    
    c = 0;
    for i = find(j)' % j was a column vector, needs to be row for for loop
        if (i + n - 1 > length(tokens)); break; end % make sure not to index out of bounds
        
        subv = tokens(i:i + n - 1); % get subvector of tokens starting from i
        c = c + all(subv == grams); % if subvector found is same as querying grams add 1
    end
end
