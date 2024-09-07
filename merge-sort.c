#include <stdio.h>
#include <stdlib.h>

void merge(int *, int, int, int, int);

void merge_sort(int *list, int start_i, int end_i) {
  if (start_i >= end_i) {
    return;
  }
  
  int mid = (start_i + end_i) / 2;

  merge_sort(list, start_i, mid);
  merge_sort(list, mid + 1, end_i);

  int start_l = start_i;
  int length_l = mid - start_i + 1;
  int start_r = mid + 1;
  int length_r = end_i - mid;
  merge(list, start_l, length_l, start_r, length_r);
}

void merge(int *list, int start_l, int length_l, int start_r, int length_r) {
  int i = 0;
  int j = 0;

  while (i < length_l && j < length_r) {
    if (list[start_l + i] <= list[start_r + j]) {
      i++;
    } else {
      int value = list[start_r + j];
      int index = start_r + j;
      while (index > start_l + i) {
        list[index] = list[index - 1];
        index--;
      }
      list[start_l + i] = value;
      i++;
      j++;
    }
  }
}

int *createNumbers() {
  int *myNumbers = (int*) malloc(5 * sizeof(int));
  myNumbers[0] = 5;
  myNumbers[1] = 1;
  myNumbers[2] = 2;
  myNumbers[3] = 3;
  myNumbers[4] = 7;
  return myNumbers;
}

int main(void) {
  int *heapList = createNumbers();

  int stackList[] = {5, 1, 2, 3, 7};

  merge_sort(stackList, 0, 4);
  for (int i = 0; i < 5; i++) {
    printf("%d ", stackList[i]);
  }

  merge_sort(heapList, 0, 4);
  for (int i = 0; i < 5; i++) {
    printf("%d ", heapList[i]);
  }

  free(heapList);
}