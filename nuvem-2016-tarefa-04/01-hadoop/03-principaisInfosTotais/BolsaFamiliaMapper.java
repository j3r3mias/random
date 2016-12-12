package BolsaFamilia;

import java.io.IOException;

import org.apache.hadoop.io.DoubleWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapred.*;

public class BolsaFamiliaMapper extends MapReduceBase implements Mapper<LongWritable, Text, Text, Text> {
	//private final static DoubleWritable oneD = new DoubleWritable(1.0);

	public void map(LongWritable key, Text value, OutputCollector<Text, Text> output, Reporter reporter) throws IOException {
		String valueString = value.toString();
		String[] SingleData = valueString.split("\t");
		output.collect(new Text("Total"), new Text(SingleData[10] + "\t" + SingleData[8]));
	}
}
