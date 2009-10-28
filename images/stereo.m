L=iload('garden-l.jpg', 'mono');
R=iload('garden-r.jpg', 'mono');
sr=isift(R);
sl=isift(L);
m = match(sl, sr)

m.plot('in', 'only', 100, 'g')
m
F = m.ransac(@fmatrix, 0.01, 1)
m.plot('out', 'r')
m.plot('in', 'only', 100, 'g')
