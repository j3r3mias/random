#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int memo[1000000][1000000]; // Limites para k e n

int conta_sc_k(int *V, int k, int n)
{
    if (k == 0) return 1;
    if (k < 0) return 0;
    if (n < 0) return 0;

    if (memo[k][n] != -1) return memo[k][n]; // Se já foi calculado

    int ans = -1;

    if (V[n] > k) {
        ans = conta_sc_k(V, k, n - 1);
    } else {
        ans = conta_sc_k(V, k - V[n], n - 1) + conta_sc_k(V, k, n - 1);
    }

    memo[k][n] = ans;
    return ans;
}

int main()
{
    // Exemplo da discussão
    int V[] = {1, 4, 5, 5, 7, 9}, k = 10;

    // Exemplo grande para validar redução do exponencial
    // int V[200], k;
    // for (int i = 0; i < 200; i++) {
    //     V[i] = rand() % 100;
    // }
    // k = rand() % 100;

    int n = sizeof(V) / sizeof(V[0]);

    memset(memo, -1, sizeof(memo));

    printf("Numero de subconjuntos de soma %d: %d\n", k, conta_sc_k(V, k, n - 1));

    return 0;
}

