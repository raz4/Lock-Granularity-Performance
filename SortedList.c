#define _GNU_SOURCE

#include "SortedList.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>

/*
 * SortedList (and SortedListElement)
 *
 *	A doubly linked list, kept sorted by a specified key.
 *	This structure is used for a list head, and each element
 *	of the list begins with this structure.
 *
 *	The list head is in the list, and an empty list contains
 *	only a list head.  The list head is also recognizable because
 *	it has a NULL key pointer.
 */
/*struct SortedListElement {
	struct SortedListElement *prev;
	struct SortedListElement *next;
	const char *key;
};
typedef struct SortedListElement SortedList_t;
typedef struct SortedListElement SortedListElement_t;*/


/**
 * SortedList_insert ... insert an element into a sorted list
 *
 *	The specified element will be inserted in to
 *	the specified list, which will be kept sorted
 *	in ascending order based on associated keys
 *
 * @param SortedList_t *list ... header for the list
 * @param SortedListElement_t *element ... element to be added to the list
 */
void SortedList_insert(SortedList_t *list, SortedListElement_t *element)
{

  /*SortedListElement_t* listcpy = list;
  while (listcpy->next != list && (strcmp(listcpy->next->key, element->key) < 0)){
    listcpy = listcpy->next;
  }
  element->next = listcpy->next;
  element->prev = listcpy;
  listcpy->next->prev = element;
  listcpy->next = element;*/

  	SortedListElement_t *previous = list;
  SortedListElement_t *next = list->next;
  while (next != list) {
    if (strcmp(element->key, next->key) <= 0) {
      break;
    }
    previous = next;
    next = next->next;
  }

  if (opt_yield & INSERT_YIELD) {
    pthread_yield();
  }

  element->prev = previous;
  element->next = next;
  previous->next = element;
  next->prev = element;
  
}

/**
 * SortedList_delete ... remove an element from a sorted list
 *
 *	The specified element will be removed from whatever
 *	list it is currently in.
 *
 *	Before doing the deletion, we check to make sure that
 *	next->prev and prev->next both point to this node
 *
 * @param SortedListElement_t *element ... element to be removed
 *
 * @return 0: element deleted successfully, 1: corrtuped prev/next pointers
 *
 */
int SortedList_delete( SortedListElement_t *element){
  if (element->next->prev != element || element->prev->next != element){
    return 1;
  }

  if (opt_yield & DELETE_YIELD){
    sched_yield();
  }
  
  element->next->prev = element->prev;
  element->prev->next = element->next;
  //    free(element);
  return 0;
}

/**
 * SortedList_lookup ... search sorted list for a key
 *
 *	The specified list will be searched for an
 *	element with the specified key.
 *
 * @param SortedList_t *list ... header for the list
 * @param const char * key ... the desired key
 *
 * @return pointer to matching element, or NULL if none is found
 */
SortedListElement_t *SortedList_lookup(SortedList_t *list, const char *key){
  SortedListElement_t* cpy = list->next;
  while(cpy != list){
    if (strcmp(cpy->key, key) == 0){
      if (opt_yield & LOOKUP_YIELD){
	sched_yield();
      }
      return cpy;
    }
    cpy = cpy->next;
  }

  if (opt_yield & LOOKUP_YIELD){
    sched_yield();
  }
  
  return NULL;
}

/**
 * SortedList_length ... count elements in a sorted list
 *	While enumeratign list, it checks all prev/next pointers
 *
 * @param SortedList_t *list ... header for the list
 *
 * @return int number of elements in list (excluding head)
 *	   -1 if the list is corrupted
 */
int SortedList_length(SortedList_t *list){
  SortedListElement_t* cpy = list->next;
  int size = 0;
  while (cpy != list){
    if (cpy->next->prev != cpy || cpy->prev->next != cpy){
      return -1;
    }
    size++;
    cpy = cpy->next;
  }

  if (opt_yield & LOOKUP_YIELD){
    sched_yield();
  }
  
  return size;
}

/**
 * variable to enable diagnositc yield calls
 */
extern int opt_yield;
#define	INSERT_YIELD	0x01	// yield in insert critical section
#define	DELETE_YIELD	0x02	// yield in delete critical section
#define	LOOKUP_YIELD	0x04	// yield in lookup/length critical esction
