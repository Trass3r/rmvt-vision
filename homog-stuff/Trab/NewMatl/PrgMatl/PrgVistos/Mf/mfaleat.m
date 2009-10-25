function [F,nums] = Mfaleat(Pte,Ptd,type)

% MFALEAT Calculate a rondom fundamental matrix, with four points
%	of the input sets Pte and Ptd.
% [F,nums] = Mfaleat(Pte,Ptd);
%
% Input  : Two vectors of 2D points, Pte and Ptd
%	   Method type, type
% Output : The fundamental matrix, F
%	   The positions of the points that were chosen, nums
%
% see MFCALC
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
F=mfcalc(Pe,Pd,type);

end;
