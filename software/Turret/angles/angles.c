#include <math.h>
#include <stdio.h>
#include <conio.h>
#include <stdlib.h>
#include "svd.h"
#include "angles.h"

void transpose_matrix(int row, int column, double** matrix, double** transpose_matrix){
    for (int i = 1; i < row+1; i++){
        for (int j = 1; j < column+1; j++){
            transpose_matrix[i][j] = matrix[j][i];
            //printf("Transpose[%d][%d]: %f\n", i,j,transpose_matrix[i][j]);
            //printf("Matrix   [%d][%d]: %f\n", j,i,matrix[j][i]);
        }
    }
}

void print_nxnmatrix(double** mat, int n){
    for (int i = 1; i<n+1;i++){
        for (int j = 1; j < n+1; j++)
        {
            printf("Mat[%d][%d]: %f\n", i,j,mat[i][j]);
        }   
    }
}

void destroy_matrix(double** arr){
    free(*arr);
    free( arr);
}

void print_matrix(double** matrix, int m, int n){
    printf("Result:\n");
    for (int i = 1; i < m+1; i++) {
        for (int j = 1; j < n+1; j++) {
            printf("Mat[%d][%d]: %f\n", i,j,matrix[i][j]);
        }
        printf("\n");
    }
}

void matrix_mult(double** mat_a, double** mat_b, double** result, int m, int n, int p){
    for (int i = 1; i <= n; i++) {
        for (int j = 1; j <= m; j++) {
            result[i][j] = 0;
            for (int k = 1; k <= p; k++) {
                result[i][j] += mat_a[i][k] * mat_b[k][j];
            }
        }
    }
}

void matrix_mult_test(double** mat_a, double** mat_b, double** result, int m, int n, int n_2){
    for (int i = 1; i <= m; i++) {
        for (int j = 1; j <= n_2; j++) {
            result[i][j] = 0;
            for (int k = 1; k <= n; k++) {
                result[i][j] += mat_a[i][k] * mat_b[k][j];
            }
        }
    }
}

void create_r(double** r){
    r[1][1] = -0.5*a / C; r[1][2] = sqrt(3)*a/2 / C; r[1][3] = 0;
    r[2][1] = -a     / C; r[2][2] = 0           / C; r[2][3] = 0;
    r[3][1] = -0.5*a / C; r[3][2] = a*sqrt(3)/6 / C; r[3][3] = sqrt(2*a/3) / C;
    r[4][1] = -0.5*a / C; r[4][2] = sqrt(3)*a/2 / C; r[4][3] = 0;
    r[5][1] = 0      / C; r[5][2] = sqrt(3)*a/3 / C; r[5][3] = sqrt(2*a/3) / C;
    r[6][1] = 0.5*a  / C; r[6][2] = sqrt(3)*a/6 / C; r[6][3] = sqrt(2*a/3) / C;
}

void retireve_part_of_matrix(double** matrix, double** new, int row_m, int column_n){ 
    for (int i = 1; i < row_m; i++)
    {
        for (int j = 1; j < column_n; j++)
        {
            new[i][j] = matrix[i][j];
        }
    }
}

void calculate_x(double** V, double** U, double** Sigma, double** delays, double** result){
    int i, j, k;
    double** temp = dmatrix(1,3,1,3);
    double** temp2 = dmatrix(1,3,1,6);

    
    // Ganger sammen v og sigma 
    matrix_mult_test(V,Sigma, temp, 3,3,3);
    printf("Første mult complete\n");

    
    print_matrix(temp, 3,3);

    // Ganger så inn U_T 
    matrix_mult_test(temp, U, temp2, 3,3,6);
    printf("Andre mult complete\n");

    print_matrix(temp2, 3,6);

    // Ganger inn tallene 

    matrix_mult_test(temp2, delays, result, 3,6,1);
    printf("Tredje mult complete\n");

    destroy_matrix(temp);
    destroy_matrix(temp2);

}

double rad2deg(double radians){
    return radians * (180 / PI); 
}

double theta(double** r){
    double** new_r = dmatrix(1,3,1,1);
    matrix_mult_test(r,r,new_r,3,1,3);
    double length_r = sqrt(new_r[1][1]); 
    return rad2deg(acos(r[1][3] / (length_r)));
}

double phi(double** r){
    return rad2deg(atan2(r[1][1], r[1][2]));
}


int main(){
    printf("Nepe\n");
    double** u = dmatrix(1,6,1,3);
    create_r(u);
    double* sigma =dvector(1,3);
    //Matrix* r = mXcreate(6,3);
    //create_r(r);
    double** v = dmatrix(1,3,1,3);
    //Matrix* X = mXtranspose(r);
    svdcmp(u,6,3,sigma,v);
    printf("SVD++ complete\n");
   

    

    double** u_t = dmatrix(1,3,1,6);
    //print_matrix(u, 6,3);
    transpose_matrix(3,6,u, u_t);
    //print_matrix(u_t, 3,6);
    destroy_matrix(u);

    double** v_t = dmatrix(1,3,1,3);
    transpose_matrix(3,3,v,v_t);
    printf("v\n");
    print_matrix(v,3,3);
    //destroy_matrix(v);

    double** sigma_inv = dmatrix(1,3,1,3);
    for (int i = 1; i < 4; i++){
        for (int j = 1; j < 4; j++){
            sigma_inv[i][j]     = 0;
            sigma_inv[i][i]     = ( 1 / sigma[i]);
        }
    }
    printf("Sigma_inv:\n");
    print_matrix(sigma_inv,3,3);
        
    free_dvector(sigma,1,3);
   
    // Calculate x 
    double** x = dmatrix(1,3,1,1); 
    
    double** delays = dmatrix(1,6,1,1);
    delays[1][1] = 0.008064;
    delays[2][1] = 0.80704;
    delays[3][1] = - 0.000032;
    delays[4][1] = -0.000256;
    delays[5][1] = 0.000128;
    delays[6][1] = 0.000352;
    printf("Pre calc X\n");

    calculate_x(v, u_t, sigma_inv, delays, x);
    printf("Post calc x\n");

    printf("Theta: %f\n", theta(x));
    printf("Phi  : %f\n", phi(x));


    print_matrix(x, 3,1);

    destroy_matrix(x);
    destroy_matrix(delays);
    destroy_matrix(v);
    destroy_matrix(u);
    destroy_matrix(sigma_inv);
    printf("Main done");
    

    return 0;
}