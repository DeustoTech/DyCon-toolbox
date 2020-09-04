/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * mcadd.c
 *
 * Code generation for function 'mcadd'
 *
 */

/* Include files */
#include "mcadd.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void mcadd(const real_T u[4], real_T v, real_T y[4])
{
  /*  The directive %#codegen indicates that the function */
  /*  is intended for code generation */
  y[0] = u[0] + v;
  y[1] = u[1] + v;
  y[2] = u[2] + v;
  y[3] = u[3] + v;
}

/* End of code generation (mcadd.c) */
