#!/usr/bin/python

from random import shuffle
from string import digits
from hashlib import md5

class ContaBancaria:
    def __init__(self, senha: str):
        self._senha = md5(self._valida_senha(senha).encode()).hexdigest()
        self._combinacoes_atual = None
        print(f'Hash da senha (o que é salvo no banco de dados): {self._senha}')

    def _valida_senha(self, senha: str):
        if len(senha) != 6:
            raise ValueError('Senha deve ter 6 digitos')
        if not senha.isdigit():
            raise ValueError('Senha deve conter apenas digitos')
        return senha
    
    def _gera_pares_atual(self):
        digitos = list(digits)
        shuffle(digitos)
        pares = []
        for i in range(5):
            pares.append((digitos[i], digitos[9-i]))
        return pares
    
    def _valida_botoes_digitada(self, botoes: str):
        if len(botoes) != 6:
            raise ValueError('Senha deve ter 6 digitos')
        if not botoes.isdigit():
            raise ValueError('Senha deve conter apenas digitos')
        if any(filter(lambda x: int(x) > 4 or int(x) < 0, botoes)):
            raise ValueError('Imagina que só tem botões de 0 a 4')
        if not self._combinacoes_atual:
            # Nunca pode acontecer
            raise ValueError('Combinacoes nao geradas')
        
        print('Testando: ', end='')
        for b in botoes:
            print(f'{self._combinacoes_atual[int(b)]} ', end='')
        print()

        cont = 0
        for d1 in self._combinacoes_atual[int(botoes[0])]:
            for d2 in self._combinacoes_atual[int(botoes[1])]:
                for d3 in self._combinacoes_atual[int(botoes[2])]:
                    for d4 in self._combinacoes_atual[int(botoes[3])]:
                        for d5 in self._combinacoes_atual[int(botoes[4])]:
                            for d6 in self._combinacoes_atual[int(botoes[5])]:
                                comb = f'{d1}{d2}{d3}{d4}{d5}{d6}'
                                digest_gerado = md5(comb.encode()).hexdigest()
                                print(f'{cont:03d} - Testando combinacao: {comb} com hash {digest_gerado} contra hash {self._senha} - {digest_gerado == self._senha}')
                                cont += 1
                                if digest_gerado == self._senha:
                                    print(f'Senha validada em {comb}')
                                    return True

        return False

    def caixa_eletronico(self):
        self._combinacoes_atual = self._gera_pares_atual()
        for i, (d1, d2) in enumerate(self._combinacoes_atual):
            print(f'Botao {i}: [{d1} ou {d2}]')

        botoes_apertados = input('Digite a senha senha pelos botoes: ')

        print('Senha OK' if self._valida_botoes_digitada(botoes_apertados) else 'Senha invalida')

if __name__ == '__main__':
    senha = input('Digite a senha (6 dígitos): ')
    conta = ContaBancaria(senha)
    conta.caixa_eletronico()