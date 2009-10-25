function  x = psinvsol(A,b);

% PSINVSOL Computes pseudo-inverse solution x of the system Ax=b.
% x = psinvsol(A,b);
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
    x=inv(A'*A)*A'*b;
  end;
end;