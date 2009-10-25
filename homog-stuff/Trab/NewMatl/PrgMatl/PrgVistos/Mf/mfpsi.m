function F = MFpsi(Pte,Ptd);

% MFPSI Calculate the fundamental matrix between the two vectors of 2D
%   points by the pseudo-inverse method.
% F = Mfpsi(Pte,Ptd);
%
% Input  : Two vectors of 2D points, Pte and Ptd
% Output : The fundamental matrix, F
%
% Nuno Alexandre Cid Martins
% Coimbra, Oct 27, 1998
% I.S.R.

transpe=0;
transpd=0;
X=[];
x=[];
if (nargin~=2),
  error('Requires two vectors of 2D points as input arguments.');
else
  if (isstr(Pte) | isstr(Ptd)),
    error('Requires two vectors of 2D points as input arguments.');
  else
    if (size(Pte,1)~=size(Ptd,1) | size(Pte,2)~=size(Ptd,2)),
      error('The vectors must have the same size');
    else
      if (size(Pte,1)==2 & size(Pte,2)~=2),
	Pte=Pte';
	transpe=1;
      end;
      if (size(Ptd,1)==2 & size(Ptd,2)~=2),
	Ptd=Ptd';
	transpd=1;
      end;
      if ((size(Pte,2)~=2) | (size(Ptd,2)~=2)),
	error('The points of the vector must be 2D.');
      else
	if ((size(Pte,1)<4) | (size(Ptd,1)<4)),
	  error('The vectors should have at least eight points');
	else
	  for i=1:size(Pte,1),
	    xe=Pte(i,1);
	    ye=Pte(i,2);
	    xd=Ptd(i,1);
	    yd=Ptd(i,2);
	    X=[X;xe*xd ye*xd xd xe*yd ye*yd yd xe ye];
	    x=[x;-1];
	  end;
	  V=psinvsol(X,x);
	  F(1,1)=V(1,1);
	  F(1,2)=V(2,1);
	  F(1,3)=V(3,1);
	  F(2,1)=V(4,1);
	  F(2,2)=V(5,1);
	  F(2,3)=V(6,1);
	  F(3,1)=V(7,1);
	  F(3,2)=V(8,1);
	  F(3,3)=1.0;
	end;
      end;
      if (transpe),
	Pte=Pte';
      end;
      if (transpd),
	Ptd=Ptd';
      end;
    end;
  end;
end;