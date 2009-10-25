function [F] = calmfund(Pte,Ptd,norm,fix,eigen,rank);

% CALMFUND Calculate the fundamental matrix, using two vectors of 2D points
%   of the left and right images, by two different methods (pseudo-inverse
%   or eigen values). It's possible do conditionate the input/output data
%   by normalising or aplying the rank condition.
% [F] = calmfund(Pte,Ptd,norm,fix,eigen,rank)
%
% Input  : Points in the left image, Pte
%	   Points in the right image, Ptd
%	   Do a normalization to the initial points, norm=1, else norm=0
%	   Cameras in visual fixation visual, fix=1, else fix=0
%	   Using eigen values method eigen=1. Using pseudo-inverse method eigen=0
%	   Force the rank constraint, rank=1, else rank=0
% Output : The fundamental matrix, F
%
% Nuno Alexandre Cid Martins
% Coimbra, Sep 27, 1998
% I.S.R.

if (nargin<2),
  error('Faltam parametros');
  break;
else
  if (nargin<3),
    norm=0;
    fix=0;
    eigen=0;
    rank=0;
  else
    if (nargin<4),
      fix=0;
      eigen=0;
      rank=0;
    else
      if (nargin<5),
	eigen=0;
	rank=0;
      else
	rank=0;
      end;
    end;
  end;
end;
if (norm),
  d=[];
  se=sum(Pte);
  xe=se(1)/size(Pte,1);
  ye=se(2)/size(Pte,1);
  Pte=Pte-[xe*ones(size(Pte,1),1) ye*ones(size(Pte,1),1)];
  for i=1:size(Pte,1),
    d=[d;sqrt(Pte(i,1)^2+Pte(i,2)^2)];
  end;
  Dm=mean(d);
  sf=sqrt(2)/Dm;
  for i=1:size(Pte,1),
    Pte(i,1)=Pte(i,1)*sf;
    Pte(i,2)=Pte(i,2)*sf;
  end;
  Pe=[sf 0 -sf*xe;0 sf -sf*ye;0 0 1];
  d=[];
  sd=sum(Ptd);
  xd=sd(1)/size(Ptd,1);
  yd=sd(2)/size(Ptd,1);
  Ptd=Ptd-[xd*ones(size(Ptd,1),1) yd*ones(size(Ptd,1),1)];
  for i=1:size(Ptd,1),
    d=[d;sqrt(Ptd(i,1)^2+Ptd(i,2)^2)];
  end;
  Dm=mean(d);
  sf=sqrt(2)/Dm;
  for i=1:size(Ptd,1),
    Ptd(i,1)=Ptd(i,1)*sf;
    Ptd(i,2)=Ptd(i,2)*sf;
  end;
  Pd=[sf 0 -sf*xd;0 sf -sf*yd;0 0 1];
end;
X=[];
for i=1:size(Pte,1),
  xe=Pte(i,1);
  ye=Pte(i,2);
  xd=Ptd(i,1);
  yd=Ptd(i,2);
  if (fix),
    if (~eigen),
      X=[X;ye*xd xd xe*yd yd xe ye];
    else
      X=[X;ye*xd xd xe*yd yd xe ye 1];
    end;
  else
    if (~eigen),
      X=[X;xe*xd ye*xd xd xe*yd ye*yd yd xe ye];
    else
      X=[X;xe*xd ye*xd xd xe*yd ye*yd yd xe ye 1];
    end;
  end;
end;
if (~eigen),
  Sol=inv(X'*X)*X'*(-ones(size(X,1),1));
  F(3,3)=1.0;
else
  [V D]=eig(X'*X);
  m=1.0e+308;
  j=1;
  for i=1:size(D,1),
    if (m>D(i,i)),
      m=D(i,i);
      j=i;
    end;
  end;
  if (fix),
    Sol(1)=V(1,j);
    Sol(2)=V(2,j);
    Sol(3)=V(3,j);
    Sol(4)=V(4,j);
    Sol(5)=V(5,j);
    Sol(6)=V(6,j);
    F(3,3)=V(7,j);
  else
    Sol(1)=V(1,j);
    Sol(2)=V(2,j);
    Sol(3)=V(3,j);
    Sol(4)=V(4,j);
    Sol(5)=V(5,j);
    Sol(6)=V(6,j);
    Sol(7)=V(7,j);
    Sol(8)=V(8,j);
    F(3,3)=V(9,j);
   end;
end;
if (fix),
  F(1,1)=0;
  F(1,2)=Sol(1);
  F(1,3)=Sol(2);
  F(2,1)=Sol(3);
  F(2,2)=0;
  F(2,3)=Sol(4);
  F(3,1)=Sol(5);
  F(3,2)=Sol(6);
else
  F(1,1)=Sol(1);
  F(1,2)=Sol(2);
  F(1,3)=Sol(3);
  F(2,1)=Sol(4);
  F(2,2)=Sol(5);
  F(2,3)=Sol(6);
  F(3,1)=Sol(7);
  F(3,2)=Sol(8);
end;
if (rank),
  [U S V]=svd(F);
  m=1.0e+308;
  j=1;
  for i=1:3,
    if (m>S(i,i)),
      m=S(i,i);
      j=i;
    end;
  end;
  S(j,j)=0;
  F=U*S*V';
end;