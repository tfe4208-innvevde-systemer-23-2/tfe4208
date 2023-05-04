#include <math.h>
#include <stdio.h>
#include <stdlib.h>

int **matrix_multiply(int **a, int **b, int m, int n, int p) {
    int **result = (int **)malloc(m * sizeof(int *));
    for (int i = 0; i < m; i++) {
        result[i] = (int *)malloc(p * sizeof(int));
    }

    for (int i = 0; i < m; i++) {
        for (int j = 0; j < p; j++) {
            result[i][j] = 0;
            for (int k = 0; k < n; k++) {
                result[i][j] += a[i][k] * b[k][j];
            }
        }
    }

    return result;
}

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

int main() {
    int m = 2, n = 3, p = 2;
    int **a = (int **)malloc(m * sizeof(int *));
    for (int i = 0; i < m; i++) {
        a[i] = (int *)malloc(n * sizeof(int));
    }
    a[0][0] = 1; a[0][1] = 2; a[0][2] = 3;
    a[1][0] = 4; a[1][1] = 5; a[1][2] = 6;

    int **b = (int **)malloc(n * sizeof(int *));
    for (int i = 0; i < n; i++) {
        b[i] = (int *)malloc(p * sizeof(int));
    }
    b[0][0] = 7; b[0][1] = 8;
    b[1][0] = 9; b[1][1] = 10;
    b[2][0] = 11; b[2][1] = 12;

    int **result = matrix_multiply(a, b, m, n, p);

    printf("Result:\n");
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < p; j++) {
            printf("%d ", result[i][j]);
        }
        printf("\n");
    }

    for (int i = 0; i < m; i++) {
        free(a[i]);
        free(result[i]);
    }
    free(a);
    free(result);

    for (int i = 0; i < n; i++) {
        free(b[i]);
    }
    free(b);

    return 0;
}

