function acc = test(folder, pcount, pprob, ncount, nprob, n)
    files = dir(fullfile(folder, '*.txt')); % get all the text file names
    
    acc = zeros(size(files));
    for i = 1:length(files)
        file = files(i);
        info = string(split(erase(file.name, '.txt'), '_'));
        rating = str2double(info(2));
        
        txt = fileread(fullfile(file.folder, file.name));
        tokens = tokenize(txt);
        uniques = unique(tokens);
        uniques = rm_fluff(uniques);
        
        posp = 0;
        negp = 0;
        for j = 1:length(uniques)
            word = uniques(j);
            
            if (~isKey(pprob, word)); posp = posp + log(1/(sum(pcount) + n));
            else; posp = posp + log(pprob(word)); end
            
            if (~isKey(nprob, word)); negp = negp + log(1/(sum(ncount) + n));
            else; negp = negp + log(nprob(word)); end
        end

        if (rating > 5 && posp > negp); acc(i) = 1;
        elseif (rating < 5 && negp > posp); acc(i) = 1; end
        
    end
    
    acc = sum(acc)/length(acc);
end
