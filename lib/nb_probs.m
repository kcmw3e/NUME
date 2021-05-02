function P = nb_probs(vocab, count, n)
    total = sum(count) + n;
    P = containers.Map;
    for i = 1:length(vocab)
        P(vocab(i)) = (count(i) + 1)/total;
    end
end