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
set title "Mutex-synchronized Lists: Operations per second"
set xlabel "Threads"
set logscale x 2
set xrange [0.75:]
set ylabel "Operations per second"
set logscale y 10
set output 'lab2b_4.png'

# 1
plot \
     "< grep list-none-m,[1,2,4,6,8]*,1000,1, lab_2b_list.csv" using ($2):(10**9/(($6)/($5))) \
		title '1 list' with points lc rgb 'green', \
     "< grep list-none-m,[1,2,4,6,8]*,1000,4, lab_2b_list.csv" using ($2):(10**9/(($6)/($5))) \
		title '2 lists' with points lc rgb 'red', \
     "< grep list-none-m,[1,2,4,6,8]*,1000,8, lab_2b_list.csv" using ($2):(10**9/(($6)/($5))) \
        title '3 lists' with points lc rgb 'blue', \
     "< grep list-none-m,[1,2,4,6,8]*,1000,16, lab_2b_list.csv" using ($2):(10**9/(($6)/($5))) \
        title '4 lists' with points lc rgb 'black'
		
# 2
set title "Spin-lock Synchronized Lists: Operations per second"
set xlabel "Threads"
set logscale x 2
set xrange [0.75:]
set ylabel "Operations per second"
set logscale y 10
set output 'lab2b_5.png'

# grep out only successful (sum=0)  unsynchronized runs
plot \
     "< grep list-none-s,[1,2,4,6,8]*,1000,1, lab_2b_list.csv" using ($2):(10**9/(($6)/($5))) \
		title '1 list' with points lc rgb 'green', \
     "< grep list-none-s,[1,2,4,6,8]*,1000,4, lab_2b_list.csv" using ($2):(10**9/(($6)/($5))) \
		title '2 lists' with points lc rgb 'red', \
     "< grep list-none-s,[1,2,4,6,8]*,1000,8, lab_2b_list.csv" using ($2):(10**9/(($6)/($5))) \
        title '3 lists' with points lc rgb 'blue', \
     "< grep list-none-s,[1,2,4,6,8]*,1000,16, lab_2b_list.csv" using ($2):(10**9/(($6)/($5))) \
        title '4 lists' with points lc rgb 'black'
	
