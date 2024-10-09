function [va,gtot]=randLogNormEuclidea(mean,sigma,num)
    g = randn(num, 1, 'like', BanArray);
    gtot=g*sigma + mean;    
    va= exp(gtot);
end

