#include <math.h>


#define C 343.3  // Lydhastighet 
#define a 0.075  // Sidelengde tetraheder

// The vectors between each point in the tetrahedral
// Potential Todo: Just define this as a matrix directly 
float r21[3] = {-0.5*a, math.sqrt(3)*a/2, 0};
float r31[3] = {-a, 0, 0};
float r41[3] = {-0.5*a, a*math.sqrt(3)/6, math.sqrt(2*a/3)};
float r32[3] = {-0.5*a, -math.sqrt(3)*a/2, 0};
float r42[3] = {0, -math.sqrt(3)*a/3, math.sqrt(2*a/3)};
float r43[3] = {0.5*a, math.sqrt(3)*a/6, math.sqrt(2*a/3)};


float[][] transpose(int row, int column, float matrix[][]){
    float transpose_matrix[][];
    for (int i = 0; i < row; i++){
        for (int j = 0; j < column; j++){
            transpose_matrix[j][i] = matrix[i][j];
        }
    }
    return transpose_matrix[][];
     
}

int least_square(){
    return 0;
}


int main(){
    return 0;
}