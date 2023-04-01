#include <math.h>
#include <stdio.h>
#include <stdlib.h>


#define C 343.3  // Lydhastighet 
#define a 0.075  // Sidelengde tetraheder
#define REAL float

inline static REAL sqr(REAL x) {
    return x*x;
}


//  float* time_delays = {0.008064, 0.80704, -3.2*10**(-5), -0.000256, 0.000128, 0.000352};


float **create_matrix(int m, int n){
    float **b = (float **)malloc(m * sizeof(float *));
    for (int i = 0; i < m; i++) {
        b[i] = (float *)malloc(n * sizeof(float));
    }
    return b;
}

void print_matrix(float** matrix, int m, int n){
    printf("Result:\n");
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            printf("%f ", matrix[i][j]);
        }
        printf("\n");
    }
}

void destroy_matrix(float** arr){
    free(*arr);
    free( arr);
}

float **transpose_matrix(int row, int column, float** matrix){
    float** transpose_matrix = create_matrix(row, column);
    for (int i = 0; i < row; i++){
        for (int j = 0; j < column; j++){
            transpose_matrix[i][j] = matrix[j][i];
        }
    }
    return transpose_matrix;
}


float** transpose_vector(int length, float vec[]){
    float** transpose_matrix = create_matrix(length, 1);
    for (int i = 0; i < length; i++){
        transpose_matrix[i][0] = vec[i]; 
    }
    return transpose_matrix;
}

float** matrix_mult(float** mat_a, float** mat_b, int m, int n){
    float **result = (float **)malloc(m * sizeof(float *));
    for (int i = 0; i < m; i++) {
        result[i] = (float *)malloc(n * sizeof(float));
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

int linreg(int n, const REAL x[], const REAL y[], REAL* m, REAL* b, REAL* r){
    REAL   sumx = 0.0;                      /* sum of x     */
    REAL   sumx2 = 0.0;                     /* sum of x**2  */
    REAL   sumxy = 0.0;                     /* sum of x * y */
    REAL   sumy = 0.0;                      /* sum of y     */
    REAL   sumy2 = 0.0;                     /* sum of y**2  */

    for (int i=0;i<n;i++){ 
        sumx  += x[i];       
        sumx2 += sqr(x[i]);  
        sumxy += x[i] * y[i];
        sumy  += y[i];      
        sumy2 += sqr(y[i]); 
    } 

    REAL denom = (n * sumx2 - sqr(sumx));
    if (denom == 0) {
        // singular matrix. can't solve the problem.
        *m = 0;
        *b = 0;
        if (r) *r = 0;
            return 1;
    }

    *m = (n * sumxy  -  sumx * sumy) / denom;
    *b = (sumy * sumx2  -  sumx * sumxy) / denom;
    if (r!=NULL) {
        *r = (sumxy - sumx * sumy / n) /    /* compute correlation coeff */
              sqrt((sumx2 - sqr(sumx)/n) *
              (sumy2 - sqr(sumy)/n));
    }

    return 0; 
}


int least_square(){
    return 0;
}





float theta(){
    float z_axis[3] = {0,0,1}; 
    float** z_axis_trans = transpose_vector(3, z_axis);
    for (size_t i = 0; i < 3; i++)
    {
        printf("Val: %d", z_axis_trans[i][0]);
    }
}


void init(){
    float r21[] = {-0.5*a, sqrt(3)*a/2, 0};
    float r31[] = {-a, 0, 0};
    float r41[] = {-0.5*a, a*sqrt(3)/6, sqrt(2*a/3)};
    float r32[] = {-0.5*a, sqrt(3)*a/2, 0};
    float r42[] = {0, sqrt(3)*a/3, sqrt(2*a/3)};
    float r43[] = {0.5*a, sqrt(3)*a/6, sqrt(2*a/3)};


    float** r = create_matrix(6,3);

    // float **b = create_matrix(6, 3);
    // b[0][0] = 7; b[0][1] = 8; b[0][2] = 13; b[0][3] = 14;
    // b[1][0] = 9; b[1][1] = 10; b[1][2] = 0.5; b[1][3] = 5; 
    // b[2][0] = 11; b[2][1] = 12;
    // print_matrix(b, 6, 3);
    // float** b_t = create_matrix(3, 6);
    // b_t = transpose_matrix(3, 6, b);
    // print_matrix(b_t, 3, 6);
    // destroy_matrix(b);
    // destroy_matrix(b_t);
}

float** create_r(){
    float** r = create_matrix(6,3);
    r[0][0] = -0.5*a; r[0][1] = sqrt(3)*a/2; r[0][2] = 0;
    r[1][0] = -a;     r[1][1] = 0;           r[1][2] = 0;


    return r; 
}

int main(){
    //init();

    float vector[3] = {1.0, 2.0, 3.0};
    printf("%.1f\n", vector[0]);
    
    //*transpose = create_matrix(1, 3);
    float **transpose = transpose_vector(3, vector);


    //print_matrix(transpose, 1, 3);
    printf("Transpose of vector: \n");
    for (int i = 0; i < 3; i++) {
        printf("%f\n", transpose[i][0]);
    }
   
    return 0;
}