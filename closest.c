/* closest.c
 *
 * Fast matching of points in N-dimensional space.
 *
 *	K = CLOSEST(A, B)
 *
 *   A is N X NA
 *   B is N x NB
 *
 *   K is 1 x NA and the element J = K(I) indicates that the Ith column of A is closest
 * to the Jth column of B.  That is, A(:,I) is closest to B(:,J).
 */
#include "mex.h"
#include <math.h>

/* Input Arguments */

#define	A_IN		prhs[0]
#define	B_IN		prhs[1]

/* Output Arguments */

#define	K_OUT	plhs[0]
#define	D_OUT	plhs[1]

void
mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    int     nA, nB, N;
    int     i, j;

	/* Check for proper number of arguments */

    if (nrhs != 2) {
		mexErrMsgTxt("CLOSEST requires two input arguments.");
	}

    if (mxGetM(A_IN) != mxGetM(B_IN)) {
		mexErrMsgTxt("Input arguments must have the same number of rows");
    }
    if (mxGetClassID(A_IN) != mxGetClassID(B_IN)) {
		mexErrMsgTxt("Input arguments must have the same type");
    }

    N = mxGetM(A_IN);
    nA = mxGetN(A_IN);
    nB = mxGetN(B_IN);

    if (mxGetClassID(A_IN) == mxDOUBLE_CLASS) {
        /*****************************************************
         *      double precision
         *****************************************************/
        double	*A, *B, *B0, *K, *D;
        double	*bins, *binnum;

        A = mxGetPr(A_IN);
        B0 = B = mxGetPr(B_IN);

        K_OUT = mxCreateDoubleMatrix(1, nA, mxREAL);
        K = mxGetPr(K_OUT);

        if (nlhs == 2) {
            D_OUT = mxCreateDoubleMatrix(1, nA, mxREAL);
            D = mxGetPr(D_OUT);
        }

        for (i=0; i<nA; i++) {
            double  min;
            int     which;

            min = mxGetInf();

            for (j=0, B=B0; j<nB; j++) {
                register double t=0, d, *p1, *p2;
                register int    k;

                for (k=0, p1=A, p2=B; k<N; k++) {
                    d = (*p1++ - *p2++);
                    t += d*d;
                    /*
                    if (t > min)
                        goto shortcut;
                    */
                }
                if (t<min) {
                    min = t;
                    which = j;
                }
    shortcut:
                B += N; // step through columns of B
            }
            K[i] = which+1;

            // optionally save the distance between the points
            if (nlhs == 2)
                D[i] = min;

            A += N; // step through columns of A
        }
    } else if (mxGetClassID(A_IN) == mxSINGLE_CLASS) {
        /*****************************************************
         *      single precision
         *****************************************************/
        float	*A, *B, *B0, *K, *D;
        float	*bins, *binnum;

        A = (float *)mxGetPr(A_IN);
        B0 = B = (float *)mxGetPr(B_IN);

        K_OUT = mxCreateNumericMatrix(1, nA, mxSINGLE_CLASS, mxREAL);
        K = (float *)mxGetPr(K_OUT);

        if (nlhs == 2) {
            D_OUT = mxCreateNumericMatrix(1, nA, mxSINGLE_CLASS, mxREAL);
            D = (float *)mxGetPr(D_OUT);
        }

        for (i=0; i<nA; i++) {
            float  min;
            int     which;

            min = mxGetInf();

            for (j=0, B=B0; j<nB; j++) {
                register float t=0, d, *p1, *p2;
                register int    k;

                for (k=0, p1=A, p2=B; k<N; k++) {
                    d = (*p1++ - *p2++);
                    t += d*d;
                    /*
                    if (t > min)
                        goto shortcut2;
                    */
                }
                if (t<min) {
                    min = t;
                    which = j;
                }
    shortcut2:
                B += N; // step through columns of B
            }
            K[i] = which+1;

            // optionally save the distance between the points
            if (nlhs == 2)
                D[i] = min;

            A += N; // step through columns of A
        }
    }
}
