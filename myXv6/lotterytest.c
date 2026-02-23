#include "types.h"
#include "stat.h"
#include "user.h"

static volatile int sink = 0;

int
main(int argc, char **argv)
{
  int nchildren = 4;
  int duration = 5;
  const int MAXCHILD = 6;

  if(argc >= 2) nchildren = atoi(argv[1]);
  if(argc >= 3) duration = atoi(argv[2]);
  if(nchildren < 1) nchildren = 1;
  if(nchildren > MAXCHILD) nchildren = MAXCHILD;

  int ticks_per_sec = 100;
  int duration_ticks = duration * ticks_per_sec;

  int pipes[MAXCHILD][2];
  int i;
  for(i = 0; i < nchildren; i++){
    if(pipe(pipes[i]) < 0){
      printf(2, "pipe failed\n");
      exit();
    }
  }

  for(i = 0; i < nchildren; i++){
    int pid = fork();
    if(pid == 0){
      // child
      close(pipes[i][0]); // close read end
      // child i gets i+1 tickets
      settickets(i+1);

      int start = uptime();
      unsigned count = 0;
      while(uptime() - start < duration_ticks){
        // do some work in batches to reduce syscall overhead
        int j;
        for(j = 0; j < 10000; j++) sink += j;
        count++;
      }

      // write final count to parent
      write(pipes[i][1], &count, sizeof(count));
      close(pipes[i][1]);
      exit();
    }
    close(pipes[i][1]);
  }

  // parent reads results from each child
  unsigned counts[MAXCHILD];
  unsigned total = 0;
  for(i = 0; i < nchildren; i++){
    unsigned v = 0;
    int r = read(pipes[i][0], &v, sizeof(v));
    if(r != sizeof(v)) v = 0;
    counts[i] = v;
    total += v;
    close(pipes[i][0]);
  }

  // reap children
  for(i = 0; i < nchildren; i++) wait();

  printf(1, "Lottery test results: %d children, %d seconds\n", nchildren, duration);
  printf(1, "Child\tTickets\tCount\tShare(%%)\n");
  for(i = 0; i < nchildren; i++){
    int t = i+1;
    // share in tenths of percent to avoid floats
    int share_x10 = (total > 0) ? (counts[i] * 1000 / total) : 0;
    int share_whole = share_x10 / 10;
    int share_dec = share_x10 % 10;
    printf(1, "%d\t%d\t%d\t%d.%d%%\n", i, t, counts[i], share_whole, share_dec);
  }
  printf(1, "Total work-units: %d\n", total);
  exit();
}
