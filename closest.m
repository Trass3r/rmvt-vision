%CLOSEST   Find matching points in N-dimensional space.
%
% Fast matching of points in N-dimensional space.
%
%	K = CLOSEST(A, B)
%
%   A is N X NA
%   B is N x NB
%
% K is 1 x NA and the element J = K(I) indicates that the Ith column of A is closest
% to the Jth column of B.  That is, A(:,I) is closest to B(:,J).
