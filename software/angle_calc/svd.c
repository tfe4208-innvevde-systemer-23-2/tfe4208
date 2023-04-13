#include <stdio.h>
#include <stdlib.h>
#include <math.h>

/*
Example function to calculate singular value decompostion for 2D-arrays. 
Hopefully don't need to use this :) s
*/

/* Function to perform SVD on a matrix */
int svd(double *A, int m, int n, double *U, double *S, double *V,double* singular_values) {
    int i, j, k, l, p, q;
    int n_iter = 100;
    double tol = 1e-6;
    double *e, *work;
    double c, f, g, h, s, x, y, z;
    double *pA, *pU, *pVt, *pVt_swap, *pVt_k, tmp;;
    int n_singular = (m < n) ? m : n;
    
    e = (double*)malloc(n*sizeof(double));
    work = (double*)malloc(n*sizeof(double));

    /* Initialize U, S, and Vt */
    pA = A;
    pU = U;
    pVt = V;
    for (i = 0; i < m*n; i++) {
        pU[i] = 0.0;
    }
    for (i = 0; i < n*n; i++) {
        pVt[i] = 0.0;
    }
    for (i = 0; i < n; i++) {
        S[i] = 0.0;
    }

    /* Bidiagonalization using Householder transformations */
    for (i = 0; i < n; i++) {
        /* Copy the i-th column to work */
        pA = A + i*m;
        pVt[i*n+i] = 1.0;
        h = 0.0;
        for (j = i; j < m; j++) {
            h += pA[j]*pA[j];
        }
        if (h < tol) {
            e[i] = 0.0;
        } else {
            e[i] = sqrt(h);
            if (pA[i] < 0.0) {
                e[i] = -e[i];
            }
            h += pA[i]*e[i];
            pA[i] -= e[i];
            for (j = i+1; j < n; j++) {
                f = 0.0;
                for (k = i; k < m; k++) {
                    f += pA[k]*A[j*m+k];
                }
                f /= h;
                for (k = i; k < m; k++) {
                    A[j*m+k] -= f*pA[k];
                }
            }
        }
        S[i] = e[i];
        pA[i] = h;
        /* Apply Householder transformation to the remaining columns */
        if (i < n-1) {
            pA = A + i*m;
            for (j = i+1; j < n; j++) {
                pVt[i*n+j] = pA[j];
            }
            for (j = i; j < m; j++) {
                pU[i*m+j] = pA[j]/h;
            }
            f = pA[i+1];
            g = e[i+1];
            for (j = i+1; j < n-1; j++) {
                work[j] = 0.0;
            }
            for (j = i+1; j < n; j++) {
                s = (f*pVt[(i+1)*n+j] + g*pVt[i*n+j])/h;
                for (k = i+1; k < m; k++) {
                    work[k] += s*pA[k];
                }
                for (k = i+1; k < n; k++) {
                            pVt[i*n+k] += s*pVt[(i+1)*n+k];
            }
            e[i+1] = pVt[i*n+(i+1)];
            pVt[i*n+(i+1)] = 0.0;
            if (fabs(e[i+1]) < tol) {
                continue;
            }
            f = e[i+1];
            g = pVt[(i+1)*n+(i+1)];
            h = sqrt(f*f + g*g);
            if (g < 0.0) {
                h = -h;
            }
            e[i+1] = h;
            s = f/h;
            g = g/h;
            pVt[(i+1)*n+(i+1)] = g;
            for (k = i+2; k < n; k++) {
                work[k] = 0.0;
            }
            for (k = i+1; k < m; k++) {
                pA[k] = pU[i*m+k];
            }
            for (j = i+1; j < n; j++) {
                f = pVt[(i+1)*n+j];
                s = (f*g + pVt[i*n+j]*s)/h;
                pVt[i*n+j] = pVt[i*n+j]*g - f*s;
                for (k = i+1; k < m; k++) {
                    work[k] += s*pU[j*m+k];
                }
            }
            for (j = i+1; j < n; j++) {
                g = work[j];
                for (k = i+1; k < m; k++) {
                    pU[j*m+k] -= g*pA[k];
                }
            }
        }
    }
}

/* Diagonalization using iterative QR algorithm */
for (k = n-1; k >= 0; k--) {
    for (n_iter = 0; n_iter < 100; n_iter++) {
        for (l = k; l >= 0; l--) {
            if (fabs(e[l]) <= tol) {
                break;
            }
            if (fabs(S[l-1]) <= tol) {
                break;
            }
        }
        if (l == k) {
            break;
        }
        pVt = V + l*n;
        if (fabs(pVt[l-1]) > tol) {
            g = S[l-1];
            h = S[l];
            f = (pVt[l-1]*e[l] - g*e[l-1])/h;
            g = pVt[l]*h;
            s = sqrt(f*f + g*g);
            f = f/s;
            g = g/s;
            h = pVt[l-1]*g - e[l-1]*f;
            for (i = l; i < n; i++) {
                e[i-1] = 0.0;
            }
            e[l-1] = s;
            pVt[l-1] = f;
            pVt[l] = g;
            for (i = 0; i < m; i++) {
                pU[l*m+i] = pU[l*m+i] - f*pU[(l-1)*m+i] - g*pU[l*m+i];
            }
        } else {
            e[l-1] = 0.0;
        }
    }
    if (S[k] < 0.0) {
        S[k] = -S[k];
    for (i = 0; i <= k; i++) {
        pVt[i*n+k] = -pVt[i*n+k];
}
}
}

/* Sort singular values in descending order */
for (i = 0; i < n-1; i++) {
    k = i;
    for (j = i+1; j < n; j++) {
        if (S[j] > S[k]) {
            k = j;
        }
    }
    if (k != i) {
        tmp = S[i];
        S[i] = S[k];
        S[k] = tmp;
        pVt_swap = V + i*n;
        pVt_k = V + k*n;
        for (j = 0; j < m; j++) {
            tmp = pVt_swap[j];
            pVt_swap[j] = pVt_k[j];
            pVt_k[j] = tmp;
        }
    }
}

/* Transpose Vt to obtain V */
for (i = 0; i < n; i++) {
    for (j = i+1; j < n; j++) {
        tmp = pVt[i*n+j];
        pVt[i*n+j] = pVt[j*n+i];
        pVt[j*n+i] = tmp;
    }
}

/* Copy singular values to output array */
for (i = 0; i < n_singular; i++) {
    singular_values[i] = S[i];
}

/* Copy U and V to output arrays */
for (i = 0; i < m*n; i++) {
    U[i] = pU[i];
    V[i] = pVt[i];
}

free(pA);
free(e);
free(work);
free(S);
}