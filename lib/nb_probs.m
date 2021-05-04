% Calculate probabilities based on Naive Bayes assumptions for a voabulary.
% vocab is a subset of a larger vocabulary corresponding to a given class
% of vocabulary. count is the frequency of each word in vocab appearing in
% all the texts that make up vocab. n is the total number of terms in the
% larger vocabulary of all documents of all classes. P is a MATLAB
% containers.Map that maps each word in vocab to its probability found
% using Naive Bayes assumption: P(word|class) = (frequency + a)/total where
% P(word|class) is the probability that the word appears in the class,
% frequency is the number of times the word appears in the documents of the
% class that vocab belongs, a is a laplace smoothing constant (a = 1 here),
% and total is given by sum(count) + a*n.
%
% Example:
%   % assuming the following dataset
%   % myfolder/|class1/| t1.txt --> 'Hello world!'
%   %                  | t2.txt --> 'world text'
%   %          |class2/| t3.txt --> 'Goodbye word'
%
%   [vocab1, count1, ~, ~] = train('[path_to]/myfolder/class1');
%   % vocab1 = ["hello"; "world"; "text"]
%   % count1 = [ 1;       2;       1]
%
%   [vocab2, count2, ~, ~] = train('[path_to]/myfolder/class2');
%   % vocab2 = ["goodbye"; "world"]
%   % count2 = [ 1;         1]
%
%   P = nb_probs(vocab1, count1, length(union(vocab1, vocab2)));
%   % P("world") = (2 + 1)/(4 + 4)
function P = nb_probs(vocab, count, n)
    arguments
        vocab string;
        count double;
        n double;
    end
    
    total = sum(count) + n;
    
    P = containers.Map;
    for i = 1:length(vocab); P(vocab(i)) = (count(i) + 1)/total; end
end
