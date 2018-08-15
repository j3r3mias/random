import java.util.Date;
import java.util.concurrent.Executors;
import java.util.concurrent.ThreadPoolExecutor;

public class Principal {
    
    public static void main(String[] args) {

        int loop;

        if (args.length == 0) {
            loop = 5;
        } else {
            loop = Integer.valueOf(args[0]);
        }

        double[][] myMatrix = new double[1000][100000];
        for (int i = 0; i < myMatrix.length; i++) {
            for (int j = 0; j < myMatrix.length; j++) {
                myMatrix[i][j] = 5;
            }
        }

        long begin = new Date().getTime();
        new MatrixThread(myMatrix, 0, 1000, loop).run();
        long end = new Date().getTime();
        System.out.println("Serial(2): " + (end - begin));

        for (int i = 0; i < myMatrix.length; i++) {
            for (int j = 0; j < myMatrix.length; j++) {
                myMatrix[i][j] = 5;
            }
        }
        begin = new Date().getTime();
        new MatrixThread(myMatrix, 0, 1000, loop).run();
        end = new Date().getTime();
        System.out.println("Serial(2): " + (end - begin));

        for (int threadQtd = 2; threadQtd < 15;
                threadQtd++) {

            for (int i = 0; i < myMatrix.length; i++) {
                for (int j = 0; j < myMatrix.length; j++) {
                    myMatrix[i][j] = 5;
                }
            }

            int slice = (myMatrix.length / threadQtd);
            
            ThreadPoolExecutor executor = (ThreadPoolExecutor)
                Executors.newFixedThreadPool(threadQtd);
            
            begin = new Date().getTime();
            for (int i = 0; i < threadQtd; i++) {
                MatrixThread meuRunnable = 
                    new MatrixThread(myMatrix, i * slice, 
                                     i * slice + slice, loop);
                executor.execute(meuRunnable);
            }
            executor.shutdown();
            while (!executor.isTerminated()) {
                // do nothing
            }
            end = new Date().getTime();
            
            System.out.println("Paralelo(" + threadQtd + "): " + (end -
                               begin));
        }
    }
}
