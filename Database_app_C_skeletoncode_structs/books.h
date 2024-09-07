#ifndef BOOKS_H
#define BOOKS_H

#include "book.h"

struct booknode{
  book book;
  book *nextbook;
};

typedef struct booknode booknode;

void addBook(booknode *head, int day, int month, int year, char title[40], char author[40], char genre[20], int rating);
void printBooks(booknode *head);

#endif