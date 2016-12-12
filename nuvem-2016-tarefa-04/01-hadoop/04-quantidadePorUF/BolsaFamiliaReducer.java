package BolsaFamilia;

import java.io.IOException;
import java.util.*;

import org.apache.hadoop.io.DoubleWritable;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapred.*;

import java.text.DecimalFormat;

public class BolsaFamiliaReducer extends MapReduceBase implements Reducer<Text, IntWritable, Text, IntWritable> {

    public void reduce(Text t_key, Iterator<IntWritable> values, OutputCollector<Text, IntWritable> output, Reporter reporter)
        throws IOException {
	    Text key = t_key;
            int frequencyPerUF = 0;

	    while (values.hasNext()) {
               	IntWritable value = values.next();
		frequencyPerUF = frequencyPerUF + value.get();
	    }
	    output.collect(key, new IntWritable(frequencyPerUF));
	}
}
