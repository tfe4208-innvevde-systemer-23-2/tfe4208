#include <math.h>
#include <stdio.h>
#include <conio.h>
#include <stdlib.h>
#include "svd.h"


#define C 343.3  // Lydhastighet 
#define a 0.075  // Sidelengde tetraheder

inline static double sqr(double x) {
    return x*x;
}

//  double* time_delays = {0.008064, 0.80704, -3.2*10**(-5), -0.000256, 0.000128, 0.000352};

double **create_matrix(int m, int n){
    double **b = (double **)malloc(m * sizeof(double *));
    for (int i = 0; i < m; i++) {
        b[i] = (double *)malloc(n * sizeof(double));
    }
    return b;
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

void destroy_matrix(double** arr){
    free(*arr);
    free( arr);
}

double **transpose_matrix(int row, int column, double** matrix){
    double** transpose_matrix = create_matrix(row, column);
    for (int i = 0; i < row; i++){
        for (int j = 0; j < column; j++){
            transpose_matrix[i][j] = matrix[j][i];
        }
    }
    return transpose_matrix;
}


double** transpose_vector(int length, double vec[]){
    double** transpose_matrix = create_matrix(length, 1);
    for (int i = 0; i < length; i++){
        transpose_matrix[i][0] = vec[i]; 
    }
    return transpose_matrix;
}

double** matrix_mult(double** mat_a, double** mat_b, int m, int n){
    double **result = (double **)malloc(m * sizeof(double *));
    for (int i = 0; i < m; i++) {
        result[i] = (double *)malloc(n * sizeof(double));
    }
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            result[i][j] = 0;
            for (int k = 0; k < n; k++) {
                result[i][j] += mat_a[i][k] * mat_b[k][j];
            }
        }
    }
    return result;
}

// Functions above are tested and works! 

void gauss_jordan(){

};

int least_square(){
    return 0;
}





double theta(){
    double z_axis[3] = {0,0,1}; 
    double** z_axis_trans = transpose_vector(3, z_axis);
    for (size_t i = 0; i < 3; i++)
    {
        printf("Val: %d", z_axis_trans[i][0]);
    }
}

double** create_r(){
    double** r = create_matrix(6,3);
    r[0][0] = -0.5*a; r[0][1] = sqrt(3)*a/2; r[0][2] = 0;
    r[1][0] = -a;     r[1][1] = 0;           r[1][2] = 0;
    r[2][0] = -0.5*a; r[2][1] = a*sqrt(3)/6; r[2][2] =  sqrt(2*a/3);
    r[3][0] = -0.5*a; r[3][1] = sqrt(3)*a/2; r[3][2] = 0;
    r[4][0] = 0;      r[4][1] = sqrt(3)*a/3; r[4][2] = sqrt(2*a/3);
    r[5][0] = 0.5*a;  r[5][1] = sqrt(3)*a/6; r[5][2] = sqrt(2*a/3);    
    return r; 
}

int main(){
    printf("Nepe\n");
    double** r       = create_r();
    double* sigma;
    double** V       = create_matrix(3,3);
    double** X       = create_matrix(6,3);
    for (int i = 0; i < 6; i++) {
        for (int j = 0; j < 3; j++) {
            X[i][j] = r[i][j] / C;
        }
    } 

    svdcmp(X,6,3,sigma,V);
    printf("Test 2 baby\n");
    printf("%f", V[0][0]);

   
    return 0;
}