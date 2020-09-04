/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * rand.c
 *
 * Code generation for function 'rand'
 *
 */

/* Include files */
#include "rand.h"
#include "RD_Gray_Scott.h"
#include "RD_Gray_Scott_emxutil.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRTEInfo vb_emlrtRTEI = { 1,/* lineNo */
  14,                                  /* colNo */
  "rand",                              /* fName */
  "/usr/local/MATLAB/R2020a/toolbox/eml/lib/matlab/randfun/rand.m"/* pName */
};

/* Function Definitions */
void b_rand(const emlrtStack *sp, const real_T varargin_1[2], emxArray_real_T *r)
{
  int32_T i;
  int32_T i1;
  int32_T i2;
  i = (int32_T)varargin_1[0];
  i1 = r->size[0] * r->size[1];
  r->size[0] = i;
  i2 = (int32_T)varargin_1[1];
  r->size[1] = i2;
  emxEnsureCapacity_real_T(sp, r, i1, &vb_emlrtRTEI);
  if ((i != 0) && (i2 != 0)) {
    emlrtRandu(&r->data[0], (int32_T)varargin_1[0] * (int32_T)varargin_1[1]);
  }
}

/* End of code generation (rand.c) */
