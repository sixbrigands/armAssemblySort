#include "mbed.h"

extern "C" int sort(int numbers[16], int size);
void c_sort (int numbers[16], int size);
// Declare LED outputs
DigitalOut myled1(LED1);
DigitalOut myled2(LED2);
DigitalOut myled3(LED3);
DigitalOut myled4(LED4);
// Set up array to sort
const int size = 16;
int numbers[size] = {12, 11, 14, 10, 9, 8, 22, 7, 6, 5, 15, 4, 3, 2, 0, 1};


int main() {
    // Show current array contents and set lights to "before" pattern
    printf("\n\rBefore:\n\r");
    for(int index = 0; index <= size-1; index++) {
        printf("%d, ", numbers[index]); 
    }
    
    sort(numbers, size); // Call to assembly sort numbers goes to R0 and size goes to R1
    //c_sort(numbers, size); // Call to driver test stub
    
    printf("\n\rAfter:\n\r");
    for(int index = 0; index <= size-1; index++) {
        printf("%d, ", numbers[index]); 
    }
    printf("\n\rDONE!!!\n\r");
    while(1) {}
}


// C version of sort function, to test algorithm and driver
void c_sort (int numbers[16], int size){
    int temp;
    for (int out_count = 0; out_count <= size - 2; out_count++){
        for (int in_count = 0; in_count <= size - 2 - out_count; in_count++){
            if (numbers[in_count] > numbers[in_count + 1]){
                temp = numbers[in_count];
                numbers[in_count] = numbers[in_count + 1];
                numbers[in_count + 1] = temp;
            }
        }
    }
}
