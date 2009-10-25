function [Hg,nums] = Hgaleat(Pte,Ptd,type)

% HGALEAT Calculate a rondom homography, with four points of the input
%   sets Pte and Ptd.
% [Hg,nums] = Hgaleat(Pte,Ptd);
%
% Input  : Two vectors of 2D points, Pte and Ptd
%	   Method type, type
% Output : The homographic matrix, Hg
%	   The positions of the points that were chosen, nums
%
% see HGCALC
%
% Nuno Alexandre Cid Martins
% Coimbra, Oct 27, 1998
% I.S.R.

if (size(Pte)~=size(Ptd)),
  disp('Wrong size of the sets of points');
else
  n=size(Pte,1);
end;
nums=numaleat(n);
for i=1:4,
  Pe(i,:)=Pte(nums(i),:);
  Pd(i,:)=Ptd(nums(i),:);
end;
Hg=hgcalc(Pe,Pd,type);

end;