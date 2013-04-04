/*
 * gcd.c
 *
 *  Created on: Feb 18, 2013
 *      Author: Shaoyi Cheng
 */
#include <stdio.h>

int getCurNum()
{
	int curNum=0;
	while(1)
	{
		char curChar = getchar();
		// echo the current character
		xil_printf("%c", curChar);
		//
		if(curChar == '\r')
		{
			print("\r\n");
			return curNum;
		}
		else if(curChar >= '0' && curChar <='9')
		{
			curNum = curNum*10+(curChar - '0');
		}
	}
}
int computeGCD(int firstNum, int secondNum)
{
	int done = 0;
	int A=firstNum,B=secondNum;
	while(!done)
	{
		if(A < B)
		{
			int swap = A;
			A = B;
			B = swap;
		}
		else if(B!=0)
		{
			A = A-B;
		}
		else
			done = 1;
	}
	return A;
	
}
int main()
{
	print("GCD program started, please enter two positive numbers.\r\n");

	while(1)
	{
		print("Enter the first number (non-numeric chars will be ignored):\r\n");
		int firstNum = getCurNum();
		print("Enter the second number (non-numeric chars will be ignored):\r\n");
		int secondNum = getCurNum();
		int gcd = computeGCD(firstNum, secondNum);
		xil_printf("The gcd of %d and %d is %d!\r\n", firstNum, secondNum, gcd);
	}
	return 0;

}

