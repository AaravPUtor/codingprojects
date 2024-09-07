#include <stdio.h>
#include "book.h"

void printBook(book book){
  printf("Release date: %d.%d.%d", book.releasedate.day, book.releasedate.month, book.releasedate.year);
  printf("Title: %s", book.title);
  printf("Author: %s", book.author);
  printf("Genre: %s", book.genre);
  printf("Rating: %d", book.rating);
}
  
