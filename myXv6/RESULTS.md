Experiment: Lottery Scheduling (lotterytest)

Setup
- Number of children: default 4 (first argument)
- Duration: default 5 seconds (second argument)
- Tickets: each child i gets i+1 tickets

Workload
- Each child runs a tight CPU-bound loop for the specified duration.
- Each child increments a local counter per batch; at the end it reports its final count to the parent.

Run Results

Lottery test results: 6 children, 15 seconds
Child   Tickets Count   Share(%)
0       1       37756   5.9%
1       2       69003   10.8%
2       3       100683  15.7%
3       4       123022  19.2%
4       5       140445  22.0%
5       6       166613  26.1%
Total work-units: 637522

Lottery test results: 6 children, 5 seconds
Child   Tickets Count   Share(%)
0       1       13902   6.5%
1       2       21920   10.2%
2       3       30797   14.4%
3       4       42747   20.0%
4       5       47817   22.4%
5       6       56176   26.3%
Total work-units: 213359

Lottery test results: 4 children, 5 seconds
Child   Tickets Count   Share(%)
0       1       28474   13.0%
1       2       47406   21.7%
2       3       68157   31.2%
3       4       73911   33.9%
Total work-units: 217948

Lottery test results: 4 children, 1 seconds
Child   Tickets Count   Share(%)
0       1       4958    11.7%
1       2       10026   23.7%
2       3       11030   26.1%
3       4       16222   38.4%
Total work-units: 42236

Lottery test results: 4 children, 1 seconds
Child   Tickets Count   Share(%)
0       1       6460    14.9%
1       2       10018   23.2%
2       3       13008   30.1%
3       4       13670   31.6%
Total work-units: 43156

Lottery test results: 4 children, 1 seconds
Child   Tickets Count   Share(%)
0       1       4921    11.2%
1       2       10676   24.4%
2       3       12839   29.4%
3       4       15180   34.8%
Total work-units: 43616

Observed metrics
- Each child reports a "count" proportional to the amount of CPU work it completed during the wall-clock duration.
- The relative share is computed as count_i / sum(counts).

Notes on variance and convergence
- Lottery scheduling is probabilistic. Single short runs like the 4 children, 1 second runs showed a vairance of a few 
percent.
- Increasing the duration reduces variance and the observed shares converge toward the expected proportions (tickets_i / sum(tickets)).

Expected behavior
- With 2 children with tickets 1 and 3, expect approximately a 1:3 ratio of CPU work over long runs.

Why longer runs converge
- Each scheduling choice is independent and selects a process proportional to its tickets.
- By the law of large numbers, the fraction of times a process is chosen converges to its ticket fraction as the number of selections grows.
