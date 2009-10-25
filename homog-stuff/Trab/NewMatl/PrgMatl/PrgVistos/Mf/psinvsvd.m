function  x = psinvsvd(A,b);

% PSINVSVD Computes pseudo-inverse solution x of the system Ax=b,
%   using the SVD of A.
% x = psinvsvd(A,b);
%
% input  : Coeficient Matrix of the system, A
%			  Result vector of the system, b
% output : Solution vector, x
%
% Nuno Alexandre Cid Martins
% Coimbra, Sep 29, 1998
% I.S.R.

if (nargin~=2),
  error('Requires two input arguments.');
else
  if (isstr(A) | isstr(b)),
    error('Requires one matrix and one vector as input arguments.');
  else
    [U,S,V]=svd(A);
    Sp=zeros(size(S));
    for i=1:size(S,2),
      if (S(i,i)~=0),
	Sp(i,i)=1/S(i,i);
      else
	Sp(i,i)=0;
      end;
    end;
    Ap=V*Sp'*U';
    x=Ap*b;
  end;
end;