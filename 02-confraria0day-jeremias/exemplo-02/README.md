**# Pré-requisitos: #**

    (1) g++: versão 6 para uso do OpenMP 4.0 ou superior
        Caso você não queira, ou não possa, utilizar essa versão do g++, 
        apenas o cancellation for não irá funcionar, mas isso não é uma 
        otimização necessária.

    (2) libcrypto - libssh.x86_64 - para uso de funções de hash

    (3) python - 2.7 ou superior

**# Instruções de Compiação: #**

     g++-6 -o executavel solver.cpp -fopenmp -lcrypto

**# Instruções de Execução: #**

    Para deixar o servidor executando:
    $ python server-confraria.py 1337

    Para executar o cliente que irá resolver os desafios: 
    $ ./executavel
