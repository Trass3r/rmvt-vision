function x = eigsol(A);

% EIGSOL Calculate the eigen value solution of the system Ax=0.
% x = eigsol(A);
%
% input  : Coeficient Matrix of the system, A
% output : Solution vector, x
%
% Nuno Alexandre Cid Martins
% Coimbra, Sep 29, 1998
% I.S.R.

if (nargin~=1),
  error('Requires one input argument.');
else
  if (isstr(A)),
    error('Requires one matrix as input arguments.');
  else
    [V D]=eig(A'*A);
    m=1.0e+308;
    j=1;
    for i=1:size(D,1),
      if (m>D(i,i)),
	m=D(i,i);
	j=i;
      end;
    end;
    x=V(:,j);
  end;	
end;