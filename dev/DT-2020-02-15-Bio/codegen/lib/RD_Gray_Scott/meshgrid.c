/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * meshgrid.c
 *
 * Code generation for function 'meshgrid'
 *
 */

/* Include files */
#include <string.h>
#include "rt_nonfinite.h"
#include "RD_Gray_Scott.h"
#include "meshgrid.h"

/* Function Definitions */
void meshgrid(const double x[100], const double y[100], double xx[10000], double
              yy[10000])
{
  int j;
  int i;
  for (j = 0; j < 100; j++) {
    memcpy(&yy[j * 100], &y[0], 100U * sizeof(double));
    for (i = 0; i < 100; i++) {
      xx[i + 100 * j] = x[j];
    }
  }
}

/* End of code generation (meshgrid.c) */
