#include <stdio.h>
#include <getopt.h>
#include <time.h>
#include <string.h>
#include <pthread.h>
#include <stdlib.h>
#include "SortedList.h"

#define KEY_LEN 10

extern char* optarg;
int rc = 0;
int opt_yield = 0;
int sync = 0;
int opt_mutex = 0;
int opt_spin = 0;
int num_threads = 1;
long long num_iterations = 1;
struct timespec start, end;
long long list_length = 0;
SortedListElement_t* elements;
pthread_mutex_t lock;
int spin_lock = 0;
int num = 0;
SortedListElement_t* list_head; // = malloc(sizeof(SortedListElement_t));
long long *mutex_time;
struct timespec *mutex_clock_start;
struct timespec *mutex_clock_end;
int lists = 0;
int lists_size = 1;
SortedListElement_t* lists_head;
pthread_mutex_t *lists_mlock = NULL;
int *lists_slock = NULL;


char* random_gen(const int len){
  char* s = malloc(len);
  static const char alphanum[] = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefgijklmnopqrstuvwxyz";
  for (int i = 0; i < len; i++){
    s[i] = alphanum[rand() % (sizeof(alphanum) - 1)];
  }
  return s;
}

/* HASH CODE CREDIT: DAN BERNSTEIN*/
unsigned long
hash(const unsigned char *str)
{
    unsigned long hash = 5381;
    int c;

    while (c = *str++)
        hash = ((hash << 5) + hash) + c; /* hash * 33 + c */

    return hash;
}

typedef struct arg_struct {
	int thread_num;
	long long start;
	pthread_mutex_t *thr_lock;
	SortedListElement_t* thr_list_head;
	int *thr_slock;
} arg_struct;

void *thr_func(void *arg){
  struct arg_struct *data = arg;
  long long finish = data->start + num_iterations;
  mutex_time[data->thread_num] = 0;
  /* add elements */
  if (opt_mutex){
    for (int i = data->start; i < finish; i++){

      if (lists){
		int list_num = hash(elements[i].key)%lists_size;
		data->thr_list_head = &lists_head[list_num];
		data->thr_lock = &lists_mlock[list_num];
      }
      else{
		data->thr_lock = &lock;
		data->thr_list_head = list_head;
      }
      
      clock_gettime(CLOCK_MONOTONIC, &mutex_clock_start[data->thread_num]);
	  if (pthread_mutex_lock(data->thr_lock)) {
		  perror("Thread couldn't acquire lock!");
		  exit(1);
	  }
      clock_gettime(CLOCK_MONOTONIC, &mutex_clock_end[data->thread_num]);
      SortedList_insert(data->thr_list_head, &elements[i]);
	  pthread_mutex_unlock(data->thr_lock);
      num++;
	  mutex_time[data->thread_num] += ( (mutex_clock_end[data->thread_num].tv_sec - mutex_clock_start[data->thread_num].tv_sec) * 1000000000) + mutex_clock_end[data->thread_num].tv_nsec - mutex_clock_start[data->thread_num].tv_nsec;
    }
  }
  else if (opt_spin){
    for (int i = data->start; i < finish; i++){

		if (lists) {
			int list_num = hash(elements[i].key) % lists_size;
			data->thr_list_head = &lists_head[list_num];
			data->thr_slock = &lists_slock[list_num];
		}
		else {
			data->thr_slock = &spin_lock;
			data->thr_list_head = list_head;
		}

      while (__sync_lock_test_and_set(data->thr_slock,1));
      SortedList_insert(data->thr_list_head, &elements[i]);
      __sync_lock_release(data->thr_slock);
    }
  }
  else {
    /* insert without sync */
    for (int i = data->start; i < finish; i++){
      if (lists){
        data->thr_list_head = &lists_head[hash(elements[i].key)%lists_size];
      }
	  else {
		  data->thr_list_head = list_head;
	  }
      SortedList_insert(data->thr_list_head, &elements[i]);
    }
  }

  

  /* get list length */
  if (lists) {
	  int thr_list_length = 0;
	  for (int i = 0; i < lists_size; i++) {
		  thr_list_length += SortedList_length(&lists_head[i]);
	  }
	  list_length = thr_list_length;
  }
  else {
	  list_length = SortedList_length(list_head);
  }

  /*if (opt_mutex){
	  if (lists) {
		  for (int i = 0; i < lists_size; i++) {
			  list_length += SortedList_length(&lists_head[i]);
		  }
	  }
	  else {
		  //clock_gettime(CLOCK_MONOTONIC, &mutex_clock_start[data->thread_num]);
		  //pthread_mutex_lock(data->thr_lock);
		  //clock_gettime(CLOCK_MONOTONIC, &mutex_clock_end[data->thread_num]);
		  list_length = SortedList_length(data->thr_list_head);
		  //pthread_mutex_unlock(data->thr_lock);
	  }
    
  }
  else if (opt_spin){
	  if (lists) {
		  for (int i )
	  }
    while (__sync_lock_test_and_set(&spin_lock,1));
    list_length = SortedList_length(list_head);
    __sync_lock_release(&spin_lock);
  }
  else {
    
    list_length = SortedList_length(list_head);
  }

  //mutex_time[data->thread_num] += ( (mutex_clock_end[data->thread_num].tv_sec - mutex_clock_start[data-\
>thread_num].tv_sec) * 1000000000) + mutex_clock_end[data->thread_num].tv_nsec - mutex_clock_start[dat\
a->thread_num].tv_nsec;*/
  
  SortedListElement_t* element_lookup;
  /* look up and delete elements */
  if (opt_mutex){
    for (int i = data->start; i < finish; i++){

		if (lists) {
			int list_num = hash(elements[i].key) % lists_size;
			data->thr_list_head = &lists_head[list_num];
			data->thr_lock = &lists_mlock[list_num];
		}
      
      clock_gettime(CLOCK_MONOTONIC, &mutex_clock_start[data->thread_num]);
	  pthread_mutex_lock(data->thr_lock);
      clock_gettime(CLOCK_MONOTONIC, &mutex_clock_end[data->thread_num]);
      element_lookup = SortedList_lookup(data->thr_list_head, elements[i].key);
      if (element_lookup == NULL){
        perror("ELEMENT DOES NOT EXIST\n");
		exit(1);
      }
      else if (SortedList_delete(element_lookup) == -1){
        perror("ERROR DELETING ELEMENT\n");
		exit(1);
      };
	  pthread_mutex_unlock(data->thr_lock);
	mutex_time[data->thread_num] += ( (mutex_clock_end[data->thread_num].tv_sec - mutex_clock_start[data-\
>thread_num].tv_sec) * 1000000000) + mutex_clock_end[data->thread_num].tv_nsec - mutex_clock_start[dat\
a->thread_num].tv_nsec;
    }
  }
  else if (opt_spin){
    for (int i = data->start; i < finish; i++){
		if (lists) {
			int list_num = hash(elements[i].key) % lists_size;
			data->thr_list_head = &lists_head[list_num];
			data->thr_slock = &lists_slock[list_num];
		}
      
		while (__sync_lock_test_and_set(data->thr_slock, 1));
		element_lookup = SortedList_lookup(data->thr_list_head, elements[i].key);
		if (element_lookup == NULL){
			perror("\nELEMENT DOES NOT EXIST\n");
		};
		if (SortedList_delete(element_lookup) == -1){
			perror("\nERROR DELETING ELEMENT\n");
		};
		__sync_lock_release(data->thr_slock);
    }
  }
  else {
    for (int i = data->start; i < finish; i++){

      if (lists){
        list_head = &lists_head[hash(elements[i].key)%lists_size];
      }
      
      element_lookup = SortedList_lookup(list_head, elements[i].key);
      if (element_lookup == NULL){
        perror("\nELEMENT DOES NOT EXIST\n");
      };
      if (SortedList_delete(element_lookup) == -1){
        perror("\nERROR DELETING ELEMENT\n");
      };
    }
  }

  
   
}

int main(int argc, char * argv[]){

  static struct option long_options[] = {
    {"threads", required_argument, 0, 'a'},
    {"iterations", required_argument, 0, 'b'},
    {"yield", required_argument, 0, 'c'},
    {"sync", required_argument, 0, 'd'},
    {"lists", required_argument, 0, 'e'},
    {NULL, 0, NULL, 0},
  };

  int option_index = 0;
  int c = getopt_long(argc, argv, "", long_options, &option_index);
  while (c != -1){
    switch(c){
    case 'a':
      num_threads = atoi(optarg);
      break;
    case 'b':
      num_iterations = atoi(optarg);
      break;
    case 'c':
      for (int i = 0; i < strlen(optarg); i++){
	if (!strncmp(optarg+i, "i",1)){
	  opt_yield |= INSERT_YIELD;
	}
	if (!strncmp(optarg+i, "d",1)){
	  opt_yield |= DELETE_YIELD;
	}
	if (!strncmp(optarg+i, "l",1)){
	  opt_yield |= LOOKUP_YIELD;
	}
      }
      break;
    case 'd':
      if (optarg[0] == 's'){
		sync = 's';
		opt_spin = 1;
      }
      else if (optarg[0] == 'm'){
		sync = 'm';
		opt_mutex = 1;
		if (pthread_mutex_init(&lock, NULL) != 0){
		  printf("ERROR: Mutex init failed!\n");
		  exit(1);
		}
      }
      else {
		perror("INVALID SYNC OPTION!");
		exit(1);
      }
      break;
    case 'e':
      lists = 1;
      lists_size = atoi(optarg);
      break;
    default:
      break;
    }
    c = getopt_long(argc, argv, "", long_options, &option_index);
  }

  

  long long num_elements = num_iterations * num_threads;
  elements = (SortedListElement_t *)malloc(num_elements*sizeof(SortedListElement_t));

  for (long long i = 0; i < num_elements; i++){
    elements[i].key = random_gen(KEY_LEN);
  }

  pthread_t threads[num_threads];
  
  mutex_time = malloc(sizeof(long long)*num_threads);

  mutex_clock_start = malloc(sizeof(struct timespec)*num_threads);
  mutex_clock_end = malloc(sizeof(struct timespec)*num_threads);
  
  struct arg_struct* args = malloc(num_threads*sizeof(arg_struct));
  for (int i = 0; i < num_threads; i++){
    args[i].start = i * num_iterations;
  }

  if (lists){
    lists_head = malloc(lists_size * sizeof(SortedListElement_t));
    for (int i = 0; i < lists_size; i++){
      lists_head[i].prev = &lists_head[i];
      lists_head[i].next = &lists_head[i];
      lists_head[i].key = NULL;
   }
    if (opt_mutex){
      lists_mlock = malloc(sizeof(pthread_mutex_t)*lists_size);
      for (int i = 0; i < lists_size; i++){
		pthread_mutex_init(&lists_mlock[i], NULL);
      }
    }
    else if (opt_spin){
		lists_slock = malloc(sizeof(int)*lists_size);
		for (int i = 0; i < lists_size; i++) {
			lists_slock[i] = 0;
		}
    }
  }
  else {
	  list_head = malloc(sizeof(SortedListElement_t));
	  list_head->prev = list_head;
	  list_head->next = list_head;
	  list_head->key = NULL;
  }
  
  /* start timer */
  clock_gettime(CLOCK_MONOTONIC, &start);
  
  /* create threads */
  for (int i = 0; i < num_threads; i++){
    args[i].thread_num = i;
    if ((rc = pthread_create(&threads[i], NULL, thr_func, &args[i]))){
      fprintf(stderr, "ERROR: pthread_create, CODE: %d\n", rc);
      return 1;
    }
  }

  /* wait for threads to finish */
  for (int i = 0; i < num_threads; i++){
    pthread_join(threads[i], NULL);
  }

  /* end timer */
  clock_gettime(CLOCK_MONOTONIC, &end);

  long long total_time_ns = ( (end.tv_sec - start.tv_sec) * 1000000000) + end.tv_nsec - start.tv_nsec;
  long long num_ops = num_threads * num_iterations * 3;
  long long avg_time_op = total_time_ns / num_ops;
  
  if (!lists) {
	  if (SortedList_length(list_head) != 0) {
		  fprintf(stderr, "\n%i\n", SortedList_length(list_head));
		  perror("ERROR: List length is not zero!");
		  exit(1);
	  }
  }
  else {
	  for (int i = 0; i < lists_size; i++) {
		  if (SortedList_length(&lists_head[i]) != 0) {
			  fprintf(stderr, "\n%i\n", SortedList_length(list_head));
			  perror("ERROR: List length is not zero!");
			  exit(1);
		  }
	  }
  }

  /* sum the mutex acquisition time for all threads */
  long long total_mutex_acq = 0;
  printf("list-");
  if (opt_yield & INSERT_YIELD){
    printf("i");
  }
  if (opt_yield & DELETE_YIELD){
    printf("d");
  }
  if (opt_yield & LOOKUP_YIELD){
    printf("l");
  }
  if (opt_yield == 0){
    printf("none");
  }
  printf("-");
  if (sync == 'm'){
    printf("m");
    for (int i = 0; i < num_threads; i++){
      total_mutex_acq += mutex_time[i];
    }
    total_mutex_acq /= num_threads;
  }
  if (sync == 's'){
    printf("s");
  }
  if (sync == 0){
    printf("none");
  }
  printf(",%i,%lli,%i,%lli,%lli,%lli,%lli\n", num_threads, num_iterations, lists_size, num_ops, total_time_ns, avg_time_op, total_mutex_acq);

  free(elements);

  return 0;
}
