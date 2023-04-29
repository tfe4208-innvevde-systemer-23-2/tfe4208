#include <math.h>
#include <stdio.h>
#include <stdlib.h>

double **create_matrix(int m, int n){
    double **b = (double **)malloc(m * sizeof(double *));
    for (int i = 0; i < m; i++) {
        b[i] = (double *)malloc(n * sizeof(double));
    }
    return b;
}

void matrix_mult_test(double** mat_a, double** mat_b, double** result, int m, int n, int n_2){
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n_2; j++) {
            result[i][j] = 0;
            for (int k = 0; k < n; k++) {
                result[i][j] += mat_a[i][k] * mat_b[k][j];
            }
        }
    }
}


void pseudo_inv(double** matrix){
    matrix[0][0] = -1.14433333e+03;   matrix[0][1] =-2.28866667e+03 ;matrix[0][2] =-1.14433333e+03 ;matrix[0][3] = -1.14433333e+03;matrix[0][4] =0 ;              matrix[0][5] = 1.14433333e+03 ;
    matrix[1][0] =  1.98204347e+03;   matrix[1][1] =-1.58125177e-13 ;matrix[1][2] = 6.60681158e+02 ;matrix[1][3] = -1.98204347e+03;matrix[1][4] =-1.32136232e+03 ;matrix[1][5] = 6.60681158e+02 ;
    matrix[2][0] = -6.66014676e-14;   matrix[2][1] =-2.20900587e-14 ;matrix[2][2] = 5.11761424e+02 ;matrix[2][3] = -2.64113245e-14;matrix[2][4] = 5.11761424e+02 ;matrix[2][5] = 5.11761424e+02 ;
}


int main(){
    double** matrise = create_matrix(3,6);
    pseudo_inv(matrise);

    // Legg til delays for testing
    double** delays = create_matrix(1,6);
    double delaysx[] = {-0.010272, -0.000128, -0.000416, 0.005472, 0.0, -0.000288};
    for (int i = 0; i < 6; i++)
    {
        delays[i][1] = delaysx[i];
    }
    double** r = create_matrix(1,3);
    matrix_mult_test(matrise,delays,r, 3,3,3);

    
}

