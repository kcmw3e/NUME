function p = map_union(m, n)
    arguments
        m containers.Map;
        n containers.Map;
    end
    
    ks = union(string(keys(m)), string(keys(n)));
    p = containers.Map(ks, zeros(length(ks), 1));
    for i = 1:length(ks)
        k = ks{i};
        if (isKey(m, k)); p(k) = p(k) + m(k); end
        if (isKey(n, k)); p(k) = p(k) + n(k); end
    end
end