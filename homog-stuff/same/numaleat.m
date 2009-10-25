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