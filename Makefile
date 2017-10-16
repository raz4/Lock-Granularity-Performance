#!/bin/sh
.SILENT:

default:
	gcc -g -pthread lab2_list.c SortedList.c -o lab2_list

profile: default
	-rm -f ./raw-gperf
	LD_PRELOAD=./libprofiler.so.0 CPUPROFILE=./raw.gperf ./lab2_list --threads=12 --iterations=1000 --sync=s
	./pprof --text ./lab2_list ./raw.gperf > profile_spin
	./pprof --list=thr_func ./lab2_list ./raw.gperf >> profile_spin
	rm -f ./raw.gperf
	LD_PRELOAD=./libprofiler.so.0 CPUPROFILE=./raw.gperf ./lab2_list --threads=12 --iterations=1000 --sync=m
	./pprof --text ./lab2_list ./raw.gperf > profile_mutex
	./pprof --list=thr_func ./lab2_list ./raw.gperf >> profile_mutex
	rm -f ./raw.gperf

tests: default
	#timing mutex waits
	-rm -f lab_2b_list_1.csv
	./lab2_list --iterations=1000 --threads=1 --sync=m >> lab_2b_list_1.csv
	./lab2_list --iterations=1000 --threads=2 --sync=m >> lab_2b_list_1.csv
	./lab2_list --iterations=1000 --threads=4 --sync=m >> lab_2b_list_1.csv
	./lab2_list --iterations=1000 --threads=8 --sync=m >> lab_2b_list_1.csv
	./lab2_list --iterations=1000 --threads=16 --sync=m >> lab_2b_list_1.csv
	./lab2_list --iterations=1000 --threads=24 --sync=m >> lab_2b_list_1.csv

	#confirming correctness of new implementation
	#no synchronization
	-rm -f lab_2b_list_2.csv
	./lab2_list --threads=1 --iterations=1 --lists=4 --yield=id 2>/dev/null | cat >> lab_2b_list_2.csv
	./lab2_list --threads=1 --iterations=2 --lists=4 --yield=id 2>/dev/null | cat >> lab_2b_list_2.csv
	./lab2_list --threads=1 --iterations=4 --lists=4 --yield=id 2>/dev/null | cat >> lab_2b_list_2.csv
	./lab2_list --threads=1 --iterations=8 --lists=4 --yield=id 2>/dev/null | cat >> lab_2b_list_2.csv
	./lab2_list --threads=1 --iterations=16 --lists=4 --yield=id 2>/dev/null | cat >> lab_2b_list_2.csv
	./lab2_list --threads=4 --iterations=1 --lists=4 --yield=id 2>/dev/null | cat >> lab_2b_list_2.csv
	./lab2_list --threads=4 --iterations=2 --lists=4 --yield=id 2>/dev/null | cat >> lab_2b_list_2.csv
	./lab2_list --threads=4 --iterations=4 --lists=4 --yield=id 2>/dev/null | cat >> lab_2b_list_2.csv
	./lab2_list --threads=4 --iterations=8 --lists=4 --yield=id 2>/dev/null | cat >> lab_2b_list_2.csv
	./lab2_list --threads=4 --iterations=16 --lists=4 --yield=id 2>/dev/null | cat >> lab_2b_list_2.csv
	./lab2_list --threads=8 --iterations=1 --lists=4 --yield=id 2>/dev/null | cat >> lab_2b_list_2.csv
	./lab2_list --threads=8 --iterations=2 --lists=4 --yield=id 2>/dev/null | cat >> lab_2b_list_2.csv
	./lab2_list --threads=8 --iterations=4 --lists=4 --yield=id 2>/dev/null | cat >> lab_2b_list_2.csv
	./lab2_list --threads=8 --iterations=8 --lists=4 --yield=id 2>/dev/null | cat >> lab_2b_list_2.csv
	./lab2_list --threads=8 --iterations=16 --lists=4 --yield=id 2>/dev/null | cat >> lab_2b_list_2.csv
	./lab2_list --threads=12 --iterations=1 --lists=4 --yield=id 2>/dev/null | cat >> lab_2b_list_2.csv
	./lab2_list --threads=12 --iterations=2 --lists=4 --yield=id 2>/dev/null | cat >> lab_2b_list_2.csv
	./lab2_list --threads=12 --iterations=4 --lists=4 --yield=id 2>/dev/null | cat >> lab_2b_list_2.csv
	./lab2_list --threads=12 --iterations=8 --lists=4 --yield=id 2>/dev/null | cat >> lab_2b_list_2.csv
	./lab2_list --threads=12 --iterations=16 --lists=4 --yield=id 2>/dev/null | cat >> lab_2b_list_2.csv
	./lab2_list --threads=16 --iterations=1 --lists=4 --yield=id 2>/dev/null | cat >> lab_2b_list_2.csv
	./lab2_list --threads=16 --iterations=2 --lists=4 --yield=id 2>/dev/null | cat >> lab_2b_list_2.csv
	./lab2_list --threads=16 --iterations=4 --lists=4 --yield=id 2>/dev/null | cat >> lab_2b_list_2.csv
	./lab2_list --threads=16 --iterations=8 --lists=4 --yield=id 2>/dev/null | cat >> lab_2b_list_2.csv
	./lab2_list --threads=16 --iterations=16 --lists=4 --yield=id 2>/dev/null | cat >> lab_2b_list_2.csv
	#mutex and spin synchronization
	-rm -f lab_2b_list_3.csv
	./lab2_list --threads=1 --iterations=1 --lists=4 --yield=id --sync=s 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=1 --iterations=2 --lists=4 --yield=id --sync=s 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=1 --iterations=4 --lists=4 --yield=id --sync=s 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=1 --iterations=8 --lists=4 --yield=id --sync=s 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=1 --iterations=16 --lists=4 --yield=id --sync=s 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=4 --iterations=1 --lists=4 --yield=id --sync=s 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=4 --iterations=2 --lists=4 --yield=id --sync=s 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=4 --iterations=4 --lists=4 --yield=id --sync=s 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=4 --iterations=8 --lists=4 --yield=id --sync=s 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=4 --iterations=16 --lists=4 --yield=id --sync=s 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=8 --iterations=1 --lists=4 --yield=id --sync=s 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=8 --iterations=2 --lists=4 --yield=id --sync=s 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=8 --iterations=4 --lists=4 --yield=id --sync=s 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=8 --iterations=8 --lists=4 --yield=id --sync=s 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=8 --iterations=16 --lists=4 --yield=id --sync=s 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=12 --iterations=1 --lists=4 --yield=id --sync=s 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=12 --iterations=2 --lists=4 --yield=id --sync=s 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=12 --iterations=4 --lists=4 --yield=id --sync=s 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=12 --iterations=8 --lists=4 --yield=id --sync=s 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=12 --iterations=16 --lists=4 --yield=id --sync=s 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=16 --iterations=1 --lists=4 --yield=id --sync=s 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=16 --iterations=2 --lists=4 --yield=id --sync=s 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=16 --iterations=4 --lists=4 --yield=id --sync=s 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=16 --iterations=8 --lists=4 --yield=id --sync=s 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=16 --iterations=16 --lists=4 --yield=id --sync=s 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=1 --iterations=1 --lists=4 --yield=id --sync=m 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=1 --iterations=2 --lists=4 --yield=id --sync=m 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=1 --iterations=4 --lists=4 --yield=id --sync=m 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=1 --iterations=8 --lists=4 --yield=id --sync=m 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=1 --iterations=16 --lists=4 --yield=id --sync=m 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=4 --iterations=1 --lists=4 --yield=id --sync=m 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=4 --iterations=2 --lists=4 --yield=id --sync=m 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=4 --iterations=4 --lists=4 --yield=id --sync=m 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=4 --iterations=8 --lists=4 --yield=id --sync=m 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=4 --iterations=16 --lists=4 --yield=id --sync=m 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=8 --iterations=1 --lists=4 --yield=id --sync=m 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=8 --iterations=2 --lists=4 --yield=id --sync=m 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=8 --iterations=4 --lists=4 --yield=id --sync=m 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=8 --iterations=8 --lists=4 --yield=id --sync=m 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=8 --iterations=16 --lists=4 --yield=id --sync=m 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=12 --iterations=1 --lists=4 --yield=id --sync=m 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=12 --iterations=2 --lists=4 --yield=id --sync=m 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=12 --iterations=4 --lists=4 --yield=id --sync=m 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=12 --iterations=8 --lists=4 --yield=id --sync=m 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=12 --iterations=16 --lists=4 --yield=id --sync=m 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=16 --iterations=1 --lists=4 --yield=id --sync=m 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=16 --iterations=2 --lists=4 --yield=id --sync=m 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=16 --iterations=4 --lists=4 --yield=id --sync=m 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=16 --iterations=8 --lists=4 --yield=id --sync=m 2>/dev/null | cat >> lab_2b_list_3.csv
	./lab2_list --threads=16 --iterations=16 --lists=4 --yield=id --sync=m 2>/dev/null | cat >> lab_2b_list_3.csv
	#performance analysis
	-rm -f lab_2b_list.csv
	./lab2_list --threads=1 --iterations=1000 --lists=1 --sync=s >> lab_2b_list.csv
	./lab2_list --threads=1 --iterations=1000 --lists=4 --sync=s >> lab_2b_list.csv
	./lab2_list --threads=1 --iterations=1000 --lists=8 --sync=s >> lab_2b_list.csv
	./lab2_list --threads=1 --iterations=1000 --lists=16 --sync=s >> lab_2b_list.csv
	./lab2_list --threads=4 --iterations=1000 --lists=1 --sync=s >> lab_2b_list.csv
	./lab2_list --threads=4 --iterations=1000 --lists=4 --sync=s >> lab_2b_list.csv
	./lab2_list --threads=4 --iterations=1000 --lists=8 --sync=s >> lab_2b_list.csv
	./lab2_list --threads=4 --iterations=1000 --lists=16 --sync=s >> lab_2b_list.csv
	./lab2_list --threads=8 --iterations=1000 --lists=1 --sync=s >> lab_2b_list.csv
	./lab2_list --threads=8 --iterations=1000 --lists=4 --sync=s >> lab_2b_list.csv
	./lab2_list --threads=8 --iterations=1000 --lists=8 --sync=s >> lab_2b_list.csv
	./lab2_list --threads=8 --iterations=1000 --lists=16 --sync=s >> lab_2b_list.csv
	./lab2_list --threads=12 --iterations=1000 --lists=1 --sync=s >> lab_2b_list.csv
	./lab2_list --threads=12 --iterations=1000 --lists=4 --sync=s >> lab_2b_list.csv
	./lab2_list --threads=12 --iterations=1000 --lists=8 --sync=s >> lab_2b_list.csv
	./lab2_list --threads=12 --iterations=1000 --lists=16 --sync=s >> lab_2b_list.csv
	./lab2_list --threads=16 --iterations=1000 --lists=1 --sync=s >> lab_2b_list.csv
	./lab2_list --threads=16 --iterations=1000 --lists=4 --sync=s >> lab_2b_list.csv
	./lab2_list --threads=16 --iterations=1000 --lists=8 --sync=s >> lab_2b_list.csv
	./lab2_list --threads=16 --iterations=1000 --lists=16 --sync=s >> lab_2b_list.csv
	./lab2_list --threads=1 --iterations=1000 --lists=1 --sync=m >> lab_2b_list.csv
	./lab2_list --threads=1 --iterations=1000 --lists=4 --sync=m >> lab_2b_list.csv
	./lab2_list --threads=1 --iterations=1000 --lists=8 --sync=m >> lab_2b_list.csv
	./lab2_list --threads=1 --iterations=1000 --lists=16 --sync=m >> lab_2b_list.csv
	./lab2_list --threads=4 --iterations=1000 --lists=1 --sync=m >> lab_2b_list.csv
	./lab2_list --threads=4 --iterations=1000 --lists=4 --sync=m >> lab_2b_list.csv
	./lab2_list --threads=4 --iterations=1000 --lists=8 --sync=m >> lab_2b_list.csv
	./lab2_list --threads=4 --iterations=1000 --lists=16 --sync=m >> lab_2b_list.csv
	./lab2_list --threads=8 --iterations=1000 --lists=1 --sync=m >> lab_2b_list.csv
	./lab2_list --threads=8 --iterations=1000 --lists=4 --sync=m >> lab_2b_list.csv
	./lab2_list --threads=8 --iterations=1000 --lists=8 --sync=m >> lab_2b_list.csv
	./lab2_list --threads=8 --iterations=1000 --lists=16 --sync=m >> lab_2b_list.csv
	./lab2_list --threads=12 --iterations=1000 --lists=1 --sync=m >> lab_2b_list.csv
	./lab2_list --threads=12 --iterations=1000 --lists=4 --sync=m >> lab_2b_list.csv
	./lab2_list --threads=12 --iterations=1000 --lists=8 --sync=m >> lab_2b_list.csv
	./lab2_list --threads=12 --iterations=1000 --lists=16 --sync=m >> lab_2b_list.csv
	./lab2_list --threads=16 --iterations=1000 --lists=1 --sync=m >> lab_2b_list.csv
	./lab2_list --threads=16 --iterations=1000 --lists=4 --sync=m >> lab_2b_list.csv
	./lab2_list --threads=16 --iterations=1000 --lists=8 --sync=m >> lab_2b_list.csv
	./lab2_list --threads=16 --iterations=1000 --lists=16 --sync=m >> lab_2b_list.csv

graphs: tests
	gnuplot lab2_1.gp
	gnuplot lab2_2.gp
	gnuplot lab2_3.gp
	gnuplot lab2_4.gp

tarball:
	tar -cvf lab2b-704666892.tar.gz SortedList.h SortedList.c lab2_list.c Makefile lab2b_add.csv lab_2b_list_0.csv lab_2b_list_1.csv lab_2b_list_2.csv lab_2b_list_3.csv lab_2b_list.csv profile_mutex profile_spin pprof libprofiler.so.0 lab2b_1.png lab2b_2.png lab2b_3.png lab2b_4.png lab2b_5.png lab2_1.gp lab2_2.gp lab2_3.gp lab2_4.gp README.txt

clean:
	-rm -f lab2_list

