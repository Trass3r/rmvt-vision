%HOMTRANS	transform points by homography
%
%	ph = homtrans(H, p)
%
% Apply the homography H to the image-plane points p.  p is an nx2 or
% nx3 matrix whose rows correspond to individual points.  Each row is of
% the form [u v w].  If w is not specified, ie. p has 2 columns, then it is
% assumed to be 1.
%
% Returns points as ph, an nx3 matrix where each row is the homogeneous
% point coordinates.
%

function p = homtrans(H, p1)

	if numcols(p1) == 2,
		p1 = [p1 ones(numrows(p1),1)];
	end
	p = h2e( H* e2h(p1) );
