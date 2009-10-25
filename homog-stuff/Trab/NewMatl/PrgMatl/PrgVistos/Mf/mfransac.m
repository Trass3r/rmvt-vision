function [F] = Mfransac(Pte,Ptd,iter,th,type)

% MFRANSAC Calculate the fundamental matrix between Pte and Ptd, using
%   the RANSAC method to eliminate the false matches.
% [F] = Mfransac(Pte,Ptd,iter,th,type);
%
% Input  : Two vectors of 2D points, Pte and Ptd
%	   The number of iterations of the process, iter
%	   The threshold, th
%	   Type method, type
% Output : The fundamental matrix, F
%
% Nuno Alexandre Cid Martins
% Coimbra, Oct 27, 1998
% I.S.R.

clc;
max=0;
maxdist=1e+308;
maxnums=[];
for i=1:iter,
  [F,nums]=mfaleat(Pte,Ptd,type);
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
  F=mfcalc(Pea,Pda,type);
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
  F=mfcalc(Pea,Pda,type);
  else
    clc;
    disp('Can not calculate the fundamental matrix');
end;

end;