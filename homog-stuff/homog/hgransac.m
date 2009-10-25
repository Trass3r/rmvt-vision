function [Hg] = Hgransac(Pte,Ptd,iter,th,type)

% HGRANSAC Calculate a homography between Pte and Ptd, using the RANSAC
%   method to eliminate the false matches.
% [Hg] = Hgransac(Pte,Ptd,iter,th,type);
%
% Input  : Two vectors of 2D points, Pte and Ptd
%	   The number of iterations of the process, iter
%	   The threshold, th
%	   Type method, type
% Output : The homography matrix, Hg
%
% Nuno Alexandre Cid Martins
% Coimbra, Oct 27, 1998
% I.S.R.

clc;
max=0;
maxdist=1e+308;
maxnums=[];
for i=1:iter,
  [H,nums]=hgaleat(Pte,Ptd,type);
  [test,dist]=hgteste(Pte,Ptd,H,th);
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
  H=hgcalc(Pea,Pda,type);
  Pea=[];
  Pda=[];
  for i=1:size(Pte,1),
    Pd=H*[Pte(i,:) 1]';
    Pe=inv(H)*[Ptd(i,:) 1]';
    de=sqrt((Pte(i,1)-(Pe(1,1)/Pe(3,1)))^2+(Pte(i,2)-(Pe(2,1)/Pe(3,1)))^2);
    dd=sqrt((Ptd(i,1)-(Pd(1,1)/Pd(3,1)))^2+(Ptd(i,2)-(Pd(2,1)/Pd(3,1)))^2);
    if ((de<=th) & (dd<=th)),
      Pea=[Pea;Pte(i,:)];
      Pda=[Pda;Ptd(i,:)];
    end;
  end;
  Hg=hgcalc(Pea,Pda,type);
  else
    clc;
    disp('Can not calculate the homography');
end;

end;