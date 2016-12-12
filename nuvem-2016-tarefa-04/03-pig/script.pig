-- Carregar a base no modo local. Ao passar o nome das variáveis, também é necessário colocar o tipo da variável, senão vira tudo bytearray
-- base = LOAD '/home/jeremias/Documents/NUVEM-COMPUTACIONAL-2016-2/Tarefa-04/base/bolsa-familia-pagamento/base-basica-2.csv' USING PigStorage('\t') as (uf, codMun, nomeMun, codFunc, codSubF, codProg, codAcao, nis, nome, finalidade, valor:float, mesCompet, mes);
-- base = LOAD '/base-basica-2.csv' USING PigStorage('\t') as (uf, codMun, nomeMun, codFunc, codSubF, codProg, codAcao, nis, nome, finalidade, valor:float, mesCompet, mes);
base = LOAD '${FILE}' USING PigStorage('\t') as (uf, codMun, nomeMun, codFunc, codSubF, codProg, codAcao, nis, nome, finalidade, valor:float, mesCompet, mes);

-- Pegar informações da base
-- decribe base;

-- Listar por UF
list = GROUP base BY (uf);

-- Contar as UFs a partir da lista de UFs
ufCount = FOREACH list GENERATE group as uf, COUNT(base);

-- Contar as UFs e pegar o maior valor recebido de cada
ufCount = FOREACH list GENERATE group as uf,COUNT(base), MAX(base.valor);

dump ufCount;
