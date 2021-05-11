
function P = nb_probs(m, n, a)
    arguments
        m containers.Map;
        n containers.Map;
        a double = 1;
    end
    
    P = containers.Map;
    ks = keys(m);
    d = sum(cell2mat(values(m))) + length(n)*a;
    for i = 1:length(ks)
        k = ks{i};
        P(k) = (m(k) + a)/d;
    end
end
