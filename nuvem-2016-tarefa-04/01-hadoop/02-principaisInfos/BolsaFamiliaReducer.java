package BolsaFamilia;

import java.io.IOException;
import java.util.*;

import org.apache.hadoop.io.DoubleWritable;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapred.*;

import java.text.DecimalFormat;

public class BolsaFamiliaReducer extends MapReduceBase implements Reducer<Text, Text, Text, Text> {

    public void reduce(Text t_key, Iterator<Text> values, OutputCollector<Text, Text> output, Reporter reporter)
        throws IOException {
		    Text key = t_key;
		    double biggest = 0.0;
            double total = 0.0; 
            double average = 0.0;
            int cont = 0;
            String name = new String();

            DecimalFormat f = new DecimalFormat("##.00");

		    while (values.hasNext()) {
                String valueString = values.next().toString();
                String[] SingleData = valueString.split("\t");
		    	DoubleWritable value = new DoubleWritable(Double.parseDouble(SingleData[0].replace(",", "")));
                if (value.get() > biggest) {
    	    		biggest = value.get();
                    name = SingleData[1];
                }
                total = total + value.get();
                cont = cont + 1;
		    }
            average = total / (double) cont;
            output.collect(key, new Text(String.valueOf(cont) + "\t" +
                        String.valueOf(f.format(average)) + "\t" +
                        String.valueOf(f.format(biggest)) + "\t" +
                        name + "\t" +  String.valueOf(f.format(total))));
	    }
}
