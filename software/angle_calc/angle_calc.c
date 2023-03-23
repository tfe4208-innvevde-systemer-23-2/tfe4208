#include <math.h>
#include <stdio.h>
#include <stdlib.h>


#define C 343.3  // Lydhastighet 
#define a 0.075  // Sidelengde tetraheder

float** transpose_matrix(int row, int column, float** matrix){
    float** transpose_matrix;
    for (int i = 0; i < row; i++){
        for (int j = 0; j < column; j++){
            transpose_matrix[j][i] = matrix[i][j];
        }
    }
    return transpose_matrix;
}

float** transpose_vector(int length, float* vec){
    float** transpose_vec;
    for (int i = 0; i < length; i++){
        transpose_vec[0][length - i] = vec[i]; 
    }
    return transpose_vec;
    
}

void destroy_array(float** arr){
    free(*arr);
    free( arr);
}

int least_square(){
    return 0;
}

float** matrix_mult(float** mat_a, float** mat_b){
    return NULL;
}

float theta(){
    float z_axis[3] = {0,0,1}; 
    float** z_axis_trans = transpose_vector(3, z_axis);
    for (size_t i = 0; i < 3; i++)
    {
        printf("Val: %d", z_axis_trans[i][0]);
    }
}

void setup_constants(){
    struct vector{
        double b[3];
    } myVec = {{1,2,3}};

    //r21 = calloc(3, sizeof(float));
    struct vector r21 = {-0.5*a, sqrt(3)*a/2, 0};
    struct vector r31 = {-a, 0, 0};
    struct vector r41 = {-0.5*a, a*sqrt(3)/6, sqrt(2*a/3)};
    struct vector r32 = {-0.5*a, sqrt(3)*a/2, 0};
    struct vector r42 = {0, sqrt(3)*a/3, sqrt(2*a/3)};
    struct vector r43 = {0.5*a, sqrt(3)*a/6, sqrt(2*a/3)};
}



int main(){
    setup_constants();
    theta();
    return 0;
}