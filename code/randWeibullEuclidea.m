function w=randWeibullEuclidea(lambda,k,tot)
    
    u=rand(tot,1,'like',BanArray);
        w=((-log(u))^(1/k))*lambda;
end