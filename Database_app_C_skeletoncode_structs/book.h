#ifndef BOOK_H
#define BOOK_H
#include "date.h"

struct book{ // this is a struct declaration, here you mention struct and the name of the struct then a curly bracket
  date releasedate;
  char title[40];
  char author[40];
  char genre[20];
  int rating;
  
}; //to enclose a struct, put the curly bracket and then a semicolon

typedef struct book book; // the typedef struct structname shortform, this just means struct book can be referred to as simply "book", so an identifier is being assigned to the struct otherwise it would have to be referenced as struct book every time

void printBook(book book);


#endif