#include <stdio.h>
#include <stdlib.h>

/*
This is an example code to do np.linalg.solve, might
be useful for final version of angle_calc

*/

void swap_rows(double *A, int i, int j, int n) {
    double temp;
    for (int k = 0; k < n; k++) {
        temp = A[i*n + k];
        A[i*n + k] = A[j*n + k];
        A[j*n + k] = temp;
    }
}
void eliminate(double *A, int n, int i, int j, int k) {
    double pivot = A[i*n + j];
    for (int l = j; l < n; l++) {
        A[i*n + l] /= pivot;
    }
    for (int m = 0; m < n; m++) {
        if (m == i) continue;
        double factor = A[m*n + j];
        for (int l = j; l < n; l++) {
            A[m*n + l] -= factor * A[i*n + l];
        }
    }
}

int gauss_jordan(double *A, double *b, int n) {
    for (int j = 0; j < n; j++) {
        int i_max = j;
        for (int i = j+1; i < n; i++) {
            if (abs(A[i*n + j]) > abs(A[i_max*n + j])) {
                i_max = i;
            }
        }
        if (A[i_max*n + j] == 0.0) {
            return 0; // matrix is singular
        }
        if (i_max != j) {
            swap_rows(A, i_max, j, n);
            double temp = b[i_max];
            b[i_max] = b[j];
            b[j] = temp;
        }
        eliminate(A, n, j, j, j);
        b[j] /= A[j*n + j];
        A[j*n + j] = 1.0;
    }
    for (int j = n-1; j > 0; j--) {
        for (int i = 0; i < j; i++) {
            b[i] -= A[i*n + j] * b[j];
            A[i*n + j] = 0.0;
        }
    }
    return 1;
}

int main() {
    double A[] = {1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 10.0};
    double b[] = {3.0, 4.0, 5.0};
    int n = 3;
    int success = gauss_jordan(A, b, n);
    if (success) {
        printf("Solution: [");
        for (int i = 0; i < n; i++) {
            printf("%f ", b[i]);
        }
        printf("]\n");
    } else {
        printf("Matrix is singular\n");
    }
    return 0;
}