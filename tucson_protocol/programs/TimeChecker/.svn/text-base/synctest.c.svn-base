#include <stdio.h>
#include <stdlib.h>

#define BUFSIZE 4096
#define CACHEFILE "../data/data64"
#define FILENAME "../data/data64"
#define OUTFILE "../data/outfile"

void LoadAndChange(char* filename, char* outfile) {
  FILE* h_file;
  FILE* h_out_file;
  int i;
  int read_blk;
  int write_blk;
  char buffer[BUFSIZE];
  read_blk = 0;
  write_blk = 0;
  h_file = fopen(filename, "rb");
  h_out_file = fopen(outfile, "wb");
  while (fread(buffer, 1, BUFSIZE, h_file)) {
    read_blk++;
    for (i = 0; i < BUFSIZE; i++) {
      buffer[i] = !(buffer[i]);
    }
    fwrite(buffer, 1, BUFSIZE, h_out_file);
    write_blk++;
  }
  fclose(h_file);
  fclose(h_out_file);
  fprintf(stderr, "blk read/write: %d/%d\n", read_blk, write_blk);
}

void OnlyLoad(char* filename) {
  FILE* h_file;
  int i;
  char buffer[BUFSIZE];
  h_file = fopen(filename, "rb");
  while (fread(buffer, 1, BUFSIZE, h_file)) {
  }
  fclose(h_file);
}

void ClearCache() {
  fprintf(stderr, "clearing cache...");
  OnlyLoad(CACHEFILE);
  system("sudo /usr/local/sbin/setdropcaches 1");
  system("sync");
  fprintf(stderr, "done.\n");
}

int main(int argc, char* argvs[]) {
  int test_mode;
  if (argc == 1) {
    fprintf(stderr, "specify test mode: 0: no sync, 1: sync\n");
    return 1;
  }
  test_mode = atoi(argvs[1]);
  ClearCache();
  system("iostat");
  LoadAndChange(FILENAME, OUTFILE);
  if (test_mode == 1) {
    system("sync");
  }
  system("iostat");
  return 0;
}

