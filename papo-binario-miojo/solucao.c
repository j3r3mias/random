// Compilacao: gcc -o prog solucao.c
// Execucao: echo 3 5 7 | ./prog

#include <stdio.h>

#define MIN(a, b) a < b ? a : b

int main()
{
    int amp1, amp2, tempo;
    int c1, c2, tmp;

    scanf("%d %d %d", &tempo, &amp1, &amp2);

    for (c1 = 1; c1 <= amp1; c1++) {
        if ((c1 * amp1) % amp2 == tempo)
            break;
    }

    for (c2 = 1; c2 <= amp2; c2++) {
        if ((c2 * amp2) % amp1 == tempo)
            break;
    }

    printf("%d\n", MIN(amp1 * c1, amp2 * c2));

    return 0;
}
