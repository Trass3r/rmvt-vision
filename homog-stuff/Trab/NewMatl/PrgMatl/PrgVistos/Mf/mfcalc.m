function F = Mfcalc(Pte,Ptd,type)

% MFCALC Calculate the fundamental matrix between the two vectors of 2D
%   points by a method chosen with type:
%	type 0 - svd
%	type 1 - eigen values
%	type 2 - Pseudo-inverse
%	type 3 - Pseudo-inverse by svd
% F = Mfcalc(Pte,Ptd,type);
%
% Input  : Two vectors of 2D points, Pte and Ptd
%	 : Method type
% Output : The fundamental matrix, F
%
% Nuno Alexandre Cid Martins
% Coimbra, Oct 27, 1998
% I.S.R.

if (type==0)
  F=mflsqsvd(Pte,Ptd);
elseif (type==1)
  F=mfeig(Pte,Ptd);
elseif (type==2)
  F=mfpsi(Pte,Ptd);
else
  F=mfpsisvd(Pte,Ptd);
end;