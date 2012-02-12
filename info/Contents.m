% Robotics Toolbox.
% Version 9.0  2011
%
%
%  Color
%    blackbody                          - Compute blackbody emission spectrum
%
% E = BLACKBODY(LAMBDA, T) is the blackbody radiation power density (W/m^3)
% at the wavelength LAMBDA (m) and temperature T (K).
%
% If LAMBDA is a column vector, then E is a column vector whose 
% elements correspond to to those in LAMBDA.  For example:
%
%    l = [380:10:700]'*1e-9; % visible spectrum
%    e = blackbody(l, 6500); % emission of sun
%    plot(l, e)

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.

function e = blackbody(lam, T)
    C1 = 5.9634e-17;
    C2 = 1.4387e-2;
    lam = lam(:);
    e = 2 * C1 ./ (lam.^5 .* (exp(C2/T./lam) - 1));
%    ccdresponse                        - CCD spectral response
%
% R = CCDRESPONSE(LAMBDA) is the spectral response of a typical silicon
% imaging sensor at the wavelength LAMBDA.  The response is normalized
% in the range 0 to 1.  If LAMBDA is a vector then R is a vector of the
% same length whose elements are the response at the corresponding element
% of LAMBDA.
%
% Reference::
% Data taken from an ancient Fairchild data book for a sensor with no IR filter fitted.
%
% See also RLUMINOS.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.
function cc = ccdresponse(lam)
    tab = [300 0
    350 0
    400 5
    500 30
    600 60
    700 85
    800 100
    900 85
    1000 50
    ];
    cc = spline(tab(:,1)*1e-9,tab(:,2),lam)/100;
%    cie_primaries                      - Define CIE primary colors
%
% P = CIE_PRIMARIES() is a 3-vector with the wavelengths (m) of the
% CIE 1976 red, green and blue primaries respectively.

function p = cie_primaries

    p = [700, 546.1, 435.8]*1e-9;
%    cmfrgb                             - Color matching function
%
% RGB = CMFRGB(LAMBDA) is the CIE color matching function for illumination
% at wavelength LAMBDA.  If LAMBDA is a vector then each row of XYZ
% is the color matching function of the corresponding element of LAMBDA. 
%
% RGB = CMFRGB(LAMBDA, E) is the CIE color matching function for an illumination
% spectrum E.  E and LAMBDA are vectors of the same length and the elements of E 
% represent the intensity of light at the corresponding wavelength in LAMBDA.
%
% Note::
% - the color matching function is the tristimulus required to match a 
%   particular wavelength excitation.
% - data from http://cvrl.ioo.ucl.ac.uk
% - The Stiles & Burch 2-deg CMFs are based on measurements made on
%   10 observers. The data are referred to as pilot data, but probably
%   represent the best estimate of the 2 deg CMFs, since, unlike the CIE
%   2 deg functions (which were reconstructed from chromaticity data),
%   they were measured directly.
% - From Table I(5.5.3) of Wyszecki & Stiles (1982). (Table 1(5.5.3)
%   of Wyszecki & Stiles (1982) gives the Stiles & Burch functions in
%   250 cm-1 steps, while Table I(5.5.3) of Wyszecki & Stiles (1982)
%   is gives them in interpolated 1 nm steps.)
% - These CMFs differ slightly from those of Stiles & Burch (1955). As
%   noted in footnote a on p. 335 of Table 1(5.5.3) of Wyszecki &
%   Stiles (1982), the CMFs have been "corrected in accordance with
%   instructions given by Stiles & Burch (1959)" and renormalized to
%   primaries at 15500 (645.16), 19000 (526.32), and 22500 (444.44) cm-1
%
% See also CCXYZ.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.


function rgb = cmfrgb(lambda, spect)
    ciedat = [
  390e-9,  1.83970e-003, -4.53930e-004,  1.21520e-002
  395e-9,  4.61530e-003, -1.04640e-003,  3.11100e-002
  400e-9,  9.62640e-003, -2.16890e-003,  6.23710e-002
  405e-9,  1.89790e-002, -4.43040e-003,  1.31610e-001
  410e-9,  3.08030e-002, -7.20480e-003,  2.27500e-001
  415e-9,  4.24590e-002, -1.25790e-002,  3.58970e-001
  420e-9,  5.16620e-002, -1.66510e-002,  5.23960e-001
  425e-9,  5.28370e-002, -2.12400e-002,  6.85860e-001
  430e-9,  4.42870e-002, -1.99360e-002,  7.96040e-001
  435e-9,  3.22200e-002, -1.60970e-002,  8.94590e-001
  440e-9,  1.47630e-002, -7.34570e-003,  9.63950e-001
  445e-9, -2.33920e-003,  1.36900e-003,  9.98140e-001
  450e-9, -2.91300e-002,  1.96100e-002,  9.18750e-001
  455e-9, -6.06770e-002,  4.34640e-002,  8.24870e-001
  460e-9, -9.62240e-002,  7.09540e-002,  7.85540e-001
  465e-9, -1.37590e-001,  1.10220e-001,  6.67230e-001
  470e-9, -1.74860e-001,  1.50880e-001,  6.10980e-001
  475e-9, -2.12600e-001,  1.97940e-001,  4.88290e-001
  480e-9, -2.37800e-001,  2.40420e-001,  3.61950e-001
  485e-9, -2.56740e-001,  2.79930e-001,  2.66340e-001
  490e-9, -2.77270e-001,  3.33530e-001,  1.95930e-001
  495e-9, -2.91250e-001,  4.05210e-001,  1.47300e-001
  500e-9, -2.95000e-001,  4.90600e-001,  1.07490e-001
  505e-9, -2.97060e-001,  5.96730e-001,  7.67140e-002
  510e-9, -2.67590e-001,  7.01840e-001,  5.02480e-002
  515e-9, -2.17250e-001,  8.08520e-001,  2.87810e-002
  520e-9, -1.47680e-001,  9.10760e-001,  1.33090e-002
  525e-9, -3.51840e-002,  9.84820e-001,  2.11700e-003
  530e-9,  1.06140e-001,  1.03390e+000, -4.15740e-003
  535e-9,  2.59810e-001,  1.05380e+000, -8.30320e-003
  540e-9,  4.19760e-001,  1.05120e+000, -1.21910e-002
  545e-9,  5.92590e-001,  1.04980e+000, -1.40390e-002
  550e-9,  7.90040e-001,  1.03680e+000, -1.46810e-002
  555e-9,  1.00780e+000,  9.98260e-001, -1.49470e-002
  560e-9,  1.22830e+000,  9.37830e-001, -1.46130e-002
  565e-9,  1.47270e+000,  8.80390e-001, -1.37820e-002
  570e-9,  1.74760e+000,  8.28350e-001, -1.26500e-002
  575e-9,  2.02140e+000,  7.46860e-001, -1.13560e-002
  580e-9,  2.27240e+000,  6.49300e-001, -9.93170e-003
  585e-9,  2.48960e+000,  5.63170e-001, -8.41480e-003
  590e-9,  2.67250e+000,  4.76750e-001, -7.02100e-003
  595e-9,  2.80930e+000,  3.84840e-001, -5.74370e-003
  600e-9,  2.87170e+000,  3.00690e-001, -4.27430e-003
  605e-9,  2.85250e+000,  2.28530e-001, -2.91320e-003
  610e-9,  2.76010e+000,  1.65750e-001, -2.26930e-003
  615e-9,  2.59890e+000,  1.13730e-001, -1.99660e-003
  620e-9,  2.37430e+000,  7.46820e-002, -1.50690e-003
  625e-9,  2.10540e+000,  4.65040e-002, -9.38220e-004
  630e-9,  1.81450e+000,  2.63330e-002, -5.53160e-004
  635e-9,  1.52470e+000,  1.27240e-002, -3.16680e-004
  640e-9,  1.25430e+000,  4.50330e-003, -1.43190e-004
  645e-9,  1.00760e+000,  9.66110e-005, -4.08310e-006
  650e-9,  7.86420e-001, -1.96450e-003,  1.10810e-004
  655e-9,  5.96590e-001, -2.63270e-003,  1.91750e-004
  660e-9,  4.43200e-001, -2.62620e-003,  2.26560e-004
  665e-9,  3.24100e-001, -2.30270e-003,  2.15200e-004
  670e-9,  2.34550e-001, -1.87000e-003,  1.63610e-004
  675e-9,  1.68840e-001, -1.44240e-003,  9.71640e-005
  680e-9,  1.20860e-001, -1.07550e-003,  5.10330e-005
  685e-9,  8.58110e-002, -7.90040e-004,  3.52710e-005
  690e-9,  6.02600e-002, -5.67650e-004,  3.12110e-005
  695e-9,  4.14800e-002, -3.92740e-004,  2.45080e-005
  700e-9,  2.81140e-002, -2.62310e-004,  1.65210e-005
  705e-9,  1.91170e-002, -1.75120e-004,  1.11240e-005
  710e-9,  1.33050e-002, -1.21400e-004,  8.69650e-006
  715e-9,  9.40920e-003, -8.57600e-005,  7.43510e-006
  720e-9,  6.51770e-003, -5.76770e-005,  6.10570e-006
  725e-9,  4.53770e-003, -3.90030e-005,  5.02770e-006
  730e-9,  3.17420e-003, -2.65110e-005,  4.12510e-006];

    rgb = interp1(ciedat(:,1), ciedat(:,2:4), lambda, 'spline', 0);
    if nargin == 2,
        rgb = spect(:)' * rgb / numrows(ciedat);
    end
%    cmfxyz                             - matching function
%
% XYZ = CMFXYZ(LAMBDA) is the CIE XYZ color matching function for 
% illumination at wavelength LAMBDA.  If LAMBDA is a vector then each row of
% XYZ is the color matching function of the corresponding element of LAMBDA. 
%
% XYZ = CMFXYZ(LAMBDA, E) is the CIE XYZ color matching function for an 
% illumination spectrum E.  E and LAMBDA are vectors of the same length and 
% the elements of E represent the intensity of light at the corresponding 
% wavelength in LAMBDA.
%
% Note::
% - the color matching function is the XYZ tristimulus required to match a 
%   particular wavelength excitation.
% - CIE 1931 2-deg XYZ CMFs from cvrl.ioo.ucl.ac.uk
%
% See also CMFRGB, CCXYZ.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.


function XYZ = cmfxyz(lambda, spect)
    if true
        ciedat = [
        0	0	0	0
    % CIE 1931 2-deg XYZ CMFs from cvrl.ioo.ucl.ac.uk
    360,0.000129900000,0.000003917000,0.000606100000
    365,0.000232100000,0.000006965000,0.001086000000
    370,0.000414900000,0.000012390000,0.001946000000
    375,0.000741600000,0.000022020000,0.003486000000
    380,0.001368000000,0.000039000000,0.006450001000
    385,0.002236000000,0.000064000000,0.010549990000
    390,0.004243000000,0.000120000000,0.020050010000
    395,0.007650000000,0.000217000000,0.036210000000
    400,0.014310000000,0.000396000000,0.067850010000
    405,0.023190000000,0.000640000000,0.110200000000
    410,0.043510000000,0.001210000000,0.207400000000
    415,0.077630000000,0.002180000000,0.371300000000
    420,0.134380000000,0.004000000000,0.645600000000
    425,0.214770000000,0.007300000000,1.039050100000
    430,0.283900000000,0.011600000000,1.385600000000
    435,0.328500000000,0.016840000000,1.622960000000
    440,0.348280000000,0.023000000000,1.747060000000
    445,0.348060000000,0.029800000000,1.782600000000
    450,0.336200000000,0.038000000000,1.772110000000
    455,0.318700000000,0.048000000000,1.744100000000
    460,0.290800000000,0.060000000000,1.669200000000
    465,0.251100000000,0.073900000000,1.528100000000
    470,0.195360000000,0.090980000000,1.287640000000
    475,0.142100000000,0.112600000000,1.041900000000
    480,0.095640000000,0.139020000000,0.812950100000
    485,0.057950010000,0.169300000000,0.616200000000
    490,0.032010000000,0.208020000000,0.465180000000
    495,0.014700000000,0.258600000000,0.353300000000
    500,0.004900000000,0.323000000000,0.272000000000
    505,0.002400000000,0.407300000000,0.212300000000
    510,0.009300000000,0.503000000000,0.158200000000
    515,0.029100000000,0.608200000000,0.111700000000
    520,0.063270000000,0.710000000000,0.078249990000
    525,0.109600000000,0.793200000000,0.057250010000
    530,0.165500000000,0.862000000000,0.042160000000
    535,0.225749900000,0.914850100000,0.029840000000
    540,0.290400000000,0.954000000000,0.020300000000
    545,0.359700000000,0.980300000000,0.013400000000
    550,0.433449900000,0.994950100000,0.008749999000
    555,0.512050100000,1.000000000000,0.005749999000
    560,0.594500000000,0.995000000000,0.003900000000
    565,0.678400000000,0.978600000000,0.002749999000
    570,0.762100000000,0.952000000000,0.002100000000
    575,0.842500000000,0.915400000000,0.001800000000
    580,0.916300000000,0.870000000000,0.001650001000
    585,0.978600000000,0.816300000000,0.001400000000
    590,1.026300000000,0.757000000000,0.001100000000
    595,1.056700000000,0.694900000000,0.001000000000
    600,1.062200000000,0.631000000000,0.000800000000
    605,1.045600000000,0.566800000000,0.000600000000
    610,1.002600000000,0.503000000000,0.000340000000
    615,0.938400000000,0.441200000000,0.000240000000
    620,0.854449900000,0.381000000000,0.000190000000
    625,0.751400000000,0.321000000000,0.000100000000
    630,0.642400000000,0.265000000000,0.000049999990
    635,0.541900000000,0.217000000000,0.000030000000
    640,0.447900000000,0.175000000000,0.000020000000
    645,0.360800000000,0.138200000000,0.000010000000
    650,0.283500000000,0.107000000000,0.000000000000
    655,0.218700000000,0.081600000000,0.000000000000
    660,0.164900000000,0.061000000000,0.000000000000
    665,0.121200000000,0.044580000000,0.000000000000
    670,0.087400000000,0.032000000000,0.000000000000
    675,0.063600000000,0.023200000000,0.000000000000
    680,0.046770000000,0.017000000000,0.000000000000
    685,0.032900000000,0.011920000000,0.000000000000
    690,0.022700000000,0.008210000000,0.000000000000
    695,0.015840000000,0.005723000000,0.000000000000
    700,0.011359160000,0.004102000000,0.000000000000
    705,0.008110916000,0.002929000000,0.000000000000
    710,0.005790346000,0.002091000000,0.000000000000
    715,0.004109457000,0.001484000000,0.000000000000
    720,0.002899327000,0.001047000000,0.000000000000
    725,0.002049190000,0.000740000000,0.000000000000
    730,0.001439971000,0.000520000000,0.000000000000
    735,0.000999949300,0.000361100000,0.000000000000
    740,0.000690078600,0.000249200000,0.000000000000
    745,0.000476021300,0.000171900000,0.000000000000
    750,0.000332301100,0.000120000000,0.000000000000
    755,0.000234826100,0.000084800000,0.000000000000
    760,0.000166150500,0.000060000000,0.000000000000
    765,0.000117413000,0.000042400000,0.000000000000
    770,0.000083075270,0.000030000000,0.000000000000
    775,0.000058706520,0.000021200000,0.000000000000
    780,0.000041509940,0.000014990000,0.000000000000
    785,0.000029353260,0.000010600000,0.000000000000
    790,0.000020673830,0.000007465700,0.000000000000
    795,0.000014559770,0.000005257800,0.000000000000
    800,0.000010253980,0.000003702900,0.000000000000
    805,0.000007221456,0.000002607800,0.000000000000
    810,0.000005085868,0.000001836600,0.000000000000
    815,0.000003581652,0.000001293400,0.000000000000
    820,0.000002522525,0.000000910930,0.000000000000
    825,0.000001776509,0.000000641530,0.000000000000
    830,0.000001251141,0.000000451810,0.000000000000
        1e9	0	0	0];
    else
        ciedat = [
            0 0 0 0
    360.000000000000,0.000000122200,0.000000013398,0.000000535027
    365.000000000000,0.000000919270,0.000000100650,0.000004028300
    370.000000000000,0.000005958600,0.000000651100,0.000026143700
    375.000000000000,0.000033266000,0.000003625000,0.000146220000
    380.000000000000,0.000159952000,0.000017364000,0.000704776000
    385.000000000000,0.000662440000,0.000071560000,0.002927800000
    390.000000000000,0.002361600000,0.000253400000,0.010482200000
    395.000000000000,0.007242300000,0.000768500000,0.032344000000
    400.000000000000,0.019109700000,0.002004400000,0.086010900000
    405.000000000000,0.043400000000,0.004509000000,0.197120000000
    410.000000000000,0.084736000000,0.008756000000,0.389366000000
    415.000000000000,0.140638000000,0.014456000000,0.656760000000
    420.000000000000,0.204492000000,0.021391000000,0.972542000000
    425.000000000000,0.264737000000,0.029497000000,1.282500000000
    430.000000000000,0.314679000000,0.038676000000,1.553480000000
    435.000000000000,0.357719000000,0.049602000000,1.798500000000
    440.000000000000,0.383734000000,0.062077000000,1.967280000000
    445.000000000000,0.386726000000,0.074704000000,2.027300000000
    450.000000000000,0.370702000000,0.089456000000,1.994800000000
    455.000000000000,0.342957000000,0.106256000000,1.900700000000
    460.000000000000,0.302273000000,0.128201000000,1.745370000000
    465.000000000000,0.254085000000,0.152761000000,1.554900000000
    470.000000000000,0.195618000000,0.185190000000,1.317560000000
    475.000000000000,0.132349000000,0.219940000000,1.030200000000
    480.000000000000,0.080507000000,0.253589000000,0.772125000000
    485.000000000000,0.041072000000,0.297665000000,0.570060000000
    490.000000000000,0.016172000000,0.339133000000,0.415254000000
    495.000000000000,0.005132000000,0.395379000000,0.302356000000
    500.000000000000,0.003816000000,0.460777000000,0.218502000000
    505.000000000000,0.015444000000,0.531360000000,0.159249000000
    510.000000000000,0.037465000000,0.606741000000,0.112044000000
    515.000000000000,0.071358000000,0.685660000000,0.082248000000
    520.000000000000,0.117749000000,0.761757000000,0.060709000000
    525.000000000000,0.172953000000,0.823330000000,0.043050000000
    530.000000000000,0.236491000000,0.875211000000,0.030451000000
    535.000000000000,0.304213000000,0.923810000000,0.020584000000
    540.000000000000,0.376772000000,0.961988000000,0.013676000000
    545.000000000000,0.451584000000,0.982200000000,0.007918000000
    550.000000000000,0.529826000000,0.991761000000,0.003988000000
    555.000000000000,0.616053000000,0.999110000000,0.001091000000
    560.000000000000,0.705224000000,0.997340000000,0.000000000000
    565.000000000000,0.793832000000,0.982380000000,0.000000000000
    570.000000000000,0.878655000000,0.955552000000,0.000000000000
    575.000000000000,0.951162000000,0.915175000000,0.000000000000
    580.000000000000,1.014160000000,0.868934000000,0.000000000000
    585.000000000000,1.074300000000,0.825623000000,0.000000000000
    590.000000000000,1.118520000000,0.777405000000,0.000000000000
    595.000000000000,1.134300000000,0.720353000000,0.000000000000
    600.000000000000,1.123990000000,0.658341000000,0.000000000000
    605.000000000000,1.089100000000,0.593878000000,0.000000000000
    610.000000000000,1.030480000000,0.527963000000,0.000000000000
    615.000000000000,0.950740000000,0.461834000000,0.000000000000
    620.000000000000,0.856297000000,0.398057000000,0.000000000000
    625.000000000000,0.754930000000,0.339554000000,0.000000000000
    630.000000000000,0.647467000000,0.283493000000,0.000000000000
    635.000000000000,0.535110000000,0.228254000000,0.000000000000
    640.000000000000,0.431567000000,0.179828000000,0.000000000000
    645.000000000000,0.343690000000,0.140211000000,0.000000000000
    650.000000000000,0.268329000000,0.107633000000,0.000000000000
    655.000000000000,0.204300000000,0.081187000000,0.000000000000
    660.000000000000,0.152568000000,0.060281000000,0.000000000000
    665.000000000000,0.112210000000,0.044096000000,0.000000000000
    670.000000000000,0.081260600000,0.031800400000,0.000000000000
    675.000000000000,0.057930000000,0.022601700000,0.000000000000
    680.000000000000,0.040850800000,0.015905100000,0.000000000000
    685.000000000000,0.028623000000,0.011130300000,0.000000000000
    690.000000000000,0.019941300000,0.007748800000,0.000000000000
    695.000000000000,0.013842000000,0.005375100000,0.000000000000
    700.000000000000,0.009576880000,0.003717740000,0.000000000000
    705.000000000000,0.006605200000,0.002564560000,0.000000000000
    710.000000000000,0.004552630000,0.001768470000,0.000000000000
    715.000000000000,0.003144700000,0.001222390000,0.000000000000
    720.000000000000,0.002174960000,0.000846190000,0.000000000000
    725.000000000000,0.001505700000,0.000586440000,0.000000000000
    730.000000000000,0.001044760000,0.000407410000,0.000000000000
    735.000000000000,0.000727450000,0.000284041000,0.000000000000
    740.000000000000,0.000508258000,0.000198730000,0.000000000000
    745.000000000000,0.000356380000,0.000139550000,0.000000000000
    750.000000000000,0.000250969000,0.000098428000,0.000000000000
    755.000000000000,0.000177730000,0.000069819000,0.000000000000
    760.000000000000,0.000126390000,0.000049737000,0.000000000000
    765.000000000000,0.000090151000,0.000035540500,0.000000000000
    770.000000000000,0.000064525800,0.000025486000,0.000000000000
    775.000000000000,0.000046339000,0.000018338400,0.000000000000
    780.000000000000,0.000033411700,0.000013249000,0.000000000000
    785.000000000000,0.000024209000,0.000009619600,0.000000000000
    790.000000000000,0.000017611500,0.000007012800,0.000000000000
    795.000000000000,0.000012855000,0.000005129800,0.000000000000
    800.000000000000,0.000009413630,0.000003764730,0.000000000000
    805.000000000000,0.000006913000,0.000002770810,0.000000000000
    810.000000000000,0.000005093470,0.000002046130,0.000000000000
    815.000000000000,0.000003767100,0.000001516770,0.000000000000
    820.000000000000,0.000002795310,0.000001128090,0.000000000000
    825.000000000000,0.000002082000,0.000000842160,0.000000000000
    830.000000000000,0.000001553140,0.000000629700,0.000000000000
            1e9 0 0 0];
    end

        XYZ = interp1(ciedat(:,1)*1e-9, ciedat(:,2:4), lambda, 'pchip', 0);
        if nargin == 2,
            XYZ = spect(:)' * XYZ;
        end
%    colordistance                      - Return distance in RG colorspace
%
% D = COLORDISTANCE(RGB, RG) is the distance on the rg-chromaticity plane from
% coordinate RG=[r,g] to every pixel in the color image RGB.  D is an image 
% with the same dimensions as RGB and the value of each pixel is the the color
% space distance of the corresponding pixel in RGB.
%
% Note::
% - The output image could be thresholded to determine color similarity.
%
% See also COLORSEG.

% Peter Corke 2005
%

function s = colordistance(im, rg)

    % convert image to (r,g) coordinates
    rgb = sum(im, 3);
    r = im(:,:,1) ./ rgb;
    g = im(:,:,2) ./ rgb;

    % compute the Euclidean color space distance
    d = (r - rg(1)).^2 + (g - rg(2)).^2;

    if nargout == 0,
        idisp(d)
    else
        s = d;
    end
%    colorname                          - Map between color names and RGB values
%
% RGB = COLORNAME(NAME) is the rgb-tristimulus value corresponding to the
% color specified by the string NAME.
%
% NAME = COLORNAME(RGB) is a string giving the name of the color that is 
% closest (Euclidean) to the given rgb-tristimulus value.
%
% Notes::
% - Based on the standard X11 color database rgb.txt.
% - tristimulus values are in the range 0 to 1

function r = colorname(a, opt)

    if nargin < 2
        opt = '';
    end

    persistent  rgbtable;
    
    % ensure that the database is loaded
    if isempty(rgbtable),
        % load mapping table from file
        fprintf('loading rgb.txt\n');
        f = fopen('private/rgb.txt', 'r');
        k = 0;
        rgb = [];
        names = {};
        xy = [];

        while ~feof(f),       
            line = fgets(f);
            if line(1) == '#',
                continue;
            end

            [A,count,errm,next] = sscanf(line, '%d %d %d');
            if count == 3,
                k = k + 1;
                rgb(k,:) = A' / 255.0;
                names{k} = lower( strtrim(line(next:end)) );
                xy = xyz2xy( colorspace('RGB->XYZ', rgb) );
            end
        end
        s.rgb = rgb;
        s.names = names;
        s.xy = xy;
        rgbtable = s;
    end
    
    if isstr(a)
        % map name to rgb
        if a(1)  == '?' 
            % just do a wildcard lookup
            r = namelookup(rgbtable, a(2:end));
        else
            r = name2rgb(rgbtable, a, opt);
        end
    elseif iscell(a)
        % map multiple names to rgb
        r = [];
        for name=a,
            rgb = name2rgb(rgbtable, name{1}, opt);
            if isempty(rgb)
                warning('Color %s not found', name{1});
            end
            r = [r; rgb];
        end
    else
        if numel(a) == 3
            r = rgb2name(rgbtable, a(:)');
        elseif numcols(a) == 2 && strcmp(opt, 'xy')
            % convert xy to a name
            r = {};
            for k=1:numrows(a),
                r{k} = xy2name(rgbtable, a(k,:));
            end
        elseif numcols(a) == 3 && ~strcmp(opt, 'xy')
            % convert RGB data to a name
            r = {};
            for k=1:numrows(a),
                r{k} = rgb2name(rgbtable, a(k,:));
            end
        end
    end
end
    
function r = namelookup(table, s)
    s = lower(s);   % all matching done in lower case
    
    r = {};
    count = 1;
    for k=1:length(table.names),
        if ~isempty( findstr(table.names{k}, s) )
            r{count} = table.names{k};
            count = count + 1;
        end
    end
end

function r = name2rgb(table, s, opt)
    s = lower(s);   % all matching done in lower case
    
    for k=1:length(table.names),
        if strcmp(s, table.names(k)),
            r = table.rgb(k,:);
            if strcmp(opt, 'xy')
                r
                XYZ = colorspace('RGB->XYZ', r);
                XYZ
                r = tristim2cc(XYZ);
                r
            end
            return;
        end
    end
    r = [];
end

function r = rgb2name(table, v)
    d = table.rgb - ones(numrows(table.rgb),1) * v;
    n = colnorm(d');
    [z,k] = min(n);
    r = table.names{k};
end

function r = xy2name(table, v)
    d = table.xy - ones(numrows(table.xy),1) * v;
    n = colnorm(d');
    [z,k] = min(n);
    r = table.names{k};
end
%    colorspace                         - Convert a color image between color representations.
%
% B = COLORSPACE(S,A) converts the color representation of image A
% where S is a string specifying the conversion.  S tells the
% source and destination color spaces, S = 'dest<-src', or
% alternatively, S = 'src->dest'.  
%
% [B1,B2,B3] = COLORSPACE(S,A) as above but specifies separate output channels.
%
% COLORSPACE(S,A1,A2,A3) as above but specifies separate input channels.
%
%
% Supported color spaces are:
%
% 'RGB'               R'G'B' Red Green Blue (ITU-R BT.709 gamma-corrected)
% 'YPbPr'             Luma (ITU-R BT.601) + Chroma 
% 'YCbCr'/'YCC'       Luma + Chroma ("digitized" version of Y'PbPr)
% 'YUV'               NTSC PAL Y'UV Luma + Chroma
% 'YIQ'               NTSC Y'IQ Luma + Chroma
% 'YDbDr'             SECAM Y'DbDr Luma + Chroma
% 'JPEGYCbCr'         JPEG-Y'CbCr Luma + Chroma
% 'HSV'/'HSB'         Hue Saturation Value/Brightness
% 'HSL'/'HLS'/'HSI'   Hue Saturation Luminance/Intensity
% 'XYZ'               CIE XYZ
% 'Lab'               CIE L*a*b* (CIELAB)
% 'Luv'               CIE L*u*v* (CIELUV)
% 'Lch'               CIE L*ch (CIELCH)
%
% Notes::
% - All conversions assume 2 degree observer and D65 illuminant.
% - Color space names are case insensitive.  
% - When R'G'B' is the source or destination, it can be omitted. For 
%   example 'yuv<-' is short for 'yuv<-rgb'.
% - MATLAB uses two standard data formats for R'G'B': double data with
%   intensities in the range 0 to 1, and uint8 data with integer-valued
%   intensities from 0 to 255.  As MATLAB's native datatype, double data is
%   the natural choice, and the R'G'B' format used by colorspace.  However,
%   for memory and computational performance, some functions also operate
%   with uint8 R'G'B'.  Given uint8 R'G'B' color data, colorspace will
%   first cast it to double R'G'B' before processing.
% - If A is an Mx3 array, like a colormap, B will also have size Mx3.
%
% Author::
% Pascal Getreuer 2005-2006

function varargout = colorspace(Conversion,varargin)
%%% Input parsing %%%
if nargin < 2, error('Not enough input arguments.'); end
[SrcSpace,DestSpace] = parse(Conversion);

if nargin == 2
   Image = varargin{1};
elseif nargin >= 3
   Image = cat(3,varargin{:});
else
   error('Invalid number of input arguments.');
end

FlipDims = (size(Image,3) == 1);

if FlipDims, Image = permute(Image,[1,3,2]); end
if ~isa(Image,'double'), Image = double(Image)/255; end
if size(Image,3) ~= 3, error('Invalid input size.'); end

SrcT = gettransform(SrcSpace);
DestT = gettransform(DestSpace);

if ~ischar(SrcT) & ~ischar(DestT)
   % Both source and destination transforms are affine, so they
   % can be composed into one affine operation
   T = [DestT(:,1:3)*SrcT(:,1:3),DestT(:,1:3)*SrcT(:,4)+DestT(:,4)];      
   Temp = zeros(size(Image));
   Temp(:,:,1) = T(1)*Image(:,:,1) + T(4)*Image(:,:,2) + T(7)*Image(:,:,3) + T(10);
   Temp(:,:,2) = T(2)*Image(:,:,1) + T(5)*Image(:,:,2) + T(8)*Image(:,:,3) + T(11);
   Temp(:,:,3) = T(3)*Image(:,:,1) + T(6)*Image(:,:,2) + T(9)*Image(:,:,3) + T(12);
   Image = Temp;
elseif ~ischar(DestT)
   Image = rgb(Image,SrcSpace);
   Temp = zeros(size(Image));
   Temp(:,:,1) = DestT(1)*Image(:,:,1) + DestT(4)*Image(:,:,2) + DestT(7)*Image(:,:,3) + DestT(10);
   Temp(:,:,2) = DestT(2)*Image(:,:,1) + DestT(5)*Image(:,:,2) + DestT(8)*Image(:,:,3) + DestT(11);
   Temp(:,:,3) = DestT(3)*Image(:,:,1) + DestT(6)*Image(:,:,2) + DestT(9)*Image(:,:,3) + DestT(12);
   Image = Temp;
else
   Image = feval(DestT,Image,SrcSpace);
end

%%% Output format %%%
if nargout > 1
   varargout = {Image(:,:,1),Image(:,:,2),Image(:,:,3)};
else
   if FlipDims, Image = permute(Image,[1,3,2]); end
   varargout = {Image};
end

return;


function [SrcSpace,DestSpace] = parse(Str)
% Parse conversion argument

if isstr(Str)
   Str = lower(strrep(strrep(Str,'-',''),' ',''));
   k = find(Str == '>');
   
   if length(k) == 1         % Interpret the form 'src->dest'
      SrcSpace = Str(1:k-1);
      DestSpace = Str(k+1:end);
   else
      k = find(Str == '<');
      
      if length(k) == 1      % Interpret the form 'dest<-src'
         DestSpace = Str(1:k-1);
         SrcSpace = Str(k+1:end);
      else
         error(['Invalid conversion, ''',Str,'''.']);
      end   
   end
   
   SrcSpace = alias(SrcSpace);
   DestSpace = alias(DestSpace);
else
   SrcSpace = 1;             % No source pre-transform
   DestSpace = Conversion;
   if any(size(Conversion) ~= 3), error('Transformation matrix must be 3x3.'); end
end
return;


function Space = alias(Space)
Space = strrep(Space,'cie','');

if isempty(Space)
   Space = 'rgb';
end

switch Space
case {'ycbcr','ycc'}
   Space = 'ycbcr';
case {'hsv','hsb'}
   Space = 'hsv';
case {'hsl','hsi','hls'}
   Space = 'hsl';
case {'rgb','yuv','yiq','ydbdr','ycbcr','jpegycbcr','xyz','lab','luv','lch'}
   return;
end
return;


function T = gettransform(Space)
% Get a colorspace transform: either a matrix describing an affine transform,
% or a string referring to a conversion subroutine
switch Space
case 'ypbpr'
   T = [0.299,0.587,0.114,0;-0.1687367,-0.331264,0.5,0;0.5,-0.418688,-0.081312,0];
case 'yuv'
   % R'G'B' to NTSC/PAL YUV
   % Wikipedia: http://en.wikipedia.org/wiki/YUV
   T = [0.299,0.587,0.114,0;-0.147,-0.289,0.436,0;0.615,-0.515,-0.100,0];
case 'ydbdr'
   % R'G'B' to SECAM YDbDr
   % Wikipedia: http://en.wikipedia.org/wiki/YDbDr
   T = [0.299,0.587,0.114,0;-0.450,-0.883,1.333,0;-1.333,1.116,0.217,0];
case 'yiq'
   % R'G'B' in [0,1] to NTSC YIQ in [0,1];[-0.595716,0.595716];[-0.522591,0.522591];
   % Wikipedia: http://en.wikipedia.org/wiki/YIQ
   T = [0.299,0.587,0.114,0;0.595716,-0.274453,-0.321263,0;0.211456,-0.522591,0.311135,0];
case 'ycbcr'
   % R'G'B' (range [0,1]) to ITU-R BRT.601 (CCIR 601) Y'CbCr
   % Wikipedia: http://en.wikipedia.org/wiki/YCbCr
   % Poynton, Equation 3, scaling of R'G'B to Y'PbPr conversion
   T = [65.481,128.553,24.966,16;-37.797,-74.203,112.0,128;112.0,-93.786,-18.214,128];
case 'jpegycbcr'
   % Wikipedia: http://en.wikipedia.org/wiki/YCbCr
   T = [0.299,0.587,0.114,0;-0.168736,-0.331264,0.5,0.5;0.5,-0.418688,-0.081312,0.5]*255;
case {'rgb','xyz','hsv','hsl','lab','luv','lch'}
   T = Space;
otherwise
   error(['Unknown color space, ''',Space,'''.']);
end
return;


function Image = rgb(Image,SrcSpace)
% Convert to Rec. 709 R'G'B' from 'SrcSpace'
switch SrcSpace
case 'rgb'
   return;
case 'hsv'
   % Convert HSV to R'G'B'
   Image = huetorgb((1 - Image(:,:,2)).*Image(:,:,3),Image(:,:,3),Image(:,:,1));
case 'hsl'
   % Convert HSL to R'G'B'
   L = Image(:,:,3);
   Delta = Image(:,:,2).*min(L,1-L);
   Image = huetorgb(L-Delta,L+Delta,Image(:,:,1));
case {'xyz','lab','luv','lch'}
   % Convert to CIE XYZ
   Image = xyz(Image,SrcSpace);
   % Convert XYZ to RGB
   T = [3.240479,-1.53715,-0.498535;-0.969256,1.875992,0.041556;0.055648,-0.204043,1.057311];
   R = T(1)*Image(:,:,1) + T(4)*Image(:,:,2) + T(7)*Image(:,:,3);  % R
   G = T(2)*Image(:,:,1) + T(5)*Image(:,:,2) + T(8)*Image(:,:,3);  % G
   B = T(3)*Image(:,:,1) + T(6)*Image(:,:,2) + T(9)*Image(:,:,3);  % B
   % Desaturate and rescale to constrain resulting RGB values to [0,1]   
   AddWhite = -min(min(min(R,G),B),0);
   Scale = max(max(max(R,G),B)+AddWhite,1);
   R = (R + AddWhite)./Scale;
   G = (G + AddWhite)./Scale;
   B = (B + AddWhite)./Scale;   
   % Apply gamma correction to convert RGB to Rec. 709 R'G'B'
   Image(:,:,1) = gammacorrection(R);  % R'
   Image(:,:,2) = gammacorrection(G);  % G'
   Image(:,:,3) = gammacorrection(B);  % B'
otherwise  % Conversion is through an affine transform
   T = gettransform(SrcSpace);
   temp = inv(T(:,1:3));
   T = [temp,-temp*T(:,4)];
   R = T(1)*Image(:,:,1) + T(4)*Image(:,:,2) + T(7)*Image(:,:,3) + T(10);
   G = T(2)*Image(:,:,1) + T(5)*Image(:,:,2) + T(8)*Image(:,:,3) + T(11);
   B = T(3)*Image(:,:,1) + T(6)*Image(:,:,2) + T(9)*Image(:,:,3) + T(12);
   AddWhite = -min(min(min(R,G),B),0);
   Scale = max(max(max(R,G),B)+AddWhite,1);
   R = (R + AddWhite)./Scale;
   G = (G + AddWhite)./Scale;
   B = (B + AddWhite)./Scale;
   Image(:,:,1) = R;
   Image(:,:,2) = G;
   Image(:,:,3) = B;
end

% Clip to [0,1]
Image = min(max(Image,0),1);
return;


function Image = xyz(Image,SrcSpace)
% Convert to CIE XYZ from 'SrcSpace'
WhitePoint = [0.950456,1,1.088754];  

switch SrcSpace
case 'xyz'
   return;
case 'luv'
   % Convert CIE L*uv to XYZ
   WhitePointU = (4*WhitePoint(1))./(WhitePoint(1) + 15*WhitePoint(2) + 3*WhitePoint(3));
   WhitePointV = (9*WhitePoint(2))./(WhitePoint(1) + 15*WhitePoint(2) + 3*WhitePoint(3));
   L = Image(:,:,1);
   Y = (L + 16)/116;
   Y = invf(Y)*WhitePoint(2);
   U = Image(:,:,2)./(13*L + 1e-6*(L==0)) + WhitePointU;
   V = Image(:,:,3)./(13*L + 1e-6*(L==0)) + WhitePointV;
   Image(:,:,1) = -(9*Y.*U)./((U-4).*V - U.*V);                  % X
   Image(:,:,2) = Y;                                             % Y
   Image(:,:,3) = (9*Y - (15*V.*Y) - (V.*Image(:,:,1)))./(3*V);  % Z
case {'lab','lch'}
   Image = lab(Image,SrcSpace);
   % Convert CIE L*ab to XYZ
   fY = (Image(:,:,1) + 16)/116;
   fX = fY + Image(:,:,2)/500;
   fZ = fY - Image(:,:,3)/200;
   Image(:,:,1) = WhitePoint(1)*invf(fX);  % X
   Image(:,:,2) = WhitePoint(2)*invf(fY);  % Y
   Image(:,:,3) = WhitePoint(3)*invf(fZ);  % Z
otherwise   % Convert from some gamma-corrected space
   % Convert to Rec. 701 R'G'B'
   Image = rgb(Image,SrcSpace);
   % Undo gamma correction
   R = invgammacorrection(Image(:,:,1));
   G = invgammacorrection(Image(:,:,2));
   B = invgammacorrection(Image(:,:,3));
   % Convert RGB to XYZ
   T = inv([3.240479,-1.53715,-0.498535;-0.969256,1.875992,0.041556;0.055648,-0.204043,1.057311]);
   Image(:,:,1) = T(1)*R + T(4)*G + T(7)*B;  % X 
   Image(:,:,2) = T(2)*R + T(5)*G + T(8)*B;  % Y
   Image(:,:,3) = T(3)*R + T(6)*G + T(9)*B;  % Z
end
return;


function Image = hsv(Image,SrcSpace)
% Convert to HSV
Image = rgb(Image,SrcSpace);
V = max(Image,[],3);
S = (V - min(Image,[],3))./(V + (V == 0));
Image(:,:,1) = rgbtohue(Image);
Image(:,:,2) = S;
Image(:,:,3) = V;
return;


function Image = hsl(Image,SrcSpace)
% Convert to HSL 
switch SrcSpace
case 'hsv'
   % Convert HSV to HSL   
   MaxVal = Image(:,:,3);
   MinVal = (1 - Image(:,:,2)).*MaxVal;
   L = 0.5*(MaxVal + MinVal);
   temp = min(L,1-L);
   Image(:,:,2) = 0.5*(MaxVal - MinVal)./(temp + (temp == 0));
   Image(:,:,3) = L;
otherwise
   Image = rgb(Image,SrcSpace);  % Convert to Rec. 701 R'G'B'
   % Convert R'G'B' to HSL
   MinVal = min(Image,[],3);
   MaxVal = max(Image,[],3);
   L = 0.5*(MaxVal + MinVal);
   temp = min(L,1-L);
   S = 0.5*(MaxVal - MinVal)./(temp + (temp == 0));
   Image(:,:,1) = rgbtohue(Image);
   Image(:,:,2) = S;
   Image(:,:,3) = L;
end
return;


function Image = lab(Image,SrcSpace)
% Convert to CIE L*a*b* (CIELAB)
WhitePoint = [0.950456,1,1.088754];

switch SrcSpace
case 'lab'
   return;
case 'lch'
   % Convert CIE L*CH to CIE L*ab
   C = Image(:,:,2);
   Image(:,:,2) = cos(Image(:,:,3)*pi/180).*C;  % a*
   Image(:,:,3) = sin(Image(:,:,3)*pi/180).*C;  % b*
otherwise
   Image = xyz(Image,SrcSpace);  % Convert to XYZ
   % Convert XYZ to CIE L*a*b*
   X = Image(:,:,1)/WhitePoint(1);
   Y = Image(:,:,2)/WhitePoint(2);
   Z = Image(:,:,3)/WhitePoint(3);
   fX = f(X);
   fY = f(Y);
   fZ = f(Z);
   Image(:,:,1) = 116*fY - 16;    % L*
   Image(:,:,2) = 500*(fX - fY);  % a*
   Image(:,:,3) = 200*(fY - fZ);  % b*
end
return;


function Image = luv(Image,SrcSpace)
% Convert to CIE L*u*v* (CIELUV)
WhitePoint = [0.950456,1,1.088754];
WhitePointU = (4*WhitePoint(1))./(WhitePoint(1) + 15*WhitePoint(2) + 3*WhitePoint(3));
WhitePointV = (9*WhitePoint(2))./(WhitePoint(1) + 15*WhitePoint(2) + 3*WhitePoint(3));

Image = xyz(Image,SrcSpace); % Convert to XYZ
U = (4*Image(:,:,1))./(Image(:,:,1) + 15*Image(:,:,2) + 3*Image(:,:,3));
V = (9*Image(:,:,2))./(Image(:,:,1) + 15*Image(:,:,2) + 3*Image(:,:,3));
Y = Image(:,:,2)/WhitePoint(2);
L = 116*f(Y) - 16;
Image(:,:,1) = L;                        % L*
Image(:,:,2) = 13*L.*(U - WhitePointU);  % u*
Image(:,:,3) = 13*L.*(V - WhitePointV);  % v*
return;  


function Image = lch(Image,SrcSpace)
% Convert to CIE L*ch
Image = lab(Image,SrcSpace);  % Convert to CIE L*ab
H = atan2(Image(:,:,3),Image(:,:,2));
H = H*180/pi + 360*(H < 0);
Image(:,:,2) = sqrt(Image(:,:,2).^2 + Image(:,:,3).^2);  % C
Image(:,:,3) = H;                                        % H
return;


function Image = huetorgb(m0,m2,H)
% Convert HSV or HSL hue to RGB
N = size(H);
H = min(max(H(:),0),360)/60;
m0 = m0(:);
m2 = m2(:);
F = H - round(H/2)*2;
M = [m0, m0 + (m2-m0).*abs(F), m2];
Num = length(m0);
j = [2 1 0;1 2 0;0 2 1;0 1 2;1 0 2;2 0 1;2 1 0]*Num;
k = floor(H) + 1;
Image = reshape([M(j(k,1)+(1:Num).'),M(j(k,2)+(1:Num).'),M(j(k,3)+(1:Num).')],[N,3]);
return;


function H = rgbtohue(Image)
% Convert RGB to HSV or HSL hue
[M,i] = sort(Image,3);
i = i(:,:,3);
Delta = M(:,:,3) - M(:,:,1);
Delta = Delta + (Delta == 0);
R = Image(:,:,1);
G = Image(:,:,2);
B = Image(:,:,3);
H = zeros(size(R));
k = (i == 1);
H(k) = (G(k) - B(k))./Delta(k);
k = (i == 2);
H(k) = 2 + (B(k) - R(k))./Delta(k);
k = (i == 3);
H(k) = 4 + (R(k) - G(k))./Delta(k);
H = 60*H + 360*(H < 0);
H(Delta == 0) = nan;
return;


function Rp = gammacorrection(R)
Rp = real(1.099*R.^0.45 - 0.099);
i = (R < 0.018);
Rp(i) = 4.5138*R(i);
return;


function R = invgammacorrection(Rp)
R = real(((Rp + 0.099)/1.099).^(1/0.45));
i = (R < 0.018);
R(i) = Rp(i)/4.5138;
return;


function fY = f(Y)
fY = real(Y.^(1/3));
i = (Y < 0.008856);
fY(i) = Y(i)*(841/108) + (4/29);
return;


function Y = invf(fY)
Y = fY.^3;
i = (Y < 0.008856);
Y(i) = (fY(i) - 4/29)*(108/841);
return;
%    lambda2rg                          - RGG chromaticity coordinates
%
% RGB = CCRGB(LAMBDA) is the rg-chromaticity coordinate for illumination
% at the specific wavelength LAMBDA.
%
% RGB = CCRGB(LAMBDA, E) is the rg-chromaticity coordinate for an illumination
% spectrum E.  E and LAMBDA are vectors of the same length and the elements of E 
% represent the intensity of light at the corresponding wavelength in LAMBDA.
%
% See also CMFRGB, CCXYZ.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.
function [r,g] = lambda2rg(lambda, e)
    if nargin == 1,
        RGB = cmfrgb(lambda);
    elseif nargin == 2,
        RGB = cmfrgb(lambda, e);
    end
    cc = tristim2cc(RGB);

    if nargout == 1
        r = cc;
    elseif nargout == 2
        r = cc(:,1);
        g = cc(:,2);
    end
%    lambda2xy                          - [x,y] = lambda2xy(lambda, varargin)
    cmf = cmfxyz(lambda, varargin{:});

    xy = xyz2xy(cmf);
    if nargout == 2
        x = xy(1);
        y = xy(2);
    else
        x = xy;
    end
%    loadspectrum                       - Load spectrum data
%
% S = LOADSPECTRUM(LAMBDA, FILENAME) is spectral data from file FILENAME 
% interpolated to wavelengths specified in LAMBDA (Nx1).  S is NxD and the
% elements correspond to spectral data at the corresponding element of LAMBDA.
%
% [S,LAMBDA] = LOADSPECTRUM(LAMBDA, FILENAME) as above but also returns the 
% passed wavelength LAMBDA.
%
% Notes::
% - The File is assumed to have its first column as wavelength in metres, the 
%   remainding columns are linearly interpolated and returned as columns of S.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.

function [s,lam] = loadspectrum(lambda, filename)

    lambda = lambda(:);
    tab = load(filename);

    s = interp1(tab(:,1), tab(:,2:end), lambda);

    if nargout == 2
        lam = lambda;
    end
%    luminos                            - Photopic luminosity function
%
% P = LUMINOS(LAMBDA) is the photopic luminosity function for the wavelengths
% in LAMBDA.  If LAMBDA is a vector, then P is a vector whose elements are the
% luminosity at the corresponding elements of LAMBDA.
%
% Luminosity has units of lumens which are related to the intensity with 
% which wavelengths as perceived by the light-adapted human eye.
%
% See also RLUMINOS.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.
function lu = luminos(lam)
      tab = [
      3.8000000e-007  0.0000000e+000
      3.8500000e-007  1.0000000e-004
      3.9000000e-007  1.0000000e-004
      3.9500000e-007  2.0000000e-004
      4.0000000e-007  4.0000000e-004
      4.0500000e-007  6.0000000e-004
      4.1000000e-007  1.2000000e-003
      4.1500000e-007  2.2000000e-003
      4.2000000e-007  4.0000000e-003
      4.2500000e-007  7.3000000e-003
      4.3000000e-007  1.1600000e-002
      4.3500000e-007  1.6800000e-002
      4.4000000e-007  2.3000000e-002
      4.4500000e-007  2.9800000e-002
      4.5000000e-007  3.8000000e-002
      4.5500000e-007  4.8000000e-002
      4.6000000e-007  6.0000000e-002
      4.6500000e-007  7.3900000e-002
      4.7000000e-007  9.1000000e-002
      4.7500000e-007  1.1260000e-001
      4.8000000e-007  1.3900000e-001
      4.8500000e-007  1.6930000e-001
      4.9000000e-007  2.0800000e-001
      4.9500000e-007  2.5860000e-001
      5.0000000e-007  3.2300000e-001
      5.0500000e-007  4.0730000e-001
      5.1000000e-007  5.0300000e-001
      5.1500000e-007  6.0820000e-001
      5.2000000e-007  7.1000000e-001
      5.2500000e-007  7.9320000e-001
      5.3000000e-007  8.6200000e-001
      5.3500000e-007  9.1490000e-001
      5.4000000e-007  9.5400000e-001
      5.4500000e-007  9.8030000e-001
      5.5000000e-007  9.9500000e-001
      5.5500000e-007  1.0002000e+000
      5.6000000e-007  9.9500000e-001
      5.6500000e-007  9.7860000e-001
      5.7000000e-007  9.5200000e-001
      5.7500000e-007  9.1540000e-001
      5.8000000e-007  8.7000000e-001
      5.8500000e-007  8.1630000e-001
      5.9000000e-007  7.5700000e-001
      5.9500000e-007  6.9490000e-001
      6.0000000e-007  6.3100000e-001
      6.0500000e-007  5.6680000e-001
      6.1000000e-007  5.0300000e-001
      6.1500000e-007  4.4120000e-001
      6.2000000e-007  3.8100000e-001
      6.2500000e-007  3.2100000e-001
      6.3000000e-007  2.6500000e-001
      6.3500000e-007  2.1700000e-001
      6.4000000e-007  1.7500000e-001
      6.4500000e-007  1.3820000e-001
      6.5000000e-007  1.0700000e-001
      6.5500000e-007  8.1600000e-002
      6.6000000e-007  6.1000000e-002
      6.6500000e-007  4.4600000e-002
      6.7000000e-007  3.2000000e-002
      6.7500000e-007  2.3200000e-002
      6.8000000e-007  1.7000000e-002
      6.8500000e-007  1.1900000e-002
      6.9000000e-007  8.2000000e-003
      6.9500000e-007  5.7000000e-003
      7.0000000e-007  4.1000000e-003
      7.0500000e-007  2.9000000e-003
      7.1000000e-007  2.1000000e-003
      7.1500000e-007  1.5000000e-003
      7.2000000e-007  1.0000000e-003
      7.2500000e-007  7.0000000e-004
      7.3000000e-007  5.0000000e-004
      7.3500000e-007  4.0000000e-004
      7.4000000e-007  3.0000000e-004
      7.4500000e-007  2.0000000e-004
      7.5000000e-007  1.0000000e-004
      7.5500000e-007  1.0000000e-004
      7.6000000e-007  1.0000000e-004
      7.6500000e-007  0.0000000e+000
      7.7000000e-007  0.0000000e+000];
        
    lu = [];

    for lmd = lam(:)',
        if (lmd < 380e-9) | (lmd > 770e-9)
            lu = [lu; 0.0];
        else
            lu = [lu; 683*interp1(tab(:,1), tab(:,2), lmd)];
        end
    end;
%    rg_addticks                        - Add wavelength ticks to spectral locus
%
% RG_ADDTICKS() adds wavelength ticks to the spectral locus.
%
% See also XYCOLOURSPACE.

function rg_addticks(lam1, lam2, lamd)

    % well spaced points around the locus
    lambda = [460:10:540];
    lambda = [lambda 560:20:600];

    rgb = cmfrgb(lambda*1e-9);        
    r = rgb(:,1)./sum(rgb')';    
    g = rgb(:,2)./sum(rgb')';    
    hold on
    plot(r,g, 'o')
    hold off

    for i=1:numcols(lambda)
        text(r(i), g(i), sprintf('  %d', lambda(i)));
    end
%    rluminos                           - Relative photopic luminosity function
%
% P = RUMINOS(LAMBDA) is the relative photopic luminosity function for the 
% wavelengths in LAMBDA.  If LAMBDA is a vector, then P is a vector whose 
% elements are the relative luminosity at the corresponding elements of LAMBDA.
%
% Relative luminosity lies in the interval 0 to 1 which indicate the intensity 
% with which wavelengths as perceived by the light-adapted human eye.
%
% See also LUMINOS.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.
function lu = rluminos(lambda)
    xyz = cmfxyz(lambda);
    lu = xyz(:,2);  % photopic luminosity is the Y color matching function
%    tristim2cc                         - Tristimulus to chromaticity coordinates
%
% CC = TRISTIM2CC(TRI) is the chromaticity coordinates corresponding to the
% tristimulus TRI.  If TRI is RGB then CC is rg, if TRI is XYZ then CC is xy.
% Multiple tristimulus values can be given as rows of TRI (Nx3) in which case 
% the chromaticity coordinates are the corresponding rows of CC (Nx2).
%
% [C1,C2] = TRISTIM2CC(TRI) as above but the chromaticity coordinates are
% provided in separate vectors, each Nx1.
%
% OUT = TRISTIM2CC(IM) is the chromaticity coordinates corresponding to every
% pixel in the tristimulus image IM (HxWx3).  OUT (HxWx2) has planes
% corresponding to r and g, or x and y.
%
% [O1,O2] = TRISTIM2CC(IM) as above but the chromaticity images are provided
% as images (HxW).

function [a,b] = tristim2cc(tri)

    if ndims(tri) < 3
        % each row is R G B or X Y Z

        s = sum(tri')';

        cc = tri(:,1:2) ./ [s s];
        if nargout == 1
            a = cc;
        else
            a = cc(:,1);
            b = cc(:,2);
        end
    else

        s = sum(tri, 3);

        if nargout == 1
            a = tri(:,:,1:2) ./ cat(3, s, s);
        else
            a = tri(:,:,1) ./ s;
            b = tri(:,:,2) ./ s;
        end
    end
%    xycolorspace                       - Display spectral locus
%
% XYCOLORSPACE() display the spectral locus in terms of CIE x and y 
% coordinates.
%
% XYCOLORSPACE(P) as above but plot the points whose xy-chromaticity
% is given by the columns of P.
%
% [IM,AX,AY] = XYCOLORSPACE() as above returns the spectral locus as an
% image IM, with corresponding x- and y-axis coordinates AX and AY 
% respectively.
%
% See also RG_ADDTICKS.

% Based on code by Pascal Getreuer 2006
% Demo for colorspace.m - the CIE xyY "tongue"

function [im,ax,ay] = xycolorspace(cxy)
    N = 160;
    Nx = round(N*0.8);
    Ny = round(N*0.9);
    e = 0.01;
    % Generate colors in the xyY color space
    x = linspace(e,0.8-e,Nx);
    y = linspace(e,0.9-e,Ny);
    [xx,yy] = meshgrid(x,y);
    iyy = 1./(yy + 1e-5*(yy == 0));

    % Convert from xyY to XYZ
    Y = ones(Ny,Nx);
    X = Y.*xx.*iyy;
    Z = Y.*(1-xx-yy).*iyy;
    % Convert from XYZ to R'G'B'
    CIEColor = colorspace('rgb<-xyz',cat(3,X,Y,Z));


    % define the boundary
    lambda = [400:20:700]*1e-9';
    xyz = ccxyz(lambda);

    xy = xyz(:,1:2);

    % Make a smooth boundary with spline interpolation
    xi = [interp1(xy(:,1),1:0.25:size(xy,1),'spline'),xy(1,1)];
    yi = [interp1(xy(:,2),1:0.25:size(xy,1),'spline'),xy(1,2)];

    % create a mask image, colors within the boundary
    in = inpolygon(xx, yy, xi,yi);
    
    CIEColor(~cat(3,in,in,in)) = 1; % set outside pixels to white

    if nargout == 0
        % Render the colors on the tongue
        image(x,y,CIEColor)
        if nargin == 1
            plot_point(cxy, 'k*', 'textsize', 10, 'sequence', 'textcolor', 'k');
        end
    
        set(gca, 'Ydir', 'normal');

        hold on
        plot(xi,yi,'k-');
%         for lambda = 400:20:700,
%             xyz = ccxyz(lambda*1e-9);
%             plot(xyz(1), xyz(2), 'Marker', 'o', 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k');
%         end
        hold off
        
        axis([0,0.8,0,0.9]);
        xlabel('x');
        ylabel('y');
        grid
        shg;
    else
        ax = x;
        ay = y;
        im = CIEColor;
        if nargin == 1
            markfeatures(cxy, 0, '*', {10, 'k'});
        end
    
    end
%
%  Camera models
%    CentralCamera                      - Central perspective camera class
%
%   C = camera         default camera, 1024x1024, f=8mm, 10um pixels, camera at 
%                             origin, optical axis is z-axis, u||x, v||y).
%   C = camera(f, s, pp, npix, name)
%   C = camera(0)           f=sx=sy=1, u0=v0=0: normalized coordinates
%
%   This camera model assumes central projection, that is, the focal point
%   is at z=0 and the image plane is at z=f.  The image is not inverted.
%
%   The camera coordinate system is:
%
%       0------------> u X
%       |
%       |
%       |   + (principal point)
%       |
%       |
%       v Y
%              Z-axis is into the page.
%
% Object properties (read/write)
%
%   C.f           intrinsic: focal length 
%   C.s           intrinsic: pixel size 2x1
%   C.pp          intrinsic: principal point 2x1
%   C.np          size of the virtual image plane (pixels) 2x1
%
%   C.Tcam        extrinsic: pose of the camera
%   C.name        name of the camera, used for graphical display
%
% Object properties (read only)
%
%   C.su          pixel width
%   C.sv          pixel height
%   C.u0          principal point, u coordinate
%   C.v0          principal point, v coordinate
% 
% Object methods
%
%   C.fov         return camera half field-of-view angles (2x1 rads)
%   C.K           return camera intrinsic matrix (3x3)
%   C.P           return camera project matrix for camera pose (3x4)
%   C.P(T)        return camera intrinsic matrix for specified camera pose (3x4)
%
%   C.H(T, n, d)  return homography for plane: normal n, distance d  (3x3)
%   C.F(T)        return fundamental matrix from pose 3x3
%   C.E(T)        return essential matrix from pose 3x3
%   C.E(F)        return essential matrix from fundamental matrix 3x3
%
%   C.plot_epiline(F, p)
%
%   C.invH(H)     return solutions for camera motion and plane normal
%   C.invE(E)     return solutions for pose from essential matrix 4x4x4
%
%   C.rpy(r,p,y)   set camera rpy angles
%   C.rpy(rpy)
%
%   uv = C.project(P)     return image coordinates for world points  P
%   uv = C.project(P, T)  return image coordinates for world points P 
%                          transformed by T prior to projection
%
% P is a list of 3D world points and the corresponding image plane points are 
% returned in uv.  Each point is represented by a column in P and uv.
%
% If P has 3 columns it is treated as a number of 3D points in  world 
% coordinates, one point per row.
%
% If POINTS has 6 columns, each row is treated as the start and end 3D 
% coordinate for a line segment, in world coordinates.  
%
% The optional arguments, T, represents a transformation that can be applied
% to the object data, P, prior to 'imaging'.  The camera pose, C.Tcam, is also 
% taken into account.
%
%   uv = C.plot(P)    display image coordinates for world points P
%   uv = C.plot(P, T) isplay image coordinates for world points P transformed by T
%
% Points are displayed as a round marker.  Lines are displayed as line segments.
% Optionally returns image plane coordinates uv.
%
%   C.show
%   C.show(name)
%
% Create a graphical camera with name, and pixel dimensions given by C.npix.  
% Automatically called on first call to plot().

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.

% TODO:
%   make a parent imaging class and subclass perspective, fisheye, panocam
%   test for points in front of camera and set to NaN if not
%   test for points off the image plane and set to NaN if not
%     make clipping/test flags
classdef CentralCamera < Camera

    properties
        f       % focal length
        k       % radial distortion vector
        p       % tangential distortion parameters
        distortion  % camera distortion [k1 k2 k3 p1 p2]
    end

    properties (SetAccess = private)
    end

    properties (GetAccess = private, SetAccess = private)

    end

    properties (GetAccess = private)
    end

    properties (Dependent = true, SetAccess = private)
    end

    methods

        %
        %   Return a camera intrinsic parameter structure:
        %       focal length 8mm
        %       pixel size 10um square
        %       image size 1024 x 1024
        %       principal point (512, 512)
        function c = CentralCamera(varargin)
            % invoke the superclass constructor
            c = c@Camera(varargin{:});
            c.type = 'central-perspective';
            c.perspective = true;

            if nargin == 0,
                c.name = 'canonic';
                % default values
                c.f = 1;
                c.distortion = [];
            elseif nargin == 1 && isa(varargin{1}, 'CentralCamera')
                % copy constructor
                old = varargin{1};
                for p=properties(c)'
                    % copy each property across, exceptions occur
                    % for those with protected SetAccess
                    p = p{1};
                    try
                        c = setfield(c, p, getfield(old, p));
                    end
                end
            end
            if isempty(c.pp) && ~isempty(c.npix)
                c.pp = c.npix/2;
            elseif isempty(c.pp)
                c.pp =[0 0];
            end
        end

        function n = paramSet(c, args)
            n = 0;
            switch lower(args{1})
            case 'focal'
                c.f = args{2}; n = 1;
            case 'distortion'
                v = args{2}; n = 1;
                if length(v) ~= 5
                    error('distortion vector is [k1 k2 k3 p1 p2]');
                end
                c.distortion = v;
            case 'distortion-bouget'
                v = args{2}; n = 1;
                if length(v) ~= 5
                    error('distortion vector is [k1 k2 p1 p2 k3]');
                end
                c.distortion = [v(1) v(2) v(5) v(3) v(4)];;
            case 'default'
                c.f = 8e-3;     % f
                c.rho = [10e-6, 10e-6];      % square pixels 10um side
                c.npix = [1024, 1024];  % 1Mpix image plane
                c.pp = [512, 512];      % principal point in the middle
                c.limits = [0 1024 0 1024];
            otherwise
                error('VisionToolbox:CentralCamera:UnknownOption', 'Unknown option %s', args{1});
            end
        end


        function s = char(c)

            s = sprintf('name: %s [%s]', c.name, c.type);
            s = strvcat(s, sprintf(    '  focal length:   %-11.4g', c.f));
            if ~isempty(c.distortion)
                s = strvcat(s, sprintf('  distortion:     k=(%.4g, %.4g, %.4g), p=(%.4g, %.4g)', c.distortion));
            end
            s = strvcat(s, char@Camera(c) );
        end

        % intrinsic parameter matrix
        function v = K(c)
            v = [   c.f/c.rho(1)   0           c.pp(1) 
                    0          c.f/c.rho(2)    c.pp(2)
                    0          0           1%/c.f
                ] ;
        end

        % camera calibration or projection matrix
        function v = C(c, Tcam)
            if nargin == 1,
                Tcam = c.T;
            end

            if isempty(c.rho)
                rho = [1 1];
            else
                rho = c.rho;
            end

            v = [   c.f/rho(1)     0           c.pp(1)   0
                    0            c.f/rho(2)    c.pp(2)   0
                    0            0           1         0
                ] * inv(Tcam);
        end

        function HH = H(c, T, n, d)
            
            if (d < 0) || (n(3) < 0)
                error('plane distance must be > 0 and normal away from camera');
            end
            
            % T is the transform from view 1 to view 2
            % (R,t) is the inverse
            T = inv(T);
            
            R = t2r( T );
            t = transl( T );

            HH = R + 1.0/d*t*n(:)';

            % now apply the camera intrinsics
            K = c.K
            HH = K * HH * inv(K);
            HH = HH / HH(3,3);     % normalize it
        end
        
        function s = invH(c, H, varargin)
            if nargout == 0
                invhomog(H, 'K', c.K, varargin{:});
            else
                s = invhomog(H, 'K', c.K, varargin{:});
            end
        end
        
        function fmatrix = F(c, X)
            % cam.F(X)
            % cam.F(cam2)   with 
            
            % REF: An Invitation to 3D geometry, p.177
            
            % T is the pose for view 1 
            % c.T is the pose for view 2

            if ishomog(X)
                E = c.E(X);
                K = c.K();
                fmatrix = inv(K)' * E * inv(K);
            elseif  isa(X, 'Camera')
                % use relative pose and camera parameters of 
                E = c.E(X);
                K1 = c.K;
                K2 = X.K();
                fmatrix = inv(K2)' * E * inv(K1);
            end
        end
        
        % E = cam1.E(F)     convert F matrix to E using camera intrinsics
        % E = cam1.E(T12)   compute E for second view displaced by T12 from first
        % E = cam1.E(cam2)  compute E for second view given by cam2 and first view given
        %                    by cam1
        function ematrix = E(c, X)

            % essential matrix from pose.  Assume the first view is associated
            % with the passed argument, either a hom.trans or a camera.
            % The second view is Tcam of this object.
            if ismatrix(X) && all(size(X) == [3 3]),
                % essential matrix from F matrix
                F = X;

                K = c.K();
                ematrix = K'*F*K;
                return;
            elseif isa(X, 'Camera')
                T21 = inv(X.T) * c.T;
            elseif ishomog(X)
                T21 = inv(X);
            else
                error('unknown argument type');
            end

            % T = (R,t) is the transform from transform from 2 --> 1
            %
            % as per Hartley & Zisserman p.244
            %   P' = K' [R t] where [R t] is inverse camera pose, PIC book (8.5)
            %
            % as per Ma etal. p.100
            %   X2 = RX1 + t, so [R t] is the transform from C2 to C1

            [R,t] = tr2rt(T21);
            
            % REF: An Invitation to 3D geometry, p.177
            %   E = Sk(t) R

            ematrix = skew(t) * R;
        end
        
        function s = invE(c, E, P)
            % REF: Hartley & Zisserman, Chap 9, p. 259

            % we return T from view 1 to view 2
            
            [U,S,V] = svd(E);
            % singular values are (sigma, sigma, 0)
            
            if 0
                % H&Z solution
                W = [0 -1 0; 1 0 0; 0 0 1];   % rotz(pi/2)

                t = U(:,3);
                R1 = U*W*V';
                if det(R1) < 0,
                    disp('flip');
                    V = -V;
                    R1 = U*W*V';
                    det(R1)
                end
                R2 = U*W'*V';

                % we need to invert the solutions since our definition of pose is
                % from initial camera to the final camera
                s(:,:,1) = inv([R1 t; 0 0 0 1]);
                s(:,:,2) = inv([R1 -t; 0 0 0 1]);
                s(:,:,3) = inv([R2 t; 0 0 0 1]);
                s(:,:,4) = inv([R2 -t; 0 0 0 1]);
            else
                % Ma etal solution, p116, p120-122
                % Fig 5.2 (p113), is wrong, (R,t) is from camera 2 to 1
                if det(V) < 0
                    V = -V;
                    S = -S;
                end
                if det(U) < 0
                    U = -U;
                    S = -S;
                end
                R1 = U*rotz(pi/2)'*V';
                R2 = U*rotz(-pi/2)'*V';
                t1 = vex(U*rotz(pi/2)*S*U');
                t2 = vex(U*rotz(-pi/2)*S*U');
                % invert (R,t) so its from camera 1 to 2
                s(:,:,1) = inv( [R1 t1; 0 0 0 1] );
                s(:,:,2) = inv( [R2 t2; 0 0 0 1] );
            end
            
            if nargin > 2
                for i=1:size(s,3)
                    if ~any(isnan(c.project(P, 'Tcam', s(:,:,i))))
                        s = s(:,:,i);
                        fprintf('solution %d is good\n', i);
                        return;
                    end
                end
                warning('no solution has given point in front of camera');
            end
        end
        
        % plot a line specified in theta-rho format
        function plot_line_tr(cam, lines, varargin)

            x = get(cam.h_image, 'XLim');
            y = get(cam.h_image, 'YLim');

            % plot it
            for i=1:numcols(lines)
                theta = lines(1,i);
                rho = lines(2,i);
                %fprintf('theta = %f, d = %f\n', line.theta, line.rho);
                if abs(cos(theta)) > 0.5,
                    % horizontalish lines
                    plot(x, -x*tan(theta) + rho/cos(theta), varargin{:}, 'Parent', cam.h_image);
                else
                    % verticalish lines
                    plot( -y/tan(theta) + rho/sin(theta), y, varargin{:}, 'Parent', cam.h_image);
                end
            end
        end

        function handles = plot_epiline(c, F, p, varargin)

            % for all input points
            l = F * e2h(p);

            c.line(l, varargin{:});
        end

        % return field-of-view angle for x and y direction (rad)
        function th = fov(c)
            th = 2*atan(c.npix/2.*c.rho / c.f);
        end



        function uv = project(c, P, varargin)
        % do the camera perspective transform
        %   P is 3xN matrix of points to plot

            opt.Tobj = [];
            opt.Tcam = [];

            [opt,arglist] = tb_optparse(opt, varargin);

            np = numcols(P);
                
            if isempty(opt.Tcam)
                opt.Tcam = c.T;
            end

            if ndims(opt.Tobj) == 3 && ndims(opt.Tcam) == 3
                error('cannot animate object and camera simultaneously');
            end

            if ndims(opt.Tobj) == 3
                % animate object motion, static camera

                % get camera matrix for this camera pose
                C = c.C(opt.Tcam);

                % make the world points homogeneous
                if numrows(P) == 3
                    P = e2h(P);
                end

                for frame=1:size(opt.Tobj,3)

                    % transform all the points to camera frame
                    X = C * opt.Tobj(:,:,frame) * P;     % project them

                    X(3,X(3,:)<0) = NaN;    % points behind the camera are set to NaN
                    X = h2e(X);            % convert to Euclidean coordinates

                    if c.noise
                        % add Gaussian noise with specified standard deviation
                        X = X + diag(c.noise) * randn(size(X)); 
                    end
                    uv(:,:,frame) = X;
                end
            else
                % animate camera, static object

                % transform the object
                if ~isempty(opt.Tobj)
                    P = transformp(opt.Tobj, P);
                end

                % make the world points homogeneous
                if numrows(P) == 3
                    P = e2h(P);
                end

                for frame=1:size(opt.Tcam,3)
                    C = c.C(opt.Tcam(:,:,frame));

                    % transform all the points to camera frame
                    X = C * P;              % project them
                    X(3,X(3,:)<0) = NaN;    % points behind the camera are set to NaN
                    X = h2e(X);            % convert to Euclidean coordinates

                    if c.noise
                        % add Gaussian noise with specified standard deviation
                        X = X + diag(c.noise) * randn(size(X)); 
                    end
                    uv(:,:,frame) = X;
                end
            end
        end

        function r = ray(cam, p)
            % from HZ p 162
            C = cam.C();
            Mi = inv(C(1:3,1:3));
            p4 = C(:,4);
            for i=1:numcols(p)
                r(i) = Ray3D(-Mi*p4, Mi*e2h(p(:,i)));
            end
        end

        function hg = drawCamera(cam, s, varargin)

            hold on
            if nargin == 0
                s = 1;
            end

            s = s/3;

            opt.color = 'b';
            opt.mode = {'solid', 'mesh'};
            opt.label = false;
            opt = tb_optparse(opt, varargin);

            % create a new transform group
            hg = hgtransform;

            % the box is centred at the origin and its centerline parallel to the
            % z-axis.  Its z-extent is -bh/2 to bh/2.
            bw = 0.5;       % half width of the box
            bh = 1.2;       % height of the box
            cr = 0.4;       % cylinder radius
            ch = 0.8;       % cylinder height
            cn = 16;        % number of facets of cylinder
            a = 3;          % length of axis line segments

            opt.scale = s;
            opt.parent = hg;

            % draw the box part of the camera
            r = bw*[1; 1];
            x = r * [1 1 -1 -1 1];
            y = r * [1 -1 -1 1 1];
            z = [-bh; bh]/2 * ones(1,5);
            draw(x,y,z, opt);

            % draw top and bottom of box
            x = bw * [-1 1; -1 1];
            y = bw * [1 1; -1 -1];
            z = [1 1; 1 1];

            draw(x,y,-bh/2*z, opt);
            draw(x,y,bh/2*z, opt);


            % draw the lens
            [x,y,z] = cylinder(cr, cn);
            z = ch*z+bh/2;
            h = draw(x,y,z, opt);
            set(h, 'BackFaceLighting', 'unlit');

            % draw the x-, y- and z-axes
            h = plot3([0,a*s], [0,0], [0,0], 'k')
            set(h, 'Parent', hg);
            h = plot3([0,0], [0,a*s], [0,0], 'k')
            set(h, 'Parent', hg);
            h = plot3([0,0], [0,0], [0,a*s], 'k')
            set(h, 'Parent', hg);

            if opt.label
                h = text( a*s,0,0, cam.name);
                set(h, 'Parent', hg);
            end
            hold off


            function h = draw(x, y, z, opt)

                s = opt.scale;
                switch opt.mode
                case 'solid'
                    h = surf(x*s,y*s,z*s, 'FaceColor', opt.color);
                case 'surfl'
                    h = surfl(x*s,y*s,z*s, 'FaceColor', opt.color);
                case 'mesh'
                    h = mesh(x*s,y*s,z*s, 'EdgeColor', opt.color);
                end

                set(h, 'Parent', opt.parent);
            end
        end
    end % methods
end % class
%    CatadioptricCamera                 - Catadioptric camera class
%
%   C = camera    default camera, 1024x1024, f=8mm, 10um pixels, camera at 
%                             origin, optical axis is z-axis, u||x, v||y).
%   C = camera(f, s, pp, npix, name)
%   C = camera(0)           f=sx=sy=1, u0=v0=0: normalized coordinates
%
%   This camera model assumes central projection, that is, the focal point
%   is at z=0 and the image plane is at z=f.  The image is not inverted.
%
%   The camera coordinate system is:
%
%       0------------> u X
%       |
%       |
%       |   + (principal point)
%       |
%       |
%       v Y
%              Z-axis is into the page.
%
% Object properties (read/write)
%
%   C.f           intrinsic: focal length 
%   C.s           intrinsic: pixel size 2x1
%   C.pp          intrinsic: principal point 2x1
%   C.np          size of the virtual image plane (pixels) 2x1
%
%   C.Tcam        extrinsic: pose of the camera
%   C.name        name of the camera, used for graphical display
%
% Object properties (read only)
%
%   C.su          pixel width
%   C.sv          pixel height
%   C.u0          principal point, u coordinate
%   C.v0          principal point, v coordinate
% 
% Object methods
%
%   C.fov         return camera half field-of-view angles (2x1 rads)
%   C.K           return camera intrinsic matrix (3x3)
%   C.P           return camera project matrix for camera pose (3x4)
%   C.P(T)        return camera intrinsic matrix for specified camera pose (3x4)
%
%   C.rpy(r,p,y)   set camera rpy angles
%   C.rpy(rpy)
%
%   uv = C.project(P)     return image coordinates for world points  P
%   uv = C.project(P, T)  return image coordinates for world points P 
%                          transformed by T prior to projection
%
% P is a list of 3D world points and the corresponding image plane points are 
% returned in uv.  Each point is represented by a column in P and uv.
%
% If P has 3 columns it is treated as a number of 3D points in  world 
% coordinates, one point per row.
%
% If POINTS has 6 columns, each row is treated as the start and end 3D 
% coordinate for a line segment, in world coordinates.  
%
% The optional arguments, T, represents a transformation that can be applied
% to the object data, P, prior to 'imaging'.  The camera pose, C.Tcam, is also 
% taken into account.
%
%   uv = C.plot(P)    display image coordinates for world points P
%   uv = C.plot(P, T) isplay image coordinates for world points P transformed by T
%
% Points are displayed as a round marker.  Lines are displayed as line segments.
% Optionally returns image plane coordinates uv.
%
%   C.show
%   C.show(name)
%
% Create a graphical camera with name, and pixel dimensions given by C.npix.  
% Automatically called on first call to plot().
%
% SEE ALSO: Camera

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.

% TODO:
%   make a parent imaging class and subclass perspective, fisheye, panocam
%   test for points in front of camera and set to NaN if not
%   test for points off the image plane and set to NaN if not
%     make clipping/test flags
classdef CatadioptricCamera < Camera

    properties
        k       % radial distortion vector
        model   % projection model
        maxangle    % maximum elevation angle (above horizontal)
    end

    properties (SetAccess = private)
    end

    properties (GetAccess = private, SetAccess = private)

    end

    properties (GetAccess = private)
    end

    properties (Dependent = true, SetAccess = private)
    end
    
    methods

        %
        %   Return a camera intrinsic parameter structure:
        %       focal length 8mm
        %       pixel size 10um square
        %       image size 1024 x 1024
        %       principal point (512, 512)
        function c = CatadioptricCamera(varargin)


            % invoke the superclass constructor
            c = c@Camera(varargin{:});
            c.type = 'FishEye';

            if nargin == 0,
                % default values
                c.type = 'catadioptric';
                c.k = 1;
                c.model = 'equiangular';
                c.name = 'catadioptric-default';

            else
                if isempty(c.k)
                    % compute k if not specified, so that hemisphere fits into
                    % image plane
                    r = min([(c.npix-c.pp).*c.rho, c.pp.*c.rho]);
                    switch c.model
                    case 'equiangular'
                        c.k = r / (pi/2 + c.maxangle);
                    case 'sine'
                        c.k = r;
                    case 'equisolid'
                        c.k = r / sin(pi/4);
                    case 'stereographic'
                        c.k = r / tan(pi/4);
                        r = c.k * tan(theta/2);
                    otherwise
                        error('unknown fisheye projection model');
                    end
                end
            end
        end

        function n = paramSet(c, args)
            switch lower(args{1})
            case 'maxangle'
                c.maxangle = args{2}; n = 1;
            case 'k'
                c.k = args{2}; n = 1;
            case 'projection'
                c.model = args{2}; n = 1;
            case 'default'
                c.s = [10e-6, 10e-6];      % square pixels 10um side
                c.npix = [1024, 1024];  % 1Mpix image plane
                c.pp = [512, 512];      % principal point in the middle
                c.limits = [0 1024 0 1024];
                c.name = 'default';
                r = min([(c.npix-c.pp).*c.s, c.pp.*c.s]);
                c.k = 2*r/pi;
                n = 0;
            otherwise
                error( sprintf('unknown option <%s>', args{count}));
            end
        end

        function s = char(c)

            s = sprintf('name: %s [%s]', c.name, c.type);
            s = strvcat(s, sprintf(    '  model:          %s', c.model));
            s = strvcat(s, sprintf(    '  k:              %-11.4g', c.k));
            s = strvcat(s, char@Camera(c) );
        end

        % return field-of-view angle for x and y direction (rad)
        function th = fov(c)
            th = 2*atan(c.npix/2.*c.s / c.f);
        end

        % do the fisheye projection
        function uv = project(c, P, varargin)

            np = numcols(P);
                
            opt.Tobj = [];
            opt.Tcam = [];

            [opt,arglist] = tb_optparse(opt, varargin);
            
            if isempty(opt.Tcam)
                opt.Tcam = c.T;
            end
            if isempty(opt.Tobj)
                opt.Tobj = eye(4,4);
            end

            
            % transform all the points to camera frame
            X = homtrans(inv(opt.Tcam) * opt.Tobj, P);         % project them

            R = colnorm(X(1:3,:));
            phi = atan2( X(2,:), X(1,:) );
            theta = acos( X(3,:) ./ R );

            switch c.model
            case 'equiangular'
                r = c.k * theta;
            case 'sine'
                r = c.k * sin(theta);
            case 'equisolid'
                r = c.k * sin(theta/2);
            case 'stereographic'
                r = c.k * tan(theta/2);
            otherwise
                error('unknown fisheye projection model');
            end

            x = r .* cos(phi);
            y = r .* sin(phi);

            uv = [x/c.rho(1)+c.pp(1); y/c.rho(2)+c.pp(2)];

            if c.noise
                % add Gaussian noise with specified standard deviation
                uv = uv + diag(c.noise) * randn(size(uv)); 
            end
        end
    end % methods
end % class
%    FishEyeCamera                      - Fish eye camera class
%
%   C = camera    default camera, 1024x1024, f=8mm, 10um pixels, camera at 
%                             origin, optical axis is z-axis, u||x, v||y).
%   C = camera(f, s, pp, npix, name)
%   C = camera(0)           f=sx=sy=1, u0=v0=0: normalized coordinates
%
%   This camera model assumes central projection, that is, the focal point
%   is at z=0 and the image plane is at z=f.  The image is not inverted.
%
%   The camera coordinate system is:
%
%       0------------> u X
%       |
%       |
%       |   + (principal point)
%       |
%       |
%       v Y
%              Z-axis is into the page.
%
% Object properties (read/write)
%
%   C.f           intrinsic: focal length 
%   C.s           intrinsic: pixel size 2x1
%   C.pp          intrinsic: principal point 2x1
%   C.np          size of the virtual image plane (pixels) 2x1
%
%   C.Tcam        extrinsic: pose of the camera
%   C.name        name of the camera, used for graphical display
%
% Object properties (read only)
%
%   C.su          pixel width
%   C.sv          pixel height
%   C.u0          principal point, u coordinate
%   C.v0          principal point, v coordinate
% 
% Object methods
%
%   C.fov         return camera half field-of-view angles (2x1 rads)
%   C.K           return camera intrinsic matrix (3x3)
%   C.P           return camera project matrix for camera pose (3x4)
%   C.P(T)        return camera intrinsic matrix for specified camera pose (3x4)
%
%   C.rpy(r,p,y)   set camera rpy angles
%   C.rpy(rpy)
%
%   uv = C.project(P)     return image coordinates for world points  P
%   uv = C.project(P, T)  return image coordinates for world points P 
%                          transformed by T prior to projection
%
% P is a list of 3D world points and the corresponding image plane points are 
% returned in uv.  Each point is represented by a column in P and uv.
%
% If P has 3 columns it is treated as a number of 3D points in  world 
% coordinates, one point per row.
%
% If POINTS has 6 columns, each row is treated as the start and end 3D 
% coordinate for a line segment, in world coordinates.  
%
% The optional arguments, T, represents a transformation that can be applied
% to the object data, P, prior to 'imaging'.  The camera pose, C.Tcam, is also 
% taken into account.
%
%   uv = C.plot(P)    display image coordinates for world points P
%   uv = C.plot(P, T) isplay image coordinates for world points P transformed by T
%
% Points are displayed as a round marker.  Lines are displayed as line segments.
% Optionally returns image plane coordinates uv.
%
%   C.show
%   C.show(name)
%
% Create a graphical camera with name, and pixel dimensions given by C.npix.  
% Automatically called on first call to plot().
%
% SEE ALSO: Camera

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.

% TODO:
%   make a parent imaging class and subclass perspective, fisheye, panocam
%   test for points in front of camera and set to NaN if not
%   test for points off the image plane and set to NaN if not
%     make clipping/test flags
classdef FishEyeCamera < Camera

    properties
        k       % radial distortion vector
        model   % projection model
    end

    properties (SetAccess = private)
    end

    properties (GetAccess = private, SetAccess = private)

    end

    properties (GetAccess = private)
    end

    properties (Dependent = true, SetAccess = private)
    end
    
    methods

        %
        %   Return a camera intrinsic parameter structure:
        %       focal length 8mm
        %       pixel size 10um square
        %       image size 1024 x 1024
        %       principal point (512, 512)
        function c = FishEyeCamera(varargin)


            % invoke the superclass constructor
            c = c@Camera(varargin{:});
            c.type = 'FishEye';

            if nargin == 0,
                % default values
                c.type = 'fisheye';
                c.k = 1;
                c.model = 'equiangular';
                c.name = 'fisheye-default';

            else
                if isempty(c.k)
                    % compute k if not specified, so that hemisphere fits into
                    % image plane
                    r = min([(c.npix-c.pp).*c.rho, c.pp.*c.rho]);
                    switch c.model
                    case 'equiangular'
                        c.k = r / (pi/2);
                    case 'sine'
                        c.k = r;
                    case 'equisolid'
                        c.k = r / sin(pi/4);
                    case 'stereographic'
                        c.k = r / tan(pi/4);
                        r = c.k * tan(theta/2);
                    otherwise
                        error('unknown fisheye projection model');
                    end
                end
            end
        end

        function n = paramSet(c, args)
            switch lower(args{1})
            case 'k'
                c.k = args{2}; n = 1;
            case 'projection'
                c.model = args{2}; n = 1;
            case 'default'
                c.rho = [10e-6, 10e-6];      % square pixels 10um side
                c.npix = [1024, 1024];  % 1Mpix image plane
                c.pp = [512, 512];      % principal point in the middle
                c.limits = [0 1024 0 1024];
                c.name = 'default';
                r = min([(c.npix-c.pp).*c.rho, c.pp.*c.rho]);
                c.k = 2*r/pi;
                n = 0;
            otherwise
                error( sprintf('unknown option <%s>', args{count}));
            end
        end

        function s = char(c)

            s = sprintf('name: %s [%s]', c.name, c.type);
            s = strvcat(s, sprintf(    '  model:          %s', c.model));
            s = strvcat(s, sprintf(    '  k:              %-11.4g', c.k));
            s = strvcat(s, char@Camera(c) );
        end

        % return field-of-view angle for x and y direction (rad)
        function th = fov(c)
            th = 2*atan(c.npix/2.*c.s / c.f);
        end

        % do the fisheye projection
        function uv = project(c, P, varargin)

            np = numcols(P);
                
            opt.Tobj = [];
            opt.Tcam = [];

            [opt,arglist] = tb_optparse(opt, varargin);
            
            if isempty(opt.Tcam)
                opt.Tcam = c.T;
            end
            if isempty(opt.Tobj)
                opt.Tobj = eye(4,4);
            end
            
            % transform all the points to camera frame
            X = homtrans(inv(opt.Tcam) * opt.Tobj, P);         % project them

            R = colnorm(X(1:3,:));
            phi = atan2( X(2,:), X(1,:) );
            theta = acos( X(3,:) ./ R );

            switch c.model
            case 'equiangular'
                r = c.k * theta;
            case 'sine'
                r = c.k * sin(theta);
            case 'equisolid'
                r = c.k * sin(theta/2);
            case 'stereographic'
                r = c.k * tan(theta/2);
            otherwise
                error('unknown fisheye projection model');
            end

            x = r .* cos(phi);
            y = r .* sin(phi);

            uv = [x/c.rho(1)+c.pp(1); y/c.rho(2)+c.pp(2)];

            if c.noise
                % add Gaussian noise with specified standard deviation
                uv = uv + diag(c.noise) * randn(size(uv)); 
            end
        end
    end % methods
end % class
%    camcald                            - CAMCALD Compute camera calibration from data points
%
% C = CAMCALD(D) returns the camera calibration using a least squares 
% technique.  Input is a table of data points D with each row of the 
% form [X Y Z U V] where (X,Y,Z) is the coordinate of a world point
% and [U,V] is the image plane coordinate of the corresponding point.
% C is a 3x4 camera calibration matrix.
%
% [C,E] = CAMCALD(D) as above but E is the maximum residual error after 
% back substitution (in units of pixel). 
% 
% Note:
% - this method cannot handle lense distortion.
%
% See also CAMCALP, CAMERA, CAMCALT, INVCAMCAL.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.



function [C, resid] = camcald(XYZ, uv)

    if numcols(XYZ) ~= numcols(uv)
        error('must have same number of world and image-plane points');
    end

    n = numcols(XYZ);
    if n < 6,
        error('At least 6 points required for calibration');
    end
%
% build the matrix as per Ballard and Brown p.482
%
% the row pair are one row at this point
%
    A = [ XYZ' ones(n,1) zeros(n,4) -repmat(uv(1,:)', 1,3).*XYZ' ...
          zeros(n,4) XYZ' ones(n,1) -repmat(uv(2,:)', 1,3).*XYZ'  ];
%
% reshape the matrix, so that the rows interleave
%
    A = reshape(A',11, n*2)';
    if rank(A) < 11,
        error('Rank deficient,  perhaps points are coplanar or collinear');
    end

    B = reshape( uv, 1, n*2)';

    C = A\B;    % least squares solution
    resid = max(max(abs(A * C - B)));
    if resid > 1,
        warning('Residual greater than 1 pixel');
    end
    fprintf('maxm residual %f pixels.\n', resid);
    C = reshape([C;1]',4,3)';
%
%  Image sources
%
%      Devices
%        AxisWebCamera                  - Class to read from Axis webcam
%
%
% SEE ALSO: Video
%

classdef AxisWebCamera < ImageSource

    properties
        url
        firstImage
    end

    methods

        function wc = AxisWebCamera(url, varargin)

            % invoke the superclass constructor and process common arguments
            wc = wc@ImageSource(varargin);

            % set default size params if not set
            if isempty(wc.width)
                wc.width = 640;
                wc.height = 480;
            end

            wc.url = url;
            wc.firstImage = [];

            try
                wc.firstImage = wc.grab();
            except
                error('cant access specified web cam')
            end
            [height,width] = size(wc.firstImage);
            wc.color = ndims(wc.firstImage) > 2;
        end

        function n = paramSet(wc, args)
            % handle parameters not known to the superclass
            switch lower(args{1})
            case 'resolution'
                res = args{2};
                res
                wc.width = res(1);
                wc.height = res(2);
                n = 1;
            otherwise
                error( sprintf('unknown option <%s>', args{count}));
            end
        end

        function close(m)
        end



        function im = grab(wc)

            if ~isempty(wc.firstImage)
                % on the first grab, return the image we used to test the webcam at
                % instance creation time
                im = wc.convert( wc.firstImage );
                wc.firstImage = [];
                return;
            end

            url = sprintf('%s/axis-cgi/jpg/image.cgi?resolution=%dx%d', wc.url, wc.width, wc.height);
            url
            im = wc.convert( imread(url) );

        end

        function s = char(wc)
            s = '';
            s = strvcat(s, sprintf('Webcam @ %s', wc.url));
            if wc.iscolor()
                s = strvcat(s, sprintf('  %d x %d x 3', wc.width, wc.height));
            else
                s = strvcat(s, sprintf('  %d x %d', wc.width, wc.height));
            end
        end

    end
end
%        Movie                          - Class to read movie file
%
%
% SEE ALSO: Video
%
% Based on mmread by Micah Richert

% mmread brings the whole movie into memory.  Not entirely sure what
% libavbin uses memory-wise, it takes a long time to "open" the file.

% Copyright 2008 Micah Richert
% 
% This file is part of mmread.
% 
% mmread is free software; you can redistribute it and/or modify it
% under the terms of the GNU Lesser General Public License as
% published by the Free Software Foundation; either version 3 of
% the License, or (at your option) any later version.
% 
% mmread is distributed WITHOUT ANY WARRANTY.  See the GNU
% General Public License for more details.
% 
% You should have received a copy of the GNU General Public
% License along with mmread.  If not, see <http://www.gnu.org/licenses/>.

classdef Movie < handle

    properties
        width           % width of each frame
        height          % height of each frame
        rate            % frame rate at which movie was capture

        nrFramesCaptured
        nrFramesTotal
        totalDuration
        skippedFrames

        nrVideoStreams  % number of video streams
        nrAudioStreams  % number of audio streams

        curFrame

        % options set at construction time
        imageType
        makeGrey
        gamma
        scaleFactor
    end

    methods

        function m = Movie(filename, varargin)

            % set default options
            m.imageType = [];
            m.makeGrey = false;
            m.gamma = [];
            m.scaleFactor = [];
            time = [];      % time span

            options = varargin;
            k = 1;
            while k<=length(options),
                switch options{k},
                case 'double',
                    m.imageType = 'double';
                case 'float',
                    m.imageType = 'float';
                case 'uint8',
                    m.imageType = 'uint8';
                case {'grey','gray', 'mono'},
                    m.makeGrey = true;
                case 'gamma'
                    m.gamma = options{k+1}; k = k+1;
                case 'reduce',
                    m.scaleFactor = options{k+1}; k = k+1;
                case 'time',
                    time = options{k+1}; k = k+1;
                otherwise,
                    error( sprintf('unknown option: %s', options{k}) );
                end
                k = k + 1;
            end
    
            currentdir = pwd;
            if ~ispc
                cd(fileparts(mfilename('fullpath'))); % FFGrab searches for AVbin in the current directory
            end

            FFGrab('build',filename, '', 0, 1, 1);
            
            if ~isempty(time)
                if numel(time) ~= 2
                    error('time must be a vector of length 2: [startTime stopTime]');
                end
                FFGrab('setTime',time(1),time(2));
            end

            FFGrab('setMatlabCommand', '');

            try
                FFGrab('doCapture');
            catch
                err = lasterror;
                if (~strcmp(err.identifier,'processFrame:STOP'))
                    rethrow(err);
                end
            end

            [m.nrVideoStreams, m.nrAudioStreams] = FFGrab('getCaptureInfo');

            % loop through getting all of the video data from each stream
            for i=1:m.nrVideoStreams
                [m.width, m.height, m.rate, m.nrFramesCaptured, m.nrFramesTotal, m.totalDuration] = FFGrab('getVideoInfo',i-1);
                m.skippedFrames = [];
                fprintf('%d x %d @ %f, %d frames\n', m.width, m.height, m.rate, m.nrFramesTotal);

                m.curFrame = 0;
            end
        end

        % destructor
        function delete(m)
            FFGrab('cleanUp');
        end

        function close(m)
            FFGrab('cleanUp');
        end

        function sz = size(m)
            sz = [m.width m.height];
        end

        function [im, time] = grab(m)
            if m.curFrame > m.nrFramesTotal
                im = [];
                return;
            end

            % read next frame from the file
            [data, time] = FFGrab('getVideoFrame', 0, m.curFrame);
            m.curFrame = m.curFrame + 1;

            if (numel(data) > 3*m.width*m.height)
                warning('Movie: dimensions do not match data size. Got %d bytes for %d x %d', numel(data), m.width, m.height);
            end

            if any(size(data) == 0)
                warning('Movie: could not decode frame %d', m.curFrame);
            else
                % the data ordering is wrong for matlab images, so permute it
                data = permute(reshape(data, 3, m.width, m.height),[3 2 1]);
                im = data;
            end

            % apply options specified at construction time
            if m.scaleFactor > 1,
                im = im(1:m.scaleFactor:end, 1:m.scaleFactor:end, :);
            end
            if m.makeGrey & (ndims(im) == 3),
                im = imono(im);
            end
            if ~isempty(m.imageType)
                im = cast(im, m.imageType);
            end

            if ~isempty(m.gamma)
                im = igamma(im, m.gamma);
            end
        end

        function s = char(m)
            s = '';
            %s = strvcat(s, sprintf('%d video streams', m.nrVideoStreams));
            s = strvcat(s, sprintf('%d x %d @ %d fps', m.width, m.height, m.rate));
            s = strvcat(s, sprintf('%d frames, %f sec', m.nrFramesTotal, m.totalDuration));
            s = strvcat(s, sprintf('%d frames', m.nrFramesTotal));
            %% TODO duration value is wrong %s = strvcat(s, sprintf('%d audio streams', m.nrAudioStreams));
        end

        function display(m)
            loose = strcmp( get(0, 'FormatSpacing'), 'loose');
            if loose
                disp(' ');
            end
            disp([inputname(1), ' = '])
            if loose
                disp(' ');
            end
            disp(char(m))
            if loose
                disp(' ');
            end
        end
    end
end
%        Video                          - Class to read video stream from an attached camera.
%
%
% SEE ALSO: Movie
%
% Platform-indepent camera interface based on motmot by Andrew Straw

% mmread brings the whole movie into memory.  Not entirely sure what
% libavbin uses memory-wise, it takes a long time to "open" the file.

classdef Video < handle

    properties
        width
        height
        rate

        curFrame
    end

    methods

        function m = Video(filename)

            m.curFrame = 0;
        end

        % destructor
        function delete(m)
        end

        function close(m)
        end

        function [im, time] = grab(m, opt)
            [data, time] = FFGrab('getVideoFrame', 0, m.curFrame);
            m.curFrame = m.curFrame + 1;

            if (numel(data) > 3*width*height)
                warning('Movie: dimensions do not match data size. Got %d bytes for %d x %d', numel(data), width, height);
            end

            if any(size(data) == 0)
                warning('Movie: could not decode frame %d', m.curFrame);
            else
                % the data ordering is wrong for matlab images, so permute it
                data = permute(reshape(data, 3, m.width, m.height),[3 2 1]);
                im = data;
            end
        end

        function s = char(m)
            s = '';
            s = strvcat(s, sprintf('%d video streams', m.nrVideoStreams));
            s = strvcat(s, sprintf('  %d x %d @ %d fps', m.width, m.height, m.rate));
            s = strvcat(s, sprintf('  %d frames, %f sec', m.nrFramesTotal, m.totalDuration));
            s = strvcat(s, sprintf('%d audio streams', m.nrAudioStreams));
        end

        function display(m)
            loose = strcmp( get(0, 'FormatSpacing'), 'loose');
            if loose
                disp(' ');
            end
            disp([inputname(1), ' = '])
            if loose
                disp(' ');
            end
            disp(char(m))
            if loose
                disp(' ');
            end
        end
    end
end
%
%      Test patterns
%        mkcube                         - Create vertices of a cube
%
% P = MKCUBE(S, OPTIONS) returns a set of points that define the vertices of a
% cube of side length S and centred at C (3x1).  P is 3x8 or 3x14.
%
% [X,Y,Z] = MKCUBE(S, OPTIONS) as above but return the rows of P as three 
% vectors.
%
% [X,Y,Z] = MKCUBE(S, 'edge', OPTIONS) returns a mesh that defines the edges of
% a cube.
%
% Options::
% 'facepoint'    Add an extra point in the middle of each face.
% 'centre',C     The cube is centred at C (3x1) not the origin
% 'T',T          The cube is arbitrarily transformed by the homogeneous 
%                transform T
% 'edge'         Return a set of cube edges in MATLAB mesh format rather
%                than points.
%
% See also CYLINDER, SPHERE.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.

function [o1,o2,o3] = mkcube(s, varargin)
    
    opt.centre = [];
    opt.T = [];
    opt.edge = false;
    opt.facepoint = false;

    opt = tb_optparse(opt, varargin);

    % vertices of a unit cube with one corner at origin
    cube = [
       -1    -1     1     1    -1    -1     1     1
       -1     1     1    -1    -1     1     1    -1
       -1    -1    -1    -1     1     1     1     1 ];

    if opt.facepoint
        faces = [
          1    -1     0     0     0     0
          0     0     1    -1     0     0
          0     0     0     0     1    -1 ];
        cube = [cube faces];
    end

    % vertices of cube about the origin
    cube = cube / 2 * s;

    % offset it
    if ~isempty(opt.centre)
        cube = bsxfun(@plus, cube, opt.centre(:));
    end
    % optionally transform the vertices
    if ~isempty(opt.T)
        if isvec(opt.T)
            opt.T = transl(opt.T);
        end
        cube = transformp(opt.T, cube);
    end

    if opt.edge == false
        if nargout <= 1,
            o1 = cube;
        elseif nargout == 3,
            o1 = cube(1,:);
            o2 = cube(2,:);
            o3 = cube(3,:);
        end
    else
        cube = cube(:,[1:4 1 5:8 5]);
        o1 = reshape(cube(1,:), 5, 2)';
        o2 = reshape(cube(2,:), 5, 2)';
        o3 = reshape(cube(3,:), 5, 2)';
    end
%        mkgrid                         - Make a planar grid of points
%
% P = MKGRID(D, S, OPTIONS) is a set of points that define an DxD planar grid of points
% with side length S.  The point coordinates are columns of P.
% If D is a 2-vector the grid is D(1) x D(2) points.  If S is a 2-vector the side
% lengths are S(1) x S(2).
%
% By default the grid lies in the XY plane, symmetric about the origin.
%
% Options::
% 'T',T   the homogeneous transform T is applied to all points, allowing the plane
%         to be translated or rotated.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.

function p = mkgrid(N, s, varargin)
    
    opt.T = [];


    [opt,args] = tb_optparse(opt, varargin);
    
    if length(args) > 0 && ishomog(args{1})
        opt.T = args{1};
    end
    if length(s) == 1,
        sx = s; sy = s;
    else
        sx = s(1); sy = s(2);
    end

    if length(N) == 1,
        nx = N; ny = N;
    else
        nx = N(1); ny = N(2);
    end


    if N == 2,
        % special case, we want the points in specific order
        p = [-sx -sy 0
             -sx  sy 0
              sx  sy 0
              sx -sy 0]'/2;
    else
        [X, Y] = meshgrid(1:nx, 1:ny);
        X = ( (X-1) / (nx-1) - 0.5 ) * sx;
        Y = ( (Y-1) / (ny-1) - 0.5 ) * sy;
        Z = zeros(size(X));
        p = [X(:) Y(:) Z(:)]';
    end
    
    % optionally transform the points
    if ~isempty(opt.T)
        p = homtrans(opt.T, p);
    end
%        testpattern                    - Create standard test images
%
% IM = TESTPATTERN(TYPE, W, ARGS) creates a test pattern image.  If W is a
% scalar the image is WxW else W(2)xW(1).  The type of image is indicated
% by a string, and each type has a specific set of arguments:
%
% 'rampx'     intensity ramp from 0 to 1 in the x-direction. ARGS is the number
%             of cycles.
% 'rampy'     intensity ramp from 0 to 1 in the y-direction. ARGS is the number
%             of cycles.
% 'sinx'      sinusoidal intensity pattern (from -1 to 1) in the x-direction. 
%             ARGS is the number of cycles.
% 'siny'      sinusoidal intensity pattern (from -1 to 1) in the y-direction. 
%             ARGS is the number of cycles.
% 'dots'      binary dot pattern.  ARGS are dot pitch (distance between 
%             centres); dot diameter.
% 'squares'   binary square pattern.  ARGS are pitch (distance between 
%             centres); square side length.
% 'line'      a line.  ARGS are theta (rad), intercept.
%   
% With no output argument the testpattern in displayed using idisp
%
% See also IDISP.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.


function Z = testpattern(type, w, varargin)

    z = zeros(w);
    switch type,
    case {'sinx'},
        if nargin > 2,
            ncycles = varargin{1};
        else
            ncycles = 1;
        end
        for i=1:numcols(z),
            z(:,i) = sin(i/numcols(z)*ncycles*2*pi);
        end
    case {'siny'},
        if nargin > 2,
            ncycles = varargin{1};
        else
            ncycles = 1;
        end
        for i=1:numcols(z),
            z(i,:) = sin(i/numcols(z)*ncycles*2*pi);
        end
    case {'rampx'},
        if nargin > 2,
            ncycles = varargin{1};
        else
            ncycles = 1;
        end
        for i=1:numcols(z),
            z(:,i) = mod(i/numcols(z)*ncycles,1);
        end
    case {'rampy'},
        if nargin > 2,
            ncycles = varargin{1};
        else
            ncycles = 1;
        end
        for i=1:numrows(z),
            z(i,:) = mod(i/numrows(z)*ncycles,1);
        end
    case {'line'},
        % args:
        %   angle intercept
        nr = numrows(z);
        nc = numcols(z);
        c = varargin{2};
        theta = varargin{1};

        if abs(tan(theta)) < 1,
            x = 1:nc;
            y = round(x*tan(theta) + c);
            
            s = find((y >= 1) & (y <= nr));

        else
            y = 1:nr;
            x = round((y-c)/tan(theta));
            
            s = find((x >= 1) & (x <= nc));

        end
        for k=s,    
            z(y(k),x(k)) = 1;
        end
    case {'squares'},
        % args:
        %   pitch diam 
        nr = numrows(z);
        nc = numcols(z);
        d = varargin{2};
        pitch = varargin{1};
        if d > (pitch/2),
            fprintf('warning: squares will overlap\n');
        end
        rad = floor(d/2);
        d = 2*rad;
        for r=pitch/2:pitch:(nr-pitch/2),
            for c=pitch/2:pitch:(nc-pitch/2),
                z(r-rad:r+rad,c-rad:c+rad) = ones(d+1);
            end
        end
    case {'dots'},
        % args:
        %   pitch diam 
        nr = numrows(z);
        nc = numcols(z);
        d = varargin{2};
        pitch = varargin{1};
        if d > (pitch/2),
            fprintf('warning: dots will overlap\n');
        end
        rad = floor(d/2);
        d = 2*rad;
        s = kcircle(d/2);
        for r=pitch/2:pitch:(nr-pitch/2),
            for c=pitch/2:pitch:(nc-pitch/2),
                z(r-rad:r+rad,c-rad:c+rad) = s;
            end
        end
        
    otherwise
        disp('Unknown pattern type')
        im = [];
    end

    if nargout == 0,
        idisp(z);
    else
        Z = z;
    end
%
%  Monadic operators
%    icolor                             - Colorize a greyscale image
%
% C = ICOLOR(IM) returns a color image C where each color plane is equal to IM.
%
% C = ICOLOR(IM,COLOR) returns a color image C where each pixel is COLOR
% scaled by the corresponding element of IM.
%
% Examples::
%
%    c = icolor(im);
%    c = icolor(im, [0 1 1]);  % aqua colored version of im
%
% See also IMONO, COLORIZE, IPIXSWITCH.

function c = icolor(im, color)

    if nargin < 2
        color = [1 1 1];
    end
    c = [];
    for i=1:numel(color)
        c = cat(3, c, im*color(i));
    end
%    colorize                           - Colorize a greyscale image according to binary mask
%
% OUT = COLORIZE(IM, MASK, COLOR) is a color image where each pixel in OUT
% is set to the corresponding element of IM or a specified COLOR according to
% whether the corresponding value of MASK is true or false respectively.
% The color is specified as a 3-vector (R,G,B).
%
% OUT = COLORIZE(IM, FUNC, COLOR) as above but instead of a mask we pass a handle 
% to a function that returns a per-pixel logical result, eg. @isnan.
%
% COLORIZE(IM, MASK, COLOR) as above but the resulting image is displayed.
%
% Examples::
%    out = colorize(im, im<100, [0 0 1]) display image with values < 100 in blue
%    out = colorize(im, @isnan, [1 0 0]) display image with NaN values shown in red
%
% See also IMONO, ICOLOR, IPIXSWITCH.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.

function co = colorize(img, mask, color)

    if isa(img, 'uint8') || isa(img, 'logical') 
        grey = double(img) / 255;
    else
        grey = img / max(img(:));
    end

    g = grey(:);
    z = [g g g];
    if isa(mask, 'function_handle')
        mask = mask(img);
    end

    k = find(mask(:));
    z(k,:) = ones(numrows(k),1)*color(:)';
    z = reshape(z, [size(grey) 3]);

    if nargout > 0
        co = z;
    else
        image(z);
        shg
    end
%    igamma                             - correction
%
% OUT = IGAMMA(IM, GAMMA) returns a gamma corrected version of IM.  All pixels
% are raised to the power GAMMA.  Gamma encoding can be performed with 
% GAMMA > 1 and decoding with GAMMA < 1.
%
% OUT = IGAMMA(IM, 'sRGB') returns a gamma decoded version of IM, where
% the sRGB decoding function is applied (as used in the JPEG images).
%
% Notes::
% - for images with multiple planes the gamma correction is applied to all planes
% - for images of type double the pixels are assumed in the range 0 to 1.
% - for images of type int the pixels are assumed in the range 0 to max integer 
%   value

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.

function g = igamma(im, gam)

    if strcmpi(gam, 'srgb')
        % sRGB decompress
        if isfloat(im)
            f = im;
        else
            % int image
            maxval = intmax(class(im));
            f = (double(im) / double(maxval));
        end

        % convert gamma encoded sRGB to linear tristimulus values
        k = f <= 0.04045;
        f(k) = f(k) / 12.92;
        k = f > 0.04045;
        f(k) = ( (f(k)+0.055)/1.055 ).^2.4;
        g = f;
        if ~isfloat(im)
            g = cast(g*double(maxval), class(im));
        end
    else
        % normal power law
        if isfloat(im)
            % float image
            g = im .^ gam;
        else
            % int image
            maxval = double(intmax(class(im)));
            g = ((double(im) / maxval) .^ gam) * maxval;
            g = cast(g, class(im));
        end
    end
%    imono                              - color image to monochrome
%
% OUT = IMONO(IM, OPTIONS) return a greyscale equivalent to the color image IM.
% Different conversion functions are supported.
%
% Options::
% 'r601'       ITU recommendation 601 (default)
% 'grey'       ditto
% 'grey_601'   ditto
% 'r709'       ITU recommendation 709
% 'grey_701'   ditto
%
% See also COLORIZE, RGB2HSV.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.
function im = imono(rgb, opt)

    if size(rgb,3) == 1
        % image is already monochrome
        im = rgb;
        return;
    end

    if nargin < 2
        opt = 'r601';
    end

    switch (lower(opt))
    case {'r601', 'grey', 'gray', 'mono', 'grey_601','gray_601'}
        % rec 601 luma
        im = 0.299*rgb(:,:,1) + 0.587*rgb(:,:,2) + 0.114*rgb(:,:,3);

    case {'r709', 'grey_709','gray_709'}
        % rec 709 luma
        im = 0.2126*rgb(:,:,1) + 0.7152*rgb(:,:,2) + 0.0722*rgb(:,:,3);
    case 'value'
        % 'value', the V in HSV, not CIE L*
        % the mean of the max and min of RGB values at each pixel
        mx = max(rgb, [], 3);
        mn = min(rgb, [], 3);
        if isfloat(rgb)
            im = 0.5*(mx+mn);
        else
            im = (int32(mx) + int32(mn))/2;
            im = uint8(mx);
        end
    otherwise
        error('unknown option');
    end
%    inormhist                          - Histogram normalization
%
% OUT = INORMHIST(IM) returns a histogram normalized image.
%
% Notes::
% - Useful for highlighting image detail.
%
% See also IHIST.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.
function [ni,ch] = inormhist(im)
    if size(im,3) > 1
        error('inormhist doesnt support color images');
    end
	[cdf,x] = ihist(im, 'cdf');
	[nr,nc] = size(im);
    cdf = cdf/max(cdf);
    
    if isfloat(im)
        ni = interp1(x', cdf', im(:), 'nearest');
    else
        ni = interp1(x', cdf', double(im(:)), 'nearest');
        ni = cast(ni*double(intmax(class(im))), class(im));
    end
    ni = reshape(ni, nr, nc);
%    istretch                           - Image linear normalization
%
% OUT = ISTRETCH(IM) returns a normalized image in which all pixels lie in 
% the range 0 to 1.  That is, a linear mapping where the minimum value of 
% IM is mapped to 0 and the maximum value of IM is mapped to 1.
%
% OUT = ISTRETCH(IM,MAX) as above but pixels lie in the range 0 to MAX.
%
% See also INORMHIST.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.


function zs = istretch(z, newmax)

    if nargin == 1
        newmax = 1;
    end

    mn = min(z(:));
    mx = max(z(:));

    zs = (z-mn)/(mx-mn)*newmax;
%
%      Type changing
%        idouble                        - Convert integer image to double
%
% IMD = IDOUBLE(IM) returns an image with double precision elements in the
% range 0 to 1. The integer pixels are assumed to span the range 0 to the 
% maximum value of their integer class.
%
% See also IINT.

function dim = idouble(im)

    if isinteger(im)
        dim = double(im) / double(intmax(class(im)));
    elseif islogical(im)
        dim = double(im);
    else
        dim = im;
    end
%        iint                           - Convert image to integer class
%
% OUT = IINT(IM) returns an image with 8-bit unsigned integer elements in 
% the range 0 to 255.  The floating point pixels are assumed to span the 
% range 0 to 1.

% OUT = IINT(IM, CLASS) returns an image with integer elements of the specified
% class in the range 0 INTMAX.  CLASS is a string representing any of the 
% standard Matlab integer classes, eg. 'int16'.  The floating point pixels are 
% assumed to span the range 0 to 1.
%
% Examples::
%
%    im = iint(dim, 'int16');
%
% See also IDOUBLE, CLASS, INTMAX.

function im = iint(in, cls)

    if nargin < 2
        cls = 'uint8';
    end

    im = cast(round( in * double(intmax(cls))), cls);
%
%  Diadic operators
%    ipixswitch                         - Pixelwise image merge
%
% OUT = IPIXSWITCH(MASK, IM1, IM2) returns an image where each pixel is
% selected from the corresponding pixel in IM1 or IM2 according to the
% corresponding values of MASK.  If the element of MASK is zero IM1 is
% selected, otherwise IM2 is selected.
%
% Notes::
% - IM1 and IM2 must have the same number of rows and columns
% - if IM1 and IM2 are both greyscale then OUT is greyscale
% - if IM1 and IM2 are both color then OUT is color
% - if either of IM1 and IM2 are color then OUT is color
%
% See also COLORIZE.

function co = ipixswitch(mask, I1, I2)

    if ischar(I1)
        % image is a string color name
        col = colorname(I1);
        if isempty(col)
            error('unknown color %s', col);
        end
        I1 = icolor(ones(size(mask)), col);
    elseif isscalar(I1)
        % image is a scalar, create a greyscale image same size as mask
        I1 = ones(size(mask))*I1;
    elseif ndims(I1) == 2 && all(size(I1) == [1 3])
        % image is 1x3, create a color image same size as mask
        I1 = icolor(ones(size(mask)), I1);
    else
        % actual image, check the dims
        s = size(I1); s = s(1:2);
        if ~all(s == size(mask))
            error('input image sizes do not conform');
        end
    end

    if ischar(I2)
        % image is a string color name
        col = colorname(I2);
        if isempty(col)
            error('unknown color %s', col);
        end
        I2 = icolor(ones(size(mask)), col);
    elseif isscalar(I2)
        % image is a scalar, create a greyscale image same size as mask
        I2 = ones(size(mask))*I2;
    elseif ndims(I2) == 2 && all(size(I2) == [1 3])
        % image is 1x3, create a color image same size as mask
        I2 = icolor(ones(size(mask)), I2);
    else
        % actual image, check the dims
        s = size(I2); s = s(1:2);
        if ~all(s == size(mask))
            error('input image sizes do not conform');
        end
    end

    nplanes = max(size(I1,3), size(I2,3));

    if nplanes == 3
        mask = repmat(mask, [1 1 3]);
        if size(I1,3) == 1
            I1 = repmat(I1, [1 1 3]);
        end
        if size(I2,3) == 1
            I2 = repmat(I2, [1 1 3]);
        end
    end

    % in case one of the images contains NaNs we cant blend the images
    % using arithmetic
    % out = mask .* I1 + (1-mask) .* I2;
    out = I2;
    out(mask) = I1(mask);

    if nargout > 0
        co = out;
    else
        idisp(out);
        shg
    end
%
%  Spatial operators
%
%      Linear convolution
%        ilaplace                       - Convolve with Laplacian kernel
%
% OUT = ILAPLACE(IM) returns the image after convolution with the Laplacian 
% kernel [0 -1 0; -1 4 -1; 0 -1 0].  The returned image is larger than IM
% by one pixel on each edge.
%
% OUT = ILAPLACE(IM, SIGMA) as above but the image is first smoothed with
% a Gaussian of standard deviation SIGMA.  The result is a Laplacian of
% Gaussian filter (LoG).  If SIGMA is [] then no smoothing is performed.
%
% OUT = ILAPLACE(IM, SIGMA, OPTIONS) as above but the OPTIONS are passed
% to CONV2.
%
% Options::
% 'full'    returns the full 2-D convolution (default)
% 'same'    returns OUT the same size as IM
% 'valid'   returns  the valid pixels only, those where the kernel does not
%           exceed the bounds of the image.
%
% See also ICONV, KLOG, CONV2.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.

function il = ilaplace(im, sigma, varargin);

    % perform the convolution, same size output image
    if nargin == 1 || isempty(sigma)
        il = conv2(im, klaplace(), varargin{:});
    else
        il = conv2(im, klog(sigma), varargin{:});
    end

%    % set edge pixels to zero
%    il(1,:) = 0;
%    il(end,:) = 0;
%    il(:,1) = 0;
%    il(:,end) = 0;
%        icanny                         - detection.
%
% E = ICANNY(IM, OPTIONS) returns an edge image using the Canny edge detector.  
% The edges within IM are marked by non-zero values in E, and larger values
% correspond to stronger edges.
%
% Options::
%  'sd',S    set the standard deviation for smoothing (default 1)
%  'th0',T   set the lower hysteresis threshold (default 0.1 x strongest edge)
%  'th1',T   set the upper hysteresis threshold (default 0.5 x strongest edge)
%
% Author::
% Oded Comay, Tel Aviv University, 1996-7

function E = icanny(I, varargin)

    opt.sd = 1;
    opt.th0 = 0.1;
    opt.th1 = 0.5;

    opt = tb_optparse(opt, varargin);

    x= -5*opt.sd:opt.sd*5; 
    g = exp(-0.5/opt.sd^2*x.^2); 		% Create a normalized Gaussian
    g = g(g>max(g)*.005); g = g/sum(g(:));
    dg = diff(g);				% Gaussian first derivative

    dx = abs(conv2(I, dg, 'same'));		% X/Y edges
    dy = abs(conv2(I, dg', 'same'));

    [ny, nx] = size(I);
                        % Find maxima 
    dy0 = [dy(2:ny,:); dy(ny,:)]; dy2 = [dy(1,:); dy(1:ny-1,:)];
    dx0 = [dx(:, 2:nx) dx(:,nx)]; dx2 = [dx(:,1) dx(:,1:nx-1)];
    peaks = find((dy>dy0 & dy>dy2) | (dx>dx0 & dx>dx2));
    e = zeros(size(I));
    e(peaks) = sqrt(dx(peaks).^2 + dy(peaks).^2); 

    e(:,2)    = zeros(ny,1);    e(2,:) = zeros(1,nx);	% Remove artificial edges
    e(:,nx-2) = zeros(ny,1); e(ny-2,:) = zeros(1,nx);
    e(:,1)    = zeros(ny,1);    e(1,:) = zeros(1,nx);
    e(:,nx)   = zeros(ny,1);   e(ny,:) = zeros(1,nx);
    e(:,nx-1) = zeros(ny,1); e(ny-1,:) = zeros(1,nx);
    e = e/max(e(:));

    if opt.th1  == 0, E = e; return; end			 % Perform hysteresis
    E(ny,nx) = 0;

    p = find(e >= opt.th1);
    while length(p) 
      E(p) = e(p);
      e(p) = zeros(size(p));
      n = [p+1 p-1 p+ny p-ny p-ny-1 p-ny+1 p+ny-1 p+ny+1]; % direct neighbors
      On = zeros(ny,nx); On(n) = n;
      p = find(e > opt.th0 & On);
    end
%        iconv                          - Image convolution
%
% C = ICONV(IM1, IM2, OPTIONS) convolves IM1 with IM2.  The smaller image
% is taken as the kernel and convolved with the larger image.  If the larger
% image is color (has multiple planes) the kernel is applied to each plane,
% resulting in an output image with the same number of planes.
%
% Options::
%  'same'   output image is same size as largest input image (default)
%  'full'   output image is larger than the input image
%  'valid'  output image is smaller than the input image, and contains only
%           valid pixels
%
% Notes::
% - this function is a "convenience wrapper" for the builtin function CONV2.
%
% See also CONV2.
function C = iconv(A, B, opt)

    if nargin < 3
        opt = 'same';
    end

    if numcols(A) < numcols(B)
        % B is the image
        for k=1:size(B,3)
            C(:,:,k) = conv2(B(:,:,k), A, opt);
        end
    else
        % A is the image
        for k=1:size(A,3)
            C(:,:,k) = conv2(A(:,:,k), B, opt);
        end
    end
%        ismooth                        - Smooth with Gaussian kernel
%
% OUT = ISMOOTH(IM, SIGMA) returns the image after convolution with the 
% Gaussian kernel.  The returned image is larger than IM.
%
% OUT = ILAPLACE(IM, SIGMA) as above but the image is first smoothed with
% a Gaussian of standard deviation SIGMA.  The result is a Laplacian of
% Gaussian filter (LoG).  If SIGMA is [] then no smoothing is performed.
%
% OUT = ILAPLACE(IM, SIGMA, OPTIONS) as above but the OPTIONS are passed
% to CONV2.
%
% Options::
% 'full'    returns the full 2-D convolution (default)
% 'same'    returns OUT the same size as IM
% 'valid'   returns  the valid pixels only, those where the kernel does not
%           exceed the bounds of the image.
%
% Notes::
% - smooths all planes of the input image
% - the Gaussian kernel has a unit volume
% - the Gaussian width is a function of standard deviation sigma.
% - if input image is integer it is converted to float, convolved, then
%   converted back to integer.
%
% See also	ICONV, KGAUSS.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.

function ims = ismooth(im, sigma, varargin)

    if isfloat(im)
        is_int = false;
    else
        is_int = true;
        im = idouble(im);
    end

    m = kgauss(sigma, varargin{:});

    for i=1:size(im,3),
        ims(:,:,i) = conv2(im(:,:,i), m, 'same');
    end

    if is_int
        ims = iint(ims);
     end

    if nargout == 0
        idisp(ims);
    end
%        isobel                         - Sobel edge detector
%
% OUT = ISOBEL(IM) applies the Sobel edge detector to the image IM.  This is
% the norm of the vertical and horizontal gradients, and tends to produce 
% rather thick edges.  The Sobel kernel is [-1  0  1; -2  0  2; -1  0  1].
%
% OUT = ISOBEL(IM,DX) as above but applies the kernel DX and DX' to compute
% the horizontal and vertical gradients respectively.
%
% [GX,GY] = ISOBEL(IM) as above but returns the gradient images.
%
% [GX,GY] = ISOBEL(IM,DX) as above but returns the gradient images.
%
% Notes::
% - the resulting image is the same size as the input image.
%
% See also ICANNY, ICONV.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.

function [o1,o2] = isobel(i, Dx)

    if nargin < 2,
        sv = -[ -1 -2 -1
            0 0 0
            1 2 1];
        sh = sv';
    else
        % use a smoothing kernel if sigma specified
        sh = Dx;
        sv = Dx';
    end

    ih = conv2(i, sh, 'same');
    iv = conv2(i, sv, 'same');

    % return grandient components or magnitude
    if nargout == 1,
        o1 = sqrt(ih.^2 + iv.^2);
    else
        o1 = ih;
        o2 = iv;
    end
%        radgrad                        - Compute radial gradient
%
% [GR,GT] = RADGRAD(IM) is the radial and tangential gradient of the image IM.
% At each pixel the image gradient vector is resolved in the radial and 
% tangential direction.
%
% [GR,GT] = RADGRAD(IM, CENTRE) as above but the centre of the image is
% specified as CENTRE=[X,Y] rather than the centre pixel of IM.
%
% RADGRAD(IM) as above but the result is displayed graphically.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.

function [gr,gt] = radgrad(im, center)
    
    [nr,nc] =size(im);

    if nargin == 1
        xc = nr/2;
        yc = nc/2;
    else
        xc = center(1);
        yc = center(2);
    end

    [X,Y] = meshgrid(1:nc, 1:nr);
    X = X - xc;
    Y = Y - yc;
    H = sqrt(X.^2 + Y.^2);
    sth = Y ./ H;
    cth = X ./ H;
    [ih,iv] = isobel(im);

    g = sth .* iv + cth .* ih;

    if nargout == 0
        idisp(g);
    elseif nargout == 1
        gr = g;
    elseif nargout == 2
        gr = g;
        gt = cth .* iv + sth .* ih;
    end
%
%          Kernels
%            kcircle                    - Create circular structuring element
%
% K = KCIRCLE(R) is a square matrix of zeros with a maximal centered circular 
% region of radius R pixels set to one.  K is (2R+1) x (2R+1).
%
% K = KCIRCLE(R,W) as above but S is WxW.
%
% If R is a 2-element vector then it returns an annulus of ones, and
% the two numbers are interpretted as inner and outer radii.
%
% See also ONES, KTRIANGLE, IMORPH.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.

function s = kcircle(r, w)

    if ismatrix(r) 
        rmax = max(r(:));
        rmin = min(r(:));
    else
        rmax = r;
    end


    if nargin == 2
        w = w*2 + 1;
    elseif nargin == 1
        w = 2*rmax+1;
    end
    s = zeros(w,w);

    c = ceil(w/2);

    if ismatrix(r) 
        s = kcircle(rmax,w) - kcircle(rmin, w);
    else
        [x,y] = find(s == 0);
        x = x - c;
        y = y - c;
        l = find(x.^2+y.^2-r^2 < 0.5);
        s(l) = 1;
    end
%            kdgauss                    - Derivitive of Gaussian kernel
%
% K = KDGAUSS(SIGMA) is a 2-dimensional derivative of Gaussian kernel.  The 
% width (standard deviation) of the Gaussian is SIGMA.  The kernel is centred
% within the matrix W whose half-width is W=2*SIGMA, that is, K 
% is(2W+1) x (2W+1).
%
% K = KDGAUSS(SIGMA, W) as above but the half-width of K is W.
%
% Notes::
% - this kernel is the horizontal derivative of the Gaussian, dG/dx
% - the vertical derivative, dG/dy, is K'
% - this kernel is an effective edge detector
%
% See also KGAUSS, KDOG, KLOG, ICONV.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.

function m = dgauss(sigma, w)


    if nargin == 1,
        w = ceil(3*sigma);
    end
    ww = 2*w + 1;

    [x,y] = meshgrid(-w:w, -w:w);

    m = -x/sigma^2 /(2*pi) .*  exp( -(x.^2 + y.^2)/2/sigma^2);

    %m = m / sum(sum(m));
%            kdog                       - Difference of Gaussian kernel
%
% K = KDOG(SIGMA1) is a 2-dimensional difference of Gaussian kernel equal 
% to KGAUSS(SIGMA1) - KGAUSS(SIGMA2), where SIGMA1 > SIGMA2.  By default
% SIGMA2 = 1.6*SIGMA1.  The kernel is centred within the matrix K whose 
% half-width is W=2*SIGMA2, that is, K is(2W+1) x (2W+1).
% 
% K = KDOG(SIGMA1, SIGMA2) as above but SIGMA2 is specified directly.
%
% K = KDOG(SIGMA1, SIGMA2, W) as above but the kernel half-width is specified.
%
% Notes::
% - this kernel is similar to the Laplacian of Gaussian
%
% See also KGAUSS, KDGAUSS, KLOG, ICONV.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.

function m = kdog(sigma1, sigma2, w)

    % sigma2 > sigma1
    if nargin == 1
        sigma2 = 1.6*sigma1;
        w = ceil(2*sigma2);
    elseif nargin == 2
        sigma2 = 1.6*sigma1;
        w = ceil(2*sigma2);
    elseif nargin == 3
        if sigma2 < sigma1
            t = sigma1;
            sigma1 = sigma2;
            sigma2 = t;
        end
    end

    % sigma2 > sigma1
    m1 = kgauss(sigma1, w);     % thin kernel
    m2 = kgauss(sigma2, w);     % wide kernel

    m = m2 - m1;
%            kgauss                     - smoothing kernel
%
% K = KGAUSS(SIGMA) is a 2-dimensional unit-volume Gaussian kernel.  The 
% width (standard deviation) of the Gaussian is SIGMA.  The kernel is centred
% within the matrix W whose half-width is W=2*SIGMA, that is, K 
% is(2W+1) x (2W+1).
%
% K = KGAUSS(SIGMA, W) as above but the half-width of K is W.
%
% See also KDGAUSS, KDOG, KLOG, ICONV.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.

function m = kgauss(sigma, w)


	if nargin == 1,
		w = ceil(3*sigma);
	end
	ww = 2*w + 1;

	[x,y] = meshgrid(-w:w, -w:w);

	m = 1/(2*pi*sigma^2) * exp( -(x.^2 + y.^2)/2/sigma^2);

    % area under the curve should be 1, but the discrete case is only
    % an approximation, correct it
	%m = m / sum(m(:));
%            klaplace                   - Laplacian kernel
%
% K = KLAPLACE() is the Laplacian kernel:
%       0   1  0
%       1  -4  1
%       0   1  0
%
% See also ILAPLACE, ICONV.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.
function k = klaplace;
    k = [0 1 0; 1 -4 1; 0 1 0];
%            klog                       - Laplacian of Gaussian kernel
%
% K = KLOG(SIGMA) is a 2-dimensional Laplacian of Gaussian kernel.  The 
% width (standard deviation) of the Gaussian is SIGMA.  The kernel is centred
% within the matrix W whose half-width is W=2*SIGMA, that is, K 
% is(2W+1) x (2W+1).
%
% K = KLOG(SIGMA, W) as above but the half-width of K is W.
%
% See also KGAUSS, KDOG, KDGAUSS, ICONV, ZCROSS.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.

function il = klog(sigma, w)

    if nargin == 1,
        w = ceil(3*sigma);
    end

    [x,y] = meshgrid(-w:w, -w:w);

    il = 1/(pi*sigma^4) * ( (x.^2 + y.^2)/(2*sigma^2) -1 ) .*  ...
        exp(-(x.^2+y.^2)/(2*sigma^2));
%            ksobel                     - Sobel edge detector
%
% K = KSOBEL() is the Sobel x-derivative kernel:
%           -1  0  1
%           -2  0  2
%           -1  0  1
%
% Notes::
% - this kernel is an effective horizontal edge detector
% - the Sobel vertical derivative is K'

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.

function k = ksobel

    k = [   -1 0 1
            -2 0 2
            -1 0 1];
%            ktriangle                  - Triangular kernel
%
% K = KTRIANGLE(W) is a triangular kernel within a rectangular matrix K.  The
% dimensions K are WxW if W is scalar or W(1) wide and W(2) high.  The triangle
% is isocles and is full width at the bottom row of the kernel and with its 
% apex in the top row.
%
% See also KCIRCLE.

function s = ktriangle(sz)

    sz
    if numel(sz) == 1
        w = bitor(sz, 1);  % make it odd
        h = w;
        s = zeros(w, w);

        w2 = ceil(w/2);
        h2 = w2;
    elseif numel(w) == 2
        w = bitor(sz(1), 1);  % make it odd
        h = bitor(sz(2), 1);  % make it odd
        s = zeros(h, w);

        w2 = ceil(w/2);
        h2 = ceil(h/2);
    end

    for i=1:w
        if i>w2
            y = round( ((h-1)*i + w - w2*h) /(w-w2) );
            s(y:h,i) = 1;
        else
            y = round( ((h-1)*i + 1 - w2*h) /(1-w2) );
            s(y:h,i) = 1;
        end
    end
%
%      Non-linear
%        dxform                         - Distance transform of occupancy grid
%
% DT = DISTANCEXFORM(WORLD, GOAL, OPTIONS) is the distance transform of 
% the occupancy grid WORLD with respect to the specified goal 
% point GOAL=[x,y].
%
% Options::
% 'Euclidean'   use Euclidena distance (default)
% 'cityblock'   use cityblock (Manhattan) distance
% 'show',T      display the evolving distance transform, with a delay of T
%               seconds between frames
%
% See also IMORPH, DXform.

function d = distancexform(world, goal, varargin)

    opt.metric = {'Euclidean', 'cityblock'};
    opt.show = [];

    [opt,args] = tb_optparse(opt, varargin);
    if length(args) > 0 && isnumeric(args{1})
        opt.show = args{1};
    end

    if strcmp(opt.metric, 'cityblock')
        m = ones(3,3);
        m(2,2) = 0;
    elseif strcmp(opt.metric, 'Euclidean')
        r2 = sqrt(2);
        m = [r2 1 r2; 1 0 1; r2 1 r2];
    end

    world(world==0) = Inf;
    world(world==1) = 0;

    count = 0;
    while 1
        world = imorph(world, m, 'plusmin');
        count = count+1;
        if ~isempty(opt.show)
            cmap = gray(256);
            cmap = [1 0 0; cmap];
            colormap(cmap)
            image(world+1, 'CDataMapping', 'direct');
            set(gca, 'Ydir', 'normal');
            xlabel('x');
            ylabel('y');
            pause(opt.show);
        end

        if length(find(world(:)==Inf)) == 0
            break;
        end
    end

    if show
        fprintf('%d iterations\n', count);
    end

    d = world;
%        irank                          - Fast neighbourhood rank filter
%
% OUT = IRANK(IM, ORDER, SE) returns a rank filtered version of IM.  Only 
% pixels corresponding to non-zero elements of the structuring element SE
% are ranked and the ORDER'th value in rank becomes the corresponding output 
% pixel value.  The highest rank, the maximum, is ORDER=1.
%
% OUT = IMORPH(IMAGE, SE, OP, NBINS) as above but the number of histogram
% bins can be specified.
%
% OUT = IMORPH(IMAGE, SE, OP, NBINS, EDGE) as above but performance of edge 
% pixels can be controlled.  The value of EDGE is:
% 'border'   the border value is replicated (default)
% 'none'     pixels beyond the border are not included in the window
% 'trim'     output is not computed for pixels whose window crosses
%            the border, hence output image had reduced dimensions.
% 'wrap'     the image is assumed to wrap around
%
% Notes::
% - is a MEX file
% - a histogram method is used with NBINS (default 256).
%
% See also IMORPH, IVAR, IWINDOW.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.
%        ivar                           - Pixel window statistics
%
% OUT = IVAR(IM, SE, OP) returns an image where each output pixel is
% the specified statistic over the pixel neighbourhood. The structuring 
% element SE is a small matrix with binary values that indicate
% which elements of the template window are used in the operation. 
%
% The operation OP is:
% 'var'    variance
% 'kurt'   peakiness of the distribution
% 'skew'   asymmetry of the distribution
%
% OUT = IVAR(IM, SE, OP, EDGE) as above but performance of edge pixels
% can be controlled.  The value of EDGE is:
% 'border'   the border value is replicated (default)
% 'none'     pixels beyond the border are not included in the window
% 'trim'     output is not computed for pixels whose window crosses
%            the border, hence output image had reduced dimensions.
% 'wrap'     the image is assumed to wrap around
%
% Notes::
% - is a MEX file
%
% See also IRANK, IVAR, IWINDOW.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.
%        iwindow                        - Generalized function over a pixel neighbourhood
%
% OUT = IWINDOW(IM, SE, FUNC) returns an image where each pixel is the result
% of applying the function FUNC to a neighbourhood centred on the corresponding
% pixel in IM.  The neighbourhood is defined by the size of the structuring
% element SE which should have odd side lengths.  The elements in the 
% neighbourhood corresponding to non-zero elements in SE are packed into
% a vector (in raster order from top left) and passed to the specified
% Matlab function FUNC.  The return value  becomes the corresponding pixel 
% value in OUT.
%
% OUT = IWINDOW(IMAGE, SE, FUNC, EDGE) as above but performance of edge 
% pixels can be controlled.  The value of EDGE is:
% 'border'   the border value is replicated (default)
% 'none'     pixels beyond the border are not included in the window
% 'trim'     output is not computed for pixels whose window crosses
%            the border, hence output image had reduced dimensions.
% 'wrap'     the image is assumed to wrap around
%
% Notes::
% - is a MEX file
% - is slow since the function FUNC must be invoked once for every output pixel
%
% See also IMORPH, IVAR, IRANK.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.
%
%      Morphological
%        imorph                         - Morphological neighbourhood processing
%
% OUT = IMORPH(IM, SE, OP) returns an image after morphological processing the
% image IM with the operator OP and structuring element SE.
% The structuring element SE is a small matrix with binary values that indicate
% which elements of the template window are used in the operation. 
%
% The operation OP is:
% 'min'    minimum value over the structuring element
% 'max'    maximum value over the structuring element
% 'diff'   maximum - minimum value over the structuring element
%
% OUT = IMORPH(IM, SE, OP, EDGE) as above but performance of edge pixels
% can be controlled.  The value of EDGE is:
% 'border'   the border value is replicated (default)
% 'none'     pixels beyond the border are not included in the window
% 'trim'     output is not computed for pixels whose window crosses
%            the border, hence output image had reduced dimensions.
% 'wrap'     the image is assumed to wrap around
%
% Notes::
% - is a MEX file
% - performs greyscale morphology
% - for binary image 'min' = EROSION, 'max' = DILATION.
%
% See also IRANK, IVAR, HITORMISS, OPEN, CLOSE, KCIRCLE.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.
%        iclose                         - closing
%
% B = ICLOSE(IM, SE) return the image IM after morphological closing with the
% structuring element SE.  This is a dilation followed by erosion.
%
% B = ICLOSE(IM, SE, N) return the image IM after morphological closing with the
% structuring element SE applied N times.  That is N dilations followed by N 
% erosions.
%
% B = ICLOSE(IM, SE) return the image IM after morphological closing with the
% structuring element ones(3,3).
%
% See also IOPEN, IMORPH.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.


function b = iclose(a, se, n)

	if nargin < 3,
		n = 1;
	end
	if nargin < 2,
		se = ones(3,3);
	end

	b = a;
	for i=1:n,
		b = imorph(b, se, 'max');
	end
	for i=1:n,
		b = imorph(b, se, 'min');
	end
%        iopen                          - Morphological opening
%
% OUT = IOPEN(IM, SE) return the image IM after morphological opening with the
% structuring element SE.  This is an erosion followed by dilation.
%
% B = IOPEN(IM, SE, N) return the image IM after morphological opening with the
% structuring element SE applied N times.  That is N erosions followed by N 
% dilations.
%
% B = IOPEN(IM) return the image IM after morphological opening with the
% structuring element ones(3,3).
%
% See also ICLOSE, IMORPH.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.

function b = iopen(a, se, n)
	if nargin < 3,
		n = 1;
	end
	if nargin < 2,
		se = ones(3,3);
	end

	b = a;
	for i=1:n,
		b = imorph(b, se, 'min');
	end
	for i=1:n,
		b = imorph(b, se, 'max');
	end
%        hitormiss                      - Hit or miss transform
%
% H = HITORMISS(IM, SE) is the hit-or-miss transform of the binary image IM with
% the structuring element SE.  Unlike standard morphological operations S has
% three possible values: 0, 1 and dont care (represented by NaN in MATLAB).
%
% See also IMORPH, ITHIN, ITRIPLEPOINT, IENDPOINT.

function hm = hitormiss(A, S1, S2)
    
    if nargin == 2
        S2 = double(S1 == 0);
        S1 = double(S1 == 1);
    end
    hm = imorph(A, S1, 'min') & imorph((1-A), S2, 'min');
%        ithin                          - Morphological skeletonization
%
% OUT = ITHIN(IM) skeletonizes the binary image IM.  Any non-zero region
% is replaced by a network of single-pixel wide lines.
%
% OUT = ITHIN(IM,DELAY) as above but shows each iteration with a pause
% DELAY seconds between them.
%
% See also HITORMISS, ITRIPLEPOINT, IENDPOINT.

function o = ithin(im, delay)

    % create a binary image
    im = im > 0;
    
    o = im;

    Sa = [0 0 0; NaN 1 NaN; 1 1 1];
    Sb = [NaN 0 0; 1 1 0; NaN 1 NaN];

    o = im;
    while true
        for i=1:4
            r = hitormiss(im, Sa);
            im = im - r;
            r = hitormiss(im, Sb);
            im = im - r;
            Sa = rot90(Sa);
            Sb = rot90(Sb);
        end
        if nargin > 1
            idisp(im);
            pause(delay);
        end
        if all(o == im)
            break;
        end
        o = im;
    end
    o = im;
%        iendpoint                      - Find end points in a binary skeleton image
%
% OUT = IENDPOINT(IM) returns a binary image where pixels are set if the
% corresponding input pixel in IM is the end point of a single-pixel wide
% line such as found in an image skeleton.  Computed using the hit-or-miss
% morphological operator.
%
% See also ITRIPLEPOINT, ITHIN, HITORMISS.

function o = iendpoint(im)

    o = im;
    se(:,:,1) = [   0 1 0
                    0 1 0
                    0 0 0   ];
                
    se(:,:,2) = [   0 0 1
                    0 1 0
                    0 0 0   ];
                
    se(:,:,3) = [   0 0 0
                    0 1 1
                    0 0 0   ];
                
    se(:,:,4) = [   0 0 0
                    0 1 0
                    0 0 1   ];
                
    se(:,:,5) = [   0 0 0
                    0 1 0
                    0 1 0   ];
                
    se(:,:,6) = [   0 0 0
                    0 1 0
                    1 0 0   ];
                
    se(:,:,7) = [   0 0 0
                    1 1 0
                    0 0 0   ];
                
    se(:,:,8) = [   1 0 0
                    0 1 0
                    0 0 0   ];

    o = zeros(size(im));
    for i=1:8
        o = o | hitormiss(im, se(:,:,i));
    end
%        itriplepoint                   - Find triple points in a binary skeleton image
%
% OUT = ITRIPLEPOINT(IM) returns a binary image where pixels are set if the
% corresponding input pixel in IM is a triple point, that is where three 
% single-pixel wide line intersect.  These are the Voronoi points in an image 
% skeleton.  Computed using the hit-or-miss morphological operator.
%
% See also IENDPOINT, ITHIN, HITORMISS.

function o = triplepoint(im)

    o = im;

    se(:,:,1) = [   0  1 0   ;...
                     1  1  1   ;...
                    0 0 0   ];

    se(:,:,2) = [    1 0  1   ;...
                    0  1 0   ;...
                    0 0  1   ];

    se(:,:,3) = [   0  1 0   ;...
                    0  1  1   ;...
                    0  1 0   ];

    se(:,:,4) = [   0 0  1   ;...
                    0  1 0   ;...
                     1 0  1   ];

    se(:,:,5) = [   0 0 0   ;...
                     1  1  1   ;...
                    0  1 0   ];

    se(:,:,6) = [    1 0 0   ;...
                    0  1 0   ;...
                     1 0  1   ];

    se(:,:,7) = [   0 1 0
                    1 1 0
                    0 1 0   ];

    se(:,:,8) = [   1 0 1
                    0 1 0
                    1 0 0   ];

    se(:,:,9) = [   0 1 0
                    0 1 1
                    1 0 0   ];

    se(:,:,10)= [   0 0 1
                    1  1 0
                    0 0 1   ];

    se(:,:,11)= [   1 0 0
                    0 1 1
                    0 1 0   ];

    se(:,:,12)= [   0 1 0
                    0 1 0
                    1 0 1   ];

    se(:,:,13)= [   0 0 1
                    1 1 0
                    0 1 0   ];

    se(:,:,14)= [   1 0 0
                    0 1 1
                    1 0 0   ];

    se(:,:,15)= [   0 1 0
                    1 1 0
                    0 0 1   ];

    se(:,:,16)= [   1 0 1
                    0 1 0
                    0 1 0   ];

    o = zeros(size(im));
    for i=1:16
        o = o | hitormiss(im, se(:,:,i));
    end
%
%      Similarity
%        imatch                         - Template matching
%
% XM = IMATCH(IM1, IM2, X, Y, W2, S) find a subimage of IM1 (template) within 
% the image IM2.  The template in IM1 is centred at (X,Y) and its half-width 
% is W2.  
%
% The template is searched for within IM2 inside a region, centred at (X,Y),
% and of size S.  If S is a scalar the search region is [-S, S, -S, S] relative
% to (X,Y).  More generally S is a 4-vector S=[xmin, xmax, ymin, ymax] relative
% to (X,Y).
%
% The return value is XM=[DX,DY,CC] where (DX,DY) are the x- and y-offsets 
% relative to (X,Y) and CC is the similarity score (zero-mean normalized cross
% correlation) for the best match in the search region.
%
% [XM,SCORE] = IMATCH(IM1, IM2, X, Y, W2, S) works as above but also
% returns a matrix of matching score values for each template position tested.
% The rows correspond to horizontal positions of the template, and columns the
% vertical position.
%
% Notes:
% - is a MEX file
% - IM1 and IM2 must be the same size
% - ZNCC matching is used, a perfect match score is 1.0
%
% See also ISIMILARITY.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.
%        isimilarity                    - Locate template in image
%
% S = ISIMILARITY(T, IM) return the ZNCC similarity score for the template T 
% at every location in image IM.  S is same size as IM.
%
% S = ISIMILARITY(T, IM, METRIC) as above but the metric is specified
% by the function METRIC which can be any of @sad, @ssd, @ncc, @zsad, @zssd.
%
% Notes::
% - Similarity is not computed where the window crosses the image
%   boundary, and is set to NaN.
% - The ZNCC function is a MEX and therefore the fastest
%
% See also IMATCH, SAD, SSD, NCC, ZSAD, ZSSD, ZNCC.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.

function S = isimilarity(T, im, metric)

%TODO add all the other similarity metrics, including rank and census

    if nargin < 3
        metric = @zncc;
    end
    [nr,nc] = size(im);
    hc = floor( (numcols(T)-1)/2 );
    hr = floor( (numrows(T)-1)/2 );
    hr1 = hr+1;
    hc1 = hc+1;

    S = NaN(size(im));
    
    for c=hc1:nc-hc1
        for r=hr1:nr-hr1
            S(r,c) = metric(T, im(r-hr:r+hr,c-hc:c+hc));
        end
    end
%        sad                            - Sum of absolute differences
%
% M = SAD(I1, I2) is the sum of absolute differences between the 
% two equally sized image patches I1 and I2.  The result M is a scalar that
% indicates image similarity, a value of 0 indicates identical pixel patterns
% and is increasingly positive as image dissimilarity increases.
%
% See also ZSAD, SSD, NCC, ISIMILARITY.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.

function m = sad(w1, w2)

	m = abs(w1-w2);

    m = sum(m(:));
%        ssd                            - Sum of squared differences
%
% M = SSD(I1, I2) is the sum of squared differences between the 
% two equally sized image patches I1 and I2.  The result M is a scalar that
% indicates image similarity, a value of 0 indicates identical pixel patterns
% and is increasingly positive as image dissimilarity increases.
%
% See also ZSDD, SAD, NCC, ISIMILARITY.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.

function m = ssd(w1, w2)

	m = (w1-w2).^2;
    m = sum(m(:));
%        ncc                            - Normalized cross correlation
%
% M = NCC(I1, I2) is the normalized cross-correlation between the 
% two equally sized image patches I1 and I2.  The result M is a scalar in
% the interval -1 to 1 that indicates similarity.  A value of 1 indicates 
% identical pixel patterns.
%
% Notes::
% - the NCC similarity measure is invariant to scale changes in image
%   intensity.
%
% See also ZNCC, SAD, SSD, ISIMILARITY.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.


function m = ncc(w1, w2)

	denom = sqrt( sum(sum(w1.^2))*sum(sum(w2.^2)) );

	if denom < 1e-10,
		m = 0;
	else
		m = sum(sum((w1.*w2))) / denom;
	end
%        zsad                           - Sum of absolute differences
%
% M = ZSAD(I1, I2) is the zero-mean sum of absolute differences between the 
% two equally sized image patches I1 and I2.  The result M is a scalar that
% indicates image similarity, a value of 0 indicates identical pixel patterns
% and is increasingly positive as image dissimilarity increases.
%
% Notes::
% - the ZSAD similarity measure is invariant to changes in image brightness
%   offset.
%
% See also SAD, SSD, NCC, ISIMILARITY.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.

function m = zssd(w1, w2)

	w1 = w1 - mean(w1(:));
	w2 = w2 - mean(w2(:));

	m = abs(w1-w2);
    m = sum(m(:));
%        zssd                           - Sum of squared differences
%
% M = ZSSD(I1, I2) is the zero-mean sum of squared differences between the 
% two equally sized image patches I1 and I2.  The result M is a scalar that
% indicates image similarity, a value of 0 indicates identical pixel patterns
% and is increasingly positive as image dissimilarity increases.
%
% Notes::
% - the ZSSD similarity measure is invariant to changes in image brightness
%
% See also SDD, SAD, NCC, ISIMILARITY.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.

function m = zssd(w1, w2)

	w1 = w1 - mean(w1(:));
	w2 = w2 - mean(w2(:));

	m = (w1-w2).^2;
    m = sum(m(:));
%        zncc                           - Normalized cross correlation
%
% M = ZNCC(I1, I2) is the zero-mean normalized cross-correlation between the 
% two equally sized image patches I1 and I2.  The result M is a scalar in
% the interval -1 to 1 that indicates similarity.  A value of 1 indicates 
% identical pixel patterns.
%
% Notes::
% - the ZNCC similarity measure is invariant to affine changes in image
%   intensity (brightness offset and scale).
%
% See also NCC, SAD, SSD, ISIMILARITY.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.


function m = zncc(w1, w2)

	w1 = w1 - mean(w1(:));
	w2 = w2 - mean(w2(:));

	denom = sqrt( sum(sum(w1.^2))*sum(sum(w2.^2)) );

	if denom < 1e-10,
		m = 0;
	else
		m = sum(sum((w1.*w2))) / denom;
	end
%
%  Features
%
%      Region features
%        RegionFeature                  - RegionFeature < handle
    properties
        area
        uc       % centroid
        vc
        
        umin        % the bounding box
        umax
        vmin
        vmax

        class       % the class of the pixel in the original image
        label       % the label assigned to this region
        parent      % the label of this region's parent
        children    % a list of features that are children of this feature
        edgepoint   % (x,y) of a point on the perimeter
        edge        % list of edge points
        perimeter   % length of edge
        touch       % 0 if it doesnt touch the edge, 1 if it does

        % equivalent ellipse parameters
        a           % the major axis length
        b           % the minor axis length  b<a
        theta       % angle of major axis with respect to horizontal
        shape       % b/a  < 1.0
        circularity

        moments     % moments, a struct of: m00, m01, m10, m02, m20, m11
    end

    methods

        function b = RegionFeature(b)
            b.area = [];
            b.label = [];
            b.edge = [];
        end

        function display(b)
            loose = strcmp( get(0, 'FormatSpacing'), 'loose');
            if loose
                disp(' ');
            end
            disp([inputname(1), ' = '])
            if loose
                disp(' ');
            end
            disp(char(b))
            if loose
                disp(' ');
            end
        end

        function ss = char(b)
            ss = '';
            for i=1:length(b)
                bi = b(i);
                if isempty(bi.area)
                    s = '[]';
                elseif isempty(bi.label)
                    s = sprintf('area=%d, cent=(%.1f,%.1f), theta=%.2f, a/b=%.3f', ...
                        bi.area, bi.uc, bi.vc, bi.theta, bi.shape);
                elseif ~isempty(bi.edge)
                    s = sprintf('(%d) area=%d, cent=(%.1f,%.1f), theta=%.2f, a/b=%.3f, class=%d, label=%d, touch=%d, parent=%d, perim=%d, circ=%.3f', ... 
                        i, bi.area, bi.uc, bi.vc, bi.theta, bi.shape, bi.class, bi.label, ...
                        bi.touch, bi.parent, bi.perimeter, bi.circularity);
                else
                    s = sprintf('(%d) area=%d, cent=(%.1f,%.1f), theta=%.2f, a/b=%.3f, color=%d, label=%d, touch=%d, parent=%d', ... 
                        i, bi.area, bi.uc, bi.vc, bi.theta, bi.shape, bi.class, bi.label, ...
                        bi.touch, bi.parent);

                end
                ss = strvcat(ss, s);
            end
        end

        function b = box(bb)
            b = [bb.umin bb.umax; bb.vmin bb.vmax];
        end

        function plot_boundary(bb, varargin)
            holdon = ishold;
            hold on
            for b=bb
                plot(b.edge(1,:), b.edge(2,:), varargin{:});
            end
            if ~holdon
                hold off
            end
        end

        function plot(bb, varargin)
            holdon = ishold;
            hold on
            for b=bb
                %% TODO: mark with x and o, dont use markfeatures
                %markfeatures([b.uc b.uc], 0, varargin{:});
                if isempty(varargin)
                    plot(b.uc, b.vc, 'go');
                    plot(b.uc, b.vc, 'gx');
                else
                    plot(b.uc, b.vc, varargin{:})
                end

            end
            if ~holdon
                hold off
            end
        end

        function plot_box(bb, varargin)
            for b=bb
                plot_box(b.umin, b.vmin, b.umax, b.vmax, varargin{:});
            end
        end

        function plot_ellipse(bb, varargin)
            for b=bb
                J = [b.moments.u20 b.moments.u11; b.moments.u11 b.moments.u02];
                plot_ellipse(4*J/b.moments.m00, [b.uc, b.vc], varargin{:});
            end
        end
        
        function [ri,thi] = boundary(f, varargin)

            dxy = bsxfun(@minus, f.edge, [f.uc f.vc]');

            r = norm2(dxy)';
            th = -atan2(dxy(2,:), dxy(1,:));
            [th,k] = sort(th, 'ascend');
            r = r(k);

            if nargout == 0
                plot(dxy(1,:), dxy(2,:), varargin{:});

            else
                thi = [0:399]'/400*2*pi - pi;
                ri = interp1(th, r, thi, 'spline');
            end
        end
    end

end
%        colorkmeans                    - Color image segmentation by clustering
%
% L = COLORSEG(IM, K, OPTIONS) is a segmentation of the color image IM 
% into K classes.  The label image L has the same row and column dimension
% as IM and each pixel has a value in the range 0 to K-1 which indicates
% which cluster the corresponding pixel belongs to.  A k-means clustering of
% the chromaticity of all input pixels is performed.
%
% [L,C] = COLORSEG(IM, K) as above but also returns the cluster centres C
% which is a Kx2 matrix where the I'th row is the rg-chromaticity of the I'th
% cluster and corresponds to the label I.  A k-means clustering of the 
% chromaticity of all input pixels is performed.
%
% [L,C,R] = COLORSEG(IM, K) as above but also returns the residual R, the 
% root mean square error of all pixel chromaticities from their cluster
% centre.
%
% L = COLORSEG(IM, C) is a segmentation of the color image IM into K classes.
% C is a Kx2 matrix where each row is the chromaticity of the centre of a 
% cluster.  Pixels are assigned to the closest closest centre.  Since cluster 
% centres are provided the k-means segmentation step is not required.
%
% Options::
%
% Various options are possible to choose the initial cluster centres 
% for k-means:
% 'random' randomly choose K points from
% 'spread' randomly choose K values within the rectangle spanned by the
%          input chromaticities.
% 'pick'   interactively pick cluster centres
%
% Note::
% - the k-means clustering algorithm used in the first and second forms is
%   computationally expensive and time consuming.
% - clustering is performed in rg-chromaticity space.
% - the residual is an indication of quality of fit, and 
%
% See also

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.
function [labels,C,resid] = colorseg(im, k, varargin)

    % convert RGB to xy space
    rgbcol = im2col(im);
    XYZcol = rgb2xyz(rgbcol);
    sXYZ = sum(XYZcol')';
    x = XYZcol(:,1) ./ sXYZ;
    y = XYZcol(:,2) ./ sXYZ;
    
    % do the k-means clustering
    
    if numcols(k) > 1 && numrows(k) == 2
        % k is cluster centres
        [L,C,resid] = kmeans([x y]', k);
    else
        if length(varargin) > 0
            if varargin{1} == 'pick'
                z0 = pickpoints(k, im, x, y);
                [L,C,resid] = kmeans([x y]', k, z0);
            end
        else
            [L,C,resid] = kmeans([x y]', k, varargin{:});
        end
    end
    
    % convert labels back to an image
    L = col2im(L', im);
    
    idisp(L);
    
    for k=1:numrows(C)
        fprintf('%2d: ', k);
        fprintf('%11.4g ', C(k,:));
        fprintf('\n');
        %fprintf('%s\n', colorname(C(k,:)));
    end
    
    if nargout > 0
        labels = L;
    end
end
    
function z0 = pickpoints(k, im, x, y)

    fprintf('Select %d points to serve as cluster centres\n', k);
    clf
    image(im)
    uv = round( ginput(k) );
    sz = size(im);
    i = sub2ind( sz(1:2), uv(:,2), uv(:,1) )
    
    z0 =[x(i) y(i)];
end
%        ithresh                        - Interactive image threshold
%
% OUT = ITHRESH(IM) display the image IM in a window with a slider which
% adjusts the binary threshold.  OUT is the resulting binary image.
%
% [OUT,T] = ITHRESH(IM) as above but also returns the chosen threshold.
%
% Notes::
% - for a uint8 class image the slider range is 0 to 255.
% - for a floating point class image the slider range is 0 to 1.0
%
% See also IDISP.

function [z,tf] = ithresh(im, t)

    % create a panel
    %   slider
    %   done button
    % handle int or double image
    if nargin < 2
        t = 0.5;
    end

    idisp(im >= t);

    if nargout > 0
        z = im>= t;
    end
    if nargout > 1
        tf = t;
    end
%        imoments                       - image moments
%
% F = IMOMENTS(IM) returns a RegionFeature object that describes the greyscale
% moments of the image IM.  
%
% F = IMOMENTS(U, V) as above but the moments are computed from the pixel 
% coordinates given as vectors U and V.  All pixels are equally weighted,
% effectively a binary image.
%
% F = IMOMENTS(U, V, W) as above but the pixels have weights given by the
% vector W, effectively a greyscale image.
%
% The RegionFeature object has many properties including:
%
%  uc        centroid, horizontal coordinate
%  vc        centroid, vertical coordinate
%  area      the number of pixels
%  a         major axis length of equivalent ellipse
%  b         minor axis length of equivalent ellipse
%  theta     angle of major ellipse axis to horizontal axis
%  shape     aspect ratio b/a (always <= 1.0)
%  moments   a structure containing moments of order 0 to 2, the elements
%            are m00, m10, m01, m20, m02, m11.
%
% Notes::
% - for a binary image the zeroth moment is the number of set pixels
% - this function does not perform connectivity, if connected blobs
%	are required then the ILABEL function must be used first.
%
% See also RegionFeature, ILABEL, IMOMENTS.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.

function F = imoments(varargin)

    opt.aspect = 1;
    
    [opt,args] = tb_optparse(opt, varargin);
    
	if length(args) == 1
        im = args{1};
		[v,u] = find(im);
		w = im(find(im > 0));
	else
		u = args{1};
		v = args{2};
		if length(args) == 3
			w = args{3};
		else
			w = ones(size(u));
		end
	end

	% compute basic moments
	m00 = sum(w);
	m10 = sum(u.*w);
	m01 = sum(v.*w*opt.aspect);
	m20 = sum((u.^2).*w);
	m02 = sum((v.^2).*w*opt.aspect^2);
	m11 = sum((u.*v).*w*opt.aspect);

	if m00 > 0
		% figure some central moments
		u20 = m20 - m10^2/m00;
		u02 = m02 - m01^2/m00;
		u11 = m11 - m10*m01/m00;

		% figure the equivalent axis lengths, function of the principal axis lengths
		[x,e] = eig([u20 u11; u11 u02]);
		a = 2*sqrt(max(diag(e))/m00);
		b = 2*sqrt(min(diag(e))/m00);
        v = x(:,end);
        th = atan2(v(2),v(1));

		%th = 0.5*atan2(2*u11, u20-u02);
	else
		u20 = NaN;
		u02 = NaN;
		u11 = NaN;

		a = NaN;
		b = NaN;
		th = NaN;
	end

	%F = [m00 m10/m00 m01/m00 a b th];
    F = RegionFeature;
	F.area = m00;
	if m00 > 0
		F.uc = m10/m00;
		F.vc = m01/m00;
	else
		F.uc = NaN;
		F.vc = NaN;
	end
	F.a = a;
	F.b = b;
    F.shape = b/a;
	F.theta = th;
	F.moments.m00 = m00;
	F.moments.m01 = m01;
	F.moments.m10 = m10;
	F.moments.m02 = m02;
	F.moments.m20 = m20;
	F.moments.m11 = m11;
    F.moments.u20 = u20;
    F.moments.u02 = u02;
    F.moments.u11 = u11;
%        ibbox                          - Find bounding box
%
% BOX = IBBOX(P) returns the minimal bounding box that contains the points
% described by the columns of P which is a 2xN matrix.
%
% BOX = IBBOX(IM) returns the minimal bounding box that contains the non-zero
% pixels in the image IM.
%
% The bounding box is a 2x2 matrix [XMIN XMAX; YMIN YMAX].

function box = ibbox(I)

    if numrows(I) == 2
        % input is a set of points
        u = I(1,:);
        v = I(2,:);
    else
        % input is an image, find the non-zero elements
        [v,u] = find(I);
    end
    umin = min(u);
    umax = max(u);
    vmin = min(v);
    vmax = max(v);

    box = [umin umax; vmin vmax];
%        iblobs                         - blob features
%
% F = IBLOBS(IM, OPTIONS) returns a vector of RegionFeature objects that
% describe each connected region in the image IM.
%
% Options::
%  'aspect',A        set pixel aspect ratio, default 1.0
%  'connect',C	     set connectivity, 4 (default) or 8
%  'greyscale'	     compute greyscale moments 0 (default) or 1
%  'boundary'        compute boundary (off by default)
%  'area',[A1,A2]    accept only blobs with area in interval A1 to A2
%  'shape',[S1,S2]   accept only blobs with shape in interval S1 to S2
%  'touch'           ignore blobs that touch the edge
%  'class',C         accept only blobs of pixel value C
%
% The RegionFeature object has many properties including:
%
%  uc          centroid, horizontal coordinate
%  vc          centroid, vertical coordinate
%  umin        bounding box, minimum horizontal coordinate
%  umax        bounding box, maximum horizontal coordinate
%  vmin        bounding box, minimum vertical coordinate
%  vmax        bounding box, maximum vertical coordinate
%  area        the number of pixels
%  class       the value of the pixels forming this region
%  label       the label assigned to this region
%  children    a list of indices of features that are children of this feature
%  edgepoint   coordinate of a point on the perimeter
%  edge        a list of edge points 2xN matrix
%  perimeter   number of edge pixels
%  touch       true if region touches edge of the image
%  a           major axis length of equivalent ellipse
%  b           minor axis length of equivalent ellipse
%  theta       angle of major ellipse axis to horizontal axis
%  shape       aspect ratio b/a (always <= 1.0)
%  circularity 1 for a circle, less for other shapes
%  moments     a structure containing moments of order 0 to 2
%
% See also RegionFeature, ILABEL, IMOMENTS.

function [features,labimg] = iblobs(im, varargin)
	
	[nr,nc] = size(im);

    opt.area = [0 Inf];
    opt.shape = [0 Inf]
    opt.class = NaN;
    opt.touch = NaN;
    opt.aspect = 1;
    opt.connect = 4;
    opt.greyscale = false;
    opt.moments = false;
    opt.boundary = false;

    opt = tb_optparse(opt, varargin);

    % HACK ilabel should take int image
	[li,nl,parent,color,edge] = ilabel(im, opt.connect);

	blob = 0;
	for i=1:nl,
		binimage = (li == i);

		% determine the blob extent
		[y,x] = find(binimage);
		umin = min(x); umax = max(x);
		vmin = min(y); vmax = max(y);

        % it touches the edge if its parent is 0
		t = (parent(i) == 0);

        % compute the moments
		if opt.greyscale
			F = imoments(binimage .* im, 'aspect', opt.aspect);
		else
			F = imoments(binimage, 'aspect', opt.aspect);
		end

        % compute shape property, accounting for degenerate case
		if F.a == 0,
			shape = NaN;
		else
			shape = F.b / F.a;
		end

		% apply various filters
		if 	((t == opt.touch) || isnan(opt.touch)) && ...
            ((color(i) == opt.class) || isnan(opt.class)) && ...
			(F.area >= opt.area(1)) && ...
			(F.area <= opt.area(2)) && ...
			(					...
				isnan(shape) ||			...
				(               ...
					(shape >= opt.shape(1)) &&	...
					(shape <= opt.shape(2))	...
				)				...
			)

            % this blob matches the filter

            % record a perimeter point
            [y,x] = ind2sub(size(im), edge(i));
            F.edgepoint = [x y];    % a point on the perimeter

            % optionally follow the boundary
            if opt.boundary
                F.edge = edgelist(im, [x y])';
                F.perimeter = numcols(F.edge);
                F.circularity = 4*pi*F.area/F.perimeter^2;
            end

            % set object properties
			F.umin = umin;
			F.umax = umax;
			F.vmin = vmin;
			F.vmax = vmax;
			F.touch = t;
			F.shape = shape;
            F.label = i;
            F.parent = parent(i);
            F.class = color(i);

            % save it in the feature vector
			blob = blob+1;
			features(blob) = F;
		end
	end

    if blob == 0
        features = [];
    end

    % add children property
    % the numbers in the children property refer to elements in the feature vector
    for i=1:length(features)
        parent = features(i).parent;
        for F=features
            if F.label == parent
                F.children = [F.children i];
            end
        end
    end

	%fprintf('%d blobs in image, %d after filtering\n', nl, blob);
    if nargout > 1
        labimg = li;
    end
%        ilabel                         - an image
%
% L = ILABEL(IM) performs connectivity analysis on the image IM and returns a
% label image L, same size as IM, where each pixel value represents the label
% of the region of its corresponding pixel in IMAGE in the range 1 to MAXLABEL.
%
% [L,MAXLABEL] = ILABEL(IM) as above but returns the value of the maximum
% label value.
%
% [L,MAXLABEL,PARENTS] = ILABEL(IM) as above but also returns region hierarchy
% information.  The value of PARENTS(i) is the label of the 'parent' or 
% enclosing	region of region i.  A value of 0 indicates that the region has
% no single enclosing region, for a binary image this means the region
% touches the edge of the image, for a multilevel image it means that it
% touches more than one other region.
%
% [L,MAXLABEL,PARENTS,CLASS] = ILABEL(IM) as above but also returns the class
% of pixels within each region.  The value of CLASS(i) is the value of pixels
% in region i.
%
% [L,MAXLABEL,PARENTS,CLASS,EDGE] = ILABEL(IM) as above but also returns the
% edge-touch status of each region.  If EDGE(i) is 1 then the region touches
% edge of the image, otherwise it does not.
%
% Notes::
% - is a MEX file.
% - the image can be binary or multi-level
% - connectivity is performed using 4 nearest neighbours by default. To use
%   8-way connectivity pass a second argument of 8, eg. ILABEL(IM, 8).
% - this is a "low level" function, IBLOBS is a higher level interface.
%
% See also IBLOBS, IMOMENTS.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.
%        imser                          - Maximally stable extremal regions
%
% OUT = IMSER(IM, OPTIONS) returns a list of the stable regions.
%?????
%
% Options::
% 'dark'  looking for dark features against a light background
% 'light' looking for light features against a dark background
% Notes:
% - wrapper for vl_mser, see http://vlfeat.org

function [all,nsets] = imser(im, varargin)
    if size(im,3) > 1
        error('monochrome images only');
    end

    % process the argument list.
    %  we add two arguments 'light', 'dark' for the wrapper, the rest get
    % get passed to MSER.
    opt.invert = {'dark', 'light'};

    [opt,mser_args] = tb_optparse(opt, varargin);

    invert = true;
    switch opt.invert
        case 'dark'
            invert = false;
        case 'light'
            invert = true;
    end

    % MSER operates on a uint8 image
    if isfloat(im)
        if invert
            im = 1.0-im;
        end
        im = iint(im);
    else
        if invert
            im = 255-im;
        end
    end

    % add default args if none given
    if isempty(mser_args)
        mser_args = {'MinArea', 0.0001, 'MaxArea', 0.1};
    end


    [R,F] = vl_mser(im, mser_args{:});
    fprintf('%d MSERs found\n', length(R));

    f1
    idisp(im);

    all = zeros( size(im));
    count = 1;
    for r=R'
        bim = im <= im(r);
        % HACK bim = im <= im(r);
        lim = ilabel(bim);
        mser_blob = lim == lim(r);

        %sum(mser_blob(:))

        count
        %idisp(mser_blob)
        all(mser_blob) =  count;
        count = count + 1;
        [row,col] = ind2sub(size(bim), r);
        %hold on
        %plot(col, row, 'g*');
        %pause(.2)
    end
    nsets = count;
%        niblack                        - Adaptive thresholding
%
% T = NIBLACK(IM, K, W2) is the per-pixel (local) threshold to apply to 
% image IM.  T has the same dimensions as IM.  The threshold at each pixel is 
% a function of the mean and standard deviation computed over a WxW window,
% where W=2*w2+1.
%
% [T,M,S] = NIBLACK(IM, K, W2) as above but returns the per-pixel mean M
% and standard deviation S.
%
% Example::
%     t = niblack(im, -0.2, 20);
%     idisp(im >= t);
%
% Notes::
% - This is an efficient algorithm very well suited for binarizing
%   text.
% - W2 should be chosen to be half the "size" of the features to be 
%   segemented, for example, in text segmentation, the height of a 
%   character.
% - A common choice of k=-0.2
%
%
% Reference::
% An Introduction to Digitall Image Processing,
% W. Niblack, 
% Prentice-Hall, 1986.
%
% See also OTSU, ITHRESH.

function [t,M,S] = niblack(im, k, w2)

    if nargin < 3,
        w2 = 7;
    end
    w = 2*w2 + 1;

    window = ones(w, w);

    % compute sum of pixels in WxW window
    sp = conv2(im, window, 'same');
    % convert to mean
    n = w^2;            % number of pixels in window
    m = sp / n;

    if k ~= 0
        % compute sum of pixels squared in WxW window
        sp2 = conv2(im.^2, window, 'same');
        % convert to std
        var = (n*sp2 - sp.^2) / n / (n-1);
        s = sqrt(var);

        % compute Niblack threshold
        t = m + k * s;
    else
        t = m;
        s = [];
    end

    if nargout > 1
        M = m;
    end
    if nargout > 2
        S = s;
    end
%        otsu                           - Threshold selection by Otsu's method
%
% T = OTSU(IM) is an optimal threshold for binarizing an image with a bimodal
% intensity histogram.  T is a scalar threshold that maximizes the variance 
% between the classes of pixels below and above the thresold T.
%
% Example::
%     t = otsu(im);
%     idisp(im >= t);
%
% Notes::
% - performance for images with non-bimodal histograms can be quite poor.
%
% Reference::
%  A Threshold Selection Method from Gray-Level Histograms
%  N. Otsu
%  IEEE Trans. Systems, Man and Cybernetics
%  Vol SMC-9(1), Jan 1979, pp 62-66
%
% See also NIBLACK, ITHRESH.

function t = otsu(im, N)

    if nargin < 2
        N = 255;
    end
    n = prod(size(im));
    nb = 0;
    no = n;
    ub = 0;

    % convert image to discrete values [0,N]
    if isfloat(im)
        im2 = round(im*N);
    else
        im2 = im;
    end

    h = histc(im2(:), 0:N);
    uo = sum(im2(:))/n;

    % the between class variance
    s2b = zeros(N,1);
    for T=1:N

        nt = h(T);
        nb_new = nb + nt;
        no_new = no - nt;

        if (nb_new == 0) || (no_new == 0)
            continue;
        end

        ub = (ub*nb + nt*(T-1)) / nb_new;
        uo = (uo*no - nt*(T-1)) / no_new;

        s2b(T) = nb*no*(ub - uo)^2;

        %fprintf('%d %d %f %f %f\n', nb, no, ub, uo, s2b(T));
        nb = nb_new;
        no = no_new;

    end

    [z,t] = max(s2b);

    if isfloat(im)
        t = t / N;
    end
%
%      Line features
%        Hough                          - transform
%
%	params = IHOUGH
%	H = IHOUGH(IM)
%	H = IHOUGH(IM, params)
%
%	Compute the Hough transform of the image IM data.
%
%	The appropriate Hough accumulator cell is incremented by the
%	absolute value of the pixel value if it exceeds 
%	params.edgeThresh times the maximum value found.
%
%	Pixels within params.border of the edge will not increment.
%
% 	The accumulator array has theta across the columns and offset down 
%	the rows.  Theta spans the range -pi/2 to pi/2 in params.Nth increments.
%	Offset is in the range 1 to number of rows of IM with params.Nd steps.
%
%	Clipping is applied so that only those points lying within the Hough 
%	accumulator bounds are updated.
%
%	The output argument H is a structure that contains the accumulator
%	and the theta and offset value vectors for the accumulator columns 
%	and rows respectively.  With no output 
%	arguments the Hough accumulator is displayed as a greyscale image.
%
%	H.h	the Hough accumulator
%	H.theta	vector of theta values corresponding to H.h columns
%	H.d	vector of offset values corresponding to H.h rows
% 
%	For this version of the Hough transform lines are described by
%
%		d = y cos(theta) + x sin(theta)
%
%	where theta is the angle the line makes to horizontal axis, and d is 
%	the perpendicular distance between (0,0) and the line.  A horizontal 
%	line has theta = 0, a vertical line has theta = pi/2 or -pi/2
%
%	The parameter structure:
%
%	params.Nd number of offset steps (default 64)
%	params.Nth number of theta steps (default 64)
%	params.edgeThresh increment threshold (default 0.1)
%	params.border width of non-incrmenting border(default 8)
%
%
% SEE ALSO: xyhough testpattern isobel ilap

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.

classdef Hough < handle

    properties
        Nrho
        Ntheta
        border
        suppress
        edgeThresh
        interpWidth
        houghThresh

        A       % the Hough accumulator
        rho       % the rho values for the centre of each bin vertically
        theta   % the theta values for the centre of each bin horizontally
        rho_offset
        rho_scale
    end

    methods
        function h = Hough(IM, varargin)

            h.Nrho = 401;
            h.Ntheta = 400;

            opt.interpwidth = 3;
            opt.houghthresh = 0.5;
            opt.edgethresh = 0.1;
            opt.suppress = [];
            opt.nbins = [];

            opt = tb_optparse(opt, varargin);

            % copy options into the Hough object
            if ~isempty(opt.nbins)
                if length(opt.nbins) == 1
                    h.Ntheta = opt.nbins;
                    h.Nrho = opt.nbins;
                 elseif length(opt.nbins) == 2
                    h.Ntheta = opt.nbins(1);
                    h.Nrho = opt.nbins(2);
                else
                    error('1 or 2 elements for nbins');
                end
            end

            h.Nrho = bitor(h.Nrho, 1);            % Nrho must be odd
            h.Ntheta = floor(h.Ntheta/2)*2; % Ntheta must even

            h.interpWidth = opt.interpwidth;
            h.houghThresh = opt.houghthresh;
            h.edgeThresh = opt.edgethresh;
            h.suppress = opt.suppress;
            
            if isempty(opt.suppress)
                h.suppress = (h.interpWidth-1)/2;
            end

            [nr,nc] = size(IM);

            % find the significant edge pixels
            IM = abs(IM);
            globalMax = max(IM(:));
            i = find(IM > (globalMax*h.edgeThresh));	
            [r,c] = ind2sub(size(IM), i);

            xyz = [c r IM(i)];

            % now pass the x/y/strenth info to xyhough
            h.A = h.xyhough(xyz, norm2(nr,nc));
        end

        function display(h)
            loose = strcmp( get(0, 'FormatSpacing'), 'loose');
            if loose
                disp(' ');
            end
            disp([inputname(1), ' = '])
            if loose
                disp(' ');
            end
            disp(char(h))
            if loose
                disp(' ');
            end
        end

        function s = char(h)
            s = sprintf('Hough: nd=%d, ntheta=%d, interp=%dx%d, distance=%d', ...
                h.Nrho, h.Ntheta, h.interpWidth, h.interpWidth, h.suppress);
        end
        
        function show(h)
            clf
            hi = image(h.theta, h.rho, h.A/max(max(h.A)));
            set(hi, 'CDataMapping', 'scaled');
            set(gca, 'YDir', 'normal');
            set(gca, 'Xcolor', [1 1 1]*0.5);
            set(gca, 'Ycolor', [1 1 1]*0.5);
            grid on
            xlabel('\theta (rad)');
            ylabel('\rho (pixels)');
            colormap(hot)
        end
            
        %HOUGHOVERLAY	Overlay lines on image.
        %
        %	plot(p)
        %   plot(p, N)
        %   plot(p, ls)
        %   plot(p, N, ls)
        %	houghoverlay(p, ls)
        %	handles = houghoverlay(p, ls)
        %
        %	Overlay lines, one per row of p, onto the current figure.  The row
        %	is interpretted as offset and theta, the Hough transform line
        %	representation.
        %
        %	The optional argument, ls, gives the line style in normal Matlab
        %	format.
        function handles = plot(h, varargin)

            holdon = ishold;
            hold on

            lines = h.lines();
    
            if (nargin > 1) && isnumeric(varargin{1})
                N = varargin{1};
                varargin = varargin(2:end);
                lines = lines(1:N);
            end

            % plot it
            lines.plot(varargin{:});

        end
        
        
        %HOUGHPEAKS   Find Hough accumulator peaks.
        %
        %	p = houghpeaks(H, N, hp)
        %
        %  Returns the coordinates of N peaks from the Hough
        %  accumulator.  The highest peak is found, refined to subpixel precision,
        %  then hp.radius radius around that point is zeroed so as to eliminate
        %  multiple close minima.  The process is repeated for all N peaks.
        %  p is an n x 3 matrix where each row is the offset, theta and
        %  relative peak strength (range 0 to 1).
        %
        %  The peak detection loop breaks early if the remaining peak has a relative 
        %  strength less than hp.houghThresh.
        %  The peak is refined by a weighted mean over a w x w region around
        %  the peak where w = hp.interpWidth.
        %
        % Parameters affecting operation are:
        %
        %	hp.houghThresh	threshold on relative peak strength (default 0.4)
        %	hp.radius       radius of accumulator cells cleared around peak 
        %                                 (default 5)
        %	hp.interpWidth  width of region used for peak interpolation
        %                                 (default 5)
        %
        function out = lines(h, N)
            if nargin < 2
                N = Inf;
            end

            if N < 1
                thresh = N;
                N = Inf;
            end

            [x,y] = meshgrid(1:h.Ntheta, 1:h.Nrho);

            nw2= floor((h.interpWidth-1)/2);
            nr2= floor((h.suppress-1)/2);

            [Wx,Wy] = meshgrid(-nw2:nw2,-nw2:nw2);
            globalMax = max(h.A(:));
            
            A = h.A;

            for i=1:N
                % find the current peak
                [mx,where] = max(A(:));
                %[mx where]
                
                % is the remaining peak good enough?
                if mx < (globalMax*h.houghThresh)
                    break;
                end
                [rp,cp] = ind2sub(size(A), where);
                %fprintf('\npeak height %f at (%d,%d)\n', mx, cp, rp);
                if h.interpWidth == 0
                    d = H.rho(rp);
                    theta = H.theta(cp);
                    p(i,:) = [d theta mx/globalMax];
                else
                    % refine the peak to subelement accuracy

                    k = Hough.nhood2ind(A, ones(h.interpWidth,h.interpWidth), [cp,rp]);
                    Wh = A(k);
                    %Wh                    
                    rr = Wy .* Wh;
                    cc = Wx .* Wh;
                    ri = sum(rr(:)) / sum(Wh(:)) + rp;
                    ci = sum(cc(:)) / sum(Wh(:)) + cp;
              
                    
                    %fprintf('refined %f %f\n', ci, ri);

                    % interpolate the line parameter values
                    d = interp1(h.rho, ri);
                    theta = interp1(h.theta, ci, 'linear', 0);
                    %p(i,:) = [d theta mx/globalMax];
                    L(i) = LineFeature(d, theta, mx/globalMax);
                    %p(i,:)

                end
                
                % remove the region around the peak
                k = Hough.nhood2ind(A, ones(2*h.suppress+1,2*h.suppress+1), [cp,rp]);
                A(k) = 0;

            end
            if nargout == 1
                out = L;
            else
                h.show
                hold on
                plot([L.theta]', [L.rho]', 'go');
                hold off
            end
        end % peaks


        %XYHOUGH	XY Hough transform
        %
        %	H = XYHOUGH(XYZ, drange, Nth)
        %
        %	Compute the Hough transform of the XY data given as the first two 
        %	columns of XYZ.  The last column, if given, is the point strength, 
        %	and is used as the increment for the Hough accumulator for that point.
        %
        % 	The accumulator array has theta across the columns and offset down 
        %	the rows.  Theta spans the range -pi/2 to pi/2 in Nth increments.
        %	The distance span is given by drange which is either
        %		[dmin dmax] in the range dmin to dmax in steps of 1, or
        %		[dmin dmax Nd] in the range dmin to dmax with Nd steps.
        %
        %	Clipping is applied so that only those points lying within the Hough 
        %	accumulator bounds are updated.
        %
        %	The output arguments TH and D give the theta and offset value vectors 
        %	for the accumulator columns and rows respectively.  With no output 
        %	arguments the Hough accumulator is displayed as a greyscale image.
        % 
        %	For this version of the Hough transform lines are described by
        %
        %		d = y cos(theta) + x sin(theta)
        %
        %	where theta is the angle the line makes to horizontal axis, and d is 
        %	the perpendicular distance between (0,0) and the line.  A horizontal 
        %	line has theta = 0, a vertical line has theta = pi/2 or -pi/2
        %
        % SEE ALSO: ihough mkline, mksq, isobel
        %
        function H = xyhough(h, XYZ, dmax, Nth)

            inc = 1;
            
            h.rho_offset = (h.Nrho+1)/2;
            h.rho_scale = (h.Nrho-1)/2 / dmax;
            
            if numcols(XYZ) == 2
                XYZ = [XYZ ones(numrows(XYZ),1)];
            end

            % compute the quantized theta values and the sin/cos
            nt2 = h.Ntheta/2;
            h.theta = [-nt2:(nt2-1)]'/nt2*pi/2;
            st = sin(h.theta);
            ct = cos(h.theta);

            H = zeros(h.Nrho, h.Ntheta);		% create the Hough accumulator

            % this is a fast `vectorized' algorithm

            % evaluate the index of the top of each column in the Hough array
            col0 = ([1:h.Ntheta]'-1)*h.Nrho;
            %col0_r = [(Nth-1):-1:0]'*Nrho + 1;

            for xyz = XYZ'
                x = xyz(1);		% determine (x, y) coordinate
                y = xyz(2);
                inc = xyz(3);
                inc =1 ;
                
                rho = y * ct + x * st;
                
                di = round( rho*h.rho_scale + h.rho_offset);	% in the range 1 .. Nrho
                % which elements are within the column
                %d(d<0) = -d(d<0);
                %inrange = d<Nrho;

                di = di + col0;   	% convert array of d values to Hough indices
                H(di) = H(di) + inc;	% increment the accumulator cells
            end

            nd2 = (h.Nrho-1)/2;
            h.rho = [-nd2:nd2]'/h.rho_scale;
        end % xyhough
    

    end % methods
    
    methods(Static)
        function idx = nhood2ind(im, SE, centre)
            [y,x] = find(SE);

            sw = (numcols(SE)-1)/2;
            sh = (numrows(SE)-1)/2;
            x = x + centre(1)-sw-1;
            y = y + centre(2)-sh-1;

            w = numcols(im);
            h = numrows(im);

            y(x<1) = h - y(x<1);
            x(x<1) = x(x<1) + w;
            
            y(x>w) = h - y(x>w);
            x(x>w) = x(x>w) - w;
            


            idx = sub2ind(size(im), y, x);
            idx = reshape(idx, size(SE));
        end
    end % static methods
end % Hough
%        LineFeature                    - LineFeature < handle

    properties
        rho
        theta
        strength
        length
    end

    methods
        function h = LineFeature(rho, theta, strength, length)
            if isa(rho, 'LineFeature')
                % clone the passed object
                obj = rho;
                h.rho = obj.rho;
                h.theta = obj.theta;
                h.strength = obj.strength;
                h.length = obj.length;
                return
            end
            if nargin > 0
                h.rho = rho;
                h.theta = theta;
                h.strength = strength;
                if nargin > 3
                    h.length = length;
                end
            end
        end

        function val = rho_v(lines)
            val = [lines.rho];
        end

        function val = theta_v(lines)
            val = [lines.theta];
        end

        function val = strength_v(lines)
            val = [lines.strength];
        end

        function val = length_v(lines)
            val = [lines.length];
        end

        function display(h)
            loose = strcmp( get(0, 'FormatSpacing'), 'loose');
            if loose
                disp(' ');
            end
            disp([inputname(1), ' = '])
            if loose
                disp(' ');
            end
            disp(char(h))
            if loose
                disp(' ');
            end
        end

        function ss = char(lines)
            ss = [];
            for line=lines
                s = sprintf('theta=%g, rho=%g, strength=%g', ...
                    line.theta, line.rho, line.strength);
                if ~isempty(line.length)
                    s = strcat(s, sprintf(', length=%d', line.length));
                end
                ss = strvcat(ss, s);
            end
        end
                %fprintf(' intercept     theta   strength\n');
                %disp(p);
        
        function handles = plot(lines, varargin)

            holdon = ishold;
            hold on

            % figure the x-axis scaling
            scale = axis;
            x = [scale(1):scale(2)]';
            y = [scale(3):scale(4)]';
            hl = [];

            % plot it
            for line=lines

                %fprintf('theta = %f, d = %f\n', line.theta, line.rho);
                if abs(cos(line.theta)) > 0.5,
                    % horizontalish lines
                    %disp('hoz');
                    h = plot(x, -x*tan(line.theta) + line.rho/cos(line.theta), varargin{:});
                else
                    % verticalish lines
                    %disp('vert');
                    h = plot( -y/tan(line.theta) + line.rho/sin(line.theta), y, varargin{:});
                end
                hl = [hl h];
            end

            if ~holdon,
                hold off
            end

            if nargout > 0,
                handles = hl;
            end
            figure(gcf);        % bring it to the top
        end

        function out = seglength(lines, im_edge, gap)

            if nargin < 3
                gap = 5;
            end

            out = [];
            for L=lines
                %fprintf('d=%f, theta=%f; ', L.rho, L.theta)


                if abs(L.theta) < pi/4
                    xmin = 1; xmax = numcols(im_edge);
                    m = -tan(L.theta); c = L.rho/cos(L.theta);
                    ymin = round(xmin*m + c);
                    ymax = round(xmax*m + c);
                else
                    ymin = 1; ymax = numrows(im_edge);
                    m = -1/tan(L.theta); c = L.rho/sin(L.theta);
                    xmin = round(ymin*m + c);
                    xmax = round(ymax*m + c);
                end


                line = bresenham(xmin, ymin, xmax, ymax);

                line = line(line(:,2)>=1,:);
                line = line(line(:,2)<=numrows(im_edge),:);
                line = line(line(:,1)>=1,:);
                line = line(line(:,1)<=numcols(im_edge),:);

                contig = 0;
                contig_max = 0;
                total = 0;
                missing = 0;
                for pp=line'
                    pix = im_edge(pp(2), pp(1));
                    if pix == 0
                        missing = missing+1;
                        if missing > gap
                            contig_max = max(contig_max, contig);
                            contig = 0;
                        end
                    else
                        contig = contig+1;
                        total = total+1;
                        missing = 0;
                    end
                    %ee(pp(2), pp(1))=1;
                end
                contig_max = max(contig_max, contig);

                %fprintf('  strength=%f, len=%f, total=%f\n', L.strength, contig_max, total);
                o = LineFeature(L);     % clone the object
                o.length = contig_max;
                out = [out o];
            end
        end
        
    end % methods
end % Hough
%
%          Point features
%            FeatureMatch               - % m           display summary info about matches
% m.length    number of matches
% m.inliers   coordinates of inliers: u1 v1 u2 v2
% m.outliers  coordinates of outliers: u1 v1 u2 v2
% m.plot      display two source images side by side and overlay matches
% m.plot(''all'')      " " show all matches (default)
% m.plot(''in'')       " " only show inliers
% m.plot(''out'')      " " only show outliers
% m.plot(''only'', n)  " " only show n matches
% m.plot(''first'', n) " " only show first n matches
% m.plot(ls)         " " with specified line style
% eg. m.plot(''out'', ''only'', 50, ''r'')  show only 50 outliers as red lines

classdef FeatureMatch < handle

    properties
        xy_          % x1 y1 x2 y2 of corresponding points
        distance_    % strength of match
        inlier_      % NaN indeterminate
                    % true inlier
                    % false outlier
    end

    methods

        function m = FeatureMatch(f1, f2, s)
            if nargin == 0
                return;
            end

            m.xy_ = [f1.u_ f1.v_ f2.u_ f2.v_]';
            m.distance_ = s;
            m.inlier_ = NaN;
        end

        function v = inlier(m)
            v = m([m.inlier_] == true);
        end

        function v = outlier(m)
            v = m([m.inlier_] == false);
        end

        function v = distance(m)
            v = [m.distance_];
        end

        function display(m)
            disp(' ');
            disp([inputname(1), ' = '])
            disp(' ');
            if length(m) > 20
                fprintf('%d corresponding points (listing suppressed)\n', length(m));
            else
                disp( char(m) );
            end
        end % display()

        function s = char(matches)
            s = '';
            for m=matches
                ss = sprintf('(%g, %g) <-> (%g, %g), dist=%f', ...
                    m.xy_, m.distance_);
                switch m.inlier_
                case true
                    ss = [ss ' +'];
                case false
                    ss = [ss ' -'];
                end
                s = strvcat(s, ss);
            end
        end
        
        function s = show(m)
            s = sprintf('%d corresponding points\n', length(m));
            in = [m.inlier_];
            s = [s sprintf('%d inliers (%.1f%%)\n', ...
                sum(in==true), sum(in==true)/length(m)*100)];
            s = [s sprintf('%d outliers (%.1f%%)\n', ...
                sum(in==false), sum(in==false)/length(m)*100) ];
        end
        
        function v = subset(m, n)
            i = round(linspace(1, length(m), n));
            v = m(i);
        end

        function s = p1(m, k)
            xy = [m.xy_];
            s = xy(1:2,:);
        end
        
        function s = p2(m, k)
            xy = [m.xy_];
            s = xy(3:4,:);
        end
        
        function s = p(m, k)
            s = [m.xy_];
        end
        
        function plot(m, varargin)       

            try
                ud = get(gca, 'UserData');
                u0 = ud.u0;
            catch
                error('Current image is not a pair displayed by idisp');
            end
            w = u0(2);
            
            xy = [m.xy_];
            hold on
            for k=1:numcols(xy),
                plot([xy(1,k) xy(3,k)+w], xy([2 4],k), varargin{:});
            end
            hold off
            figure(gcf);
        end % plot
        
        function [MM,rr] = ransac(m, func, varargin)
            [M,in,resid] = ransac(func, [m.xy_], varargin{:});
            
            % mark all as outliers
            for i=1:length(m)
                m(i).inlier_ = false;
            end
            for i=in
                m(i).inlier_ = true;
            end

            if nargout >= 1
                MM = M;
            end
            if nargout >= 2
                rr = resid;
            end
        end
    end

end
%            ScalePointFeature          - Point feature object
%
% A superclass for image corner features.

classdef ScalePointFeature < PointFeature

    properties
        scale_
    end % properties

    methods
        function f = ScalePointFeature(varargin)
            f = f@PointFeature(varargin{:});  % invoke the superclass constructor
        end

        function val = scale(features)
            val = [features.scale_];
        end


        % accepts all the same options as imarker, first option must be the fill color
        function plot_scale(features, varargin)

            opt.display = {'circle', 'disk'};
            [opt,arglist] = tb_optparse(opt, varargin);

            holdon = ishold;
            hold on

            s = 1;

            switch (opt.display)
            case 'circle'
                plot_circle([ [features.u_]; [features.v_] ], s*[features.scale_]', arglist{:});
            case 'disk'
                plot_circle([ [features.u_]; [features.v_] ], s*[features.scale_]', ...
                    'fillcolor', 'g', 'alpha', 0.2);
            end
            if ~holdon
                hold off
            end
        end % plot

    end % methods
end % classdef
%            SurfPointFeature           - SIFT Corner feature object
%
% A superclass for image corner features.

classdef SurfPointFeature < ScalePointFeature

    properties
        theta_
        image_id_
    end % properties

    methods
        function f = SurfPointFeature(varargin)
            f = f@ScalePointFeature(varargin{:});  % invoke the superclass constructor
        end

        function val = theta_v(features)
            val = [features.theta];
        end

        function val = theta(features)
            val = [features.theta_];
        end

        function val = image_id(features)
            val = [features.image_id_];
        end

        % accepts all the same options as imarker, first option must be the fill color
        function plot_scale(features, varargin)
            arglist = {};

            argc = 1;
            opt.display = 'circle';
            while argc <= length(varargin)
                switch lower(varargin{argc})
                case 'circle'
                    opt.display = varargin{argc};
                case 'clock'
                    opt.display = varargin{argc};
                case 'disk'
                    opt.display = varargin{argc};
                case 'arrow'
                    opt.display = varargin{argc};
                otherwise
                    arglist = [arglist varargin(argc)];
                end
                argc = argc + 1;
            end
            holdon = ishold;
            hold on

            s = 20/sqrt(pi);    % circle of same area as 20s x 20s square support region

            switch (opt.display)
            case 'circle'
                plot_circle([ [features.u_]; [features.v_] ], s*[features.scale_]', arglist{:});
            case 'clock'
                plot_circle([ [features.u_]; [features.v_] ], s*[features.scale_]', arglist{:});
                for f=features
                    plot([f.u_, f.u_+s*f.scale_*cos(f.theta_)], ...
                        [f.v_, f.v_+s*f.scale_*sin(f.theta_)], ...
                        arglist{:});
                end
            case 'disk'
                plot_circle([ [features.u_]; [features.v_] ], s*[features.scale_]', ...
                        'fillcolor', 'g', 'alpha', 0.2);
            case 'arrow'
                for f=features
                    quiver(f.u_, f.v_, s*f.scale_.*cos(f.theta_), ...
                            s*f.scale_.*sin(f.theta_), arglist{:});
                end
            end
            if ~holdon
                hold off
            end
        end % plot

        function [m,corresp] = match(f1, f2, varargin)

        opt.thresh = 0.05;
        opt = tb_optparse(opt, varargin);

% Put the landmark descriptors in a matrix
  %D1 = reshape([Ipts1.descriptor],64,[]); 
  %D2 = reshape([Ipts2.descriptor],64,[]); 
  D1 = f1.descriptor;
  D2 = f2.descriptor;
% Find the best matches
  err=zeros(1,length(f1));
  cor1=1:length(f1); 
  cor2=zeros(1,length(f1));
  for i=1:length(f1),
      distance=sum((D2-repmat(D1(:,i),[1 length(f2)])).^2,1);
      [err(i),cor2(i)]=min(distance);
  end
% Sort matches on vector distance
  [err, ind]=sort(err); 
  cor1=cor1(ind); 
  cor2=cor2(ind);
            m = [];
            cor = [];
            for i=1:length(f1)
                k1 = cor1(i);
                k2 = cor2(i);
                mm = FeatureMatch(f1(k1), f2(k2), err(i));
                m = [m mm];
                cor(:,i) = [k1 k2]';
            end            

            if isnumeric(opt.thresh)
                thresh = opt.thresh;
            elseif strcmp('median', opt.thresh)
                thresh = median(err);
            end
            if ~isempty(opt.thresh)
                k = err > thresh;
                cor(:,k) = [];
                m(k) = [];
            end

            if nargout > 1
                corresp = cor;
            end
    %
    %            [matches,dist,dist2] = closest([f1.descriptor], [f2.descriptor]);
    %            matches = [1:length(f1); matches];
    %
    %            % delete matches where distance of closest match is greater than 
    %            % 0.7 of second closest match
    %            k = dist > 0.7 * dist2;
    %
    %            matches(:,k) = [];
    %            dist(k) = [];
    %
    %            % dist is a 1xM matrix of distance between the matched features, low is good.
    %
    %            % matches is a 2xM matrix, one column per match, each column 
    %            % is the index of the matching feature in images 1 and 2
    %
    %            % sort into increasing distance
%            [z,k] = sort(dist, 'ascend');
%            matches = matches(:,k);
%            dist = dist(:,k);
%
%            m = [];
%            cor = [];
%
%            for i=1:numcols(matches),
%                k1 = matches(1,i);
%                k2 = matches(2,i);
%                mm = FeatureMatch(f1(k1), f2(k2), dist(i));
%                m = [m mm];
%                cor(:,i) = [k1 k2]';
%            end            
%
%            if nargout > 1
%                corresp = cor;
%            end
        end


    end % methods

    methods(Static)

        % the MEX functions live in a private subdirectory, so these static methods
        % provide convenient access to them

        function Ipts = surf(varargin)
            Ipts = OpenSurf(varargin{:});
        end
    end

end % classdef
%            PointFeature               - PointCorner feature object
%
% A superclass for image corner features.

classdef PointFeature < handle

    properties %(GetAccess=protected)%, Hidden=true)
        u_           % feature x-coordinates
        v_           % feature y-coordinates
        strength_
        descriptor_
    end % properties

    methods

        function f = PointFeature(u, v, strength)
            if nargin == 0
                return;
            end
            if nargin >= 2
                f.u_ = u;
                f.v_ = v;
            end
            if nargin == 3
                f.strength_ = strength;
            end
        end

        function val = u(f)
            val = [f.u_];
        end

        function val = v(f)
            val = [f.v_];
        end

        function val = p(f)
            val = [[f.u_]; [f.v_]];
        end

        function val = strength(f)
            val = [f.strength_];
        end

        function val = descriptor(f)
            val = [f.descriptor_];
        end

        function display(f)
            disp(' ');
            disp([inputname(1), ' = '])
            disp(' ');
            if length(f) > 20
                fprintf('%d features (listing suppressed)\n  Properties:', length(f));
                for property=fieldnames(f)'
                    fprintf(' %s', property{1}(1:end-1));
                end
                fprintf('\n');
            else
                disp( char(f) );
            end
        end % display()

        function ss = char(features)
            ss = [];
            for i=1:length(features)
                f = features(i);
                % display the coordinate
                s = sprintf('  (%g,%g)', f.u_, f.v_);

                % display the other properties
                for property=fieldnames(f)'
                    prop = property{1}; % convert from cell array
                    switch prop
                    case {'u_', 'v_', 'descriptor_'}
                        continue;
                    otherwise
                        val = getfield(f, prop);
                        if ~isempty(val)
                            s = strcat(s, [sprintf(', %s=', prop(1:end-1)), num2str(val, ' %g')]);
                        end
                    end
                end

                % do the descriptor last
                val = getfield(f, 'descriptor_');
                if ~isempty(val)
                    if length(val) == 1
                        % only list scalars or shortish vectors
                        s = strcat(s, [', descrip=', num2str(val, ' %g')]);
                    elseif length(val) < 4
                        % only list scalars or shortish vectors
                        s = strcat(s, [', descrip=(', num2str(val', ' %g'), ')']);
                    else
                        s = strcat(s, ', descrip= ..');
                    end
                end
                ss = strvcat(ss, s);
            end
        end

        function val = uv(features)
            val = [[features.u]; [features.v]];
        end

        % f.plot()
        % f.plot(linespec)
        function plot(features, varargin)
            holdon = ishold;
            hold on

            if nargin == 1
                varargin = {'ws'};
            end

            for i=1:length(features)
                plot(features(i).u_, features(i).v_, varargin{:});
            end

            if ~holdon
                hold off
            end
        end % plot

        function s = distance(f1, f2)
            for i=1:length(f2)
                s(i) = norm(f1.descriptor-f2(i).descriptor);
            end
        end

        function s = ncc(f1, f2)
            for i=1:length(f2)
                s(i) = dot(f1.descriptor,f2(i).descriptor);
            end
        end

        function [m,corresp] = match(f1, f2)

        % TODO: extra args for distance measure, could be ncc, pass through to closest
        % allow threshold, percentage of max

            [corresp, dist]  = closest([f1.xy_], [f2.xy_]);

            % sort into increasing distance
            [z,k] = sort(dist, 'ascend');
            corresp = corresp(:,k);
            dist = dist(:,k);

            m = [];
            cor = [];

            for i=1:numcols(corresp),
                k1 = i;
                k2 = corresp(i);
                mm = FeatureMatch(f1(k1), f2(k2), dist(i));
                m = [m mm];
                cor(:,i) = [k1 k2]';
            end            

            if nargout > 1
                corresp = cor;
            end
        end

    end % methods
end % classdef
%            iscalemax                  - Find maxima in scale space image sequence
%
% F = ISCALEMAX(L, S) returns a vector of ScalePointFeature objects from the
% scale space image sequence L which is NxMxD.  S is a vector of scale values
% corresponding to each plane of L
%
% Notes::
% - feautures are sorted into descending feature strength
%
% See also ISCALESPACE, ScalePointFeature.

function features = iscalemax(L, sscale)

    allmax = zeros(size(L));
    nbmax = zeros(size(L));
    se_all = ones(3,3);
    se_nb = se_all; se_nb(2,2) = 0;

    % get maxima at each level
    for k=1:size(L,3)
        allmax(:,:,k) = imorph(abs(L(:,:,k)), se_all, 'max', 'replicate');
        nbmax(:,:,k) = imorph(abs(L(:,:,k)),  se_nb, 'max', 'replicate');
    end

    z = zeros(size(L,1), size(L,2));
    fc = 1;
    strength = zeros(size(L,1), size(L,2));
    for k=2:size(L,3)-1     % maxima cant be at either end of the scale range
        s = abs(L(:,:,k));
        corners = find( s > nbmax(:,:,k) & s > allmax(:,:,k-1) & s > allmax(:,:,k+1) );
        for corner=corners'
            [y,x] = ind2sub(size(s), corner);
            features(fc) = ScalePointFeature(x, y, s(corner));
            features(fc).scale_ = sscale(k)*sqrt(2);
            fc = fc+1;
        end
    end

    % sort into descending order of strength
    [z,k] = sort(-features.strength);
    features = features(k);
%            iscalespace                - Return scale-space image sequence
%
% [G,L,S] = ISCALESPACE(IM, D, SIGMA) returns a scale space image sequence of 
% length D derived from IM (HxW).  The standard deviation of the smoothing 
% Gaussian is SIGMA.  At each scale step the variance of the Gaussian increases
% by SIGMA^2.  The first step in the sequence is the original image.
%
% L (HxWxN) is the absolute value of the Laplacian of the scale sequence, 
% G (HxWxN) is the scale sequence, and S (Nx1) is the vector of scales 
% corresponding to each step of the sequence.
%
% [G,L,S] = ISCALESPACE(IM, N) as above but SIGMA=1.
%
% Notes::
% - The Laplacian is computed by the difference of adjacent Gaussians.
%
% See also ISCALEMAX, ISMOOTH, ILAPLACE.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.

function [G, L, S] = scalespace(im, n, sigma)

    if nargin < 3
        sigma = 1;
    end

    g(:,:,1) = im;
    scale = 0.5;
    scales = scale;
    for i=1:n-1,
        im = ismooth(im, sigma);
        scale = sqrt(scale^2 + sigma^2);
        scales = [scales; scale];
        g(:,:,i+1) = im;
        lap(:,:,i) = scale^2 * ( g(:,:,i+1) - g(:,:,i) );
    end

    % return results as requested
    if nargout > 2,
        S = scales;
    end
    if nargout > 0,
        G = g;
    end
    if nargout > 1,
        L = lap;
    end
%            isurf                      - SURF feature extractor
%
% SF = ISURF(IM, OPTIONS) returns a vector of Surf objects
% representing scale and rotationally invariant interest points in the
% image IM.
%
% The SurfPointFeature object has many properties including:
%  u            horizontal coordinate
%  v            vertical coordinate
%  strength     feature strength
%  descriptor   feature descriptor (64x1 or 128x1)
%  sigma        feature scale
%  theta        feature orientation (rad)
%
% Options::
% 'nfeat',N      set the number of features to return (default Inf)
% 'extended'     return 128-element descriptor (default 64)
% 'upright'      dont compute rotation invariance
% 'suppress',R   set the suppression radius (default 0)
%
% Notes::
% - features are returned in descending strength order
% - wraps a function by ??
% - if IM is NxMxP it is taken as an image sequence and F is a cell array whose
%   elements are feature vectors for the corresponding image in the sequence.
% 
% Reference:
% "SURF: Speeded Up Robust Features", Herbert Bay, Andreas Ess, Tinne Tuytelaars, Luc Van Gool,
% Computer Vision and Image Understanding (CVIU), Vol. 110, No. 3, pp. 346--359, 2008
%
% See also SurfPointFeature, ISIFT, ICORNER.

function features = isurf(im, varargin)

    opt.suppress = 0;
    opt.nfeat = Inf;
    opt.extended = true;
    opt.upright = false;

    [opt,arglist] = tb_optparse(opt, varargin);

    if iscell(im)
        % images provided as a cell array, return a cell array
        % of SIFT object vectors
        fprintf('extracting SIFT features for %d greyscale images\n', length(im));
        features = {};
        for i=1:length(im)
            sf = isurf(im{i}, 'setopt', opt);
            for j=1:length(sf)
                sf(j).image_id = i;
            end
            features{i} = sf;
            fprintf('.');
        end
        fprintf('\n');
        return
    end

    % convert color image to greyscale
    if ndims(im) ==3 && size(im, 3) == 3
       im = imono(im);
    end

    if ndims(im) > 2

        % TODO sequence of color images..

        % images provided as an array, return a cell array
        % of SURF object vectors
        if opt.verbose
            fprintf('extracting SURF features for %d greyscale images\n', size(im,3));
        end
        features = {};
        for i=1:size(im,3)
            sf = isurf(im(:,:,i), 'setopt', opt);
            for j=1:length(sf)
                sf(j).image_id_ = i;
            end
            features{i} = sf;
            fprintf('.');
        end
        if opt.verbose
            fprintf('\n');
        end
        return
    end


    % do SURF using a static method that wraps the implementation from:
    % OpenSURF for Matlab
    %   written by D.Kroon University of Twente (July 2010)
    %   based on the C++ implementation by Chris Evans

    %options.extended = true;
    options.extended = false;
    options.tresh = 0.0002;
    Ipts = SurfPointFeature.surf(im, options, arglist{:});

    % Ipts is a structure array with elements x, y, scale, orientation, descriptor

    fprintf('%d corners found (%.1f%%), ', length(Ipts), ...
        length(Ipts)/prod(size(im))*100);

    % sort into descending order of corner strength
    [z,k] = sort([Ipts.strength], 'descend');
    Ipts = Ipts(:,k);

    % allocate storage for the objects
    n = min(opt.nfeat, length(Ipts));

    features = [];
    i = 1;
    while i<=n
        if i > length(Ipts)
            break;
        end

        % enforce separation between corners
        % TODO: strategy of Brown etal. only keep if 10% greater than all within radius
        if (opt.suppress > 0) && (i>1)
            d = sqrt( ([features.v]'-Ipts(i).y).^2 + ([features.u]'-Ipts(i).x).^2 );
            if min(d) < opt.suppress
                continue;
            end
        end
        f = SurfPointFeature(Ipts(i).x, Ipts(i).y, Ipts(i).strength);
        f.scale_ = Ipts(i).scale;
        f.theta_ = Ipts(i).orientation;
        f.descriptor_ = cast(Ipts(i).descriptor, 'single');

        features = [features f];
        i = i+1;
    end
    fprintf(' %d corner features saved\n', i-1);
%            icorner                    - Classical corner detector
%
% F = ICORNER(IM, OPTIONS) returns a vector of PointFeature objects describing
% the detected corner features.  This is a non-scale space detector and by
% default the Harris method is used.  If IM is an image sequence a cell array
% of feature vectors is returned.
%
% The PointFeature object has many properties including:
%  u            horizontal coordinate
%  v            vertical coordinate
%  strength     corner strength
%  descriptor   corner descriptor (vector)
%
% Options::
% 'cmin',CM         minimum corner strength
% 'cminthresh',CT   minimum corner strenght as a fraction of maximum corner strength
% 'edgegap',EG      dont return features closer than EG to the edge of image
% 'suppress',R      dont return a feature closer than R pixels to an earlier feature
% 'nfeat',N         return the N strongest corners (default Inf)
% 'detector',D      choose the detector where D is 'harris' (default), 'noble' or 'klt'
% 'sigma',S         kernel width for smoothing
% 'deviv',D         kernel for gradient (default kdgauss(2))
% 'k',K             set the value of k for Harris detector
% 'patch',P         use a PxP patch as the feature vector
% 'color'           specify that IM is a color image not a sequence
%
% Notes::
% - corners are processed in order from strongest to weakest.
% - the function stops when:
%     - the corner strength drops below .cmin
%     - the corner strenght drops below P.cMinThresh * strongest corner
%     - the list of corners is exhausted
% - features are returned in descending strength order
% - if IM has more than 2 dimensions it is either a color image or a sequence
% - if IM is NxMxP it is taken as an image sequence and F is a cell array whose
%   elements are feature vectors for the corresponding image in the sequence.
% - if IM is NxMx3 it is taken as a sequence unless the option 'color' is used
% - if IM is NxMx3xP it is taken as a sequence of color images and F is a cell
%   array whose elements are feature vectors for the corresponding color image 
%   in the sequence.
% - the default descriptor is a vector [Ix Iy Ixy] which are the unique
%   elements of the structure tensor.
%
% Reference:
% "A combined corner and edge detector", C.G. Harris and M.J. Stephens,
% Proc. Fourth Alvey Vision Conf., Manchester, pp 147-151, 1988.
%
% See also PointFeature, ISURF.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.


function [features, corner_strength] = icorner(im, varargin)

    % TODO, can handle image sequence, return 3D array of corner_strength if requested 
    % and cell array of corner vectors

    % parse options into parameter struct
    opt.k = 0.04;
    opt.deriv = kdgauss(2);

    opt.cmin = 0;
    opt.cminthresh = 0.0;
    opt.edgegap = 2;
    opt.nfeat = Inf;
    opt.sigma_i = 2;
    opt.patch = 0;
    opt.detector = {'harris', 'noble', 'st'};
    opt.color = false;

    opt.suppress = 0;
    opt.nfeat = 100;

    [opt,arglist] = tb_optparse(opt, varargin);

    if opt.patch > 0
        opt.edgegap = opt.patch;
    end

    if iscell(im)
        % images provided as a cell array, return a cell array
        % of corner object vectors
        if opt.verbose
            fprintf('extracting corner features for %d images\n', length(im));
        end
        features = {};
        for i=1:length(im)
            f = icorner(im{i}, 'setopt', opt);
            for j=1:length(f)
                f(j).image_id = i;
            end
            features{i} = f;
            fprintf('.');
        end
        if opt.verbose
            fprintf('\n');
        end
        return
    end


    if ndims(im) > 2

        % images provided as an array, return a cell array
        % of corner object vectors

        if ndims(im) == 4 && size(im,3) == 3 && opt.color
            fprintf('extracting corner features for color %d images\n', size(im,4));
            features = {};
            % sequence of color images
            for i=1:size(im,k)
                f = icorner(im(:,:,:,i), 'setopt', opt);
                for j=1:length(f)
                    %f(j).image_id_ = i;
                end
                features{i} = f;
                fprintf('.');
            end
            fprintf('\n');
            return
        elseif ndims(im) == 3 && ~opt.color
            fprintf('extracting corner features for grey %d images\n', size(im,3));
            features = {};
            % sequence of grey images
            for i=1:size(im,3)
                f = icorner(im(:,:,i), 'setopt', opt);
                for j=1:length(f)
                    %f(j).image_id_ = i;
                end
                features{i} = f;
                fprintf('.');
            end
            fprintf('\n');
            return
        end
    end

    if ndims(im) == 3 & opt.color
        R = double(im(:,:,1));
        G = double(im(:,:,2));
        B = double(im(:,:,3));
        Rx = conv2(R, opt.deriv, 'same');
        Ry = conv2(R, opt.deriv', 'same');
        Gx = conv2(G, opt.deriv, 'same');
        Gy = conv2(G, opt.deriv', 'same');
        Bx = conv2(B, opt.deriv, 'same');
        By = conv2(B, opt.deriv', 'same');

        Ix = Rx.^2+Gx.^2+Bx.^2;
        Iy = Ry.^2+Gy.^2+By.^2;
        Ixy = Rx.*Ry+Gx.*Gy+Bx.*By;
    else
        % compute horizontal and vertical gradients
        im = double(im);
        ix = conv2(im, opt.deriv, 'same');
        iy = conv2(im, opt.deriv', 'same');
        Ix = ix.*ix;
        Iy = iy.*iy;
        Ixy = ix.*iy;
    end

    % smooth them
    if opt.sigma_i > 0
        Ix = ismooth(Ix, opt.sigma_i);
        Iy = ismooth(Iy, opt.sigma_i);
        Ixy = ismooth(Ixy, opt.sigma_i);
    end

    [nr,nc] = size(Ix);
    npix = nr*nc;

    % computer cornerness
    switch opt.detector
    case 'harris'
        cornerness = (Ix .* Iy - Ixy.^2) - opt.k * (Ix + Iy).^2;
    case 'noble'
        cornerness = (Ix .* Iy - Ixy.^2) ./ (Ix + Iy);
    case 'st'
        cornerness = zeros(size(Ix));
        for i=1:npix
            lambda = eig([Ix(i) Ixy(i); Ixy(i) Iy(i)]);
            cornerness(i) = min(lambda);
        end
    end

    % compute maximum value around each pixel
    cmax = imorph(cornerness, [1 1 1;1 0 1;1 1 1], 'max');

    % if pixel exceeds this, its a local maxima, find index
    cindex = find(cornerness > cmax);

    fprintf('%d corners found (%.1f%%), ', length(cindex), ...
        length(cindex)/npix*100);

    % remove those near edges
    [y, x] = ind2sub(size(cornerness), cindex);
    e = opt.edgegap;
    k = (x>e) & (y>e) & (x < (nc-e)) & (y < (nr-e));
    cindex = cindex(k);

    % corner strength must exceed an absolute minimum
    k = cornerness(cindex) < opt.cmin;
    cindex(k) = [];

    % sort into descending order
    cval = cornerness(cindex);		    % extract corner values
    [z,k] = sort(cval, 'descend');	% sort into descending order
    cindex = cindex(k)';
    cmax = cornerness( cindex(1) );   % take the strongest feature value

    % corner strength must exceed a fraction of the maximum value
    k = cornerness(cindex)/cmax < opt.cminthresh;
    cindex(k) = [];

    % allocate storage for the objects
    n = min(opt.nfeat, numcols(cindex));

    features = [];
    i = 1;
    while i <= n
        if i > length(cindex)
            break;
        end
        K = cindex(i);
        c = cornerness(K);

        % get the coordinate
        [y, x] = ind2sub(size(cornerness), K);

        % enforce separation between corners
        % TODO: strategy of Brown etal. only keep if 10% greater than all within radius
        if (opt.suppress > 0) && (i>1)
            d = sqrt( sum((features.v'-y).^2 + (features.u'-x).^2) );
            if min(d) < opt.suppress
                continue;
            end
        end

        % ok, this one is for keeping
        f = PointFeature(x, y, c);
        if opt.patch == 0
            f.descriptor_ = [Ix(K) Iy(K) Ixy(K)]';
        else
            % if opt.patch is finite, then return a vector which is the local image
            % region as a vector, zero mean, and normalized by the norm.
            % the dot product of this with another descriptor is the ZNCC similarity measure
            w2 = opt.patch;
            d = im(y-w2:y+w2,x-w2:x+w2);
            d = d(:);
            d = d - mean(d);
            f.descriptor_ = cast( d / norm(d), 'single');
        end

        features = [features f];
        i = i+1;
    end
    fprintf(' %d corner features saved\n', i-1);

    % sort into descending order of strength
    [z,k] = sort(-features.strength);
    features = features(k);

    if nargout > 1
        corner_strength = cornerness;
    end
%
%          Other features
%            peak                       - Find peaks in vector
%
% YP = PEAK(Y, OPTIONS) are the values of the maxima in the vector Y.
%
% [YP,I] = PEAK(Y, OPTIONS) as above but also returns the indices of the maxima
% in the vector Y.
%
% [YP,XP] = PEAK(Y, X, OPTIONS) as above but also returns the corresponding 
% x-coordinates of the maxima in the vector Y.  X is the same length of Y
% and contains the corresponding x-coordinates.
%
% Options::
% 'npeaks',N    Number of peaks to return (default 2)
% 'scale',S     Only consider as peaks the largest value in the horizontal 
%               range +/- S points.
% 'interp',N    Order of interpolation polynomial (default no interpolation)
% 'plot'        Display the interpolation polynomial overlaid on the point data
%
% Notes::
% - To find minima, use PEAK(-V).
%
% See also PEAK2.

% Copyright (c) Peter Corke 1/96

function [yp,xpout] = peak(y, varargin)

    % process input options
    opt.npeaks = 2;
    opt.scale = 1;
    opt.interp = 0;
    opt.plot = false;
    
    [opt,args] = tb_optparse(opt, varargin);
    
    
    % if second argument is a matrix we take this as the corresponding x
    % coordinates
    if ~isempty(args)
        x = args{1};
        x = x(:);
        if length(x) ~= length(y)
            error('second argument must be same length as first');
        end
    else
        x = [1:length(y)]';
    end
    
    y = y(:);
    
    % find the maxima
    if opt.scale > 1
        % compare to a moving window max filtered version
        k = find(y' == maxfilt(y, opt.scale*2+1));
    else
        % take the zero crossings
        dv = diff(y);
        k = find( ([dv; 0]<0) & ([0; dv]>0) );
    end
    
    % sort the maxima into descending magnitude
    [m,i] = sort(y(k), 'descend');
    k = k(i);    % indice of the maxima

    k = k(1:opt.npeaks);
    

    % optionally plot the discrete data
    if opt.plot
        plot(x, y, '-o');      
        hold on
    end
    

    % interpolate the peaks if required
    if opt.interp
        if opt.interp < 2
            error('interpolation polynomial must be at least second order');
        end
        
        xp = [];
        yp = [];
        N = opt.interp;
        N2 = round(N/2);

        % for each previously identified peak x(i), y(i)
        for i=k'
            % fit a polynomial to the local neighbourhood
            try
                pp = polyfit(x(i-N2:i+N2), y(i-N2:i+N2), N);
            catch
                % handle situation where neighbourhood falls off the data
                % vector
                warning('Peak at %f too close to start or finish of data, skipping', x(i));
                continue;
            end
            
            % find the roots of the polynomial closest to the coarse peak
            r = roots( polydiff(pp) );
            [mm,j] = min(abs(r-x(i)));
            xx = r(j);
            
            % store x, y for the refined peak
            xp = [xp; xx];
            yp = [y; polyval(pp, xx)];
            
            if opt.plot
                % overlay the fitted polynomial and refined peak
                xr = linspace(x(i-N2), x(i+N2), 50);
                plot(xr, polyval(pp, xr), 'r');
                plot(xx, polyval(pp, xx), 'rd');
            end
        end
    else
        xp = x(k);
    end
    
    if opt.plot
        grid
        xlabel('x');
        ylabel('y');
        hold off
    end
    
    % return values
    yp = y(k)';
    if nargout > 1
        xpout = xp';
    end
%            peak2                      - Find peaks in a matrix
%
% ZP = PEAK2(Z, OPTIONS) are the peak values in the 2-dimensional signal Z.
%
% [ZP,IJ] = PEAK2(Z, OPTIONS) as above but also returns the indices of the 
% maxima in the matrix Z.  Use SUB2IND to convert these to row and column 
% values.
%
% Options::
% 'npeaks',N    Number of peaks to return (default 2)
% 'scale',S     Only consider as peaks the largest value in the horizontal 
%               and vertical range +/- S points.
% 'interp',N    Order of interpolation polynomial (default no interpolation)
% 'plot'        Display the interpolation polynomial overlaid on the point data
%
% Notes::
% - To find minima, use PEAK(-V).
%
% See also PEAK.

% Copyright (c) Peter Corke 1/96

function [zp,xypout, aout] = peak2(z, varargin)

    % process input options
    opt.npeaks = 2;
    opt.scale = 1;
    opt.interp = false;
    
    [opt,args] = tb_optparse(opt, varargin);
    
    
    % create a neighbourhood mask for non-local maxima
    % suppression
    h = opt.scale;
    w = 2*h+1;
    M = ones(w,w);
    M(h+1,h+1) = 0;
    
    % compute the neighbourhood maximum
    znh = iwindow(double(z), M, 'max', 'wrap');
    
    % find all pixels greater than their neighbourhood
    k = find(z > znh);
    
    
    % sort these local maxima into descending order
    [zpk,ks] = sort(z(k), 'descend');

    k = k(ks);
    
    npks = min(length(k), opt.npeaks);
    k = k(1:npks);
    
    [y,x] = ind2sub(size(z), k);
    xy = [x y]';
    

    % interpolate the peaks if required
    if opt.interp
        
        
        xyp = [];
        zp = [];
        ap = [];
               
        % for each previously identified peak x(i), y(i)
        for xyt=xy
            % fit a polynomial to the local neighbourhood
            try
                
                x = xyt(1); y = xyt(2);

                
                % now try to interpolate the peak over a 3x3 window
                
                zc = z(x,   y);
                zn = z(x,   y-1);
                zs = z(x,   y+1);
                ze = z(x+1, y);
                zw = z(x-1, y);
                
                dx = (ze - zw)/(2*(2*zc - ze - zw));
                dy = (zn - zs)/(2*(zn - 2*zc + zs));

                zest = zc - (ze - zw)^2/(8*(ze - 2*zc + zw)) - (zn - zs)^2/(8*(zn - 2*zc + zs));
                
                aest = min(abs([ze/2 - zc + zw/2, zn/2 - zc + zs/2]));

                
            catch
                % handle situation where neighbourhood falls off the data
                % vector
                warning('Peak at %f too close to edge of image, skipping', x(i));
                continue;
            end
            %
            
            % store x, y for the refined peak
            xyp = [xyp [x+dx; y+dy]];
            zp = [zp zest];
            ap = [ap aest];

        end
    else
        % no interpolation case
        xyp = xy;
        zp = z(k)';
        ap = [];

    end
    
    
    % return values
    if nargout > 1
        xypout = xyp;
    end
    if nargout > 2
        aout = ap;
    end
%            ihist                      - histogram
%
% IHIST(IM, OPTIONS) display the image histogram.  For an image with  multiple
% planes the histogram of each plane is given in a separate subplot.
%
% H = IHIST(IM, OPTIONS) returns the image histogram as a column vector.  For
% an image with multiple planes H is a matrix with one column per image plane.
%
% [H,X] = IHIST(IM, OPTIONS) returns the image histogram and bin coordinates as
% column vectors.  For an image with multiple planes H is a matrix with one
% column per image plane.
%
% Options::
% 'nbins'     number of histogram bins (default 256)
% 'cdf'       compute a cumulative histogram
% 'normcdf'   compute a normalized cumulative histogram
%
% Notes::
% - for an integer image the histogram spans the greylevel range 0-255
% - for a floating point image the histogram spans the greylevel range 0-1
% - for floating point images all NaN and Inf values are removed.
% - for an integer image the MEX function fhist is used
%
% See also HIST.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.

function [h,xbin] = ihist(im, varargin)

    if size(im, 3) > 1
        % color or multiband image

        np = size(im,3);
        if nargout == 0
            for k=1:np
                subplot(np, 1, k);
                ihist(im(:,:,k), varargin{:});
                xlabel(sprintf('Image plane %d', k))
                ylabel('N');
            end
        else
            for k=1:np
                [H(:,k),xx] = ihist(im(:,:,k), varargin{:});
            end
            if nargout == 1
                h = H;
            elseif nargout == 2
                h = H;
                x = xx;
            end
        end
        return
    end

    opt.nbins = 256;
    opt.type = {'hist', 'cdf', 'normcdf', 'sorted'};

    [opt,args] = tb_optparse(opt, varargin);

    if isinteger(im)
        % use quick mex function if data is integer
        [n,x] = fhist(im);
    else
        % remove NaN and Infs from floating point data
        z = im(:);
        k = find(isnan(z));
        z(k) = [];
        if length(k) > 0
            warning('%d NaNs removed', length(k));
        end
        k = find(isinf(z));
        z(k) = [];
        if length(k) > 0
            warning('%d Infs removed', length(k));
        end
        [n,x] = hist(z, opt.nbins);
        n = n'; x = x';
    end

    % handle options
    switch opt.type
    case 'cdf'
        n = cumsum(n);
    case 'normcdf'
        n = cumsum(n);
        n = n ./ n(end);
    case 'sorted'
        n = sort(n, 'descend');
    end

	if nargout == 0
        switch opt.type
        case {'cdf','normcdf'}
            % CDF is plotted as line graph
            plot(x, n, args{:});
            if min(size(im)) > 1
                xlabel('Greylevel')
            end
            ylabel('CDF');
        otherwise
            % histogram is plotted as bar graph
            bar(x, n, args{:});
            xaxis(min(x), max(x));
            if min(size(im)) > 1
                xlabel('Greylevel')
            end
            ylabel('Number of pixels');
        end
	elseif nargout == 1
		h = n;
	elseif nargout == 2
		h = n;
		xbin = x;
	end
%            iprofile                   - Extract pixels along a line in an image
%
% P = IPROFILE(IM, P1, P2) returns a vector of pixel values extracted from the
% image IM between the points P1 and P2. The points are each described by 
% a 2-vector.  P is a matrix, with one row per point, and each point is the
% pixel value which can be a vector for a multi-plane image.
%
% [P,UV] = IPROFILE(IM, P1, P2) as above but also returns the coordinates of
% the pixels.  Each row of UV is the pixel coordinate (u,v) for the 
% corresponding row of P.
%
% See also BRESENHAM, ILINE.

function [p,uv] = iprofile(c, p1, p2)

    points = bresenham(p1, p2);

    p = [];
    for point = points'
        p = [p; c2(point(2), point(1))];
    end

    if nargout > 1
        uv = points';
    end
%
%  Multiview
%
%      Geometric
%        epidist                        - Distance of point from epipolar line
%
% D = EPIDIST(F, P1, P2) is the distance of the points P2 from the epipolar
% lines due to points P1 where F is a fundamental matrix.
%
% P1 is a 2xN matrix representing N points for  which epipolar lines are 
% computed using F.  P2 is 2xM and represents M points being tested for 
% distance from each of the N epipolar lines.  D is a NxM matrix where the 
% element D(i,j) is the distance from the P2(j) to the epipolar line 
% due to P1(i).
%
% Author::
% based on fmatrix code by,
% Nuno Alexandre Cid Martins,
% Coimbra, Oct 27, 1998,
% I.S.R.
%
% See also EPILINE, FMATRIX.


function d = epidist(F, p1, p2)

    l = F*e2h(p1);
    for i=1:numcols(p1),
        for j=1:numcols(p2),
            d(i,j) = abs(l(1,i)*p2(1,j) + l(2,i)*p2(2,j) + l(3,i)) ./ sqrt(l(1,i)^2 + l(2,i)^2);
        end
    end
%        epiline                        - Draw epipolar lines
%
% EPILINE(F, P) draws epipolar lines in current figure based on points P and 
% the fundamental matrix F.  Points are specified by the columns of P.
%
% EPILINE(F, P, LS) as above but draw lines using the line style arguments LS.
%
% H = EPILINE(F, P, LS) as above but return a vector of graphic handles, one
% per line drawn.
% 
% See also FMATRIX, EPIDIST.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.

function handles = epiline(F, p, ls)

    % get plot limits from current graph
    xlim = get(gca, 'XLim');
    xmin = xlim(1);
    xmax = xlim(2);

    if nargin < 3,
        ls = 'r';
    end
    h = [];
    % for all input points
    for i=1:numrows(p),
        l = F*[p(i,:) 1]';
        y = (-l(3) - l(1)*xlim) / l(2);
        hold on
        hh = plot(xlim, y, ls);
        h = [h; hh];
        hold off
    end

    if nargout > 0,
        handles = h;
    end
%        fmatrix                        - estimate the fundamental matrix
%
% F = FMATRIX(P1, P2, OPTIONS) estimates the fundamental matrix given two
% sets of corresponding points P1 and P2, each a 2xN matrix.  F is 3x3.
%
% Notes::
% - The points must be corresponding, no outlier rejection is performed.
% - Contains a RANSAC driver
% - F is a rank 2 matrix, that is, it is singular.
%
% Reference::
% Hartley and Zisserman,
% 'Multiple View Geometry in Computer Vision',
% page 270.
%
% Author::
% Based on fundamental matrix code by
% Peter Kovesi,
% School of Computer Science & Software Engineering,
% The University of Western Australia,
% http://www.csse.uwa.edu.au/,
%
% See also RANSAC, HOMOGRAPHY, FREFINE, EPILINE, EPIDIST.

function [F,resid] = fmatrix(p1, p2)

    % RANSAC integration
    if isstruct(p1)
        F = ransac_driver(p1);
        return;
    end

    if numcols(p1) < 7
        error('must be at least 7 corresponding points');
    end

    % get data from passed arrays into homogeneous p1 and p2
    %
    %  if 6xN assume that data is conditioned
    X = p1;


    if numrows(X) == 6
        p1 = X(1:3,:);
        p2 = X(4:6,:);
        C1 = eye(3,3);
        C2 = eye(3,3);
    else
        % data is not conditioned
        if numrows(X) == 4
            p1 = X(1:2,:);
            p2 = X(3:4,:);
        elseif numrows(p1) == 2,
            if nargin < 2,
                error('must pass uv1 and uv2');
            end
            p1 = X;
            if numcols(p1) ~= numcols(p2),
                error('must have same number of points in each set');
            end
            if numrows(p1) ~= numrows(p2),
                error('p1 and p2 must have same number of rows')
            end
        end
        
        % make data homogeneous
        p1 = e2h(p1);
        p2 = e2h(p2);
        
        % and condition it
        C1 = vgg_conditioner_from_pts(p1);
        C2 = vgg_conditioner_from_pts(p2);
        p1 = vgg_condition_2d(p1, C1);
        p2 = vgg_condition_2d(p2, C2);
    end


    if numcols(p1) == 7,
        % special case of 7 points

        Fvgg = vgg_F_from_7pts_2img(p1, p2);

        if isempty(Fvgg)
            F = [];
        else
        
            % Store the (potentially) 3 solutions in a cell array
            Nsolutions = size(Fvgg, 3);
            for n = 1:Nsolutions
                F{n} = Fvgg(:,:,n);
            end
        end
        resid = 0;
        return;
    else
        % normal case

        x1 = p1(1,:)';
        y1 = p1(2,:)';
        x2 = p2(1,:)';
        y2 = p2(2,:)';

        % linear estimate
        A = [x1.*x2 y1.*x2 x2 x1.*y2 y1.*y2 y2 x1 y1 ones(size(x1))];
        [U,S,V] = svd(A);

        f = V(:,end);
        F = reshape(f, 3, 3)';

        % enforce the rank 2 constraint
        [U,S,V] = svd(F);
        S(3,3) = 0;
        F = U * S * V';

        % check the residuals
        d = fdist(F, p1, p2);
        resid = max(d);
        if nargout < 2,
            fprintf('maximum residual %.4g\n', resid);
        end

        % decondition the result
        F = C2' * F * C1;
    end
end

%----------------------------------------------------------------------------------
%   out = fmatrix(ransac)
%
%   ransac.cmd      string      what operation to perform
%       'size'
%       'condition'
%       'decondition'
%       'valid'
%       'estimate'
%       'error'
%   ransac.debug    logical     display what's going on
%   ransac.X        6xN         data to work on
%   ransac.t        1x1         threshold
%   ransac.theta    3x3         estimated quantity to test
%   ransac.misc     cell        private data for deconditioning
%
%   out.s           1x1         sample size
%   out.X           6xN         conditioned data
%   out.misc        cell        private data for conditioning
%   out.inlier      1xM         list of inliers
%   out.valid       logical     if data is valid for estimation
%   out.theta       3x3         estimated quantity
%----------------------------------------------------------------------------------

function out = ransac_driver(ransac)
    cmd = ransac.cmd;
    if ransac.debug
        fprintf('RANSAC command <%s>\n', cmd);
    end
    switch cmd
    case 'size'
        % return sample size
        % 7 is technically possible but results are not so good...
        out.s = 8;
    case 'condition'
        if numrows(ransac.X) == 4
            p1 = ransac.X(1:2,:);
            p2 = ransac.X(3:4,:);
            p1 = e2h(p1);
            p2 = e2h(p2);
        elseif numrows(ransac.X) == 6
            p1 = ransac.X(1:3,:);
            p2 = ransac.X(3:6,:);
        end

        % condition the point data
        C1 = vgg_conditioner_from_pts(p1);
        C2 = vgg_conditioner_from_pts(p2);
        p1 = vgg_condition_2d(p1, C1);
        p2 = vgg_condition_2d(p2, C2);
        out.X = [p1; p2];
        out.misc = {C1, C2};
    case 'decondition'
        F = ransac.theta;
        misc = ransac.misc;
        C1 = misc{1}; C2 = misc{2};
        out.theta = C2' * F * C1;
    case 'valid'
        out.valid = true;
    case 'error'
            % [bestInliers, bestF] = funddist(F, x, t);
        [out.inliers, out.theta] = funddist(ransac.theta, ransac.X, ransac.t);
    case 'estimate'
        [out.theta, out.resid] = fmatrix(ransac.X);
    otherwise
        error('bad RANSAC command')
    end
end

%--------------------------------------------------------------------------
% Function to evaluate the first order approximation of the geometric error
% (Sampson distance) of the fit of a fundamental matrix with respect to a
% set of matched points as needed by RANSAC.  See: Hartley and Zisserman,
% 'Multiple View Geometry in Computer Vision', page 270.
%
% Note that this code allows for F being a cell array of fundamental matrices of
% which we have to pick the best one. (A 7 point solution can return up to 3
% solutions)
    
% Copyright (c) 2004-2005 Peter Kovesi
% School of Computer Science & Software Engineering
% The University of Western Australia
% http://www.csse.uwa.edu.au/
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in 
% all copies or substantial portions of the Software.
%
% The Software is provided "as is", without warranty of any kind.

% February 2004  Original version
% August   2005  Distance error function changed to match changes in RANSAC

function [bestInliers, bestF] = funddist(F, x, t);
    
    x1 = x(1:3,:);    % Extract x1 and x2 from x
    x2 = x(4:6,:);
    
    
    if iscell(F)  % We have several solutions each of which must be tested
          
        nF = length(F);   % Number of solutions to test
        bestF = F{1};     % Initial allocation of best solution
        ninliers = 0;     % Number of inliers
        
        for k = 1:nF
            d = fdist(F{k}, x1, x2);
            inliers = find(abs(d) < t);     % Indices of inlying points
            
            if length(inliers) > ninliers   % Record best solution
                ninliers = length(inliers);
                bestF = F{k};
                bestInliers = inliers;
            end
        end
        
    else     % We just have one solution
        d = fdist(F, x1, x2);

        bestInliers = find(abs(d) < t);     % Indices of inlying points
        bestF = F;                          % Copy F directly to bestF
    end
end

function d = fdist(F, x1, x2)
    x2tFx1 = zeros(1,length(x1));
    for n = 1:length(x1)
        x2tFx1(n) = x2(:,n)'*F*x1(:,n);
    end

    Fx1 = F*x1;
    Ftx2 = F'*x2;     
    
    % Evaluate distances
    d =  x2tFx1.^2 ./ ...
         (Fx1(1,:).^2 + Fx1(2,:).^2 + Ftx2(1,:).^2 + Ftx2(2,:).^2);
end
%        homography                     - estimate homography between two sets of image points
%
% H = HOMOGRAPHY(P1, P2) estimates the homography  given two
% sets of corresponding points P1 and P2, each a 2xN matrix.  
%
% Notes::
% - The points must be corresponding, no outlier rejection is performed.
% - The points must be projections of points lying on a world plane
% - Contains a RANSAC driver
%
% Author::
% Based on homography code by
% Peter Kovesi,
% School of Computer Science & Software Engineering,
% The University of Western Australia,
% http://www.csse.uwa.edu.au/,
%
% See also RANSAC, INVHOMOG, HOMTEST, FMATRIX.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.

function [H,resid] = homography(X, p2, Ht)

    % RANSAC integration
    if isstruct(X)
        H = ransac_driver(X);
        return;
    end

    if numrows(X) == 6
        p1 = X(1:3,:);
        p2 = X(4:6,:);
    else
        if nargin < 2,
            error('must pass uv1 and uv2');
        end
        p1 = X;
        if numcols(p1) ~= numcols(p2),
            error('must have same number of points in each set');
        end
        if numrows(p1) ~= numrows(p2),
            error('p1 and p2 must have same number of rows')
        end
    end

    % linear estimation step
    H = vgg_H_from_x_lin(p1, p2);

    % non-linear refinement
    if numrows(X) ~= 6 && numcols(p1) >= 8
        % dont do it if invoked with 1 argument (from RANSAC)
        H = vgg_H_from_x_nonlin(H, e2h(p1), e2h(p2));
    end

    if numrows(p1) == 3
        d = h2e(H*p1) - h2e(p2);
    else
        d = homtrans(H,p1) - p2;
    end
    resid = max(colnorm(d));
    if nargout < 2,
        fprintf('maximum residual %.4g\n', resid);
    end
end

%----------------------------------------------------------------------------------
%   out = homography(ransac)
%
%   ransac.cmd      string      what operation to perform
%       'size'
%       'condition'
%       'decondition'
%       'valid'
%       'estimate'
%       'error'
%   ransac.debug    logical     display what's going on
%   ransac.X        6xN         data to work on
%   ransac.t        1x1         threshold
%   ransac.theta    3x3         estimated quantity to test
%   ransac.misc     cell        private data for deconditioning
%
%   out.s           1x1         sample size
%   out.X           6xN         conditioned data
%   out.misc        cell        private data for conditioning
%   out.inlier      1xM         list of inliers
%   out.valid       logical     if data is valid for estimation
%   out.theta       3x3         estimated quantity
%----------------------------------------------------------------------------------

function out = ransac_driver(ransac)
    cmd = ransac.cmd;
    if ransac.debug
        fprintf('RANSAC command <%s>\n', cmd);
    end
    switch cmd
    case 'size'
        % return sample size
        out.s = 4;
    case 'condition'
        p1 = ransac.X(1:2,:);
        p2 = ransac.X(3:4,:);
        p1 = e2h(p1);
        p2 = e2h(p2);
        out.X = [p1; p2];
        out.misc = {};
    case 'decondition'
        out.theta = ransac.theta;
    case 'valid'
        out.valid = ~isdegenerate(ransac.X);
    case 'error'
        [out.inliers, out.theta] = homogdist2d(ransac.theta, ransac.X, ransac.t);
    case 'estimate'
        [out.theta, out.resid] = homography(ransac.X);
    otherwise
        error('bad RANSAC command')
    end
end


% Copyright (c) 2004-2005 Peter Kovesi
% School of Computer Science & Software Engineering
% The University of Western Australia
% http://www.csse.uwa.edu.au/
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in 
% all copies or substantial portions of the Software.
%
% The Software is provided "as is", without warranty of any kind.

% February 2004 - original version
% July     2004 - error in denormalising corrected (thanks to Andrew Stein)
% August   2005 - homogdist2d modified to fit new ransac specification.


%----------------------------------------------------------------------
% Function to evaluate the symmetric transfer error of a homography with
% respect to a set of matched points as needed by RANSAC.

function [inliers, H] = homogdist2d(H, x, t);
    
    x1 = x(1:3,:);   % Extract x1 and x2 from x
    x2 = x(4:6,:);    
    
    % Calculate, in both directions, the transfered points    
    Hx1    = H*x1;
    invHx2 = H\x2;
    
    % Normalise so that the homogeneous scale parameter for all coordinates
    % is 1.
    
    x1     = hnormalise(x1);
    x2     = hnormalise(x2);     
    Hx1    = hnormalise(Hx1);
    invHx2 = hnormalise(invHx2); 
    
    d2 = sum((x1-invHx2).^2)  + sum((x2-Hx1).^2);
    inliers = find(abs(d2) < t);    
 end   
    
%----------------------------------------------------------------------
% Function to determine if a set of 4 pairs of matched  points give rise
% to a degeneracy in the calculation of a homography as needed by RANSAC.
% This involves testing whether any 3 of the 4 points in each set is
% colinear. 
     
function r = isdegenerate(x)

    x1 = x(1:3,:);    % Extract x1 and x2 from x
    x2 = x(4:6,:);    
    
    r = ...
    iscolinear(x1(:,1),x1(:,2),x1(:,3)) | ...
    iscolinear(x1(:,1),x1(:,2),x1(:,4)) | ...
    iscolinear(x1(:,1),x1(:,3),x1(:,4)) | ...
    iscolinear(x1(:,2),x1(:,3),x1(:,4)) | ...
    iscolinear(x2(:,1),x2(:,2),x2(:,3)) | ...
    iscolinear(x2(:,1),x2(:,2),x2(:,4)) | ...
    iscolinear(x2(:,1),x2(:,3),x2(:,4)) | ...
    iscolinear(x2(:,2),x2(:,3),x2(:,4));
 end
%
%  Stereo
%    istereo                            - Stereo matching
%
% D = ISTEREO(IML, IMR, W, RANGE, OPTIONS) returns a disparity image the same 
% size as the input images IML and IMR and the value at each pixel is the 
% horizontal shift of the corresponding pixel in IML as observed in IMR.
%
% IML and IMR are the left- and right-images of a stereo pair, of either
% double or uint8 class.
%
% W is the size of the matching window, which can be a scalar for WxW or a
% 2-vector [WX WY] for a WXxWY window.
%
% RANGE is the disparity search range, which can be a scalar for disparities in
% the range 0 to RANGE, or a 2-vector [DMIN DMAX] for searches in the range
% DMIN to DMAX.
%
% [D,SIM] = ISTEREO(IML, IMR, W, RANGE, OPTIONS) as above but returns SIM 
% which is the same size as D and the elements are the peak matching score 
% for the corresponding elements of D.  For the default matching metric ZNCC
% this varies between -1 (very bad) to +1 (perfect).
%
% [D,SIM,DSI] = ISTEREO(IML, IMR, W, RANGE, OPTIONS) as above but returns DSI 
% which is the disparity space image.  If IML and IMR are NxM and range 
% specifies D % disparity values then DSI is NxMxD where the I'th plane is the
% similarity of IML to IMR shifted by ????
%
% [D,SIM,P] = ISTEREO(IML, IMR, W, RANGE, OPTIONS) if the 'interp' option is 
% given then disparity is estimated to sub-pixel precision using quadratic
% interpolation.  In this case D is the interpolated disparity and P is
% a structure with elements A, B, dx.  The interpolation polynomial is 
% s = Ad^2 + Bd + C where s is the similarity score and d is disparity relative
% to the integer disparity at which s is maximum.  P.A and P.B are matrices the
% same size as D whose elements are the per pixel values of the interpolation
% polynomial coefficients.  P.dx is the peak of the polynomial with respect
% to the integer disparity at which s is maximum (in the range -0.5 to +0.5).
%   
% Options::
% 'metric',M   string that specifies the similarity metric to use which is
%              one of 'zncc' (default), 'ncc', 'ssd' or 'sad'.
% 'interp'     enable subpixel interpolation and D contains non-integer
%              values (default false)
%
% Notes::
% - For both output images the pixels within a half-window dimension of the edges 
%   will not be valid and are set to NaN.
% - SIM = max(DSI, 3)
%
% See also STVIEW.


% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.

function [disp,sim, o3] = istereo(L, R, drange, h, varargin)

% TODO: score cube is float, can return it

    opt.metric = 'zncc';
    opt.interp = false;

    opt = tb_optparse(opt, varargin);

    % ensure images are greyscale
    L = imono(L);
    R = imono(R);

    if length(drange) > 2
        vshift = drange(3);
        if vshift > 0
            L = L(vshift:end,:);
            R = R(1:end-vshift,:);
        else
            vshift = -vshift;
            L = L(1:end-vshift,:);
            R = R(vshift:end,:);
        end
    end
    % compute the score cube, 3rd dimension is disparity
    DSI = stereo_match(L, R, 2*h+1, drange(1:2), opt.metric);

    % best value along disparity dimension is the peak
    %   s best score
    %   d disparity at which it occurs
    %
    % both s and d are matrices same size as L and R.
    if strcmp(opt.metric, 'sad') | strcmp(opt.metric, 'ssd')
        [s,d] = min(DSI, [], 3);
    else
        [s,d] = max(DSI, [], 3);
    end

    d(isnan(s)) = NaN;


    if opt.interp
        % interpolated result required

        % get number of pixels and disparity range
        npix = prod(size(L));

        if length(drange) == 1,
            ndisp = drange + 1;
        else
            dmin = min(drange);
            dmax = max(drange);
            ndisp = dmax - dmin + 1;
        end

        % find all disparities that are not at either end of the range, we need
        % a point on either side to interpolate them
        valid = (d>1) & (d<ndisp);
        valid = valid(:);

        % make a vector of consecutive pixel indices (1 to width*height)
        ci = [1:npix]';
        % turn disparities into a column vector
        dcol = d(:);

        % remove all entries that are not valid
        ci(~valid) = [];
        dcol(~valid) = [];

        % both ci and dcol have the same number of entries

        % for every valid pixel and disparity, find the index into the 3D score
        % array.  We cheat and consider that array WxHxD as a 2D array (WxH)xD
        %
        % We compute the indices for the best score and one each side of it
        k_m = sub2ind([npix ndisp], ci, dcol-1);
        k_0 = sub2ind([npix ndisp], ci, dcol);
        k_p = sub2ind([npix ndisp], ci, dcol+1);

        % initialize matrices (size of L and R) to hold the the best score
        % and the one each side of it
        y_m = ones(size(L))*NaN;
        y_0 = ones(size(L))*NaN;
        y_p = ones(size(L))*NaN;

        % now copy over the valid scores into these arrays.  What doesnt
        % get copies is a NaN
        y_m(ci) = DSI(k_m);
        y_0(ci) = DSI(k_0);
        y_p(ci) = DSI(k_p);

        % figure the coefficients of the peak fitting parabola:
        %    y = Ax^2 + Bx + C
        % Each coefficient is a matrix same size as (L and R)
        % We don't need to compute C
        A = 0.5*y_m - y_0 + 0.5*y_p;
        B = -0.5*y_m + 0.5*y_p;

        % now the position of the peak is given by -B/2A
        dx = -B ./ (2*A);

        % and we add this fractional part to the integer value obtained
        % from the max/min function
        d = d + dx;

   end
   d = d + drange(1)-1;

    if nargout > 0,
        disp = d;
    end
    if nargout > 1,
        sim = s;
    end

    if nargout > 2
        if opt.interp
            o3.A = A;
            o3.B = B;
            o3.dx = dx;
        else
            o3 = DSI;
        end
    end
%    anaglyph                           - Convert stereo images to an anaglyph image
%
% A = ANAGLYPH(LEFT, RIGHT) is anaglyph image where the two images of
% stereo pair are coded are combined in a single image using two different
% colors.  By default the left image is red, and the right image is cyan.
%
% A = ANAGLYPH(LEFT, RIGHT, COLOR) as above but the string COLOR describes
% the color coding as a string with 2 letters, the first for left, the second 
%  for right, and each is one of:
%    r   red
%    g   green
%    b   green
%    c   cyan
%    m   magenta
%   ag = anaglyph(left, right, colors, disp)
%   ag = anaglyph(stereopair, colors, disp)
%
% A = ANAGLYPH(LEFT, RIGHT, COLOR, DISP) as above but allows for disparity 
% correction.  If DISP is positive the disparity is increased, if negative it
% is reduced.  This is achieved by trimming the images.  Use this option to 
% make the images more natural/comfortable to view, useful if the images were 
% achieved with a non-human stereo baseline or field of view.
%
% See also STVIEW.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.

function anaglyph = anaglyph(left, right, colors, disp)

    if nargin < 3,
        colors = 'rc';
    end
    if nargin < 4,
        disp = 0;
    end

    % ensure the images are greyscale
    left = imono(left);
    right = imono(right);

    [height,width] = size(left);
    if disp > 0,
        left = left(:,1:width-disp);
        right = right(:,disp+1:end);
    end
    if disp < 0,
        disp = -disp;
        left = left(:,disp+1:end);
        right = right(:,1:width-disp);
    end

    ag = zeros([size(left) 3]);

    ag = ag_insert(ag, left, colors(1));
    ag = ag_insert(ag, right, colors(2));

    if nargout > 0,
        aglyph = ag;
    else
        if isa(left, 'uint8'),
            ag = ag / 255;
        end
        image(ag);
    end

function out = ag_insert(in, im, c)

    out = in;
    % map single letter color codes to image planes
    switch c,
    case 'r'
        out(:,:,1) = im;        % red
    case 'g'
        out(:,:,2) = im;        % green
    case 'b'
        % blue
        out(:,:,3) = im;
    case 'c'
        out(:,:,2) = im;        % cyan
        out(:,:,3) = im;
    case 'm'
        out(:,:,1) = im;        % magenta
        out(:,:,3) = im;
    case 'o'
        out(:,:,1) = im;        % orange
        out(:,:,2) = im;
    end
%    stdisp                             - Display stereo pair
%
% STDISP(L, R) displays the stereo image pair L and R in adjacent windows.
%
% Two cross-hairs are created.  Clicking a point in the left image positions
% black cross hair at the same pixel coordinate in the right image.  Clicking
% the corresponding world point in the right image sets the green crosshair
% and displays the disparity.
%
% See also ISTEREO.

function stdisp(L, R)

    % display the images side by side
    idisp([L R], 'nogui');
    
    % initial cross hair location
    Y = 100;
    X = 100;

    % create the 3 lines segments and stash in user data on the axis
    ud.w = size(L,2);   % width of left image
    ud.hline = line('XData',get(gca,'XLim'),'YData',[Y Y], ...
                 'Tag','Horizontal Cursor');
    ud.vline_l = line('XData',[X X],'YData',get(gca,'YLim'), ...
                 'Tag','Vertical Cursor');
    ud.vline_r = line('XData',[X+ud.w X+ud.w],'YData',get(gca,'YLim'), ...
                 'Tag','Vertical Cursor');
    ud.vline_r2 = line('XData',[X+ud.w X+ud.w],'YData',get(gca,'YLim'), ...
                 'Tag','Vertical Cursor', 'color', 'g');
    ud.panel = uicontrol(gcf, ...
            'style', 'text', ...
            'units',  'norm', ...
            'pos', [.5 .935 .48 .05], ...
            'background', [1 1 1], ...
            'HorizontalAlignment', 'left', ...
            'string', ' Machine Vision Toolbox for Matlab  ' ...
        );
   set(gca, 'UserData', ud);

    % Set the WindowButtonFcn of the figure
    set(gcf,'WindowButtonDownFcn', @buttonDown,...
            'WindowButtonUpFcn',@buttonUp);	
                
end
        
function moveCursor(src, event)
    ud = get(gca, 'UserData');
    cp = get(gca,'CurrentPoint');
    % cp = [xfront yfront xfront; xback yback zback]

    if cp(1,1) < ud.w
        set(ud.hline, 'YData', [cp(1,2) cp(1,2)]);
        set(ud.vline_l, 'XData', [cp(1,1) cp(1,1)]);
        set(ud.vline_r, 'XData', ud.w+[cp(1,1) cp(1,1)]);
    else
        set(ud.vline_r2, 'XData', [cp(1,1) cp(1,1)]);
        xl = get(ud.vline_l, 'XData');
        %fprintf('d = %f\n', cp(1,1) - xl(1) - ud.w);
        set(ud.panel, 'string', sprintf('d = %f\n',  xl(1) + ud.w - cp(1,1)));
    end
end

function buttonDown(src, event)
    set(gcf, 'WindowButtonMotionFcn',@moveCursor);
    moveCursor(src, event);
    %disp('down');
end

function buttonUp(src, event)
    %disp('up');
    set(gcf, 'WindowButtonMotionFcn','');
end
%    irectify                           - Rectify stereo image pair
%
% [OUT1,OUT2] = IRECTIFY(F, M, IM1, IM2) returns a rectified pair of images
% corresponding to IM1 and IM2.  F is the fundamental matrix relating the two
% views and M is a Match object containing point correspondences between the
% images.
%
% [OUT1,OUT2,H1,H2] = IRECTIFY(F, M, IM1, IM2) as above but also returns
% the homographies H1 and H2 that map IM1 to OUT1 and IM2 to OUT2 respectively.
%
% See also ISTEREO, CentralCamera.

function [Img1_new, Img2_new, H12,H21] = irectify(F, m, Img1, Img2)
% http://se.cs.ait.ac.th/cvwiki/matlab:tutorial:rectification

F12 = F';

[rows,cols,depth] = size(Img1);

% Get homographies.

x1 = e2h( m.p1 );
x2 = e2h( m.p2 );

[H12,H21,bSwap] = rectify_homographies( F12, x1, x2, rows, cols );

[w1,off1] = homwarp(H12, Img1, 'full');
[w2,off2] = homwarp(H21, Img2, 'full');

% fix the vertical alignment of the images by padding
dy = off1(2) - off2(2);
if dy < 0
    w1 = ipad(w1, 'b', -dy);
    w2 = ipad(w2, 't', -dy);
else
    w1 = ipad(w1, 't', dy);
    w2 = ipad(w2, 'b', dy);
end

[w1,w2] = itrim(w1, w2);

if nargout == 0
    stview(w1, w2)
else
    Img1_new = w1;
    Img2_new = w2;
end



%-----------------------------------------------------------------------------

function [H1,H2,bSwap] = rectify_homographies( F, x1, x2, rows, cols )

  % F: a fundamental matrix

  % x1 and x2: corresponding points such that x1_i' * F * x2_i = 0

  % Initialize

  H1 = [];
  H2 = [];
  bSwap = 0;

  % Center of image

  cy = round( rows/2 );
  cx = round( cols/2 );

  % Fix F to be rank 2 to numerical accuracy

  [U,D,V] = svd( F );
  D(3,3) = 0;
  F = U*D*V';

  % Get epipole.  e12 is the epipole in image 1 for camera 2.

  e12 = null( F' );             % Epipole in image 1 for camera 2
  e21 = null( F );              % Epipole in image 2 for camera 1

  % Put epipoles in front of camera

  if e12 < 0, e12 = -e12; end;
  if e21 < 0, e21 = -e21; end;

  % Make sure the epipoles are inside the images

  check_epipoles_in_image( e12, e21, rows, cols );

  % Check that image 1 is to the left of image 2

%   if e12(1)/e12(3) < cx
%     fprintf( 1, 'Swapping left and right images...\n' );
%     tmp = e12;
%     e12 = e21;
%     e21 = tmp;
%     F = F';
%     bSwap = 1;
%   end;

  % Now we have
  % F' * e12 = 0, 
  % F  * e21 = 0,

  % Let's get the rectifying homography Hprime for image 1 first

  Hprime = map_to_infinity( e12, cx, cy );
  e12_new = Hprime * e12;
  % Normalize Hprime so that Hprime*eprime = (1,0,0)'
  Hprime = Hprime / e12_new(1);
  e12_new = Hprime * e12;
  fprintf( 1, 'Epipole 1/2 mapped to infinity: (%g, %g, %g)\n', e12_new );

  % Get canonical camera matrices for F12 and compute H0, one possible
  % rectification homography for image 2

  [P,Pprime] = get_canonical_cameras( F );
  M = Pprime(:,1:3);
  H0 = Hprime * M;

  % Test that F12 is a valid F for P,Pprime

  test_p_f( P, Pprime, F );

  % Now we need to find H so that the epipolar lines match
  % each other, i.e., inv(H)' * l = inv(Hprime)' * lprime
  % and the disparity is minimized, i.e.,
  % min \sum_i d(H x_i, Hprime xprime_i)^2

  % Transform data initially according to Hprime (img 1) and H0 (img 2)

  x1hat = Hprime * x1;
  x1hat = x1hat ./ repmat( x1hat(3,:), 3, 1 );
  x2hat = H0 * x2;
  x2hat = x2hat ./ repmat( x2hat(3,:), 3, 1 );
  rmse_x = sqrt( mean( (x1hat(1,:) - x2hat(1,:) ).^2 ));
  rmse_y = sqrt( mean( (x1hat(2,:) - x2hat(2,:) ).^2 ));
  fprintf( 1, 'Before Ha, RMSE for corresponding points in Y: %g X: %g\n', ...
           rmse_y, rmse_x );

  % Estimate [ a b c ; 0 1 0 ; 0 0 1 ] aligning H, Hprime

  n = size(x1,2);
  A = [ x2hat(1,:)', x2hat(2,:)', ones(n,1) ];
  b = x1hat(1,:)';
  abc = A\b;
  HA = [ abc' ; 0 1 0 ; 0 0 1 ];
  H = HA*H0;
  x2hat = H * x2;
  x2hat = x2hat ./ repmat( x2hat(3,:), 3, 1 );
  rmse_x = sqrt( mean(( x1hat(1,:) - x2hat(1,:) ).^2 ));
  rmse_y = sqrt( mean(( x1hat(2,:) - x2hat(2,:) ).^2 ));
  fprintf( 1, 'After Ha, RMSE for corresponding points in Y: %g X: %g\n', ...
           rmse_y, rmse_x );

  % Return the homographies as appropriate

  if bSwap
    H1 = H;
    H2 = Hprime;
  else
    H1 = Hprime;
    H2 = H;
  end;

%-----------------------------------------------------------------------------

function check_epipoles_in_image( e1, e2, rows, cols )

  % Check whether given epipoles are in the image or not

  if abs( e1(3) ) < 1e-6 & abs( e2(3) ) < 1e-6, return; end;

  e1 = e1 / e1(3);
  e2 = e2 / e2(3);
  if ( e1(1) <= cols & e1(1) >= 1 & e1(2) <= rows & e1(2) >= 1 ) | ...
     ( e2(1) <= cols & e2(1) >= 1 & e2(2) <= rows & e2(2) >= 1 )
    err_msg = sprintf( 'epipole (%g,%g) or (%g,%g) is inside image', ...
                       e1(1:2), e2(1:2) );
    error( [ err_msg, ' -- homography does not work in this case!' ] );
  end;

%-----------------------------------------------------------------------------

function [P,Pprime] = get_canonical_cameras( F )

  % Get the "canonical" cameras for given fundamental matrix
  % according to Hartley and Zisserman (2004), p256, Result 9.14

  % But ensure that the left 3x3 submatrix of Pprime is nonsingular
  % using Result 9.15, that the general form is
  % [ skewsym( e12 ) * F + e12 * v', k * e12 ] where v is an arbitrary
  % 3-vector and k is an arbitrary scalar

  P = [ 1 0 0 0
        0 1 0 0
        0 0 1 0 ];

  e12 = null( F' );
  M = skew( e12 ) * F + e12 * [1 1 1];
  Pprime = [ M, e12 ];

%-----------------------------------------------------------------------------

function test_p_f( P, Pprime, F )

  % Test that camera matrices Pprime and P are consistent with
  % fundamental matrix F
  % Meaning  (Pprime*X)' * F * (P*X) = 0,  for all X in 3space

  % Get the epipole in camera 1 for camera 2

  C2 = null( P );
  eprime = Pprime * C2;

  % Construct F from Pprime, P, and eprime

  Fhat = skew( eprime ) * Pprime * pinv( P );

  % Check that it's close to F

  alpha = Fhat(:)\F(:);
  if norm( alpha*Fhat-F ) > 1e-10
    fprintf( 1, 'Warning: supplied camera matrices are inconsistent with F\n' );
  else
    fprintf( 1, 'Supplied camera matrices OK\n' );
  end;

%-----------------------------------------------------------------------------

function H = map_to_infinity( x, cx, cy )

  % Given a point and the desired origin (point of minimum projective
  % distortion), compute a homograph H = G*R*T taking the point to the
  % origin, rotating it to align with the X axis, then mapping it to
  % infinity.

  % First map cx,cy to the origin

  T = [ 1 0 -cx
        0 1 -cy
        0 0 1 ];
  x = T * x;

  % Now rotate the translated x to align with the X axis.

  cur_angle = atan2( x(2), x(1) );
  R = [ cos( -cur_angle ), -sin( -cur_angle ), 0
        sin( -cur_angle ),  cos( -cur_angle ), 0
                        0,                  0, 1 ];
  x = R * x;

  % Now the transformation G mapping x to infinity

  if abs( x(3)/norm(x) ) < 1e-6
      % It's already at infinity
      G = eye(3)
  else
      f = x(1)/x(3);
      G = [    1   0  0
               0   1  0
             -1/f  0  1 ];
  end;

  H = G*R*T;
%
%  Image sequence
%    BagOfWords                         - bag.occurrences(word)          number of occurreneces of word in bag
% [w,f] = bag.occurrences(word)  return vectors of word
classdef BagOfWords < handle
    properties
        K       % number of clusters
        nstop   % number of stop words

        C

        words
        stopwords
        map

        nimages       % number of images

        features
        wv          % cached word vectors
    end

    methods
        % bag = BagOfWords(features, K)
        % bag = BagOfWords(features, existingBag)
        function bag = BagOfWords(sf, a1)

            % save the feature vector
            if iscell(sf)
                bag.features = [sf{:}];
            else
                bag.features = sf;
            end
            bag.nimages = max([bag.features.image_id]);

            if isnumeric(a1)
                K = a1;
                % do the clustering
                [bag.C,L] = vl_kmeans([bag.features.descriptor], K, ...
                    'verbose', 'algorithm', 'elkan');

                bag.K = K;
                bag.words = double(L);

            elseif isa(a1, 'BagOfWords')
                oldbag = a1;

                bag.K = oldbag.K;
                bag.stopwords = oldbag.stopwords;

                % cluster using number of words from old bag
                bag.words = closest([bag.features.descriptor], oldbag.C);

                k = find(ismember(bag.words, oldbag.stopwords));

                fprintf('Removing %d features associated with stop words\n', length(k));

                bag.words(k) = [];
                bag.words = oldbag.map(bag.words);
                bag.features(k) = [];

                bag.compute_wv(oldbag);

            end
        end

        % return all features assigned to specified word(s)
        function f = isword(bag, words)
            k = ismember(bag.words, words);
            f = bag.features(k);
        end

        % number of occurrences of specified word across all features
        function n = occurrence(bag, word)
            n = sum(bag.words == word);
        end

        function [all2, S] = remove_stop(bag, nstop)
            % find the stop words and remove them
            % these are the nstop most frequent words

            [w,f] = count_unique(bag.words);
            [f,i] = sort(f, 'descend');
            bag.stopwords = w(i(1:nstop));

            % remove all features that are stop words from L and all
            k = find(ismember(bag.words, bag.stopwords));

            fprintf('Removing %d features associated with %d most frequent words\n', ...
                length(k), nstop);

            % fix the labels
            b = zeros(1,length(bag.words));
            b(bag.stopwords) = 1;
            bag.map = [1:length(bag.words)] - cumsum(b);

            bag.words(k) = [];
            bag.words = bag.map(bag.words);
            bag.features(k) = [];

        end

        function wv = wordvector(bag, k)
            if isempty(bag.wv)
                bag.compute_wv();
            end
            if nargin > 1
                wv = bag.wv(:,k);
            else
                wv = bag.wv;
            end
        end

        % image-word frequency
        function W = iwf(bag)
            N = bag.nimages;  % number of images
            % Create the word matrix W
            %  each column is an image
            %  each row is a word
            %  each element is the number of occurences of that word in that iamge
            W = [];
            id = [bag.features.image_id];

            nl = bag.K - length(bag.stopwords);

            for i=1:bag.nimages
                % get the words associated with image i
                words = bag.words(id == i);

                % create columns of the W
                [w,f] = count_unique(words);
                v = zeros(nl,1);
                v(w) = f;
                W = [W v];
            end
        end

        function W = compute_wv(bag, bag2)

            if nargin == 2
                Wv = bag2.iwf();
                N = bag2.nimages;
                W = bag.iwf();
            else
                Wv = bag.iwf();
                N = bag.nimages;
                W = Wv;
            end

            Ni = sum( Wv'>0 );

            m = [];
            for i=1:bag.nimages
                % number of words in this image
                nd = sum( W(:,i) );

                % word occurrence frequency
                nid = W(:,i)';

                v = nid/nd .* log(N./Ni);
                m = [m v'];
            end

            if nargout == 1
                W = m;
            else
                bag.wv = m;
            end
        end

        function [w,f] = wordfreq(bag)
            [w,f] = count_unique(bag.words);
        end

        % compute similarity matrix
        function sim = similarity(bag1, bag2)
            wv1 = bag1.wordvector;
            wv2 = bag2.wordvector;
            whos
            for i=1:bag1.nimages
                for j=1:bag2.nimages
                    v1 = wv1(:,i); v2 = wv2(:,j);
                    sim(i,j) = dot(v1,v2) / (norm(v1) * norm(v2));
                end
            end
        end

        function display(bag)
            loose = strcmp( get(0, 'FormatSpacing'), 'loose');
            if loose
                disp(' ');
            end
            disp([inputname(1), ' = '])
            if loose
                disp(' ');
            end
            disp(char(bag))
            if loose
                disp(' ');
            end
        end

        function s = char(bag)
            s = sprintf(...
            'BagOfWords: %d features from %d images\n           %d words, %d stop words\n', ...
                length(bag.features), bag.nimages, ...
                bag.K-length(bag.stopwords), length(bag.stopwords));
        end


        function v = contains(bag, word)
            v = unique([bag.isword(word).image_id]);
        end
            
        function exemplars(bag, words, images, varargin)

            nwords = length(words);
            gap = 2;

            opt.ncolumns = 10;
            opt.maxperimage = 2;
            opt.width = 50;

            opt = tb_optparse(opt, varargin);

            % figure the number of exemplars to show, no more than opt.maxperimage
            % from any one image
            nexemplars = 0;
            for w=words
                h = hist(bag.contains(w));
                h = min(h, opt.maxperimage);
                nexemplars = nexemplars + sum(h);
            end
            opt.ncolumns = min(nexemplars, opt.ncolumns);

            Ng = opt.width+gap;
            panel = zeros(nwords*Ng, opt.ncolumns*Ng);
            L = bag.words;

            for i=1:nwords
                % for each word specified
                word = words(i);

                features = bag.isword(word);  % find features corresponding to the word

                image_prev = [];
                count = 1;
                for j=1:length(features)
                    % for each instance of that word
                    sf = features(j);

                    % only display one template from each image to show some
                    % variety
                    if sf.image_id == image_prev
                        c = c - 1;
                        if c <= 0
                            continue;
                        end
                    else
                        c = opt.maxperimage;
                    end
                    % extract it from the containing image
                    out = sf.support(images, opt.width);

                    % paste it into the panel
                    panel = ipaste(panel, out, [count-1 i-1]*Ng, 'zero');
                    image_prev = sf.image_id;
                    count = count + 1;
                    if count > opt.ncolumns
                        break;
                    end
                end
            end

            idisp(panel, 'plain');


            for i=1:nwords
                % for each word specified
                word = words(i);
                features = bag.isword(word);  % find features corresponding to the word

                image_prev = [];
                count = 1;
                for j=1:length(features)
                    % for each instance of that word
                    sf = features(j);
                    if sf.image_id == image_prev
                        c = c - 1;
                        if c <= 0
                            continue;
                        end
                    else
                        c = opt.maxperimage;
                    end
                    % extract it from the containing image
                    text((count-1)*Ng+gap*2, (i-1)*Ng+3*gap, ...
                        sprintf('%d/%d', word, sf.image_id), 'Color', 'g')
                    image_prev = sf.image_id;
                    count = count + 1;
                    if count > opt.ncolumns
                        break;
                    end
                end
            end
        end
    end
end
%    ianimate                           - Display an image sequence
%
% IANIMATE(IM, OPTIONS) displays a greyscale image sequence IM which is MxNxS
% where S is the number of frames in the sequence.
%
% IANIMATE(IM, FEATURES, OPTIONS) displays a greyscale image sequence IM with
% point features overlaid.  FEATURES is an Sx1 cell array whose elements are
% a vector of feature objects.  The feature is plotted using the object's plot
% method and additional options are passed through to that method.
%
% Examples::
%
%     ianimate(seq)                   % animate image sequence
%     c = icorner(im, 'nfeat', 200);  % computer corners
%     ianimate(seq, features, 'gs');  % features shown as green squares
%
% Options::
%  'fps',F       set the frame rate (default 5 frames/sec)
%  'loop'        endlessly loop over the sequence
%  'movie',M     save the animation as a series of PNG frames in the folder M
%  'npoints',N   plot no more than N features per frame (default 100)
%  'only',I      display only the I'th frame from the sequence
%
% See also PointFeature, IHARRIS, ISURF, IDISP.

% TODO should work with color image sequence, dims are: row col plane seq

function ianimate(im, varargin)

    points = [];
    opt.fps = 5;
    opt.loop = false;
    opt.npoints = 100;
    opt.only = [];
    opt.movie = [];

    [opt, arglist]  = tb_optparse(opt, varargin);

    if length(arglist) >= 1 && iscell(arglist(1))
        points = arglist{1};
        arglist = arglist(2:end);
    end
    
    clf
    pause on
    colormap(gray(256));
    
    if ~isempty(opt.movie)
        mkdir(opt.movie);
        framenum = 1;
    end

    while true
        for i=1:size(im,3)
            if opt.only ~= i
                continue;
            end
            image(im(:,:,i), 'CDataMapping', 'Scaled');
            if ~isempty(points)
                f = points{i};
                n = min(opt.npoints, length(f));
                f(1:n).plot(arglist{:});
            end
            title( sprintf('frame %d', i) );

            if opt.only == i
                return;
            end
            if isempty(opt.movie)
                            pause(1/opt.fps);
            else
                f = getframe;
                imwrite(f.cdata, sprintf('%s/%04d.png', opt.movie, framenum));
                framenum = framenum+1;
            
            end
        end

        if ~opt.loop
            break;
        end
   end
%    Tracker                            - TODO 
%   more wrapper funcs for track structs
%   fix idisp delete/recreate thing
%   add a step and run methods?
classdef Tracker
    properties
        history
        track
        id      % unique id
        N
        thresh
        dims
    end

    methods
        function t = Tracker(im, c, varargin)

            opt.radius = 20;
            opt.nslots = 800;
            opt.thresh = 0.8;
            opt.movie = [];

            opt = tb_optparse(opt, varargin);

            t.id = 1;
            t.history = [];
            t.N = opt.nslots;
            t.thresh = opt.thresh;
            t.dims = size(im);
            
            if ~isempty(opt.movie)
                mkdir(opt.movie);
                framenum = 1;
            end
            
            for slot=1:t.N
                t.track(slot).busy = false;
                t.track(slot).uv = [];
                t.track(slot).uv_h = [];
                t.track(slot).seen = 0;
                t.track(slot).lastseen = 0;
                t.track(slot).feature = [];
                t.track(slot).id = 0;
                t.track(slot).curmatch = 0;
                t.track(slot).similarity = 0;
            end
            
            for slot=1:length(c{1})
                t.track(slot).busy = true;
                t.track(slot).uv = c{1}(slot).uv;
                t.track(slot).uv_h = [];
                t.track(slot).seen = 1;
                t.track(slot).lastseen = 1;
                t.track(slot).feature = c{1}(slot);
                t.track(slot).id = t.id;
                t.id = t.id + 1;
                t.track(slot).curmatch = slot;
                t.track(slot).similarity = 0;
            end

            for frame=2:length(c)
                corners = c{frame};
                
                retired = 0;

                for slot=1:t.N
                    % for all active elements in track, look for a match in the
                    % current image
                    if ~t.track(slot).busy
                        continue;
                    end

                    % compute distance from this feature to all new ones
                    if length(corners) == 0
                        continue;  % no features left to assign
                    end
                    d = distance(t.track(slot).uv, [corners.uv]);

                    % choose those that are close
                    near = find(d < opt.radius);
                    
                    
                    if length(near) > 0
                        % if there are some close by points, check their similarity
                        sim = t.track(slot).feature.ncc( corners(near) );
                        [z,best] = max(sim);
                    
                        if  z > t.thresh
                            % if the match is good, update the track
                            t.track(slot).curmatch = near(best);
                            t.track(slot).similarity = z;
                            t.track(slot).uv_h = [t.track(slot).uv_h t.track(slot).uv];
                            t.track(slot).uv = corners(near(best)).uv;
                            t.track(slot).seen = t.track(slot).seen + 1;
                            t.track(slot).lastseen = frame;
                            t.track(slot).feature = corners(near(best));  % update the feature
                            
                            corners(near(best)) = [];        % remove this corner from consideration
                        end

                    end
                    
                    if (frame - t.track(slot).lastseen) > 5
                        %fprintf('id %d lost at age %d\n', track(slot).id, track(slot).seen);
                        t.track(slot).busy = false;
                        retired = retired + 1;

                        if t.track(slot).seen > 5
                            % retire the track
                            h =[];
                            h.id = t.track(slot).id;
                            h.uv = [t.track(slot).uv_h t.track(slot).uv];
                            t.history = [t.history h];
                        end
                    end
                end
                
                fprintf('%d continuing tracks, %d new tracks, %d retired\n', ...
                    sum([t.track.busy]), length(corners), retired);
                
                for i=1:length(corners)
                    slot = find([t.track.busy]==false);
                    if length(slot) == 0
                        warning('no free slots');
                        continue;
                    end
                    slot = slot(1);
                    
                    t.track(slot).busy = true;
                    t.track(slot).uv = corners(i).uv;
                    t.track(slot).uv_h = [];
                    t.track(slot).seen = 1;
                    t.track(slot).feature = corners(i);
                    t.track(slot).id = t.id;
                    t.id = t.id + 1;
                    t.track(slot).curmatch = i;
                    t.track(slot).similarity = 0;
                    % for all remaining corners, start new track
                end
                
                k = [t.track.busy] == true & [t.track.seen] > 2 & (frame-[t.track.lastseen]) == 0;
                idisp(im(:,:,frame), 'nogui');
                plot_point( [t.track(k).uv], 'ws', 'printf', {'%d', [t.track(k).id]});
                title( sprintf('frame %d', frame) );
                drawnow
                
                if ~isempty(opt.movie)
                    f = getframe;
                    imwrite(f.cdata, sprintf('%s/%04d.png', opt.movie, framenum));
                    framenum = framenum+1;
                    
                end
                %pause
            end

            % add curent tracks to the history
            for slot=1:t.N
                if t.track(slot).busy && t.track(slot).seen > 5
                    % retire the track
                    h =[];
                    h.id = t.track(slot).id;
                    h.uv = [t.track(slot).uv_h t.track(slot).uv];
                    t.history = [t.history h];
                end
            end


        end %constructor

        function l = tracklengths(t)
            l = [];
            for h=t.history
                l = [l numcols(h.uv)];
            end
        end

        function plot(t)
            clf
            hold on
            for h=t.history
                % for each track
                plot(h.uv(1,:)', h.uv(2,:)');
            end
            axis([0 t.dims(2) 0 t.dims(1)]);
            set(gca, 'Ydir', 'reverse');
            hold off
        end

    end %methods
end %class
%
%  Shape changing
%    homwarp                            - Warp image according to homography
%
% OUT = HOMWARP(H, IM, OPTIONS) warps the image by applying the homography H 
% to the coordinates of pixels in the input image IM.
%
% [OUT,OFFS] = HOMWARP(H, IM, OPTIONS) as above but OFFS is the offset of the
% warped tile OUT with respect to the origin of IM.
%
% Options::
% 'full'          output image contains the full input image
% 'extrapval',V   set not mapped pixels to this value
% 'box',R         output image contains the specified ROI in the input image
% 'scale',S       scale the output by this factor
% 'dimension',D   ensure output image is DxD
% 'size',S        size of output image S=[H,W]
%
% See also HOMOGRAPHY, INTERP2.

function [w,foffs] = homwarp(H, im, varargin)

    opt.full = false;
    opt.extrapval = NaN;
    opt.size = [];
    opt.box = [];
    opt.scale = 1;
    opt.dimension = [];

    opt = tb_optparse(opt, varargin);

    if isempty(opt.box) && ~opt.full
        error('must specify box or full size');
    end

    [w,h] = isize(im);

    if opt.full
        % bounding box in the input image is the full extent
        box = [1 w w 1; 1 1 h h];
    else
        % opt.box is specified in standard ROI format
        l = opt.box(1,1); t = opt.box(2,1);
        r = opt.box(1,2); b = opt.box(2,2);
        box = [l r r l; t t b b];
    end

    % map the box vertices in input image to vertices in output image
    Hbox = homtrans(H, box);

    % determine the extent
    xmin = min(Hbox(1,:)); xmax = max(Hbox(1,:));
    ymin = min(Hbox(2,:)); ymax = max(Hbox(2,:));

    % we want the pixel coordinates to map to positive values, determine the minimum
    offs = floor([xmin, ymin]);

    % and prepend a translational homography that translates the output image
    H = [1 0 -offs(1); 0 1 -offs(2); 0 0 1] * H;
    sz = round([xmax-xmin+1, ymax-ymin+1]);

    if ~isempty(opt.dimension)
        s = opt.dimension / max(sz);
        H = diag([s s 1]) * H;

        Hbox = homtrans(H, box);

        % determine the extent
        xmin = min(Hbox(1,:)); xmax = max(Hbox(1,:));
        ymin = min(Hbox(2,:)); ymax = max(Hbox(2,:));

        % we want the pixel coordinates to map to positive values, determine the minimum
        offs = floor([xmin, ymin]);

        % and prepend a translational homography that translates the output image
        H = [1 0 -offs(1); 0 1 -offs(2); 0 0 1] * H;
        sz = round([xmax-xmin+1, ymax-ymin+1]);
    end
    
    [Ui,Vi] = imeshgrid(im);

    % determine size of the output image
    if isempty(opt.size)
        [Uo,Vo] = imeshgrid(sz);
    else
        [Uo,Vo] = imeshgrid(opt.size);
    end
            
    UV = homtrans(inv(H), [Uo(:) Vo(:)]');
    U = reshape(UV(1,:), size(Uo));
    V = reshape(UV(2,:), size(Vo));

    % warp each color plane
    for p=1:size(im,3)
        imh(:,:,p) = interp2(Ui, Vi, idouble(im(:,:,p)), U, V, 'linear', opt.extrapval);
    end

    if nargout > 0
        w = imh;
    else
        idisp(imh);
    end

    if nargout > 1 && opt.full
        foffs = offs;
    end
%    idecimate                          - an image
%
% S = IDECIMATE(IM, M) returns a decimated image where the image size is
% reduced by M (an integer) in both dimensions.  The image is smoothed
% with a Gaussian kernel with standard deviation M/2 then subsampled.
%
% S = IDECIMATE(IM, M, SD) as above but the standard deviation of the
% smoothing kernel is set to SD.
%
% S = IDECIMATE(IM, M, []) as above but no smoothing is applied prior
% to decimation.
%
% Notes::
% - if the image has multiple planes, each plane is decimated.
% - smoothing is used to eliminate aliasing artificats and the standard deviation
%   should be chosen as a function of the maximum spatial frequency in the image.
%
% See also ISCALE, ISMOOTH.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.

function s = shrink(im, m, sigma)

    if nargin < 2
        m = 2;
    end

    if (m - ceil(m)) ~= 0
        error('decimation factor must be integer');
    end

    if nargin < 3
        sigma = m / 2;
    end

    % smooth the image
    if ~isempty(sigma)
        im = ismooth(im, sigma);
    end

    % then decimate
	s = im(1:m:end,1:m:end,:);
%    ipad                               - Pad an image with constants
%
% OUT = IPAD(IM, SIDES, N) pads an image with a block of NaN value pixels of
% with N on the sides specified by SIDES which is a string containing one or 
% more of the characters:
% 't'   top
% 'b'   bottom
% 'l'   left
% 'r'   right
%
% OUT = IPAD(IM, SIDES, N, V) as above but pads with pixels of value V.
%
% Notes::
% - nothing to do with tablet computers
%
% Examples::
%
%     ipad(im, 't', 20)  block of 20 pixels across the top
%     ipad(im, 'tl', 10) block of 10 pixels across the top and left side

function out = ipad(in, sides, n, val)

    if nargin < 4
        val = NaN;
    end
    
    out = in;
    for side=sides
        [w,h] = isize(out);

        switch side
            case 't'
                out = [val*ones(n,w); out];
            case 'b'
                out = [out; val*ones(n,w)];
            case 'l'
                out = [val*ones(h,n) out];
            case 'r'
                out = [out val*ones(h,n)];
        end
    end
%    ipyramid                           - Pyramidal image decomposition
%
% OUT = IPYRAMID(IM) returns a pyramid decomposition of input image IM using 
% Gaussian smoothing with standard deviation of 1.  OUT is a cell array of
% images each one having dimensions half that of the previous image. The 
% pyramid is computed down to a non-halvable image size.
%
% OUT = IPYRAMID(IM, SIGMA) as above but the Gaussian standard deviation 
% is SIGMA
%
% OUT = IPYRAMID(IM, SIGMA, N) as above but only N levels of the pyramid are
% computed.
%
% See also IDECIMATE, ISMOOTH.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.

function p = ipyramid(im, sigma, N)
    if nargin < 2,
        sigma = 1;
        N = floor( log2( min(size(im) ) ) );
    elseif nargin < 3,
        N = floor(log2(min(size(im))));
    end

    [height,width] = size(im);
    K = kgauss(sigma);

    p{1} = im;

    for k = 1:N,
        [nrows,ncols] = size(im);

        % smooth
        im = conv2(im, K, 'same');

        % sub sample
        im = im(1:2:nrows,1:2:ncols);

        % stash it
        p{k+1} = im;
    end
%    ireplicate                         - Expand an image by pixel replication
%
% OUT = IREPLICATE(IM, K) returns an image where each pixel is replicated into
% a KxK block.  If IM is NxM the result is (KN)x(KM).
%
% See also ISCALE, IDECIMATE.

function ir2 = ireplicate(im, M)

    if size(im, 3) > 1
        error('color images not supported');
    end

    if nargin < 2
        M = 1;
    end

    dims = size(im);
    nr = dims(1); nc = dims(2);

    % replicate the columns
    ir = zeros(M*nr,nc);
    for i=1:M
        ir(i:M:end,:) = im;
    end

    % replicate the rows
    ir2 = zeros(M*nr,M*nc);
    for i=1:M
        ir2(:,i:M:end) = ir;
    end
%    iroi                               - Extract region of interest
%
% OUT = IROI(IM,R) returns a region of interest from the image IM 
% where R=[umin umax;vmin vmax].
%
% OUT = IROI(IM) as above but the image is displayed and the user is prompted to
% adjust a rubber band box to select the region of interest.
%
% [OUT,R] = IROI(IM) as above but returns the selected region of 
% interest R=[umin umax;vmin vmax].
%
% See also IDISP.

% TODO
%   IROI(image, centre, width)
%   IROI(image, [], width)     prompts to pick the centre point
%

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.
function [im, region] = iroi(image, reg, wh)

    if nargin == 3
        xc = reg(1); yc = reg(2);
        w = round(wh(1)/2); h = round(h(2)/2);
        im = image(yc-h:yc+h,xc-w:xc+w,:);
    elseif nargin == 2
        im = image(reg(2,1):reg(2,2),reg(1,1):reg(1,2),:);
    else
        clf
        idisp(image, 'nogui');
        oldpointer = get(gcf, 'pointer');
        set(gcf, 'pointer', 'fullcrosshair');

        % get the rubber band box
        waitforbuttonpress
        disp('pressed');
        cp0 = floor( get(gca, 'CurrentPoint') );

        rect = rbbox;       % return on up click
        disp('rrbox returns');
        
        cp1 = floor( get(gca, 'CurrentPoint') );
        
        ax = get(gca, 'Children');
        img = get(ax, 'CData');         % get the current image

        % determine the bounds of the ROI
        top = cp0(1,2);
        left = cp0(1,1);
        bot = cp1(1,2);
        right = cp1(1,1);
        if bot<top,
            t = top;
            top = bot;
            bot = t;
        end
        if right<left,
            t = left;
            left = right;
            right = t;
        end

        % restore the pointer
        set(gcf, 'pointer', oldpointer);
        
        % extract the ROI
        im = img(top:bot,left:right,:);
        
        figure
        idisp2(im);
        title(sprintf('ROI (%d,%d) %dx%d', left, top, right-left, bot-top));
        
        if nargout == 2,
            region = [left right; top bot];
        end
    end
%    irotate                            - rotate image
%
% OUT = IROTATE(IM, ANGLE, OPTIONS) returns a version of the image IM
% that has been rotated about its centre.
%
% Options::
% 'outsize',S     set size of OUT to NxM where S=(N,M)
% 'crop'          return central part of image, same size as IM
% 'scale',S       scale the image size by S (default 1)
% 'extrapval',V   set background pixels to V (default 0)
% 'smooth',S      smooth image with Gaussian of standard deviation S
%
% Notes::
% - rotation is defined with respect to a z-axis into the image
% - counter-clockwise is a positive angle. factor >1 is larger, <1 is smaller.
%
% See also ISCALE.

function im2 = irotate(im, angle, varargin)

    opt.outsize = [];
    opt.crop = false;
    opt.scale = 1.0;
    opt.extrapval = 0;
    opt.smooth = [];
    
    opt = tb_optparse(opt, varargin);

    if isfloat(im)
        is_int = false;
    else
        is_int = true;
        im = idouble(im);
    end

    if ~isempty(opt.smooth)
        im = ismooth(im, opt.smooth);
    end

    [nr,nc,np] = size(im);

    if isempty(opt.outsize)
        % output image size is determined by input size 
        [Uo,Vo] = imeshgrid(im);

    else
        % else from specified size
        [Uo,Vo] = meshgrid(1:opt.outsize(1), 1:opt.outsize(2));
    end



    % create the coordinate matrices for warping
    [Ui,Vi] = imeshgrid(im);


    % rotation and scale
    R = rotz(angle);
    uc = nc/2; vc = nr/2;
    Uo2 = 1/opt.scale*(R(1,1)*(Uo-uc)+R(2,1)*(Vo-vc))+uc;
    Vo2 = 1/opt.scale*(R(1,2)*(Uo-uc)+R(2,2)*(Vo-vc))+vc;

    Uo = Uo2;
    Vo = Vo2;

    
    if opt.crop
        trimx = abs(nr/2*sin(angle));
        trimy = abs(nc/2*sin(angle));
        if opt.scale < 1
            trimx = trimx + nc/2*(1-opt.scale);
            trimy = trimy + nr/2*(1-opt.scale);
        end
        trimx = ceil(trimx) + 1;
        trimy = ceil(trimy) + 1;
        trimx
        trimy
        Uo = Uo(trimy:end-trimy,trimx:end-trimx);
        Vo = Vo(trimy:end-trimy,trimx:end-trimx);

    end

    for k=1:size(im,3)
        im2(:,:,k) = interp2(Ui, Vi, im(:,:,k), Uo, Vo, 'linear', opt.extrapval);
    end

    if is_int
        im2 = iint(im2);
    end
%    isamesize                          - Adjust image size
%
% OUT = ISAMESIZE(IM1, IM2) returns an image derived from IM1 that has
% the same dimensions as IM2.  IM1 is cropped and scaled as required.
%
% OUT = ISAMESIZE(IM1, IM2, BIAS) as above but BIAS controls which part
% of the image is cropped.  BIAS=0.5 is symmetric cropping, BIAS<0.5 moves
% the crop window up or to the left, while BIAS>0.5 moves the crop window
% down or to the right.
%
% See also ISCALE.

function im2 = isamesize(im, im1, bias)
    % return im scaled/cropped to be the same size as im1

    if nargin < 3
        bias = 0.5;
    end

    if bias < 0 || bias > 1
        error('bias must be in the range [0,1]')
    end
    sz1 = size(im1);
    sz = size(im);
    scale = sz1(1:2) ./ sz(1:2);

    scale
    im2 = iscale(im, max(scale));

    if numrows(im2) > numrows(im1)
        % scaled image is too high, trim some rows
        d = numrows(im2) - numrows(im1);
        d1 = max(1, floor(d*bias));
        d2 = d-d1;
        [1 d d1 d2]
        im2 = im2(d1:end-d2-1,:,:);
    end
    if numcols(im2) > numcols(im1)
        % scaled image is too wide, trim some columns
        d = numcols(im2) - numcols(im1);
        d1 = max(1, floor(d*bias));
        d2 = d-d1;
        [2 d d1 d2]
        im2 = im2(:,d1:end-d2-1,:);
    end
%    iscale                             - Scale an image
%
% OUT = ISCALE(IM, S) returns a version of IM scaled in both directions by S
% which is real number.  S>1 makes the image larger, S<1 makes it smaller.
%
% Options::
% 'outsize',S     set size of OUT to NxM where S=(N,M)
% 'extrapval',V   set background pixels to V (default 0)
% 'smooth',S      smooth image with Gaussian of standard deviation S.
%                 S=[] means no smoothing (default S=1)
%
% Notes::
% - rotation is defined with respect to a z-axis into the image
% - counter-clockwise is a positive angle. factor >1 is larger, <1 is smaller.
%
% See also IREPLICATE, IDECIMATE, IROTATE.

function im2 = iscale(im, factor, varargin)

    outsize = [];
    bgcolor = 0;
    
    opt.outsize = [];
    opt.extrapval = 0;
    opt.smooth = 1;

    opt = tb_optparse(opt, varargin);
    
    if isfloat(im)
        is_int = false;
    else
        is_int = true;
        im = idouble(im);
    end

    if ~isempty(opt.smooth)
        im = ismooth(im, opt.smooth);    % smooth the image to prevent aliasing % TODO should depend on scale factor
    end

    [nr,nc,np] = size(im);

    if isempty(opt.outsize)
        nrs = floor(nr*factor);
        ncs = floor(nc*factor);
    else
        % else from specified size
        % output image size is determined by input size and scale factor
        ncs = outsize(1);
        nrs = outsize(2);
    end


    % create the coordinate matrices for warping
    [U,V] = imeshgrid(im);
    [Uo,Vo] = imeshgrid(ncs, nrs);

    % the inverse function
    Uo = Uo/factor;
    Vo = Vo/factor;

    
    for k=1:size(im,3)
        im2(:,:,k) = interp2(U, V, im(:,:,k), Uo, Vo, 'linear', opt.extrapval);
    end

    if is_int
        im2 = iint(im2);
    end
%    itrim                              - Trim edges of warped images
%
% [OUT1,OUT2] = ITRIM(IM1,IM2) returns the central parts of images IM1 and 
% IM2 as OUT1 and OUT2 respectively.  When images are rectified or warped
% the shapes can become quite distorted and this function crops out the
% central rectangular region of each.  It assumes that the undefined pixels
% in IM1 and IM2 have values of NaN.  The same cropping is applied to each
% input image.
%
% [OUT1,OUT2] = ITRIM(IM1,IM2,T) as above but the threshold T in the range
% 0 to 1 is used to adjust the level of cropping.
%
% See also HOMWARP, IRECTIFY.
function [out1,out2] = itrim(in1, in2, thresh)

    if nargin < 3
        thresh = 0.75;
    end
    
    out1 = trimx(in1, thresh);
    out2 = trimx(in2, thresh);
    
    z = iconcat({out1, out2});
    
    z = trimy(z, thresh);
    
    w1 = size(out1, 2);
    
    out1 = z(:,1:w1);
    out2 = z(:,w1+1:end);
    
    [w1,h1] = isize(out1);
    [w2,h2] = isize(out2);
    
    if w1 > w2
        out1 = out1(:,1:w2);
    else
        out2 = out2(:,1:w1);   
    end
    
end
    
    
    function out = trim(in, thresh)

        out = trimx(in, thresh);


        out = trimy(out, t);
    end

    
    function out = trimx(in, thresh)
        % trim contiguous edge columns that are mostly NaN
        t = sum(isnan(in)) > thresh*size(in,1);
        
        out = in;
        n = chunk(t);
        if n > 0
            out = out(:,n+1:end);
        end
        
        n = chunk(t(end:-1:1));
        if n > 0
            out = out(:,1:end-n);
        end
    end

    function out = trimy(in, thresh)
        out = trimx(in', thresh)';
    end

    function n = chunk(t)
        n = 0;
        for i=t(:)'
            if i == 0
                break;
            else
                n = n + 1;
            end 
        end
    end
%
%  Utility
%
%      Image utility
%        idisp                          - image display tool
%
% IDISP(IM, OPTIONS) displays an image and allows interactive investigation
% such as pixel value, cross-section, histogram and zooming.  The image is
% displayed in a figure with a toolbar across the top.
%
% IDISP(C, OPTIONS) horizontally concatenates the images in the cell array C
% and displays them as above.
%
% User interface:
%
% - Left clicking on a pixel will display its value in a box at the top.
%
% - The "line" button allows two points to be specified and a new figure
%   displays intensity along a line between those points.
%
% - The "histo" button displays a histogram of the pixel values in a new figure.
%   If the image is zoomed, the histogram is computed over only those pixels in 
%   view.
%
% The "zoom" button requires a left-click and drag to specify a box which
% defines the zoomed view.
%
% Options::
% 'ncolors',N   number of colors in the color map (default 256)
% 'nogui'       display the image without the GUI
% 'noaxes'      no axes on the image
% 'noframe'     no axes or frame on the image
% 'plain'       no axes, frame or GUI
% 'bar'         add a color bar to the image
% 'print',F     write the image to file F in EPS format
% 'square'      display aspect ratio so that pixels are squate
% 'wide'        make figure very wide, useful for displaying stereo pair
% 'flatten'     display image planes as 1G
% 'ynormal'     y-axis increases upward, image is inverted
% 'cscale',C    C is a 2-vector that specifies the grey value range that spans
%               the colormap.
% 'xydata',XY   XY is a cell array whose elements are vectors that span the 
%               x- and y-axes respectively.
% 'grey'        color map: greyscale unsigned
% 'invert'      color map: greyscale unsigned, zero is white, maximum value 
%               is black
% 'signed'      color map: greyscale signed, positive is blue, negative is red,
%               zero is black
% 'invsigned'   color map: greyscale signed, positive is blue, negative is red,
%               zero is white
% 'random'      color map: random values, highlights fine structure
% 'dark'        color map: greyscale unsigned, darker than 'grey', good for 
%               superimposed graphics
%
% Notes::
% - color images are displayed in true color mode: pixel triples map to display
%   pixels
% - grey scale images are displayed in indexed mode: the image pixel value is 
%   mapped through the color map to determine the display pixel value.
% - the minimum and maximum image values are mapped to the first and last 
%   element of the color map, which by default ('greyscale') is the range black
%   to white.
%
% See also IMAGE, CAXIS, COLORMAP, ICONCAT.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.
function idisp(im, varargin)

    opt.ncolors = 256;
    opt.gui = true;
    opt.axes = true;
    opt.square = false;
    opt.wide = false;
    opt.colormap = [];
    opt.print = [];
    opt.bar = false;
    opt.frame = true;
    opt.ynormal = false;
    opt.cscale = [];
    opt.xydata = [];
    opt.plain = false;
    opt.flatten = false;
    opt.colormap_std = {[], 'grey', 'signed', 'invsigned', 'random', 'invert', 'dark'};

    [opt,arglist] = tb_optparse(opt, varargin);

    if opt.plain
        opt.frame = false;
        opt.gui = false;
    end
    if ~isempty(opt.print)
        opt.gui = false;
    end
    if opt.flatten
        im = reshape( im, size(im,1), size(im,2)*size(im,3) );
    end

    if length(arglist) ~= 0
        warning(['Unknown options: ', arglist]);
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % command line invocation, display the image
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % display the image
    clf
    ud = [];
    
    if iscell(im)
        % image is a cell array
        [im,ud.u0] = iconcat(im);
    end

    ud.size = size(im);
    
    set(gca, 'CLimMode', 'Manual');
    set(gca, 'CLim', [min(im(:)) max(im(:))]);
    if ~isempty(opt.xydata)
        hi = image(opt.xydata{1}, opt.xydata{2}, im);
    else
        hi = image(im, 'CDataMapping', 'scaled');
    end

    if opt.wide
        set(gcf, 'units', 'norm');
        pos = get(gcf, 'pos');
        set(gcf, 'pos', [0.0 pos(2) 1.0 pos(4)]);
    end


    if isempty(opt.colormap_std)
        if isempty(opt.colormap)
            % default colormap
            disp('default color map');
            cmap = gray(opt.ncolors);
        else
            % load a Matlab color map
            disp('matlab color map');
            cmap = feval(opt.colormap);
        end
    else
        % a builtin shorthand color map was specified
        disp(['builtin color map: ', opt.colormap_std]);
        switch opt.colormap_std
        case 'random'
            cmap = rand(opt.ncolors,3);
        case 'dark'
            cmap = gray(opt.ncolors)*0.5;
        case 'grey'
            cmap = gray(opt.ncolors);
        case 'invert'
                % invert the monochrome color map: black <-> white
            cmap = gray(opt.ncolors);
            cmap = cmap(end:-1:1,:);
        case {'signed', 'invsigned'}
                % signed color map, red is negative, blue is positive, zero is black
                % inverse signed color map, red is negative, blue is positive, zero is white
            cmap = zeros(opt.ncolors, 3);
            opt.ncolors = bitor(opt.ncolors, 1);    % ensure it's odd
            ncm2 = ceil(opt.ncolors/2);
            if strcmp(opt.colormap, 'signed')
                % signed color map, red is negative, blue is positive, zero is black
                for i=1:opt.ncolors
                    if i > ncm2
                        cmap(i,:) = [0 0 1] * (i-ncm2) / ncm2;
                    else
                        cmap(i,:) = [1 0 0] * (ncm2-i) / ncm2;
                    end
                end
            else
                % inverse signed color map, red is negative, blue is positive, zero is white
                for i=1:opt.ncolors
                    if i > ncm2
                        s = (i-ncm2)/ncm2;
                        cmap(i,:) = [1-s 1-s 1];
                    else
                        s = (ncm2-i)/ncm2;
                        cmap(i,:) = [1 1-s 1-s];
                    end
                end
            end
            mn = min(im(:));
            mx = max(im(:));
            set(gca, 'CLimMode', 'Manual');
            if mn < 0 && mx > 0
                a = max(-mn, mx);
                set(gca, 'CLim', [-a a]);
            elseif mn > 0
                set(gca, 'CLim', [-mx mx]);
            elseif mx < 0
                set(gca, 'CLim', [-mn mn]);
            end
        end
    end
    colormap(cmap);

    if opt.bar
        colorbar
    end
    if opt.frame
        if opt.axes
            xlabel('u (pixels)');
            ylabel('v (pixels)');
        else
            set(gca, 'Xtick', [], 'Ytick', []);
        end
    else
        set(gca, 'Visible', 'off');
    end
    if opt.square
        set(gca, 'DataAspectRatio', [1 1 1]);
    end
    if opt.ynormal
        set(gca, 'YDir', 'normal');
    end
    set(hi, 'CDataMapping', 'scaled');
    if ~isempty(opt.cscale)
        set(gca, 'Clim', opt.cscale);
    end
    
    figure(gcf);    % bring to top

    if opt.print
        print(opt.print, '-depsc');
        return
    end
    if opt.gui
        set(gcf, 'MenuBar', 'none');
        set(gcf, 'ToolBar', 'none');
        htf = uicontrol(gcf, ...
                'style', 'text', ...
                'units',  'norm', ...
                'pos', [.5 .935 .48 .05], ...
                'background', [1 1 1], ...
                'HorizontalAlignment', 'left', ...
                'string', ' Machine Vision Toolbox for Matlab  ' ...
            );
        ud.axis = gca;
        ud.panel = htf;
        ud.image = hi;
        set(gca, 'UserData', ud);
        set(hi, 'UserData', ud);

        % show the variable name in the figure's title bar
        varname = inputname(1);
        if isempty(varname)
            set(gcf, 'name', 'idisp');
        else
            set(gcf, 'name', sprintf('idisp: %s', varname));
        end

        % create pushbuttons
        uicontrol(gcf,'Style','Push', ...
            'String','line', ...
            'Foregroundcolor', [0 0 1], ...
            'Units','norm','pos',[0 .93 .1 .07], ...
            'UserData', ud, ...
            'Callback', @(src,event) idisp_callback('line', src) );
        uicontrol(gcf,'Style','Push', ...
            'String','histo', ...
            'Foregroundcolor', [0 0 1], ...
            'Units','norm','pos',[0.1 .93 .1 .07], ...
            'UserData', ud, ...
            'Callback', @(src,event) idisp_callback('histo', src) );
        uicontrol(gcf,'Style','Push', ...
            'String','zoom', ...
            'Foregroundcolor', [0 0 1], ...
            'Units','norm','pos',[.2 .93 .1 .07], ...
            'Userdata', ud, ...
            'Callback', @(src,event) idisp_callback('zoom', src) );
        uicontrol(gcf,'Style','Push', ...
            'String','unzoom', ...
            'Foregroundcolor', [0 0 1], ...
            'Units','norm','pos',[.3 .93 .15 .07], ...
            'Userdata', ud, ...
            'Callback', @(src,event) idisp_callback('unzoom', src) );
            %'DeleteFcn', 'idisp(''cleanup'')', ...
        set(gcf, 'Color', [0.8 0.8 0.9], ...
            'WindowButtonDownFcn', @(src,event) idisp_callback('down', src), ...
            'WindowButtonUpFcn', @(src,event) idisp_callback('up', src) );
%            htf = uicontrol(gcf, ...
%                    'style', 'text', ...
%                    'units',  'norm', ...
%                    'pos', [.6 0 .4 .04], ...
%                    'ForegroundColor', [0 0 1], ...
%                    'BackgroundColor', get(gcf, 'Color'), ...
%                    'HorizontalAlignment', 'right', ...
%                    'string', 'Machine Vision Toolbox for Matlab  ' ...
%                );

        set(hi, 'UserData', ud);
    end
    set(hi, 'DeleteFcn', @(src,event) idisp_callback('idelete', src) );
    set(gca, ...
        'DeleteFcn', @(src,event) idisp_callback('destroy', src), ...
        'NextPlot', 'replace', ...
        'UserData', ud);

end

% invoked on a GUI event
function idisp_callback(cmd, src)

%disp(['in callback: ', cmd]);
	if isempty(cmd)
		% mouse push or motion request
		h = get(gcf, 'CurrentObject'); % image
		ud = get(h, 'UserData');		% axis
        
        if ~isempty(ud)
            cp = get(ud.axis, 'CurrentPoint');
            x = round(cp(1,1));
            y = round(cp(1,2));
            try
                imdata = get(ud.image, 'CData');
                set(ud.panel, 'String', sprintf(' (%d, %d) = %s', x, y, num2str(imdata(y,x,:), 4)));
                drawnow
            end
        end
	else
		switch cmd
        case {'destroy', 'idelete'}
            %fprintf('cleaning up figure\n');
            clf
            set(gcf, 'MenuBar', 'figure');
            set(gcf, 'ToolBar', 'figure');
            set(gcf, 'WindowButtonUpFcn', '');
            set(gcf, 'WindowButtonDownFcn', '');
        case 'cleanup'
            %fprintf('cleaning up handlers\n');
            set(gcf, 'WindowButtonDownFcn', '');
            set(gcf, 'WindowButtonUpFcn', '');

		case 'down',
			% install pixel value inspector
			set(gcf, 'WindowButtonMotionFcn', @(src,event) idisp_callback([], src) );
			idisp_callback([], src);
			
		case 'up',
			set(gcf, 'WindowButtonMotionFcn', '');

		case 'line',
			h = get(gcf, 'CurrentObject'); % push button
                        
			ud = get(h, 'UserData');
            
			set(ud.panel, 'String', 'Click first point');
			[x1,y1] = ginput(1);
			x1 = round(x1); y1 = round(y1);
			set(ud.panel, 'String', 'Click last point');
			[x2,y2] = ginput(1);
			x2 = round(x2); y2 = round(y2);
			set(ud.panel, 'String', '');
			imdata = get(ud.image, 'CData');
			dx = x2-x1; dy = y2-y1;
			if abs(dx) > abs(dy),
				x = x1:x2;
				y = round(dy/dx * (x-x1) + y1);
				figure

                if size(imdata,3) > 1
                    set(gca, 'ColorOrder', eye(3,3), 'Nextplot', 'replacechildren');
                    n = size(imdata,1)*size(imdata,2);
                    z = [];
                    for i=1:size(imdata,3)
                        z = [z imdata(y+x*numrows(imdata)+(i-1)*n)'];
                    end
                    plot(x', z);
                else
                    plot(imdata(y+x*numrows(imdata)))
                end
			else
				y = y1:y2;
                x = round(dx/dy * (y-y1) + x1);
				figure
                if size(imdata,3) > 1
                    set(gca, 'ColorOrder', eye(3,3), 'Nextplot', 'replacechildren');
                    n = size(imdata,1)*size(imdata,2);
                    z = [];
                    for i=1:size(imdata,3)
                        z = [z imdata(y+x*numrows(imdata)+(i-1)*n)'];
                    end
                    plot(z, y');
                else
                    plot(imdata(y+x*numrows(imdata)))
                end

            end
            title(sprintf('(%d,%d) to (%d,%d)', x1, y1, x2, y2));
            xlabel('distance (pixels)')
            ylabel('greyscale');
            grid on
            
        case 'histo',
            h = get(gcf, 'CurrentObject'); % push button
			ud = get(h, 'UserData');

			imdata = get(ud.image, 'CData');
            b = floor(axis);   % bounds of displayed image
            if b(1) == 0,
                b = [1 b(2) 1 b(4)];
            end

            figure
            imdata = double(imdata(b(3):b(4), b(1):b(2),:));
            ihist(imdata);

		case 'zoom',
            % get the rubber band box
            waitforbuttonpress
            cp0 = floor( get(gca, 'CurrentPoint') );

            rect = rbbox;	    % return on up click

            cp1 = floor( get(gca, 'CurrentPoint') );

            % determine the bounds of the ROI
            top = cp0(1,2);
            left = cp0(1,1);
            bot = cp1(1,2);
            right = cp1(1,1);
            if bot<top,
                t = top;
                top = bot;
                bot = t;
            end
            if right<left,
                t = left;
                left = right;
                right = t;
            end

            % extract the view region
			axes(gca);
			axis([left right top bot]);
		case 'unzoom',
			h = get(gcf, 'CurrentObject'); % push button
			ud = get(h, 'UserData');
			axes(ud.axis);
			axis([1 ud.size(2) 1 ud.size(1)]);

        otherwise
            idisp( imread(z) );
		end
	end
end
%        idisplabel                     - Display an image with mask
%
% IDISPLABEL(IM, LABELIMAGE, LABELS) displays only those image pixels which 
% belong to a specific class.  IM is a greyscale NxM or color NxMx3 image, and
% LABELIMAGE is an NxM image containing integer pixel class labels for the
% corresponding pixels in IM.  The pixel classes to be displayed are given by
% the elements of LABELS which is a scalar a vector of class labels.  
% Non-selected pixels are displayed as white.
%
% IDISPLABEL(IM, LABELIMAGE, LABELS, BG) as above but the grey level of the 
% non-selected pixels is specified by BG in the range 0 to 1.
%
% See also IBLOBS, ICOLORIZE, COLORSEG.

function idisplabel(im, label, select, bg)

    if isscalar(select)
        mask = label == select;
    else
        mask = zeros(size(label));
        for s=select(:)',
            mask = mask | (label == s);
        end
    end
    
    if nargin < 4
        bg = 1;
    end
    
    if ndims(im) == 3
        mask = cat(3, mask, mask, mask);
    end
    
    im(~mask) = bg;
    idisp(im, 'nogui');
    shg
%        iread                          - Read an image from file
%
% IM = IREAD() presents a file selection GUI from which the user can select
% an image file which is returned as 2D or 3D matrix.  On subsequent calls 
% the initial folder is as set on the last call.
%
% IM = IREAD(FILE, OPTIONS) reads the specified file and returns a matrix.  If
% the path is relative it is searched for on Matlab search path.

% Wildcards are allowed in file names.  If multiple files match a 3D or 4D image
% is returned where the last dimension is the number of images in the sequence.
%
% Options::
% 'uint8'      return an image with 8-bit unsigned integer pixels in 
%              the range 0 to 255
% 'single'     return an image with single precision floating point pixels
%              in the range 0 to 1.
% 'double'     return an image with double precision floating point pixels
%              in the range 0 to 1.
% 'grey'       convert image to greyscale if it's color using ITU rec 601
% 'grey_601'   ditto
% 'grey_709'   convert image to greyscale if it's color using ITU rec 709
% 'gamma',G    gamma value, either numeric or 'sRGB'
% 'reduce',R   decimate image by R in both dimensions
% 'roi',R      apply the region of interest R to each image, 
%              where R=[umin umax; vmin vmax].
% Notes::
% - a greyscale image is returned as an NxM matrix
% - a color image is returned as an NxMx3 matrix
% - a greyscale image sequence is returned as an NxMxP matrix where P is the sequence length 
% - a color image sequence is returned as an NxMx3xP matrix where P is the sequence length 
%
% See also IDISP, IMONO, IGAMMA, IMWRITE, PATH.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.


function [I,info] = iread(filename, varargin)
    persistent mypath

    % options
    %
    %   'float
    %   'uint8
    %   'grey'
    %   'gray'
    %   'grey_601'
    %   'grey_709'
    %   'grey_value'
    %   'gray_601'
    %   'gray_709'
    %   'gray_value'
    %   'reduce', n

    opt.type = {[], 'double', 'single', 'uint8'};
    opt.mkGrey = {[], 'grey', 'gray', 'mono', '601', 'grey_601', 'grey_709'};
    opt.gamma = [];
    opt.reduce = 1;
    opt.roi = [];
    opt.disp = [];

    opt = tb_optparse(opt, varargin);

    im = [];
    
    if nargin == 0,
        % invoke file browser GUI
        [file, npath] = uigetfile(...
            {'*.png;*.pgm;*.ppm;*.jpg;*.tif', 'All images';
            '*.pgm', 'PGM images';
            '*.jpg', 'JPEG images';
            '*.gif;*.png;*.jpg', 'web images';
            '*.*', 'All files';
            }, 'iread');
        if file == 0,
            fprintf('iread canceled from GUI\n');
            return; % cancel button pushed
        else
            % save the path away for next time
            mypath = npath;
            filename = fullfile(mypath, file);
            im = loadimg(filename, opt);
        end
    elseif (nargin == 1) & exist(filename,'dir'),
        % invoke file browser GUI
        if isempty(findstr(filename, '*')),
            filename = strcat(filename, '/*.*');
        end
        [file,npath] = uigetfile(filename, 'iread');
        if file == 0,
            fprintf('iread canceled from GUI\n');
            return; % cancel button pushed
        else
            % save the path away for next time
            mypath = npath;
            filename = fullfile(mypath, file);
            im = loadimg(filename, opt);
        end
    else
        % some kind of filespec has been given
        if ~isempty(strfind(filename, '*')) | ~isempty(strfind(filename, '?')),
            % wild card files, eg.  'seq/*.png', we need to look for a folder
            % seq somewhere along the path.
                        [pth,name,ext] = fileparts(filename);

            if opt.verbose
                fprintf('wildcard lookup: %s %s %s\n', pth, name, ext);
            end
            
            % search for the folder name along the path
            folderonpath = pth;
            for p=path2cell(path)'  % was userpath
                if exist( fullfile(p{1}, pth) ) == 7
                    folderonpath = fullfile(p{1}, pth);
                    if opt.verbose
                        fprintf('folder found\n');
                    end
                    break;
                end
            end
            s = dir( fullfile(folderonpath, [name, ext]));      % do a wildcard lookup

            if length(s) == 0,
                error('no matching files found');
            end

            for i=1:length(s)
                im1 = loadimg( fullfile(folderonpath, s(i).name), opt);
                if i==1
                    % preallocate storage, much quicker
                    im = zeros([size(im1) length(s)], class(im1));
                end
                if ndims(im1) == 2
                    im(:,:,i) = im1;
                elseif ndims(im1) == 3
                    im(:,:,:,i) = im1;
                end
            end
        else
            % simple file, no wildcard
            if strncmp(filename, 'http://', 7)
                im = loadimg(filename, opt);
            elseif exist(filename)
                im = loadimg(filename, opt);
            else
                % see if it exists on the Matlab search path
                for p=path2cell(userpath)'
                    if exist( fullfile(p{1}, filename) ) > 0
                        im = loadimg(fullfile(p{1}, filename), opt);
                        break;
                    end
                end
  
            end
        end
    end

                      
    if isempty(im)
        error(sprintf('cant open file: %s', filename));
    end
    if nargout > 0
        I = im;
        if nargout > 1
            info = imfinfo(filename);
        end
    else
        % if no output arguments display the image
        if ndims(I) <= 3
            idisp(I);
        end
    end
end

function im = loadimg(name, opt)

    % now we read the image
    im = imread(name);

    if opt.verbose
        if ndims(im) == 2
            fprintf('loaded %s, %dx%d\n', name, size(im,2), size(im,1));
        elseif ndims(im) == 3
            fprintf('loaded %s, %dx%dx%d\n', name, size(im,2), size(im,1), size(im,3));
        end
    end

    % optionally convert it to greyscale using specified method
    if ~isempty(opt.mkGrey) && (ndims(im) == 3)
        im = imono(im, opt.mkGrey);
    end

    % optionally chop out a roi
    if ~isempty(opt.roi)
        im = iroi(im, opt.roi);
    end

    % optionally decimate it
    if opt.reduce > 1,
        im = im(1:opt.reduce:end, 1:opt.reduce:end, :);
    end

    % optionally convert to specified numeric type
    if ~isempty(opt.type)
        if isempty(findstr(opt.type, 'int'))
            im = cast(im, opt.type) / double(intmax(class(im)));
        else
            im = cast(im, opt.type);
        end
    end

    % optionally gamma correct it
    if ~isempty(opt.gamma)
        im = igamma(im, opt.gamma);
    end

    if opt.disp
        idisp(im);
    end

end
%        pgmfilt                        - Pipe image through PGM utility
%
% OUT = PGMFILT(IM, PGMCMD) pipes the image IM through an Unix filter program
% and returns its output as an image. The program given by the string PGMCMD
% must accept and return images in PGM format.
%
% See also PNMFILT, IREAD.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.


function im2 = pgmfilt(im, cmd)

    % MATLAB doesn't support pipes, so it all has to be done via temp files...

    % make up two file names
    fname = tempname;
    fname2 = tempname;

    imwrite(im, fname, 'pgm');
    %cmd
    unix([cmd ' < ' fname ' > ' fname2]);
    %fname2
    im2 = imread(fname2, 'pgm');
    unix(['/bin/rm ' fname ' ' fname2]);
%        pnmfilt                        - Pipe image through PNM utility
%
% OUT = PNMFILT(IM, PNMCMD) pipes the image IM through an Unix filter program
% and returns its output as an image. The program given by the string PNMCMD
% must accept and return images in PNM format.
%
% See also PGMFILT, IREAD.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.

function im2 = pnmfilt(im, cmd)

	% MATLAB doesn't support pipes, so it all has to be done via 
	% temp files :-(

	% make up two file names
	ifile = sprintf('%s.pnm', tempname);
	ofile = sprintf('%s.pnm', tempname);

    imwrite(im, ifile, 'pgm');
	%cmd
	unix([cmd ' < ' ifile ' > ' ofile]);

	im2 = double( imread(ofile) );
	unix(['/bin/rm ' ifile ' ' ofile]);
%
%      Image generation
%        iconcat                        - Concatenate images
%
% C = ICONCAT(IM,OPTIONS) concatenates images from the cell array IM.  The
% images do not have to be of the same size, and smaller images are surrounded
% by background pixels which can be specified.
%
% ICONCAT(IM,OPTIONS) as above but displays the concatenated images 
% using idisp.
%
% [C,U] = ICONCAT(IM,OPTIONS) as above but also returns the vector U whose
% elements are the coordinates of the left (or top in vertical mode) edge of
% the corresponding image.
%
% Options::
% 'dir',D     direction of concatenation: 'horizontal' (default) or 'vertical'.
% 'bgval',B   value of unset background pixels
%
% Notes::
% - works for color or greyscale images
% - direction can be abbreviated to first character, 'h' or 'v'
% - in vertical mode all images are right justified
% - in horizontal mode all images are top justified
%
% See also IDISP.

function [out,u0] = iconcat(images, dir, bgval)
% TODO: add a gap option

    opt.dir = 'h';
    opt.bg = NaN;

   % image is a cell array
    width = 0;
    height = 0;
    
    if nargin < 2
        dir = 'h';
    end
    if nargin < 3
        bgval = NaN;
    end
    
    np_prev = NaN;
    u0 = 1;
    for i=1:length(images)
        if dir(1) == 'v'
            images{i} = images{i}';
        end
        
        image = images{i};

        [nr,nc,np] = size(image);
        if ~isnan(np_prev) && np ~= np_prev
            error('all images must have same number of planes');
        end
        width = width + nc;
        height = max(height, nr);
        if i > 1
            u0(i) = u0(i-1) + nc;
        end
    end
    composite = bgval*ones(height, width, np);

    u = 1;
    for i=1:length(images)
        composite = ipaste(composite, images{i}, [u 1]);
        u = u + size(images{i}, 2);
    end
    
    if dir == 'v'
        composite = permute(composite, [2 1 3]);
    end
        
    
    if nargout == 0
        idisp(composite)
    else
        out = composite;
    end
%        iline                          - Draw a line in an image
%
% OUT = ILINE(IM, P1, P2) returns a copy of the image IM with a line drawn
% between the points P1 and P2, each is a 2-vector [X,Y].  The pixels on the
% line are set to 1.
%
% OUT = ILINE(IM, P1, P2, V) as above but each pixel on the line is set to V.
%
% Notes::
% - uses the Bresenham algorith
% - only works for greyscale images
% - the line looks jagged since no anti-aliasing is performed
%
% See also BRESENHAM, IPROFILE.

function c2 = iline(c, p1, p2, value)

    if nargin < 4
        value = 1;
    end

    points = bresenham(p1, p2);

    c2 = c;
    for point = points'
        c2(point(2), point(1)) = value;
    end
%        ipaste                         - Paste an image into an image
%
% OUT = IPASTE(IM, IM2, P, OPTIONS) returns the image IM with the image IM2 
% pasted in at the position P=(U,V).
%
% Options::
% 'centre'   The pasted image is centred at P, otherwise P is the top-left 
%            corner (default)
% 'zero'     the coordinates of P start at zero, by default 1 is assumed
% 'set'      IM2 overwrites pixels in IM (default)
% 'add'      IM2 is added to the pixels in IM
% 'mean'     the mean of pixel values in IM2 and IM is used

function out = ipaste(canvas, pattern, topleft, varargin)

    [h,w,nc] = size(canvas);
    [ph,pw,np] = size(pattern);

    opt.centre = false;
    opt.zero = false;
    opt.mode = {'set', 'add', 'mean'};

    opt = tb_optparse(opt, varargin);

    if opt.centre
        % specify centre of pattern not topleft
        left = topleft(1) - floor(pw/2);
        top = topleft(2) - floor(ph/2);
    else
        left = topleft(1);      % x
        top = topleft(2);       % y
    end

    if opt.zero
        left = left+1;
        top = top+1;
    end

    if (top+ph-1) > h
        error('pattern falls off bottom edge');
    end
    if (left+pw-1) > w
        error('pattern falls off right edge');
    end

    if np > nc
        % pattern has multiple planes, replicate the canvas
        out = repmat(canvas, [1 1 np]);
    else
        out = canvas;
    end
    if np < nc
        pattern = repmat(pattern, [1 1 nc]);
    end
    switch opt.mode
    case 'set'
        out(top:top+ph-1,left:left+pw-1,:) = pattern;
    case 'add'
        out(top:top+ph-1,left:left+pw-1,:) = out(top:top+ph-1,left:left+pw-1,:) +pattern;
    case 'mean'
        old = out(top:top+ph-1,left:left+pw-1,:);
        k = ~isnan(pattern);
        old(k) = 0.5 * (old + pattern);
        out(top:top+ph-1,left:left+pw-1,:) = old;
    end
%
%      Moments
%        humoments                      - Hu moments
%
% PHI = HUMOMENTS(IM) is the vector of Hu moment invariants for the binary
% image IM, and PHI is 7x1.
%
% Notes::
% - IM is assumed to be a binary image of a single connected region
%
% See also NPQ.

function phi = humoments(im)

    % second moments
    eta_20 = npq(im, 2, 0);
    eta_02 = npq(im, 0, 2);
    eta_11 = npq(im, 1, 1);

    % third moments
    eta_30 = npq(im, 3, 0);
    eta_03 = npq(im, 0, 3);
    eta_21 = npq(im, 2, 1);
    eta_12 = npq(im, 1, 2);

    phi(1) = eta_20 + eta_02;
    phi(2) = (eta_20 - eta_02)^2 + 4*eta_11^2;
    phi(3) = (eta_30 - 3*eta_12)^2 + (3*eta_21 - eta_03)^2;
    phi(4) = (eta_30 + eta_12)^2 + (eta_21 + eta_03)^2;
    phi(5) = (eta_30 - 3*eta_12)*(eta_30+eta_12)* ...
       ((eta_30 +eta_12)^2 - 3*(eta_21+eta_03)^2) + ...
       (3*eta_21 - eta_03)*(eta_21+eta_03)* ...
       (3*(eta_30+eta_12)^2 - (eta_21+eta_03)^2);
    phi(6) = (eta_20 - eta_02)*((eta_30 +eta_12)^2 - (eta_21+eta_03)^2) + ...
       4*eta_11 *(eta_30+eta_12)*(eta_21+eta_03);
    phi(7) = (3*eta_21 - eta_03)*(eta_30+eta_12)* ...
      ((eta_30 +eta_12)^2 - 3*(eta_21+eta_03)^2) + ...
      (3*eta_12 - eta_30)*(eta_21+eta_03)*( 3*(eta_30+eta_12)^2 - (eta_21+eta_03)^2);
%        mpq                            - Image moments
%
% M = MPQ(IM, P, Q) is the PQ'th moment of the image IM.  That is, the sum
% of I(x,y) x^P y^Q.
%
% See also MPQ_POLY, NPQ, UPQ.

function m = mpq(im, p, q)

    [X,Y] = imeshgrid(im);

    m = sum(sum( im.*X.^p.*Y.^q ) );
%        mpq_poly                       - Moments of polygon
%
% M = MPQ_POLY(V, P, Q) is the PQ'th moment of the polygon with vertices 
% described by the columns of V.
%
% Notes::
% - The points must be sorted such that they follow the perimeter in 
%   sequence (counter-clockwise).  
% - If the points are clockwise the moments will all be negated, so centroids
%   will be still be correct.
% - If the first and last point in the list are the same, they are considered
%   as a single vertex.
%
% See also MPQ, NPQ_POLY, UPQ_POLY.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.

function m = mpq(iv, p, q)
    if ~all(iv(:,1) == iv(:,end))
        %disp('closing the polygon')
        iv = [iv iv(:,1)];
    end
    [nr,n] = size(iv);
    if nr < 2,
        error('must be at least two rows of data')
    end
    x = iv(1,:);
    y = iv(2,:);
 
    m = 0.0;
    for l=1:n
        if l == 1
            dxl = x(l) - x(n);
            dyl = y(l) - y(n);
        else
            dxl = x(l) - x(l-1);
            dyl = y(l) - y(l-1);
        end
        Al = x(l)*dyl - y(l)*dxl;
        
        s = 0.0;
        for i=0:p
            for j=0:q
                s = s + (-1)^(i+j) * combin(p,i) * combin(q,j)/(i+j+1) * x(l)^(p-i)*y(l)^(q-j) * dxl^i * dyl^j;
            end
        end
        m = m + Al * s;
    end
    m = m / (p+q+2);

function c = combin(n, r)
% 
% COMBIN(n,r)
%   compute number of combinations of size r from set n
%
    c = prod((n-r+1):n) / prod(1:r);
%        upq                            - Central image moments
%
% M = UPQ(IM, P, Q) is the PQ'th central moment of the image IM.  That is, 
% the sum of I(x,y) (x-x0)^P (y-y0)^Q where (x0,y0) is the centroid.
%
% Notes::
% - The central moments are invariant to translation.
%
% See also UPQ_POLY, MPQ, NPQ.

function m = upq(im, p, q)

    [X,Y] = imeshgrid(im);

	m00 = mpq(im, 0, 0);
	xc = mpq(im, 1, 0) / m00;
	yc = mpq(im, 0, 1) / m00;

    m = sum(sum( im.*(X-xc).^p.*(Y-yc).^q ) );
%        upq_poly                       - Central moments of polygon
%
% M = UPQ_POLY(V, P, Q) is the PQ'th central moment of the polygon with 
% vertices described by the columns of V.
%
% Notes::
% - The points must be sorted such that they follow the perimeter in 
%   sequence (counter-clockwise).  
% - If the points are clockwise the moments will all be negated, so centroids
%   will be still be correct.
% - If the first and last point in the list are the same, they are considered
%   as a single vertex.
% - The central moments are invariant to translation.
%
% See also UPQ, MPQ_POLY, NPQ_POLY.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.

function m = upq(iv, p, q)

	m00 = mpq_poly(iv, 0, 0);
	xc =  mpq_poly(iv, 1, 0) / m00;
	yc =  mpq_poly(iv, 0, 1) / m00;

	m = mpq_poly(iv - ones(numrows(iv),1)*[xc yc], p, q);
%        npq                            - Normalized central image moments
%
% M = NPQ(IM, P, Q) is the PQ'th normalized central moment of the image IM.
% That is UPQ(IM,P,Q)/MPQ(IM,0,0).
%
% Notes::
% - The normalized central moments are invariant to translation and scale.
%
% See also NPQ_POLY, MPQ, UPQ.
function m = npq(im, p, q)

	if (p+q) < 2
		error('normalized moments only valid for p+q >= 2');
	end

	g = (p+q)/2 + 1;
	m = upq(im, p, q) / mpq(im, 0, 0)^g;
%        npq_poly                       - Normalized central moments of polygon
%
% M = NPQ_POLY(V, P, Q) is the PQ'th normalized central moment of the 
% polygon with vertices described by the columns of V.
%
% Notes::
% - The points must be sorted such that they follow the perimeter in 
%   sequence (counter-clockwise).  
% - If the points are clockwise the moments will all be negated, so centroids
%   will be still be correct.
% - If the first and last point in the list are the same, they are considered
%   as a single vertex.
% - The normalized central moments are invariant to translation and scale.
%
% See also MPQ_POLY, MPQ, NPQ, UPQ.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.

function m = npq(iv, p, q)

	if (p+q) < 2,
		error('normalized moments: p+q >= 2');
	end
	g = (p+q)/2 + 1;
	m = upq_poly(iv, p, q) / mpq_poly(iv, 0, 0)^g;
%
%      Plotting
%        plot_arrow                     - draw an arrow
%        plot_box                       - draw a box
%        plot_circle                    - draw a circle
%        plot_ellipse                   - draw an ellipse
%        plot_homline                   - plot homogeneous line
%        plot_point                     - plot points
%        plot_poly                      - plot polygon
%        plot_sphere                    - draw a sphere
%
%      Homogeneous coordinates
%        e2h                            - Euclidean coordinates to homogeneous
%        h2e                            - homogeneous coordinates to Euclidean
%        homtrans                       - apply homogeneous transform to points
%
%      3D
%        icp                            - Point cloud alignment
%
% T21 = ICP(P1, P2, OPTIONS) returns the homogeneous transformation that best
% transforms the set of points P2 to P1 using the iterative closest point
% algorithm.
%
% [T21,D] = ICP(P1, P2, OPTIONS) as above but also returns the norm of the
% error between the transformed P2 and P1.
%
% Options::
% 'plot'           show the points P1 and P2 at each iteration
% 'maxtheta',T     limit the change in rotation at each step to T (default 0.05)
% 'maxiter',N      stop after N iterations (default 100)
% 'mindelta',T     stop when the relative change in error norm is less than T (default 0.001)
% 'distthresh',T   eliminate correspondences more than T x the median distance
%
% Notes::
% - points can be 2- or 3-dimensional.
%
% Reference::
% "A method fo rregistration of 3-d shapes", P.Besl and H.McKay,
% IEEETrans. Pattern Anal. Mach. Intell., vol. 14, no. 2, pp. 239-256, Feb. 1992.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.
function [T,d] = icp3(set1, set2, varargin)

    % T is the transform from set1 to set2
    opt.maxtheta = 0.05;
    opt.maxiter = 100;
    opt.mindelta = 0.001;
    opt.plot = false;
    opt.distthresh = [];
    opt = tb_optparse(opt, varargin);
    
	N1 = numcols(set1);	% number of model points
	N2 = numcols(set2);

	p1 = mean(set1');
	p2 = mean(set2');
	t = p2 - p1;
	T = transl(t);
    
	dnorm = 0;
    dnorm_p = NaN;
    
	for count=1:opt.maxiter
        
		% transform the model
        set1t = transformp(T, set1);

		% for each point in set 2 find the nearest point in set 1       
        [corresp,distance] = closest(set2, set1t);
        
        if isempty(opt.distthresh)
            set2t = set2;
        else
            k = find(distance > 2*median(distance));

            % now remove them
            if ~isempty(k),
                fprintf('breaking %d corespondances ', length(k));
                distance(k) = [];
                corresp(k) = [];
            end
            set2t = set2;
            set2t(:,k) = [];
        end
        
		% display the model points
		if opt.plot
            usefig('ICP');
            clf
            plot3(set1t(1,:),set1t(2,:),set1t(3,:),'bx');
            grid
            hold on
            plot3(set2t(1,:),set2t(2,:),set2t(3,:),'ro');

            for i=1:numcols(set2t),
                ic = corresp(i);
                plot3( [set1t(1,ic) set2t(1,i)], [set1t(2,ic) set2t(2,i)], [set1t(3,ic) set2t(3,i)], 'g');
            end
            pause(0.25)
        end

		% find the centroids of the two point sets
		% for the observations include only those points which have a
		% correspondance.
		p1 = mean(set1t(:,corresp)');
        %[length(corresp)         length(unique(corresp))]
        p1 = mean(set1t');
		p2 = mean(set2t');

        % compute the moments
		M = zeros(3,3);
		for i=1:numcols(set2t)
            ic = corresp(i);
			M = M + (set1t(:,ic) - p1') * (set2t(:,i) - p2')';
        end
        
		[U,S,V] = svd(M);
        
        % compute the rotation of p1 to p2
        % p2 = R p1 + t
		R = V*U';

        if det(R) < 0
            warning('rotation is not in SO(3)');
            R = -R;
        end
        
        if opt.debug
            p1
            p2
            M
            R
        end
        
        % optionally clip the rotation, helps converence
		if ~isempty(opt.maxtheta)
			[theta,v] = tr2angvec(R);
            if theta > opt.maxtheta;
                theta = opt.maxtheta;
            elseif theta < -opt.maxtheta
                theta = -opt.maxtheta;
            end
            R = angvec2r(theta, v);
        end
        if opt.debug
            theta
            v
            R
        end

			
		% determine the incremental translation
        t = p2' - p1';
		
		%disp([t' tr2rpy(R)])

		% update the transform from data (observation) to model
		T = trnorm( T * [R t; 0 0 0 1] );
		%count = count + 1;
		rpy = tr2rpy(T);
		
        dnorm = norm(distance);
        
        if opt.verbose
            fprintf('n=%d, d=%8.3f, t = (%8.3f %8.3f %8.3f), rpy = (%6.1f %6.1f %6.1f) deg\n', ...
			length(distance), dnorm, transl(T), rpy*180/pi);
            std(distance)
        end

        % check termination condition
        if abs(dnorm - dnorm_p)/dnorm_p < opt.mindelta
            count = NaN;    % flag that we exited on mindelta
            break
        end
		dnorm_p = dnorm;
    end
    
    if opt.verbose
        if isnan(count)
                fprintf('terminate on minimal change of error norm');
        else
            fprintf('terminate on iteration limit (%d iterations)\n', opt.maxiter);
        end
    end
    
    if nargout > 1
        d = dnorm;
    end
%        Ray3D                          - Ray3D
    properties
        P0   % a point on the ray
        d     % direction of the ray
    end

    methods
        function r = Ray3D(P0, d)
            r.P0 = P0(:);
            r.d = unit(d(:));
        end

        % r1.intersect(r2)   ray intersect ray
        % r1.intersect(plane)ray intersect plane (4-vector)
        function [x,e] = intersect(r1, r2)
            if isa(r2, 'Ray3D')
                % ray intersect ray case
                if length(r1) ~= length(r2)
                    error('can only intersect rays pairwise');
                end

                for i=1:length(r1)
                    alpha = [-r1(i).d r2(i).d cross(r1(i).d,r2(i).d)] \ ...
                        (r1(i).P0-r2(i).P0);
                    x(:,i) = r1(i).P0 + alpha(1)*r1(i).d;
                    e(i) = norm(r1(i).P0 - r2(i).P0 + ...
                        alpha(1)*r1(i).d -alpha(2)*r2(i).d);
                end
            else
                % ray intersect plane case
                % plane is P = (a,b,c,d), P.x = 0

                for i=1:length(r1)
                    n = r2(1:3); d = r2(4);
                    alpha = -(d + dot(n, r1.P0)) / ( dot(n, r1.d) );
                    x(:,i) = r1.P0 + alpha*r1.d;
                end
            end
        end

        % closest distance between point and line
        function [x,e] = closest(r1, P)
            alpha = dot(P - r.P0, r.d);
            x = r1.P0 + alpha*r1.d;
            e = norm(x-P);
        end

        function display(rays)
            disp(' ');
            disp([inputname(1), ' = '])
            disp(' ');
            if length(rays) > 20
                fprintf('%d corresponding points (listing suppressed)\n', length(m));
            else
                disp( char(rays) );
            end
        end % display()

        function s = char(rays)
            s = '';
            for r=rays
                ss = sprintf('d=(%g, %g, %g), P0=(%g, %g, %g)\n', ...
                    r.d, r.P0);
                s = strvcat(s, ss);
            end
        end

    end
end
%
%      Integral image
%        iisum                          - Sum of integral image
%
% S = IISUM(II, Y1, Y2, X1, X2) is the sum of pixels in the region (X1,Y1) to
% (X2,Y2) based on the precomputed integral image II.
%
% See also INTGIMAGE.

function s = iisum(ii, r1, r2, c1, c2)

    r1 = r1 - 1;
    if r1 < 1
        sA = 0;
        sB = 0;
    else
        sB = ii(r1,c2);
    end
    c1 = c1 - 1;
    if c1 < 1
        sA = 0;
        sC = 0;
    else
        sC = ii(r2,c1);
    end
    if (r1 >= 1) && (c1 >= 1)
        sA = ii(r1,c1);
    end

    s = ii(r2,c2) + sA -sB - sC;
%        intgimage                      - Compute integral image
%
% OUT = INTIMAGE(IM) returns the integral image corresponding to IM.
%
% Integral images can be used for rapid computation of summations over 
% rectangular regions.
%
% See also IISUM.

function ii = intgimage(I)

    ii = cumsum( cumsum(I)' )';
%
%      Edge representation
%        edgelist                       - Return list of edge pixels for region
%
% E = EDGELIST(IM, P, OPTIONS) is list of edge pixels of a region.  IM is a 
% binary image and P=[X,Y] is the coordinate of one point on the perimeter
% of a region. E is a matrix with row per edge point, and each row is a
% coordinate [X,Y].
% 
% Options::
% 'clockwise'        Follow the perimeter in clockwise direction (default)
% 'anticlockwise'    Follow the perimeter in anti-clockwise direction
%
% Notes::
% - Pixel values of 0 are assumed to be background, non-zero is an object.
% - The given point is always the first element of the edgelist.
% - Direction is with respect to y-axis upward.
% - If the region touches the edge of the image the edge is considered to be
%   the image edge.
%
% See also IBLOBS.

function e = edgelist(im, P, varargin)

    opt.direction = {'clockwise', 'anticlockwise'};
    opt = tb_optparse(opt, varargin);

    if strcmp(opt.direction, 'clockwise')
        neighbours = [1:8]; % neigbours in clockwise direction
    elseif strcmp(opt.direction, 'anticlockwise')
        neighbours = [8:-1:1];  % neigbours in counter-clockwise direction
    end

    P = P(:)';
    P0 = P;     % make a note of where we started
    pix0 = im(P(2), P(1));  % color of pixel we start at

    % find an adjacent point outside the blob
    Q = adjacent_point(im, P, pix0);
    if isempty(Q)
        error('no neighbour outside the blob');
    end

    e = P;  % initialize the edge list

    % these are directions of 8-neighbours in a clockwise direction
    dirs = [-1 0; -1 1; 0 1; 1 1; 1 0; 1 -1; 0 -1; -1 -1];

    while 1
        % find which direction is Q
        dQ = Q - P;
        for kq=1:8
            if all(dQ == dirs(kq,:))
                break;
            end
        end

        % now test for directions relative to Q
        for j=neighbours
            % get index of neighbour's direction in range [1,8]
            k = j + kq;
            if k > 8
                k = k - 8;
            end

            % compute coordinate of the k'th neighbour
            Nk = P + dirs(k,:);
            try
                if im(Nk(2), Nk(1)) == pix0
                    % if this neighbour is in the blob it is the next edge pixel
                    P = Nk;
                    break;
                end
            end
            Q = Nk;     % the (k-1)th neighbour
        end

        % check if we are back where we started
        if all(P == P0)
            break;
        end

        % keep going, add P to the edgelist
        e = [e; P];
    end
end

function P = adjacent_point(im, seed, pix0)
    % find an adjacent point not in the region
    dirs = [1 0; 0 1; -1 0; 0 -1];
    for d=dirs'
        P = [seed(1)+d(1), seed(2)+d(2)];
        try
            if im(P(2), P(1)) ~= pix0
                return;
            end    
        catch
            % if we get an exception then by definition P is outside the region,
            % since it's off the edge of the image
            return;
        end
    end
    P = [];
end
%        boundmatch                     - [z, s] = boundmatch(r1, r2)

    s = mean(r1) / mean(r2);
    r1 = r1/mean(r1);
    r2 = r2/mean(r2);

    for i=1:400
        %rr = [r2(end-i+2:end); r2(i:end)];
        rr = circshift(r2, i-200);
        z(i) = max( xcorr(r1, rr) );
    end
%
%      General
%        bresenham                      - Create points on line
%
% P = BRESENHAM(X1, Y1, X2, Y2) is a list of integer coordinates for 
% points lying on the line segement (X1,Y1) to (X2,Y2).  Endpoints 
% must be integer.
%
% P = BRESENHAM(P1, P2) as above but P1=[X1,Y1] and P2=[X2,Y2].
%
% See also ICANVAS.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.

function p = bresenham(x1, y1, x2, y2)

    if nargin == 2
        p1 = x1; p2 = y1;

        x1 = p1(1); y1 = p1(2);
        x2 = p2(1); y2 = p2(2);
    elseif nargin ~= 4
        error('expecting 2 or 4 arguments');
    end

    x = x1;
    if x2 > x1
        xd = x2-x1;
        dx = 1;
    else
        xd = x1-x2;
        dx = -1;
    end

    y = y1;
    if y2 > y1
        yd = y2-y1;
        dy = 1;
    else
        yd = y1-y2;
        dy = -1;
    end

    p = [];

    if xd > yd
      a = 2*yd;
      b = a - xd;
      c = b - xd;

      while 1
        p = [p; x y];
        if all([x-x2 y-y2] == 0)
            break
        end
        if  b < 0
            b = b+a;
            x = x+dx;
        else
            b = b+c;
            x = x+dx; y = y+dy;
        end
      end
    else
      a = 2*xd;
      b = a - yd;
      c = b - yd;

      while 1
        p = [p; x y];
        if all([x-x2 y-y2] == 0)
            break
        end
        if  b < 0
            b = b+a;
            y = y+dy;
        else
            b = b+c;
            x = x+dx; y = y+dy;
        end
      end
    end
end
%        closest                        - Find matching points in N-dimensional space.
%
% K = CLOSEST(A, B) returns point correspondence for N-dimensional points.  A
% is NxNA and B is NxNB.  K is 1 x NA and the element J = K(I) indicates that 
% the I'th column of A is closest to the Jth column of B.  That is, A(:,I) 
% is closest to B(:,J).
%
% Notes::
% - is a MEX file.
%        col2im                         - Convert pixel vector to image
%
% OUT = COL2IM(PIX, IMSIZE) is an image comprising the pixel values in PIX which
% is an LxP matrix with one row per pixel.  The result is an NxMxP image
% where L = NxM.  IMSIZE is a 2-vector (N,M).
%
% OUT = COL2IM(PIX, IM) as above but the dimensions of OUT are the same as IM.
%
% See also IM2COL.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.

function im = col2im(col, img)

    ncols = numcols(col);

    if ~((ncols == 1) | (ncols == 3)),
        error('must be 1 or 3 columns');
    end

    if length(img) == 2,
        sz = img;
    elseif length(img) == 3,
        sz = img(1:2);
    else
        sz = size(img);
        sz = sz(1:2);
    end

    if ncols == 3,
        sz = [sz 3];
    end

    sz
    im = reshape(col, sz);
%        distance                       - DISTANCE Euclidean distances between sets of points
%
% D = DISTANCE(A,B) is the Euclidean distances between L-dimensional points
% described by the matrices A (LxM) and B (LxN) respectively.  The distance 
% D is MxN and element D(I,J) is the distance between points A(I) and D(J).
%
% Notes::
% - This fully vectorized (VERY FAST!)
% - It computes the Euclidean distance between two vectors by:
%
%                 ||A-B|| = sqrt ( ||A||^2 + ||B||^2 - 2*A.B )
%
% Example:: 
%    A = rand(400,100); B = rand(400,200);
%    d = distance(A,B);
%
% Author::
%  Roland Bunschoten,
%  University of Amsterdam,
%  Intelligent Autonomous Systems (IAS) group,
%  Kruislaan 403  1098 SJ Amsterdam,
%  tel.(+31)20-5257524,
%  bunschot@wins.uva.nl
%  Last Rev : Oct 29 16:35:48 MET DST 1999
%  Tested   : PC Matlab v5.2 and Solaris Matlab v5.3
%  Thanx    : Nikos Vlassis

% Copyright notice: You are free to modify, extend and distribute 
%    this code granted that the author of the original code is 
%    mentioned as the original author of the code.

function d = distance(a,b)

if (nargin ~= 2)
   error('Not enough input arguments');
end

if (size(a,1) ~= size(b,1))
   error('A and B should be of same dimensionality');
end

aa=sum(a.*a,1); bb=sum(b.*b,1); ab=a'*b; 
d = sqrt(abs(repmat(aa',[1 size(bb,2)]) + repmat(bb,[size(aa,2) 1]) - 2*ab));
%        im2col                         - Convert an image to pixel per row format
%
% OUT = IM2COL(IM) returns the image as a pixel vector.  Each row is a pixel 
% value which is a P-vector where the image in NxMxP.  The pixels are in
% image column order and there are NxM rows.
%
% See also COL2IM.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.

function c = im2col(im)

    im = shiftdim(im, 2);

    if ndims(im) == 3,
        c = reshape(im, 3, [])';
    else
        c = reshape(im, 1, [])';
    end
%        imeshgrid                      - Domain matrices for image
%
% [U,V] = IMESHGRID(IM) return matrices that describe the domain of image IM
% and can be used for the evaluation of functions over the image. The 
% element U(v,u) = u and V(v,u) = v.
%
% [U,V] = IMESHGRID(W, H) as above but the domain is WxH.
%
% [U,V] = IMESHGRID(SIZE) as above but the domain is described size which is
% scalar SIZExSIZE or a 2-vector [W H].
%
% See also MESHGRID.

function [U,V] = imeshgrid(a1, a2)

    if nargin == 1
        if length(a1) == 1
            % we specified a size for a square output image
            [U,V] = meshgrid(1:a1, 1:a1);
        elseif length(a1) == 2
            % we specified a size for a rectangular output image (w,h)
            [U,V] = meshgrid(1:a1(1), 1:a1(2));
        elseif ndims(a1) >= 2
            [U,V] = meshgrid(1:numcols(a1), 1:numrows(a1));
        else
            error('incorrect argument');
        end
    elseif nargin == 2
        [U,V] = meshgrid(1:a1, 1:a2);
    end
%        iscolor                        - Test if argument is a color image
%
% ISCOLOR(IM) is true (1) if IM is a color image, that is, it has 3 or
% more dimensions.

function s = iscolor(im)
    s = isnumeric(im) && size(im,1) > 1 && size(im,2) > 1 && size(im,3) == 3;
%        isize                          - Return size of image
%
% N = ISIZE(IM,D) returns the size of the D'th dimension of IM.
%
% [H,W] = ISIZE(IM) returns the image height H and width W.
%
% [H,W,P] = ISIZE(IM) returns the image height H and width W and number of
% planes.
%
% See also SIZE.

function [o1,o2,o3] = isize(im, idx)

    if nargin == 2
        o1 = size(im, idx);
    else
        s = size(im);
        o1 = s(2);      % width, number of columns
        if nargout > 1
            o2 = s(1);  % height, number of rows
        end
        if nargout > 2
            if ndims(im) == 2
                o3 = 1;
            else
                o3 = s(3);
            end
        end
    end
%        kmeans                         - K-means clustering
%
% [L,C] = KMEANS(X, K, OPTIONS) performs K-means clustering for multi-dimensional data
% points X (NxD) where N is the number of points, and D is the dimension.  K is
% the number of clusters.  L is a vector (Nx1) whose elements indicates which 
% cluster the corresponding element of X belongs to.  The optional return
% value C (KxD) contains the cluster centroids.
%
% [L,C] = KMEANS(X, K, C0) as above but the initial clusters C0 (KxD) is given
% and row I is the initial estimate of the centre of cluster I.
%
% L = KMEANS(X, C) similar to above but the clustering step is not performed,
% it is assumed to have been completed previously.  C (KxD) contains the cluster
% centroids and L (Nx1) indicates which cluster the corresponding element of X
% is closest to.
%
% Options::
% 'random'   randomly choose K points from X
% 'spread'   randomly choose K values within the hypercube spanned
%            by X.
%
% Reference::
% Tou and Gonzalez,
% Pattern Recognition Principles,
% pp 94

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.

% add Kaufman initialization
%
% 1) Initialize c1 with the most centrally located input sample. 
% 2) For i = 2, . . . , K, each ci is initialized in the following 
% way: for each non-selected input sample xj , calculate its 
% summed distance to the other non-selected input samples xl , 
% who are closer to xj than to their respective nearest seed 
% clusters, 
% http://www.comp.nus.edu.sg/~tancl/Papers/IJCNN04/he04ijcnn.pdf
% http://citeseer.ist.psu.edu/398385.html

function [label,centroid,resid] = kmeans(x, K, varargin)
% TODO update doco for assignment mode
%      option to loop N times and take lowest residual
%      return residual from assignment mode
    deb = 0;

    n = numcols(x);
    
    if numcols(K) > 1 && numrows(x) == numrows(K)
        % kmeans(x, centres)
        % then return closest clusters
        label = closest(x, K);
        if nargout > 1
            centroid = K;
        end
        if nargout > 2
            resid = norm( x - K(:,label) );
        end
        return
    end

    opt.plot = false;
    opt.init = {'random', 'spread'};
    [opt,z0] = tb_optparse(opt, varargin);

    if opt.plot && numrow(x) > 3
        warning('cant plot for more than 3D data');
        opt.plot = false;
    end
    if ~isempty(z0)
        % an initial condition was supplied
        if numcols(z0) ~= K,
            error('initial cluster length should be k');
        end
        if numrows(z0) ~= numrows(x),
            error('number of dimensions of z0 must match dimensions of x');
        end
    else
        % determine initial condition
        if strcmp(opt.init, 'random')
            % select K points from the set given as initial cluster centres
            k = randi(n, K, 1);
            z0 = x(:,k);
        elseif strcmp(opt.init, 'spread')
            % select K points from within the hypercube defined by the points
            mx = max(x')';
            mn = min(x')';
            z0 = (mx-mn) * rand(1,K) + mn * ones(1,K);
        end
    end

    % z is the centroid
    % zp is the previous centroid
    % s is the vector of cluster labels corresponding to rows in x
    
    z = z0;
    

    %
    % step 1
    %
    zp = z;             % previous centroids
    s = zeros(1,n);
    sp = s;
    
    iterating = 1;
    k = 1;
    iter = 0;
    
    while iterating,
        iter = iter + 1;
        
        tic
        t0 = toc;

        %
        % step 2
        %

        s = closest(x, z);
                    
        %
        % step 3
        %
        for j=1:K
            k = find(s==j);
            if isempty(k)
                if strcmp(opt.init, 'random')
                    k = randi(n, 1, 1);
                    z0 = x(:,k);
                elseif strcmp(opt.init, 'spread')
                    % this cluster has no elements, randomly assign it
                    zp(:,j) = (mx-mn) * rand(1,1) + mn;
                end
            else
                % else, assign it to the mean of its elements
                zp(:,j) = mean( x(:,k)' );
                dd = sum( (repmat(zp(:,j),1,length(k)) - x(:,k)).^2 );
                dd = dd / numrows(x);
                maxerr(j) = max( sqrt(dd) );
            end
        end

        %
        % step 4
        %
        %  determine the change in cluster centres over the last step
        delta = sum( sum( (z - zp).^2 ) );

        if opt.verbose
            t = toc;
            fprintf('%d: norm=%g, delta=%g, took %.1f seconds\n', iter, mean(maxerr), delta, t);
        end

        if delta == 0,
            fprintf('delta to zero\n');
            iterating = 0;
        end
        z = zp;
        if opt.plot
            if numrows(z) == 2
                plot(z(1,:), z(2,:));
            else
                plot3(z(1,:), z(2,:), z(3,:));
            end
            pause(.1);
        end
        
        % if no point assignments changed then we are done
        if all(sp == s)
            fprintf('no point assignments changed\n');
            iterating = 0;
        end
        sp = s;
    end
    
    if nargout == 0
        % if no output arguments display results        
        if numrows(z) < 5
            for i=1:K,
                fprintf('cluster %d: %s (%d elements)\n', i, ...
                    sprintf('%11.4g ', z(i,:)), length(find(s==i)));
            end
        end
        
    end
    if nargout > 0
        centroid = z;
    end
    if nargout > 1
        label = s;
    end
    if nargout > 2
        % compute the residual
        resid = norm( x - z(:,s) );
    end

    dt = toc - t0;
    if dt > 10
        fprintf('that took %.1f seconds\n', dt);
    elseif dt > 60
        fprintf('that took %.1f minutes\n', dt/60);
    end
%        medfilt1                       - One-dimensional median filter
%
% Y = MEDFILT1(X, W) is the median filter of the signal X computed over a
% sliding window of width W.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.
function m = medfilt1(s, w)
    if nargin == 1,
        w = 5;
    end
    
    s = s(:)';
    w2 = floor(w/2);
    w = 2*w2 + 1;

    n = length(s);
    m = zeros(w,n+w-1);
    s0 = s(1); sl = s(n);

    for i=0:(w-1),
        m(i+1,:) = [s0*ones(1,i) s sl*ones(1,w-i-1)];
    end
    m = median(m);
    m = m(w2+1:w2+n);
%        ransac                         - Random sample and consensus
%
% M = RANSAC(FUNC, X, T, OPTIONS) robustly fit the data X to the function FUNC
% using the RANSAC algorithm.  X contains corresponding point data, one column
% per point pair.  RANSAC determines the subset of points (inliers) that best
% fit the model described by the function FUNC.  T is a threshold applied
% to the model FUNC applied to a data point, if too high the point is
% considered an outlier.
%
% [M,IN] = RANSAC(FUNC, X, T, OPTIONS) as above but returns the vector IN of
% column indices of X that describe the inlier point set.
%
% [M,IN,RESID] = RANSAC(FUNC, X, T, OPTIONS) as above but returns the final
% residual of applying FUNC to the inlier set.
%
% OUT = FUNC(R) is the function passed to RANSAC and it must accept 
% a single argument R which is a structure:
%
%   R.cmd      string      the operation to perform which is either
%   R.debug    logical     display what's going on
%   R.X        6xN         data to work on, N point pairs
%   R.t        1x1         threshold
%   R.theta    3x3         estimated quantity to test
%   R.misc     cell        private data
%
% The function return value is also a structure:
%
%   OUT.s           1x1         sample size
%   OUT.X           2DxN        conditioned data
%   OUT.misc        cell        private data
%   OUT.inlier      1xM         list of inliers
%   OUT.valid       logical     if data is valid for estimation
%   OUT.theta       3x3         estimated quantity
%   OUT.resid       1x1         model fit residual
%
% The values of R.cmd are:
%  'size'          return the minimum number of points required to compute
%                  an estimate to OUT.s
%  'condition'     condition the point data to X -> OUT.X
%  'decondition'   decondition the estimated model data to R.theta -> OUT.theta
%  'valid'         true if a set of points is not degenerate, that is they 
%                  will produce a model.  This is used to discard random samples
%                  that do not result in useful models  -> OUT.valid
%  'estimate'      [OUT.theta,OUT.resid] = EST(R.X) returns the best fit model 
%                  and residual for the subset of points R.X.  If this function 
%                  cannot fit a model then OUT.theta = [].  If multiple models
%                  are found OUT.theta is a cell array.
%  'error'         [OUT.inlier,OUT.theta] = ERR(R.theta,R.X,T) evaluates the 
%                  distance from the model(s) R.theta to the points R.X and
%                  returns the best model OUT.theta and the subset of R.X that 
%                  best supports (most inliers) that model.
%
% For some algorithms (eg. fundamental matrix) it is necessary to condition
% the data to improve the accuracy of model estimation.  The data transform
% parameters are kept in the .misc element and used in the final step to 
% transform the estimate based on conditioned data to original data, the
% deconditioning operation.
%
% Options::
% 'maxTrials',N     maximum number of iterations (default 2000)
% 'maxDataTrials',N maximum number of attempts to select a non-degenerate 
%                   data set (default 100)
%
% References::
%  - M.A. Fishler and  R.C. Boles. "Random sample concensus: A paradigm
%    for model fitting with applications to image analysis and automated
%    cartography". Comm. Assoc. Comp, Mach., Vol 24, No 6, pp 381-395, 1981
%
%  - Richard Hartley and Andrew Zisserman. "Multiple View Geometry in
%    Computer Vision". pp 101-113. Cambridge University Press, 2001
%
% Author::
%  Peter Kovesi
%  School of Computer Science & Software Engineering
%  The University of Western Australia
%  pk at csse uwa edu au    
%  http://www.csse.uwa.edu.au/~pk
%
% See also FMATRIX, HOMOGRAPHY.

% Copyright (c) 2003-2006 Peter Kovesi
% School of Computer Science & Software Engineering
% The University of Western Australia
% pk at csse uwa edu au    
% http://www.csse.uwa.edu.au/~pk
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in 
% all copies or substantial portions of the Software.
%
% The Software is provided "as is", without warranty of any kind.
%
% May      2003 - Original version
% February 2004 - Tidied up.
% August   2005 - Specification of distfn changed to allow model fitter to
%                 return multiple models from which the best must be selected
% Sept     2006 - Random selection of data points changed to ensure duplicate
%                 points are not selected.
% February 2007 - Jordi Ferrer: Arranged warning printout.
%                               Allow maximum trials as optional parameters.
%                               Patch the problem when non-generated data
%                               set is not given in the first iteration.
% August   2008 - 'feedback' parameter restored to argument list and other
%                 breaks in code introduced in last update fixed.
% December 2008 - Octave compatibility mods

function [M, inliers, resid] = ransac(fittingfn, x, t, varargin);

    %useRandomsample = ~exist('randsample');

    opt.maxTrials = 2000;
    opt.maxDataTrials = 100;

    opt = tb_optparse(opt, varargin);
    
    [rows, npts] = size(x);                 
    
    p = 0.99;         % Desired probability of choosing at least one sample
                      % free from outliers

    bestM = NaN;      % Sentinel value allowing detection of solution failure.
    trialcount = 0;
    bestscore =  0;    
    N = 1;            % Dummy initialisation for number of trials.
    
    out = invoke('size', fittingfn, opt.verbose, []);
    s = out.s;


    in.X = x;
    out = invoke('condition', fittingfn, opt.verbose, in);
    x = out.X;
    misc = out.misc;
    


    while N > trialcount
        
        % Select at random s datapoints to form a trial model, M.
        % In selecting these points we have to check that they are not in
        % a degenerate configuration.
        degenerate = 1;
        count = 1;
        while degenerate
            % Generate s random indicies in the range 1..npts
            % (If you do not have the statistics toolbox, or are using Octave,
            % use the function RANDOMSAMPLE from my webpage)
        if 0
	    if useRandomsample
            ind = randomsample(npts, s);
	    else
            ind = randsample(npts, s);
	    end
        else
            ind = randi(npts, 1, s);
        end

            % Test that these points are not a degenerate configuration.

            in.X = x(:,ind);
            out = invoke('valid', fittingfn, opt.verbose, in);
            degenerate = ~out.valid;
            
            if ~degenerate
                % Fit model to this random selection of data points.
                % Note that M may represent a set of models that fit the data in
                % this case M will be a cell array of models

                in.X = x(:,ind);
                out = invoke('estimate', fittingfn, opt.verbose, in);
                M = out.theta;
                
                % Depending on your problem it might be that the only way you
                % can determine whether a data set is degenerate or not is to
                % try to fit a model and see if it succeeds.  If it fails we
                % reset degenerate to true.
                if isempty(M)
                    degenerate = 1;
                end
            end
            
            % Safeguard against being stuck in this loop forever
            count = count + 1;
            if count > opt.maxDataTrials
                warning('Unable to select a nondegenerate data set');
                break
            end
        end
        
        % Once we are out here we should have some kind of model...        
        % Evaluate distances between points and model returning the indices
        % of elements in x that are inliers.  Additionally, if M is a cell
        % array of possible models 'distfn' will return the model that has
        % the most inliers.  After this call M will be a non-cell object
        % representing only one model.

        in.t = t;
        in.theta = M;
        in.X = x;
        out = invoke('error', fittingfn, opt.verbose, in);
        inliers = out.inliers;
        M = out.theta;
        
        % Find the number of inliers to this model.
        ninliers = length(inliers);
        
        if ninliers > bestscore    % Largest set of inliers so far...
            bestscore = ninliers;  % Record data for this model
            bestinliers = inliers;
            bestM = M;
            
            % Update estimate of N, the number of trials to ensure we pick, 
            % with probability p, a data set with no outliers.
            fracinliers =  ninliers/npts;
            pNoOutliers = 1 -  fracinliers^s;
            pNoOutliers = max(eps, pNoOutliers);  % Avoid division by -Inf
            pNoOutliers = min(1-eps, pNoOutliers);% Avoid division by 0.
            N = log(1-p)/log(pNoOutliers);
        end
        
        trialcount = trialcount+1;
        if opt.verbose > 1
            fprintf('trial %d out of %d         \r',trialcount, ceil(N));
        end

        % Safeguard against being stuck in this loop forever
        if trialcount > opt.maxTrials
            warning( ...
            sprintf('ransac reached the maximum number of %d trials',...
                    opt.maxTrials));
            break
        end     
    end
    fprintf('\n');
    
    if ~isnan(bestM)   % We got a solution 
        M = bestM;
        inliers = bestinliers;
    else           
        M = [];
        inliers = [];
        error('ransac was unable to find a useful solution');
    end

    % Now do a final least squares fit on the data points considered to
    % be inliers.
    [M,resid] = feval(fittingfn, x(:,inliers)); % with conditioned data

    % then decondition it
    in.theta = M;
    in.misc = misc;
    out = invoke('decondition', fittingfn, opt.verbose, in);
    M = out.theta;

    if opt.verbose || (nargout == 0)
        fprintf('%d trials\n', trialcount);
        fprintf('%d outliers\n', npts-length(inliers));
        fprintf('%g final residual\n', resid);
    end
end

function out = invoke(cmd, func, verbose, in)
    if isempty(in) || (nargin < 4)
        in = [];
    end
    in.debug = verbose > 1;
    in.cmd = cmd;
    
    if verbose > 2,
        fprintf('---------------------------------------------\n');
        in
    end
    out = feval(func, in);
    
    if verbose > 2,
        out
    end
end
%        zcross                         - Zero-crossing detector
%
% IZ = ZCROSS(IM) is a binary image with pixels set corresponding to 
% zero crossings in the signed image IM.  That is, pixels are set at positive
% pixels adajacent to a negative pixel.
%
% Notes::
% - can be used in association with a Lapalacian of Gaussian image to 
%   determine edges.
%
% See also ILOG.

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.

function iz = zcross(im)

    z = zeros([size(im), 4]);
    K = [1 1 0 ;1 1 0; 0 0 0];
    z(:,:,1) = conv2(im, K, 'same');
    K = [0 1 1 ;0 1 1; 0 0 0];
    z(:,:,2) = conv2(im, K, 'same');
    K = [0 0 0; 1 1 0 ;1 1 0];
    z(:,:,3) = conv2(im, K, 'same');
    K = [0 0 0; 0 1 1 ;0 1 1];
    z(:,:,4) = conv2(im, K, 'same');

    maxval = max(z, [], 3);
    minval = min(z, [], 3);

    iz = (maxval > 0) & (minval < 0);
%
% Copyright (C) 2011 Peter Corke
