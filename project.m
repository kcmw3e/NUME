% Semester Project Sentiment Analysis based on IMDB movie reviews
% 24-311 Numerical Methods, Carnegie Mellon University
% Casey Walker

function [acc] = project(nvArgs)
arguments
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

addpath(fullfile(pwd, 'lib'));

nlprint("Semester Project -- Sentiment Analysis based on IMDB movie reviews");
nlprint("24-311 Numerical Methods, Carnegie Mellon University");
nlprint("Casey Walker");
nlprint();

descriptor = sprintf("%ggrams", n);
if (keepfluff); descriptor = sprintf("%s_fluffy", descriptor); end
if (bin); descriptor = sprintf("%s_bin", descriptor);
else; descriptor = sprintf("%s_tf", descriptor); end
if (minfreq > 1); descriptor = sprintf("%s_%gminf", descriptor, minfreq); end
descriptor = sprintf("%s_%ga", descriptor, a);
modelname = sprintf("model_%s.mat", descriptor);

nlprint("Checking for file with pre-computed Naive Bayes probabilities.");
if (~isfile(fullfile(pwd, modelname)))
    nlprint("  Couldn't find file containing pre-computed Naive Bayes probabilites.");
    nlprint("  Computing them now instead using data from IMDB.")
    
    nlprint("    Checking that data exists.");
    check_folder(fullfile(pwd, "data/train/pos"));
    check_folder(fullfile(pwd, "data/train/neg"));
    
    nlprint("    Training Naive Bayes model from existing IMDB review data.");
    
    args = namedargs2cell(nvArgs);
    model = train(fullfile(pwd, "data/train/"), args{:});
    
    nlprint("    Saving data for future use.");
    save(modelname, 'model');
    nlprint("  Done computing Naive Bayes probabilities.");
end

nlprint("  Loading model...");
load(fullfile(pwd, modelname), 'model');

nlprint("Testing model.");
tic;

nlprint("  Checking for existence of proper folders.");
check_folder(fullfile(pwd, "data/test/pos"));
check_folder(fullfile(pwd, "data/test/neg"));
check_folder(fullfile(pwd, "data/test/non"));

nlprint("  Running tests.");
pacc = test(fullfile(pwd, "data/test/pos"), model);
nacc = test(fullfile(pwd, "data/test/neg"), model);
nonacc = test(fullfile(pwd, "data/test/non"), model);

dt = toc;
nlprint("  Finished testing.");
nlprint("See 'results.txt' for results.");

resfile = fopen('results.txt', 'a');
fprintf(resfile, "\nResults");
fprintf(resfile, "\n  Model parameters\n" + ...
                 "    n-grams:   % g\n" + ...
                 "    fluffy:    % g\n" + ...
                 "    binary:    % g\n" + ...
                 "    smoothing: % g\n" + ...
                 "    min freq:  % g\n",  ...
                 n, keepfluff, bin, a, minfreq);
fprintf(resfile, "  Positive Accuracy:   % g%%\n" + ...
                 "  Negative Accuracy:   % g%%\n" + ...
                 "  Non-review Accuracy: % g%%\n",  ...
                 100*pacc, 100*nacc, 100*nonacc);
fprintf(resfile, "  Testing time: % gs\n", dt);
fprintf(resfile, "\n");
fclose(resfile);

rmpath(fullfile(pwd, 'lib'));

acc = [pacc, nacc, nonacc];
end
