function [test,dist] = Mfteste(Pte,Ptd,F,th)

% MFTESTE Counts how many points of the sets, Pte and Ptd, has the euclidean
%   distance between the point and the epipolar line, under the threshold range. 
% [test,dist] = Mfteste(Pte,Ptd,F,th);
%
% Input  : Two vectors of 2D points, Pte and Ptd
%	   The fundamental matrix, F
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
  Re=F*[Pte(i,:) 1]';
  Rd=F'*[Ptd(i,:) 1]';
  de=(Rd(1,1)*Pte(i,1)+Rd(2,1)*Pte(i,2)+Rd(3,1))/sqrt(Rd(1,1)^2+Rd(2,1)^2);
  dd=(Re(1,1)*Ptd(i,1)+Re(2,1)*Ptd(i,2)+Re(3,1))/sqrt(Re(1,1)^2+Re(2,1)^2);
  if ((de<=th) & (dd<=th)),
    count=[count i];
    dist=dist+de+dd;
  end;
end;
test=size(count,2);

end;