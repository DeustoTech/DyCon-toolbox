/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * sin.c
 *
 * Code generation for function 'sin'
 *
 */

/* Include files */
#include "sin.h"
#include "RD_Gray_Scott.h"
#include "RD_Gray_Scott_data.h"
#include "eml_int_forloop_overflow_check.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo y_emlrtRSI = { 11,  /* lineNo */
  "sin",                               /* fcnName */
  "/usr/local/MATLAB/R2020a/toolbox/eml/lib/matlab/elfun/sin.m"/* pathName */
};

/* Function Definitions */
void b_sin(const emlrtStack *sp, emxArray_real_T *x)
{
  int32_T nx;
  int32_T k;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &y_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  nx = x->size[0] * x->size[1];
  b_st.site = &u_emlrtRSI;
  if ((1 <= nx) && (nx > 2147483646)) {
    c_st.site = &m_emlrtRSI;
    check_forloop_overflow_error(&c_st);
  }

  for (k = 0; k < nx; k++) {
    x->data[k] = muDoubleScalarSin(x->data[k]);
  }
}

/* End of code generation (sin.c) */
