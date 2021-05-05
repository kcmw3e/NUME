% Semester Project Sentiment Analysis based on IMDB movie reviews
% 24-311 Numerical Methods, Carnegie Mellon University
% Casey Walker

% Training steps
%  get string from file
%  tokenize string (remove unwatned punctuation, separate into words)
%  get unique words
%  remove unwanted words
%  add new words to vocabulary
%  count words in file
%  add count to map
%  calculate probabilities

% Testing steps
%  get string from file
%  tokenize string (remove unwatned punctuation, separate into words)
%  get unique words
%  remove unwanted words
%  calculate probabilites based on training data

function project()

clear;
close all;
clc;

addpath(fullfile(pwd, 'lib'));

nlprint("Semester Project -- Sentiment Analysis based on IMDB movie reviews");
nlprint("24-311 Numerical Methods, Carnegie Mellon University");
nlprint("Casey Walker");
nlprint();

nlprint("Checking for file with pre-computed Naive Bayes probabilities.");
if (~isfile(fullfile(pwd, "nbps.mat")))
    nlprint("  Couldn't find file containing pre-computed Naive Bayes probabilites.");
    nlprint("  Computing them now instead using data from IMDB.")
    
    nlprint("    Checking that data exists.");
    check_folder(fullfile(pwd, "data/train/pos"));
    check_folder(fullfile(pwd, "data/train/neg"));
    
    nlprint("    Training Naive Bayes model from existing IMDB review data.");
    [pvocab, pcount, ptexts, pmap] = train(fullfile(pwd, "data/train/pos"));
    [nvocab, ncount, ntexts, nmap] = train(fullfile(pwd, "data/train/neg"));
    vocab = union(pvocab, nvocab);
    
    nlprint("    Computing probabilities with data from IMDB reviews.");
    pP = nb_probs(pvocab, pcount, length(vocab));
    nP = nb_probs(nvocab, ncount, length(vocab));
    
    nlprint("    Saving data for future use.");
    save('nbps', 'pP', 'nP', 'pcount', 'ncount', 'vocab');
    
    nlprint("  Done computing Naive Bayes probabilities.");
else
    nlprint("  Found file containing model. Loading data...");
    load(fullfile(pwd, "nbps"));
end
nlprint()


nlprint("Testing model.");

nlprint("  Checking for existence of proper folders.");
check_folder(fullfile(pwd, "data/test/pos"));
check_folder(fullfile(pwd, "data/test/neg"));
check_folder(fullfile(pwd, "data/test/non"));

nlprint("  Running tests.");
pacc = test(fullfile(pwd, "data/test/pos"), pcount, pP, ncount, nP, length(vocab));
nacc = test(fullfile(pwd, "data/test/neg"), pcount, pP, ncount, nP, length(vocab));
nonacc = test(fullfile(pwd, "data/test/non"), pcount, pP, ncount, nP, length(vocab));
nlprint("  Finished testing.");

nlprint("Results:");
nlprint("  Positive review accuracy: %g%%", pacc*100);
nlprint("  Negative review accuracy: %g%%", nacc*100);
nlprint("  None-review accuracy:     %g%%", nonacc*100);

rmpath(fullfile(pwd, 'lib'));

end
