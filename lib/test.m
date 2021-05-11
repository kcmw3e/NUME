
function acc = test(folder, model)
    arguments
        folder string;
        model struct;
    end
    
    collections = model.collections;
    ngrams = model.ngrams;
    n = model.n;
    keepfluff = model.keepfluff;
    bin = model.bin;
    a = model.laplace;
    
    pos = collections("pos");
    neg = collections("neg");
    
    posgrams = pos{1};
    posprobs = pos{2};
    
    neggrams = neg{1};
    negprobs = neg{2};
    
    posd = sum(cell2mat(values(posgrams))) + a*length(ngrams);
    negd = sum(cell2mat(values(neggrams))) + a*length(ngrams);
    
    files = dir(fullfile(folder, '*.txt')); % get all the text file names
    
    acc = zeros(length(files), 1); % preallocate array for efficiency
    for i = 1:length(files) % loop through each file and clean/tokenize and test it
        file = files(i);
        info = string(split(erase(file.name, '.txt'), '_')); % file names should be '[id]_[rating].txt'
        rating = str2double(info(2));
        
        txt = fileread(fullfile(file.folder, file.name)); % string inside the text file
        
        tokens = tokenize(txt); % all the words in txt
        
        if (~keepfluff); tokens = rm_fluff(tokens); end % remove fluffwords
        
        grams = findgrams(tokens, n); % find the n-grams of the text without fluff
        
        posp = 0; % probability that text is pos class
        negp = 0; % probability that it's neg class
        for j = 1:size(grams, 2) % loop through every gram, count how many times it appears, calculate probabilities
            g = grams(:, j);
            c = hasgrams(tokens, g);
            if (bin); c = c > 0; end
            k = join(g); % map keys have to be character vectors
            
            if (~isKey(posprobs, k)); dp = log(a/posd);
            else; dp = log(posprobs(k)); end
            posp = posp + c*dp;
            
            if (~isKey(negprobs, k)); dn = log(a/negd);
            else; dn = log(negprobs(k)); end
            negp = negp + c*dn;
        end

        % if the prediction was right, document as a 1, otherwise will be
        % left as 0 (acc was preallocated to 0s)
        if (rating > 5 && posp > negp); acc(i) = 1;
        elseif (rating < 5 && negp > posp); acc(i) = 1; end
        
    end
    
    acc = sum(acc)/length(acc);
end
