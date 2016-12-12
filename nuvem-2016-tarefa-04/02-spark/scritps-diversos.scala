// Comando para chamar o spark-shell no modo interativo trabalhando com
// arquivos csv:
//    spark-shell --packages com.databricks:spark-csv_2.10:1.3.0

// Carrega o banco
 val baseRaw = spark.read.format("com.databricks.spark.csv").option("header",
"true").option("inferSchema", "true").option("delimiter",
"\t").load("base-basica-3.csv")

// Renomeando o cabeçalho (quando tem)
val names = Seq("UF", "codMunicipio", "nomeMunicipio", "codFuncao",
"codSubFuncao", "codPrograma", "codAcao", "NIS", "nome", "finalidade", "valor",
"mesCompetencia", "mes")

val base = baseRaw.toDF(names: _*)

// Registrando a base para ser utilizada
base.registerTempTable("db")

// Consulta UFs
val UF = spark.sql("select distinct UF from db")

// Exibe os valores coletados
UF.collect.foreach(println)

// Quantidade de pessoas por UF
val pessoasPorUF = spark.sql("SELECT DISTINCT(uf), COUNT(uf) AS teste FROM db
GROUP BY uf")
pessoasPorUF.collect.foreach(println)

// Pega o nome da pessoa que recebeu o maior valor
val max = spark.sql("SELECT nome, MAX(valor) FROM db GROUP BY nome ORDER BY
MAX(valor) DESC LIMIT 1")

