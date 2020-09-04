/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * main.c
 *
 * Code generation for function 'main'
 *
 */

/*************************************************************************/
/* This automatically generated example C main file shows how to call    */
/* entry-point functions that MATLAB Coder generated. You must customize */
/* this file for your application. Do not modify this file directly.     */
/* Instead, make a copy of this file, modify it, and integrate it into   */
/* your development environment.                                         */
/*                                                                       */
/* This file initializes entry-point function arguments to a default     */
/* size and value before calling the entry-point functions. It does      */
/* not store or use any values returned from the entry-point functions.  */
/* If necessary, it does pre-allocate memory for returned values.        */
/* You can use this file as a starting point for a main function that    */
/* you can deploy in your application.                                   */
/*                                                                       */
/* After you copy the file, and before you deploy it, you must make the  */
/* following changes:                                                    */
/* * For variable-size function arguments, change the example sizes to   */
/* the sizes that your application requires.                             */
/* * Change the example values of function arguments to the values that  */
/* your application requires.                                            */
/* * If the entry-point functions return values, store these values or   */
/* otherwise use them as required by your application.                   */
/*                                                                       */
/*************************************************************************/
/* Include files */
#include "rt_nonfinite.h"
#include "RD_Gray_Scott.h"
#include "main.h"
#include "RD_Gray_Scott_terminate.h"
#include "RD_Gray_Scott_initialize.h"

/* Function Declarations */
static void main_RD_Gray_Scott(void);

/* Function Definitions */
static void main_RD_Gray_Scott(void)
{
  static double cDt[100000000];
  static double cEt[100000000];

  /* Call the entry-point 'RD_Gray_Scott'. */
  RD_Gray_Scott(cDt, cEt);
}

int main(int argc, const char * const argv[])
{
  (void)argc;
  (void)argv;

  /* Initialize the application.
     You do not need to do this more than one time. */
  RD_Gray_Scott_initialize();

  /* Invoke the entry-point functions.
     You can call entry-point functions multiple times. */
  main_RD_Gray_Scott();

  /* Terminate the application.
     You do not need to do this more than one time. */
  RD_Gray_Scott_terminate();
  return 0;
}

/* End of code generation (main.c) */
