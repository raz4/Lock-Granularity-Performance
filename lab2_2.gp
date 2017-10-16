#! /usr/bin/gnuplot
#
# purpose:
#	 generate data reduction graphs for the multi-threaded add project
#
# input: lab2_add.csv
#	1. test name
#	2. # threads
#	3. # iterations per thread
#	4. # add operations
#	5. run time (ns)
#	6. run time per operation (ns)
#	7. total sum at end of run (should be zero)
#
# output:
#	lab2_add-1.png ... threads and iterations that run (unprotected) w/o failure
#	lab2_add-2.png ... cost per operation of yielding
#	lab2_add-3.png ... cost per operation vs number of iterations
#	lab2_add-4.png ... threads and iterations that run (protected) w/o failure
#	lab2_add-5.png ... cost per operation vs number of threads
#
# Note:
#	Managing data is simplified by keeping all of the results in a single
#	file.  But this means that the individual graphing commands have to
#	grep to select only the data they want.
#

# general plot parameters
set terminal png
set datafile separator ","

# how many threads/iterations we can run without failure (w/o yielding)
set title "Timing Mutex Waits"
set xlabel "Threads"
set logscale x 10
set xrange [0.75:]
set ylabel "Time (nanoseconds)"
set logscale y 2
set output 'lab2b_2.png'

# grep out only successful (sum=0)  unsynchronized runs
plot \
     "< grep list-none-m lab_2b_list_1.csv" using ($2):($8) \
	title 'Wait-for-lock time' with points lc rgb 'green', \
     "< grep list-none-m lab_2b_list_1.csv" using ($2):($7) \
	title 'Avg. time per operation' with points lc rgb 'red', \


