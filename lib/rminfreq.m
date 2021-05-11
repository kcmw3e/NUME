function rminfreq(m, f)
    arguments
        m containers.Map;
        f double;
    end
    
    if (f <= 1); return; end
    
    ks = keys(m);
    for i = 1:length(ks)
        k = ks{i};
        if (m(k) < f); remove(m, k); end
    end

end
