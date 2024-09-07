#include <stdio.h>
#include "books.h"

void addBook(booknode *head, int day, int month, int year, char title[40], char author[40], char genre[20], int rating){
  
  book *newbook = (book *)malloc(sizeof(book)); //the malloc function is used here to allocate a portion of memory specifically to the size of the struct book depending on how many bytes it takes up as the size should be dynamic and memory shouldn't be unneedingly taken up
  newbook->releasedate.day = day;
  newbook->releasedate.month = month;
  newbook->releasedate.year = year;
  newbook->rating = rating;
  strcpy(newbook->title, title); //copies all the characters from title to newbook->title, because the value of title won't be the same 
  strcpy(newbook->author, author);
  strcpy(newbook->genre, genre);

  if(head == NULL){
    head = newbook;
  }
  
  while(head->nextbook != NULL){
    head = head->nextbook;
  }
  head->nextbook = newbook;
  
}

//perform the linked list implementation to add the book to the linked list

void printBooks(booknode *head){
  while(head != NULL){
    printf("%d, ", head->nextbook);
    head = head->nextbook;
  }
  
}
//print the items of the Linked list
