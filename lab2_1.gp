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
set title "Synchronized Adds: Operations per second"
set xlabel "Threads"
set logscale x 2
set xrange [0.75:]
set ylabel "Operations per second"
set logscale y 10
set output 'lab2b_1.png'

# grep out only successful (sum=0)  unsynchronized runs
plot \
     "< grep add-m lab2b_add.csv | grep ',0$'" using ($2):(10**9/(($5)/($4))) \
	title 'Mutex Add' with points lc rgb 'green', \
     "< grep add-s lab2b_add.csv | grep ',0$'" using ($2):(10**9/(($5)/($4))) \
	title 'Spin-lock Add' with points lc rgb 'red', \
     "< grep list-none-m lab_2b_list_0.csv" using ($2):(10**9/(($6)/($5*3))) \
        title 'Mutex List' with points lc rgb 'blue', \
     "< grep list-none-s lab_2b_list_0.csv" using ($2):(10**9/(($6)/($5*3))) \
        title 'Spin-lock List' with points lc rgb 'black'
	
