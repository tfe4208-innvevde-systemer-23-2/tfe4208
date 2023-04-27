#ifndef __ANGLES_H__
#define __ANGLES_H__

#include "../peripheral/peripheral.h"

#define C 343.3  // Lydhastighet 
#define a 0.075  // Sidelengde tetraheder
#define PI 3.1415926535

void transpose_matrix(int row, int column, double **matrix, double **transpose_matrix);
void print_nxnmatrix(double **mat, int n);
void destroy_matrix(double **arr);
void print_matrix(double **matrix, int m, int n);
void matrix_mult(double **mat_a, double **mat_b, double **result, int m, int n, int p);
void matrix_mult_test(double **mat_a, double **mat_b, double **result, int m, int n, int n_2);
void create_r(double **r);
void retireve_part_of_matrix(double **matrix, double **new, int row_m, int column_n);
void calculate_x(double **V, double **U, double **Sigma, double **delays, double **result);
double rad2deg(double radians);
double theta(double **r);
double phi(double **r);
int *get_angles_from_correlation(peripheral_lags lags);

#endif
