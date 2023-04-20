#include <math.h>
#include <stdio.h>
#include <conio.h>
#include <stdlib.h>
#include "svd.h"
//#include "matrix.h"


#define C 343.3  // Lydhastighet 
#define a 0.075  // Sidelengde tetraheder


//void create_r(Matrix* r){
//    r->values[0][0] = -0.5*a / C; r->values[0][1] = sqrt(3)*a/2 / C; r->values[0][2] = 0;
//    r->values[1][0] = -a     / C; r->values[1][1] = 0           / C; r->values[1][2] = 0;
//    r->values[2][0] = -0.5*a / C; r->values[2][1] = a*sqrt(3)/6 / C; r->values[2][2] = sqrt(2*a/3) / C;
//    r->values[3][0] = -0.5*a / C; r->values[3][1] = sqrt(3)*a/2 / C; r->values[3][2] = 0;
//    r->values[4][0] = 0      / C; r->values[4][1] = sqrt(3)*a/3 / C; r->values[4][2] = sqrt(2*a/3) / C;
//    r->values[5][0] = 0.5*a  / C; r->values[5][1] = sqrt(3)*a/6 / C; r->values[5][2] = sqrt(2*a/3) / C;    
//    return r->values; 
//}

void print_nxnmatrix(double** mat, int n){
    for (int i = 1; i<n+1;i++){
        for (int j = 1; j < n+1; j++)
        {
            printf("Mat[%d][%d]: %f\n", i,j,mat[i][j]);
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

int main(){
    printf("Nepe\n");

    double** r = dmatrix(1,6,1,3);
    create_r(r);
    double* sigma =dvector(1,6);
    //Matrix* r = mXcreate(6,3);
    //create_r(r);
    double** v = dmatrix(1,3,1,3);
    //Matrix* X = mXtranspose(r);

    svdcmp(r,6,3,sigma,v);
    printf("Test 2 baby\n");
    print_nxnmatrix(v,3);
    printf("Main done");
    

    return 0;
}