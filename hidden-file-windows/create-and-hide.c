#include <stdio.h>
#include <Windows.h>

int main() {

    const char* nomeArquivo = "sou-oculto.txt";
    
    // Cria o arquivo
    FILE* arquivo = fopen(nomeArquivo, "w");
    if (arquivo == NULL) return -1;

    fwrite("BLAHBLAH\n", 1, 9, arquivo);
    fclose(arquivo);
    
    // Define o atributo oculto
    if (!SetFileAttributes(nomeArquivo, FILE_ATTRIBUTE_HIDDEN)) return -1;
    
    puts("ok");
    
    return 0;
}
