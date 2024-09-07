#ifndef DATE_H //header guard to prevent it from being included by more than one header file in main.c, i.e: if commands.h and book.h both include date.h and main.c also includes commands.h and book.h so this prevents it from being referenced more than once in a program
#define DATE_H 
//this is also part of the header guard

struct date{
  int day;
  int month;
  int year;
};

typedef struct date date;

#endif //you end the header guard with this after the rest of the process
