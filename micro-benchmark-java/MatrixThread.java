import java.util.Random;

public class MatrixThread implements Runnable {
	
	private double[][] matrix;
	private int from;
	private int to;
    private int loop;

	public MatrixThread(double[][] matrix, int from, int to, int loop) {
		this.matrix = matrix;
		this.from = from;
		this.to = to;
        this.loop = loop;
	}

	@Override
	public void run() {
		for (int i = from; i < to; i++) {
			for (int j = 0; j < matrix.length; j++) {
                if (j == 0) {
				    matrix[i][j] = 1 + i - j;
                } else {
                    for (int k = 0; k < loop; k++) {
                        matrix[i][j] = Math.sqrt(matrix[i][j - 1] * 1.1) +
                            Math.sin(matrix[i][j - 1]);
                        matrix[i][j] = Math.pow(matrix[i][j - 1], 2) +
                            Math.cos(matrix[i][j - 1]);
                    }
                }

			}
		}
	}

}
