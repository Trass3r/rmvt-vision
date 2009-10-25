function Hg = Hgcalc(Pte,Ptd,type)

% HGCALC Calculate the homography between the two vectors of 2D
%   points by a method chosen with type:
%	type 0 - svd
%	type 1 - eigen values
%	type 2 - Pseudo-inverse
%	type 3 - Pseudo-inverse by svd
% Hg = Hgcalc(Pte,Ptd,type);
%
% Input  : Two vectors of 2D points, Pte and Ptd
%	 : Method type
% Output : The homographic matrix, Hg
%
% Nuno Alexandre Cid Martins
% Coimbra, Oct 27, 1998
% I.S.R.

if (type==0)
  Hg=hglsqsvd(Pte,Ptd);
elseif (type==1)
  Hg=hgeig(Pte,Ptd);
elseif (type==2)
  Hg=hgpsi(Pte,Ptd);
else
  Hg=hgpsisvd(Pte,Ptd);
end;