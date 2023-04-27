#ifndef __ANGLES_H__
#define __ANGLES_H__

#include "../peripheral/peripheral.h"


void transpose_matrix(int row, int column, double **matrix, double **transpose_matrix);
void print_nxnmatrix(double **mat, int n);
void destroy_matrix(double** arr, int low, int high);
void print_matrix(double **matrix, int m, int n);
void matrix_mult(double **mat_a, double **mat_b, double **result, int m, int n, int p);
void matrix_mult_test(double **mat_a, double **mat_b, double **result, int m, int n, int n_2);
void create_r(double **r);
void retireve_part_of_matrix(double **matrix, double **new, int row_m, int column_n);
void calculate_x(double **V, double **U, double **Sigma, double **delays, double **result);
double rad2deg(double radians);
void dmatrixFill(double **m, int nrl, int nrh, int ncl, int nch);
double theta(double **r, double** new_r);
double phi(double **r);
void get_angles_from_correlation(peripheral_lags lags, int *angles, double** x, double** delays, double** v_t, double** u_t, double** sigma_inv, double** temp, double** temp2, double** new_r);

#endif
