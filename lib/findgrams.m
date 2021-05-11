% t is an array vector of string tokens (usually singl-word tokens).
% findgrams returns all the unique n-length grams (n-grams) in t
function g = findgrams(tokens, n)
    arguments
        tokens string;
        n double;
    end
    
    g = strings(length(tokens) - (n - 1), n);
    for i = 1:length(tokens) - (n - 1)
        g(i, 1:n) = tokens(i:i + n - 1)';
    end
    
    g = unique(g, 'rows')';
end