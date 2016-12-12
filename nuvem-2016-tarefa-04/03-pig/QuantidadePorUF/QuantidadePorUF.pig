base = LOAD '${FILE}' USING PigStorage('\t') as (uf, codMun, nomeMun, codFunc, codSubF, codProg, codAcao, nis, nome, finalidade, valor:float, mesCompet, mes);

list = GROUP base BY (uf);

ufCount = FOREACH list GENERATE group as uf, COUNT(base);

ufCount = FOREACH list GENERATE group as uf,COUNT(base);

dump ufCount;
