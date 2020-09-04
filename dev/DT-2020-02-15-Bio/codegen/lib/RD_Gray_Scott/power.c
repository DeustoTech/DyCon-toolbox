/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * power.c
 *
 * Code generation for function 'power'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "RD_Gray_Scott.h"
#include "power.h"

/* Function Definitions */
void power(const double a[10000], double y[10000])
{
  int k;
  for (k = 0; k < 10000; k++) {
    y[k] = a[k] * a[k];
  }
}

/* End of code generation (power.c) */
