function  x = lsqsvd(A,b);

% LSQSVD Computes the least-squares solution x of the system Ax=b,
%   using the SVD of A.
% x = lsqsvd(A,b);
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
    ub=U'*b;
    y=zeros(size(A,2),1);
    for i=1:size(A,2),
      if (S(i,i)~=0),
	y(i)=ub(i)/S(i,i);
      else
	y(i)=1.0e+308;
      end;
    end;
    x=V*y;
  end;
end;