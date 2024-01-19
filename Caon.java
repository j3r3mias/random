class Memoria {
    Memoria() {
        byte[] b = new byte[1024 * 1024 * 1024];
        for (int i = 0; i < b.length; i++) {
            b[i] = 1;
        }
    }

    @Override
    protected void finalize() throws Throwable {
        System.out.println("Memoria liberada");
    }

}


class Caon {
    public static void main(String[] args) {
        statusMemoria();
        Memoria m = new Memoria();
        statusMemoria();
        try {
            m.finalize();
        } catch (Throwable e) {
            e.printStackTrace();
        }
        System.out.println("Verificando uso de memória sem o GC");
        statusMemoria();
        callGC();
        System.out.println("Verificando após uma chamada do GC");
        statusMemoria();
    }

    static void callGC() {
        System.gc();
        System.runFinalization();
    }

    static void statusMemoria() {
        Runtime rt = Runtime.getRuntime();
        System.out.println("=====================================================");
        System.out.println("Memoria total: " + rt.totalMemory() / 1024 / 1024);
        System.out.println("Memoria livre: " + rt.freeMemory() / 1024 / 1024);
        System.out.println("Memoria usada: " + (rt.totalMemory() - rt.freeMemory()) / 1024 / 1024);
        System.out.println("=====================================================");
    }

}