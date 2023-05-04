#ifndef __ANGLES_H__
#define __ANGLES_H__

#include "../peripheral/peripheral.h"

#define PI 3.1415926535

double **create_matrix(int m, int n);
void matrix_mult(double** mat_a, double** mat_b, double** result, int m, int n, int n_2);
void print_matrix(double** matrix, int m, int n);
void pseudo_inv(double** matrix);
double rad2deg(double radians);
double theta(double** r);
double phi(double** r);
void get_angles_from_correlation(peripheral_lags* lags, double** matrise, double** delays, double** r, double* angles);

#endif
