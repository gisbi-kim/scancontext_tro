function [dist] = normalizedKLDiv(P, Q)

dist_kl = KLDiv(P, Q);
dist = 1 - exp(-dist_kl);

end

