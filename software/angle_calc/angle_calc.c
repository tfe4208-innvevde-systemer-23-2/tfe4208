#include <math.h>
#include <stdio.h>
#include <conio.h>
#include <stdlib.h>
#include "svd.h"
//#include "matrix.h"


#define C 343.3  // Lydhastighet 
#define a 0.075  // Sidelengde tetraheder

void transpose_matrix(int row, int column, double** matrix){
    double** transpose_matrix = dmatrix(1,row,1,column);
    for (int i = 1; i <= row; i++){
        for (int j = 1; j <= column; j++){
            transpose_matrix[i][j] = matrix[j][i];
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

void print_matrix(double** matrix, int m, int n){
    printf("Result:\n");
    for (int i = 1; i < m+1; i++) {
        for (int j = 1; j < n+1; j++) {
            printf("%f ", matrix[i][j]);
        }
        printf("\n");
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

void calculate_x(double** v, double** u, double* sigma, double** delays, double** result){
    int i, j, k;
    double** temp = dmatrix(1,3,1,1);
    double** temp2 = dmatrix(1,6,1,1);


     // Ganger sammen v og u 
    for (i = 1; i <= 3; i++) {
        for (j = 1; j <= 3; j++) {
            for (k = 1; k <= 3; k++) {
                temp[i-1][0] += v[i][k] * u[k][j];
            }
        }
    }

    // legger sammen sigma 
    for (i = 1; i <= 3; i++) {
        for (j = 1; j <= 1; j++) {
            for (k = 1; k <= 1; k++) {
                temp2[i-1][0] += temp[i-1][0] * sigma[k];
            }
        }
    }

       // Multiply the second vector
    for (i = 4; i <= 6; i++) {
        for (j = 1; j <= 1; j++) {
            for (k = 1; k <= 1; k++) {
                temp2[i-1][0] += delays[i-4][k] * sigma[k];
            }
        }
    }

    // Calculate the sum of the elements in the second vector
    double sum = 0;
    for (i = 1; i <= 6; i++) {
        sum += temp2[i-1][0];
    }

    // Store the final result in the result array
    for (i = 1; i <= 3; i++) {
        for (j = 1; j <= 1; j++) {
            result[i][j] = temp[i-1][0] + sum;
        }
    }
}


int main(){
    //printf("Nepe\n");
    double** u = dmatrix(1,6,1,3);
    create_r(u);
    double* sigma =dvector(1,6);
    //Matrix* r = mXcreate(6,3);
    //create_r(r);
    double** v = dmatrix(1,3,1,3);
    //Matrix* X = mXtranspose(r);
    svdcmp(u,6,3,sigma,v);
    double** new_u = dmatrix(1, 3, 1, 6 );
    retireve_part_of_matrix(u, new_u , 3, 6);
    double* sigma_inv = dvector(1,3);
    for (int i = 1; i < 4; i++)
    {
        sigma_inv[i] = ( 1 / sigma[i]);
    }
    transpose_matrix(3,6,u);

    // Calculate x 
    double** x = dmatrix(1,3,1,1); 
    
    double** delays = dmatrix(1,6,1,1);
    delays[1][1] = 0.008064;
    delays[2][1] = 0.80704;
    delays[3][1] = - 0.000032;
    delays[4][1] = -0.000256;
    delays[5][1] = 0.000128;
    delays[6][1] = 0.000352;

    calculate_x(v, new_u, sigma_inv, delays, x);

    print_matrix(x, 3,1);



    
    printf("Main done");
    

    return 0;
}