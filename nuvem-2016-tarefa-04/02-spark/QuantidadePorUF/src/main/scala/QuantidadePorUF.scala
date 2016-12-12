import org.apache.spark.SparkContext
import org.apache.spark.SparkContext._
import org.apache.spark.SparkConf
import org.apache.spark.sql.SparkSession

object QuantidadePorUF {
  def main(args: Array[String]) {
    val spark = SparkSession
        .builder
        .appName("Quantidade de Pessoas por UF")
        .getOrCreate()
    //val baseRaw = spark.read.format("com.databricks.spark.csv").option("header", "true").option("inferSchema", "true").option("delimiter", "\t").load("/home/jeremias/Documents/NUVEM-COMPUTACIONAL-2016-2/Tarefa-04/codigo/spark/base-basica-2.csv")
    val baseRaw = spark.read.format("com.databricks.spark.csv").option("header", "true").option("inferSchema", "true").option("delimiter", "\t").load(args(0))
//    val names = Seq("UF", "codMunicipio", "nomeMunicipio", "codFuncao", "codSubFuncao", "codPrograma", "codAcao", "NIS", "nome", "finalidade", "valor", "mesCompetencia", "mes")
    val names = Seq("UF", "codMunicipio", "nomeMunicipio", "codFuncao", "codSubFuncao", "codPrograma", "codAcao", "NIS", "nome", "finalidade", "valor", "mesCompetencia")
    val base = baseRaw.toDF(names: _*)
    base.registerTempTable("db")
    val pessoasPorUF = spark.sql("SELECT uf, COUNT(uf) AS teste FROM db GROUP BY uf") 
    pessoasPorUF.collect.foreach(println)
    spark.stop()
  }
}
