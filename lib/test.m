% Tests a dataset based on Naive Bayes assumption. folder is the path to a
% directory that should contain a set of text files. Each text file will be
% cleaned according to the functions tokenize() and rm_fluff() -- see
% respective *.m files for details. The text files should be named
% with a unique id followed by an underscore and a rating out of 10 (e.g.
% 123_9 is a file with id 123 and rating 9 out of 10). Positive files are
% considered anything with a rating over 5, and negative anything 5 and
% below, but for best practices it's best to test with items that are more
% polarized (>=6 and <=4).
% There are 6 inputs:
%   folder --> path to a directory containing text files as described above
%   pcount --> array of indexed word frequencies (see train.m)for
%              positive vocabulary
%   pprob  --> a MATLAB containers.Map object mapping words from the
%              positive vocabulary to the pre-computed Naive Bayes
%              probabilities
%   ncount --> negative counterpart to pcount
%   nprob  --> negative counterpart to pprob
%   n      --> total number of terms in combined vocabulary (pos + neg)
% The returned acc is the accuracy with which the Naive Bayes pre-compiled
% probabilites correctly predicted the data to be positive or negatively
% rated. This is simply computed as (number correct)/(total number).
%
% Example:
%   % assuming the following dataset
%   % myfolder/| train/| pos/| t1.txt --> 'Hello great world!'
%   %                  | neg/| t2.txt --> 'some bad text'
%   %                        | t3.txt --> 'Goodbye world :('
%   %          | test/ 0_8.txt --> 'A great day!'
%
%   [pvocab, pcount, ptexts, pmap] = train('[path_to]/myfolder/train/pos');
%   [nvocab, ncount, ntexts, nmap] = train('[path_to]/myfolder/train/neg');
%   vocab = union(pvocab, nvocab);
%   n = length(vocab);
%   pprob = nb_probs(pvocab, pcount, n);
%   nprob = nb_probs(nvocab, ncount, n);
%   acc = test('[path_to]/myfolder/test', pcount, pprob, ncount, nprob, n);
%   % acc is then whether or not the data predicted 0_8.txt to be positive (should be 1)
function acc = test(folder, pcount, pprob, ncount, nprob, n)
    arguments
        folder string;
        pcount double;
        pprob containers.Map;
        ncount double;
        nprob containers.Map;
        n double;
    end
    
    files = dir(fullfile(folder, '*.txt')); % get all the text file names
    
    acc = zeros(size(files)); % preallocate array for efficiency
    for i = 1:length(files) % loop through each file and clean/tokenize and test it
        file = files(i);
        info = string(split(erase(file.name, '.txt'), '_')); % file names should be '[id]_[rating].txt'
        rating = str2double(info(2));
        
        txt = fileread(fullfile(file.folder, file.name)); % string inside the text file
        
        % clean the text
        tokens = tokenize(txt);
        uniques = unique(tokens);
        uniques = rm_fluff(uniques);
        
        posp = 0; % probability that text is pos class
        negp = 0; % probability that it's neg class
        for j = 1:length(uniques) % loop through every unique word, count how many times it appears, calculate probabilities
            word = uniques(j);
            
            % if the word is in the map, it has a probability already, if
            % it isn't then the probabilty is give by 1/(sum(pcount) + n)
            % note that log(P) is used to compute probabilities together
            % since they will be very small and would be interpreted as 0
            % after a few multiplications
            if (~isKey(pprob, word)); posp = posp + log(1/(sum(pcount) + n));
            else; posp = posp + log(pprob(word)); end
            
            if (~isKey(nprob, word)); negp = negp + log(1/(sum(ncount) + n));
            else; negp = negp + log(nprob(word)); end
        end

        % if the prediction was right, document as a 1, otherwise will be
        % left as 0 (acc was preallocated to 0s)
        if (rating > 5 && posp > negp); acc(i) = 1;
        elseif (rating < 5 && negp > posp); acc(i) = 1; end
        
    end
    
    acc = sum(acc)/length(acc);
end
