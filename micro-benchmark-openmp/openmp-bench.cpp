#include <stdint.h>
#include <iostream>
#include <omp.h>
#include <sys/time.h>

using namespace std;

#define N 3000000000L

long long timestampInUS()
{
        struct timeval ts;
        gettimeofday(&ts, NULL);
        return (ts.tv_sec * 1000000LL + (ts.tv_usec));
}

int main() {
	
	long i;
	uint64_t t1s, t1e, t2s, t2e, t4s, t4e, t8s, t8e;
	double pis, pi2, pi4, pi8;
	
    pis = pi2 = pi4 = pi8 = 0;
    
    t1s = timestampInUS(); 
    for (long i = 0; i < N; ++i) {
        pis += 1 / (double) (i * 2 + 1) * (i & 1 ? -1 : 1);
    }
    t1e = timestampInUS(); 

    t2s = timestampInUS(); 
    omp_set_num_threads(2);
#pragma omp parallel for reduction(+: pi2)
    for (long i = 0; i < N; ++i) {
        pi2 += 1 / (double) (i * 2 + 1) * (i & 1 ? -1 : 1);
    }
    t2e = timestampInUS(); 

    t4s = timestampInUS(); 
    omp_set_num_threads(4);
#pragma omp parallel for reduction(+: pi4)
    for (long i = 0; i < N; ++i) {
        pi4 += 1 / (double) (i * 2 + 1) * (i & 1 ? -1 : 1);
    }
    t4e = timestampInUS(); 

    t8s = timestampInUS(); 
    omp_set_num_threads(8);
#pragma omp parallel for reduction(+: pi8)
    for (long i = 0; i < N; ++i) {
        pi8 += 1 / (double) (i * 2 + 1) * (i & 1 ? -1 : 1);
    }
    t8e = timestampInUS(); 

	cout << "Serial    : " << pis << " - " << t1e - t1s << endl;
	cout << "Parallel 2: " << pi2 << " - " << t2e - t2s << endl;
	cout << "Parallel 4: " << pi2 << " - " << t4e - t4s << endl;
	cout << "Parallel 8: " << pi2 << " - " << t8e - t8s << endl;

    return 0;
}
