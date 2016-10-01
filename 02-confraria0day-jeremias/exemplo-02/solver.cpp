// Dependências
// g++ - versão 6 (para uso do OpenMP 4.0
// (obs: Se não utilizar versões mais antigas do openmp, apenas o cancellation
// for não irá funcionar, mas não é uma otimização necessária
//
// libcrypto - 
//
//
// Compilação
// g++-6 -o executavel solver.cpp -fopenmp -lcrypto


#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h> 
#include <openssl/sha.h>
#include <omp.h>

int sockfd, portNumber, n;
struct sockaddr_in serv_addr;
struct hostent *server;
char buffer[712];
double valueFloat, coin;
int amount, value;
char *token;
char hashPart[25], target[50];
char alphanumeric[] = "ABCDEFGHIJKLMNOPQRSTUVXYWZabcdefghijklmnopqrstuvxywz0123456789 $%*+-./:";
char *an;

void error(const char *msg);
void open_connection();
void close_connection();

// Recebe a mensagem e guarda no buffer
void readmsg();

// Envia o conteúdo do buffer
void writemsg();
void solve();
void genSHA256(unsigned char *input, char *hash);

// Extrai do buffer a parte do hash e a parte do resultado
void getStartValue();
void tokenizeHashes();

int main(int argc, char *argv[])
{
    int tmp;
    char startValue[10];
    an = alphanumeric;
    //server = gethostbyname("localhost");
    server = gethostbyname("localhost");
    portNumber = 1337;

    open_connection();
    readmsg();
    printf("%s\n", buffer);
    
    getStartValue();
    writemsg();
    readmsg();

    if (!strcmp(buffer, "OK, iniciando!")) {
        printf("Confirmação não deu certo. Saindo...\n");
        close_connection();
        return 0;
    }

    while (1) {
        // Lê o desafio
        readmsg();
        if((buffer[8] == 'S') && (buffer[9] == 'H') && (buffer[10] == 'A')) {
            printf("%s\n", buffer);
            tokenizeHashes();
            solve();
        } else if ((buffer[6] == 'R') && (buffer[7] == 'e')) {
            printf("%s\n", buffer);
        }
        else {
            printf("A flag é: %s\n", buffer);
            break;
        }
    }

    close_connection();

    close(sockfd);
    return 0;
}

void error(const char *msg)
{
    perror(msg);
    exit(0);
}

void readmsg()
{
    bzero(buffer, 256);
    n = read(sockfd, buffer, 255);
    if (n < 0) 
         error("ERROR reading from socket");
}
void writemsg()
{
    n = write(sockfd, buffer, strlen(buffer));
    if (n < 0) 
         error("ERROR writing to socket");
}


void open_connection()
{

    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) 
        error("ERROR opening socket");
    if (server == NULL) {
        fprintf(stderr,"ERROR, no such host\n");
        exit(0);
    }
    bzero((char *) &serv_addr, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    bcopy((char *)server->h_addr, 
         (char *)&serv_addr.sin_addr.s_addr,
         server->h_length);
    serv_addr.sin_port = htons(portNumber);
    if (connect(sockfd,(struct sockaddr *) &serv_addr,sizeof(serv_addr)) < 0) 
        error("ERROR connecting");
}

void close_connection()
{
    close(sockfd);
}

void tokenizeHashes()
{
    token = strtok(buffer, "\"");
    token = strtok(NULL, "\"");
    strcpy(hashPart, token);
    token = strtok(NULL, "\"");
    token = strtok(NULL, "\".");
    strcpy(target, token);

}

void getStartValue()
{
    token = strtok(buffer, ".");
    token = strtok(NULL, ",");
    token = strtok(NULL, " ");
    token = strtok(NULL, " ");
    token = strtok(NULL, " ");
    token = strtok(NULL, " :");
    strcpy(buffer, token);
}



void genSHA256(unsigned char *input, char *hash)
{
    unsigned char output[SHA256_DIGEST_LENGTH];

    SHA256(input, strlen((char *)input), output);

    for(int i = 0; i < SHA256_DIGEST_LENGTH; i++)
    {
        sprintf(hash + (i * 2), "%02x", output[i]);
    }

    hash[64] = 0;

}

void solve()
{
    int i, j, k, l, ok;
    unsigned char guess[SHA256_DIGEST_LENGTH];
    char hash[100], answer[4];
    guess[0] = '\0';
    strcat((char *)guess, "::::");
    strcat((char *)guess, hashPart);
    
    #pragma omp parallel for firstprivate(j, k, l, guess, hash)
    for (i = 0; i < 71; i++) {
        guess[0] = an[i];
        for (j = 0; j < 71; j++) {
            guess[1] = an[j];
            for (k = 0; k < 71; k++) {
                guess[2] = an[k];
                for (l = 0; l < 71; l++) {
                    guess[3] = an[l];
                    genSHA256(guess, hash);
                    if (strstr(hash, target)) {
                        for (int ii = 0; ii < 4; ii++) {
                            buffer[ii] = guess[ii];
                        }
                        buffer[4] = '\0';
                        #pragma omp cancel for
                    }
                }
            }
        }
        #pragma omp cancellation point for
    }
    printf("A flag é: %s\n", buffer);
    writemsg();
}
