#ifndef SVD
#define SVD

#include <stdint.h>

#define NR_END 1
#define FREE_ARG char*
#define SIGN(a,b) ((b) >= 0.0 ? fabs(a) : -fabs(a))

static double dmaxarg1;
static double dmaxarg2;
#define DMAX(a,b) (dmaxarg1=(a),dmaxarg2=(b),(dmaxarg1) > (dmaxarg2) ? (dmaxarg1) : (dmaxarg2))

static int iminarg1;
static int iminarg2;
#define IMIN(a,b) (iminarg1=(a),iminarg2=(b),(iminarg1) < (iminarg2) ? (iminarg1) : (iminarg2))

double **dmatrix(int nrl, int nrh, int ncl, int nch);
double *dvector(int nl, int nh);
void free_dvector(double *v, int nl, int nh);
double pythag(double a, double b);

void svdcmp(double **a, int m, int n, double* w, double **v);

#endif


