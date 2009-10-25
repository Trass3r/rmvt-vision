function Hg = Hglsqsvd(Pte,Ptd);

% HGLSQSVD Calculate the homography between the two vectors of 2D
%   points by the least-square method, using svd.
% Hg = Hglsqsvd(Pte,Ptd);
%
% Input  : Two vectors of 2D points, Pte and Ptd
% Output : The homographic matrix, Hg
%
% Nuno Alexandre Cid Martins
% Coimbra, Oct 2, 1998
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
	error('The points of the vector must be 3D.');
      else
	if ((size(Pte,1)<4) | (size(Ptd,1)<4)),
	  error('The vectors should have at least four points');
	else
	  for i=1:size(Pte,1),
	    xe=Pte(i,1);
	    ye=Pte(i,2);
	    xd=Ptd(i,1);
	    yd=Ptd(i,2);
	    X=[X;xe ye 1 0 0 0 -xe*xd -xd*ye;0 0 0 xe ye 1 -xe*yd -ye*yd];
	    x=[x;xd;yd];
	  end;
	  V=lsqsvd(X,x);
	  Hg(1,1)=V(1,1);
	  Hg(1,2)=V(2,1);
	  Hg(1,3)=V(3,1);
	  Hg(2,1)=V(4,1);
	  Hg(2,2)=V(5,1);
	  Hg(2,3)=V(6,1);
	  Hg(3,1)=V(7,1);
	  Hg(3,2)=V(8,1);
	  Hg(3,3)=1.0;
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