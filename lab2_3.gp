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
set title "Multiple Lists: Threads and Iterations that run without failure"
set xlabel "Threads"
set logscale x 2
set xrange [0.75:]
set ylabel "Iterations per thread"
set logscale y 10
set output 'lab2b_3.png'

# grep out only successful (sum=0)  unsynchronized runs
plot \
    "< grep list-id-m lab_2b_list_3.csv" using ($2):($3) \
	title 'w/mutex' with points lc rgb 'red', \
	"< grep list-id-s lab_2b_list_3.csv" using ($2):($3) \
	title 'w/spin-lock' with points lc rgb 'green', \
	"< grep list-id-none lab_2b_list_2.csv" using ($2):($3) \
	title 'w/o sync' with points lc rgb 'blue'
