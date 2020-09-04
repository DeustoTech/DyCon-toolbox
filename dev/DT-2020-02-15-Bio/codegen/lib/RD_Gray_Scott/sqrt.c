/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * sqrt.c
 *
 * Code generation for function 'sqrt'
 *
 */

/* Include files */
#include <math.h>
#include "rt_nonfinite.h"
#include "RD_Gray_Scott.h"
#include "sqrt.h"

/* Function Definitions */
void b_sqrt(double x[10000])
{
  int k;
  for (k = 0; k < 10000; k++) {
    x[k] = sqrt(x[k]);
  }
}

/* End of code generation (sqrt.c) */
