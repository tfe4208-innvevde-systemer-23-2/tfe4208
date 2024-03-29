#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include "angles.h"

double **create_matrix(int m, int n){
    double **b = (double **)malloc(m * sizeof(double *));
    for (int i = 0; i < m; i++) {
        b[i] = (double *)malloc(n * sizeof(double));
    }
    return b;
}

void matrix_mult(double** mat_a, double** mat_b, double** result, int m, int n, int n_2){
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n_2; j++) {
            result[i][j] = 0;
            for (int k = 0; k < n; k++) {
                result[i][j] += mat_a[i][k] * mat_b[k][j];
            }
        }
    }
}

void print_matrix(double** matrix, int m, int n){
    printf("Result:\n");
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            printf("%f ", matrix[i][j]);
        }
        printf("\n");
    }
}


void pseudo_inv(double** matrix){
    matrix[0][0] = -1.14433333e+03;   matrix[0][1] =-2.28866667e+03 ;matrix[0][2] =-1.14433333e+03 ;matrix[0][3] = -1.14433333e+03;matrix[0][4] =0 ;              matrix[0][5] = 1.14433333e+03 ;
    matrix[1][0] =  1.98204347e+03;   matrix[1][1] =-1.58125177e-13 ;matrix[1][2] = 6.60681158e+02 ;matrix[1][3] = -1.98204347e+03;matrix[1][4] =-1.32136232e+03 ;matrix[1][5] = 6.60681158e+02 ;
    matrix[2][0] = -6.66014676e-14;   matrix[2][1] =-2.20900587e-14 ;matrix[2][2] = 5.11761424e+02 ;matrix[2][3] = -2.64113245e-14;matrix[2][4] = 5.11761424e+02 ;matrix[2][5] = 5.11761424e+02 ;
}

double rad2deg(double radians){
    return radians * (180 / PI); 
}

double theta(double** r){
    double length_r = sqrt(pow(r[0][0], 2) + pow(r[1][0], 2) + pow(r[2][0], 2));
    if (length_r != 0.0) {
    	return rad2deg(acos(r[2][0] / (length_r)));
    }
    else {
    	return 180.0;
    }
}

double phi(double** r){
    return rad2deg(atan2(r[0][0], r[1][0]));
}

void get_angles_from_correlation(peripheral_lags* lags, double** matrise, double** delays, double** r, double* angles) {
    delays[0][0] = lags->t01;
    delays[1][0] = lags->t02;
    delays[2][0] = lags->t03;
    delays[3][0] = lags->t12;
    delays[4][0] = lags->t13;
    delays[5][0] = lags->t23;


    matrix_mult(matrise,delays,r, 3,6,1);

    double t = theta(r);
    double p = phi(r);

    angles[0] = t;
    angles[1] = p;

}
