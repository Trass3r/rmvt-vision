function [test,dist] = Hgteste(Pte,Ptd,H,th)

% HGTESTE Counts how many points of the sets, Pte and Ptd, has the euclidean
%   distance between the point and his reprojection, under the threshold
%   range. 
% [test,dist] = Hgteste(Pte,Ptd,H,th);
%
% Input  : Two vectors of 2D points, Pte and Ptd
%	   The homography, H
%	   The threshold, th
% Output : The number of points under the threshold range, test
%	   The distance error, dist
%
% Nuno Alexandre Cid Martins
% Coimbra, Oct 27, 1998
% I.S.R.

count=[];
dist=0;
for i=1:size(Pte,1),
  Pd=H*[Pte(i,:) 1]';
  Pe=inv(H)*[Ptd(i,:) 1]';
  de=sqrt((Pte(i,1)-(Pe(1,1)/Pe(3,1)))^2+(Pte(i,2)-(Pe(2,1)/Pe(3,1)))^2);
  dd=sqrt((Ptd(i,1)-(Pd(1,1)/Pd(3,1)))^2+(Ptd(i,2)-(Pd(2,1)/Pd(3,1)))^2);
  if ((de<=th) & (dd<=th)),
    count=[count i];
    dist=dist+de+dd;
  end;
end;
test=size(count,2);

end;