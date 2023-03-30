#include <math.h>
#include <stdio.h>
#include <stdlib.h>


/*
int main(){
    int sus = 250;
    int* ptr1;
    int** pt2;

    ptr1 = &sus; 
    pt2 = &ptr1;
    printf("Val: %d", **pt2); 
    return 0; 
}
*/


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

