#include<math.h>
#include<stdio.h>
#include<stdlib.h>
#include<sys/types.h>
#include<sys/time.h>
#include<time.h>

#define CACHEFILE "../data/data64"
#define FILENAME "../data/testblock1G"
#define BUFSIZE 1024

#define EMPTYLOOPS 2000000000
#define CPULOOPS 20000000

double GetTimeDiff(struct timeval t0, struct timeval t1) {
  double ft0 = (double)t0.tv_sec + (double)t0.tv_usec / 1000000.0;
  double ft1 = (double)t1.tv_sec + (double)t1.tv_usec / 1000000.0;
  return ft0 - ft1;
}

/* test 1 */
void EmptyLoop(int iterations) {
  int iter;
  for (iter = 0; iter < iterations; iter++) {}
}

/* test 2 */
void CPUTask(int iterations) {
  int iter;
  for (iter = 0; iter < iterations; iter++) {
    sqrt(pow(2.35, log10((double)iter + 10.0)));
  }
}

/* test 3 */
void IOTask(char* filename) {
  FILE* h_file;
  char buffer[BUFSIZE];
  h_file = fopen(filename, "rb");
  while (fread(buffer, 1, BUFSIZE, h_file)) {

  }
  fclose(h_file);
}

void ClearCache() {
  fprintf(stderr, "clearing cache...");
  IOTask(CACHEFILE);
  system("sudo setdropcaches 3");
  fprintf(stderr, "done.\n");
}

int main(int argc, char* argvs[]) {
  struct timeval start_time;
  struct timeval end_time;
  int test_id;
  int testnum;
  if (argc < 2) {
    fprintf(stderr, "Usage: timechecker mode test_id\n");
    return 1;
  }
  if (atoi(argvs[1]) == 1) {
    ClearCache();
  }
  gettimeofday(&start_time, NULL);
  for(testnum = 2; testnum < argc; testnum++) {
    test_id = atoi(argvs[testnum]);
    if (test_id == 2) {
      CPUTask(CPULOOPS);
    } else if (test_id == 3) {
      IOTask(FILENAME);
    }
  }
  gettimeofday(&end_time, NULL);
  printf("%3.3f\n", GetTimeDiff(end_time, start_time));
  return 0;
}
