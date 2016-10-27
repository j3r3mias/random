#!/usr/bin/python
# -*- coding: UTF-8 -*-

# Para executar, basta utilizar 
# $ python server-confraria.py 1337
# É possível utilizar outras portas, mas não esqueça de mudar também no solver

import time
import socket
import sys
import hashlib
import string
from thread import *
from random import *
 
 
_port = int(sys.argv[1])
_timeout = 50          # Tempo para timout em segundos
_host = ''              # listen to all interfaces
_bufsize = 4096
 
_logfile = open(str(sys.argv[0]) + '.log', 'a')     # Local para salvar os ips
                                                    # que conectaram no
                                                    # challenge
 
_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
_socket.bind((_host, _port))
_socket.listen(_bufsize)
_stage = 10             # Número de desafios
_hash = 'sha256'
_flag = 'confraria0day{p4r4ll3l_c0d3s_c4n_s4v3_y0ur_l1f3}'
 
def clientThread(client):
    
    guess = randint(1, 100) 

    msg = '''
            +++         Confraria0day               +++

 [*] Pronto para o desafio?

 [+] Você tem 30 segundos para responder cada pergunta, ou a conexão será
 encerrada.

 [+] Para iniciar, digite o número %s: ''' % (guess)
                        
    client.send(msg)

    userGuess = client.recv(_bufsize).strip()
    
    print ' - Usuário respondeu: ' + str(userGuess)

    if str(guess) == userGuess:
        client.send('     OK, iniciando!' + '\n\n')
        stage = 0
        while True:
            client.settimeout(_timeout)
            try:
                A = ''.join([choice(string.printable[:62]) for x in range(26)])
                # Teste
                # A = '::::' + A[4:]
                # Fim do teste
                print "Resposta esperada: " + A[:4]
                msg = '''' 
 [+] %s(X + "%s").hexdigest() == "%s..."
     X é uma string alfanumérica e |X| == 4
     Entre com a resposta para X: ''' % (_hash.upper(), A[4:], 
     hashlib.sha256(A).hexdigest()[:32])
                client.send(msg)
                ans = client.recv(_bufsize).strip()
                print hashlib.sha256(ans + A[4:]).hexdigest() 
                print hashlib.sha256(A).hexdigest()
                
                if hashlib.sha256(ans + A[4:]).hexdigest() == hashlib.sha256(A).hexdigest():
                    client.send('\n [+] Resposta correta!' + '\n')
                    stage = stage + 1

                    if stage == _stage:
                        msg = ' [+] Parabéns, a flag é: %s\n' % (_flag)
                        client.send(msg)
                        client.close()
                        break
                else: 
                    client.send(' [-] Resposta incorreta!' + '\n')
                    client.send('     Saindo...' + '\n')
                    client.close()
                    break

            except socket.timeout:
                client.send('\n [-] Tempo esgotado. Precisa responder mais rápido... \n')
                client.send('     Saindo...' + '\n')
                client.close()
                break
    else:
        client.send(' Número errado! \n')
        client.close()
 
while True:
    client, addr = _socket.accept()
    info = ' Conectado pelo ip %s e porta %d' % (addr[0] , addr[1])
    _logfile.write(info + '\n')
    start_new_thread(clientThread ,(client,))
s.close()
