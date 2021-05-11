
function model = train(folder, nvArgs)
    arguments
        folder string;
        nvArgs.n double = 1;
        nvArgs.keepfluff logical = 0;
        nvArgs.bin logical = 0;
        nvArgs.laplace double = 1;
        nvArgs.minfreq double = 1;
    end
    
    n = nvArgs.n;
    keepfluff = nvArgs.keepfluff;
    bin = nvArgs.bin;
    a = nvArgs.laplace;
    minfreq = nvArgs.minfreq;
    
    dirs = dir(folder);
    dirs = dirs([dirs.isdir]); % filter out folders
    dirs = dirs(~ismember({dirs.name}, {'.', '..'})); % ignore current/parent directory
    
    ngrams = containers.Map;
    collections = containers.Map;
    for i = 1:length(dirs)
        d = dirs(i);
        dn = fullfile(d.folder, d.name);
        files = dir(fullfile(dn, '*.txt'));
        
        ng = containers.Map;
        for j = 1:length(files) % loop through every text file and clean/tokenize it
            file = files(j);
            txt = fileread(fullfile(file.folder, file.name)); % string inside the text file
            
            tokens = tokenize(txt); % all the words in txt
            
            if (~keepfluff); tokens = rm_fluff(tokens); end % remove fluffwords
            
            grams = findgrams(tokens, n); % find the n-grams of the text without fluff
            
            for k = 1:size(grams, 2) % loop through each n-gram, count appearances, add it to ngrams
                g = grams(:, k);
                c = hasgrams(tokens, g);
                if (bin); c = c > 0; end
                key = join(g); % keys must be character vectors
                if (~isKey(ng, key)); ng(key) = 0; end % if it's not already in ngrams, create an entry for it
                ng(key) = ng(key) + c; % then add the frequency
            end
        end
        
        rminfreq(ng, minfreq);
        
        collections(d.name) = ng;
        ngrams = map_union(ngrams, ng);
    end
    
    for i = 1:length(dirs)
        d = dirs(i);
        ng = collections(d.name);
        p = nb_probs(ng, ngrams, a);
        collections(d.name) = {ng, p};
    end
    
    model = struct('collections', collections, 'ngrams', ngrams, 'n', n,'keepfluff', keepfluff, 'minfreq', minfreq, 'bin', bin, 'laplace', a);
end
