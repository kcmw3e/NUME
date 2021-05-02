clear;
close all;
clc;

% 24-311 Numerical Methods, Carnegie Mellon University
% Semester Project
% Casey Walker

% Training steps
% get string from file
% tokenize string (remove unwatned punctuation, separate into words)
% get unique words
% remove unwanted words
% add new words to vocabulary
% count words in file
% add count to map
% calculate probabilities

% Testing steps
% get string from file
% tokenize string (remove unwatned punctuation, separate into words)
% get unique words
% remove unwanted words
% calculate probabilites based on training data

addpath(fullfile(pwd, 'lib'));

[pvocab, pcount, ptexts, pmap] = train(fullfile(pwd, "data/train/pos"));
[nvocab, ncount, ntexts, nmap] = train(fullfile(pwd, "data/train/neg"));
vocab = union(pvocab, nvocab);

pP = nb_probs(pvocab, pcount, length(vocab));
nP = nb_probs(nvocab, ncount, length(vocab));

nlprint("now testing");

pacc = test(fullfile(pwd, "data/test/pos"), pcount, pP, ncount, nP, length(vocab));
nacc = test(fullfile(pwd, "data/test/neg"), pcount, pP, ncount, nP, length(vocab));
nonacc = test(fullfile(pwd, "data/test/non"), pcount, pP, ncount, nP, length(vocab));

nlprint("Pos: %g%%, Neg: %g%%, Non: %g%%", pacc*100, nacc*100, nonacc*100);

rmpath(fullfile(pwd, 'lib'));