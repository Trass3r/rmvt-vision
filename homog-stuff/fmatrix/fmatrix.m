%FMATRIX	return the fundamental matrix
%
%	F = FMATRIX(Pa, Pb [, how])
%
%	Given two sets of corresponding points Pa and Pb (each a nx2 matrix)
%	return the fundamental matrix relating the two sets of observations.
%
%
% Nuno Alexandre Cid Martins
% Coimbra, Oct 27, 1998
% I.S.R.
%
% Code wrapper by Peter Corke.

function F = fmatrix(Pa, Pb, varargin)

	if nargin == 2,
		how = 'svd';
	else
			how = varargin{1};
	end

	switch how,
	case {'eig'}
		F = Mfeig(Pa, Pb);
	case {'pinv'}
		F = Mfpsi(Pa, Pb);
	case {'svd'}
		F = Mfpsisvd(Pa, Pb);
	case {'lsq'}
		F = Mflsqsvd(Pa, Pb);
	case {'ransac'}
		if nargin < 5,
			error('Must have 5 parameters for RANSAC mode: Pa, Pb, iter, threshold, how');
		F = Mfransac(Pa,Pb,iter,th,type)
	otherwise
		error( sprintf('bad method %s specified', how) );
end

function F = Mfeig(Pte,Ptd);

% MFEIG Calculate the fundamental matrix between the two vectors of 2D
%   points by the eigen values method.
% F = Mfeig(Pte,Ptd);
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
	if ((size(Pte,1)<5) | (size(Ptd,1)<5)),
	  error('The vectors should have at least nine points');
	else
	  for i=1:size(Pte,1),
	    xe=Pte(i,1);
	    ye=Pte(i,2);
	    xd=Ptd(i,1);
	    yd=Ptd(i,2);
	    X=[X;xe*xd ye*xd xd xe*yd ye*yd yd xe ye 1];
	  end;
	  V=eigsol(X);
	  F(1,1)=V(1,1);
	  F(1,2)=V(2,1);
	  F(1,3)=V(3,1);
	  F(2,1)=V(4,1);
	  F(2,2)=V(5,1);
	  F(2,3)=V(6,1);
	  F(3,1)=V(7,1);
	  F(3,2)=V(8,1);
	  F(3,3)=V(9,1);
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


function F = Mflsqsvd(Pte,Ptd);

% MFLSQSVD Calculate the fundamental matrix between the two vectors of
%   2D points by the least-square method, using svd.
% F = Mflsqsvd(Pte,Ptd);
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
	error('The points of the vector must be 3D.');
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
	  V=lsqsvd(X,x);
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


function [F] = Mfransac(Pte,Ptd,iter,th,how)

% MFRANSAC Calculate the fundamental matrix between Pte and Ptd, using
%   the RANSAC method to eliminate the false matches.
% [F] = Mfransac(Pte,Ptd,iter,th,how);
%
% Input  : Two vectors of 2D points, Pte and Ptd
%	   The number of iterations of the process, iter
%	   The threshold, th
%	   Type method, how
% Output : The fundamental matrix, F
%
% Nuno Alexandre Cid Martins
% Coimbra, Oct 27, 1998
% I.S.R.

max=0;
maxdist=1e+308;
maxnums=[];
for i=1:iter,
  [F,nums]=mfaleat(Pte,Ptd,how);
  [test,dist]=mfteste(Pte,Ptd,F,th);
  if ((test>max) | (test==max & dist<maxdist)),
    max=test;
    maxdist=dist;
    maxnums=nums;
  end;
end;
if (max>=4),
  for i=1:4,
    Pea(i,:)=Pte(maxnums(i),:);
    Pda(i,:)=Ptd(maxnums(i),:);
  end;
  F=fmatrix(Pea,Pda,how);
  Pea=[];
  Pda=[];
  for i=1:size(Pte,1),
    Re=F*[Pte(i,:) 1]';
    Rd=F'*[Ptd(i,:) 1]';
    de=(Rd(1,1)*Pte(i,1)+Rd(2,1)*Pte(i,2)+Rd(3,1))/sqrt(Rd(1,1)^2+Rd(2,1)^2);
    dd=(Re(1,1)*Ptd(i,1)+Re(2,1)*Ptd(i,2)+Re(3,1))/sqrt(Re(1,1)^2+Re(2,1)^2);
    if ((de<=th) & (dd<=th)),
      Pea=[Pea;Pte(i,:)];
      Pda=[Pda;Ptd(i,:)];
    end;
  end;
  F=fmatrix(Pea,Pda,how);
  else
    disp('Can not calculate the fundamental matrix');
end;

end;


function [F,nums] = Mfaleat(Pte,Ptd,how)

% MFALEAT Calculate a rondom fundamental matrix, with four points
%	of the input sets Pte and Ptd.
% [F,nums] = Mfaleat(Pte,Ptd);
%
% Input  : Two vectors of 2D points, Pte and Ptd
%	   Method type, how
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
F=fmatrix(Pe,Pd,how);

end;


function nums = numaleat(n)

% NUMALEAT Give four random numbers from 1 to n.
% nums = numaleat(n);
%
% Input  : The maximum number, n
% Output : The four random numbers, nums
%
% Nuno Alexandre Cid Martins
% Coimbra, Oct 27, 1998
% I.S.R.

num=0;
while (~num),
  num=round(n*rand);
end;
if (n<4),
  break;
elseif (n~=4),
  nums=[num];
else
  nums=[1;2;3;4];
end;
while (size(nums,1)~=4),
  num=0;
  while (~num),
    num=round(n*rand);
  end;
  ig=0;
  for i=1:size(nums,1),
    if (num==nums(i)),
      ig=1;
      break;
    end;
  end;
  if (~ig),
    nums=[nums;num];
  end;
end;

end;
