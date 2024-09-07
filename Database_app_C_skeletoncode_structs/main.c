#include <stdio.h>
#include "book.h"
#include "commands.h"

int main(void) {
  
  book book1;
  
  char *Options[] = {"list", "add", "delete", "more info"};
  int choice = 0;
  while(choice != -1){
    for(int i= 0; i <4; i++){
      printf("%d\t%s\n", i, Options[i]);
    }
    
    printf("please select your option from 0 to 3 and press enter:\t");
    
    scanf("%d", &choice); //&choice obtains the location of a value, *d obtains the value related to a pointer
    printf("%d\n", choice);
  
    switch(choice){
      case 0: 
        list();
        break; // a break statement is used here to prevent it from checking the next case after the chosen case
      case 1: 
        add();
        break;
      case 2: 
        deletebook();
        break;
      case 3: 
        moreinfo();
        break;
      case -1:
        break;
      default:
        printf("invalid option\n");
    }
  }
  
  return 0;
}

