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
#include "power.h"
#include "RD_Gray_Scott.h"
#include "RD_Gray_Scott_data.h"
#include "RD_Gray_Scott_emxutil.h"
#include "eml_int_forloop_overflow_check.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo p_emlrtRSI = { 70,  /* lineNo */
  "power",                             /* fcnName */
  "/usr/local/MATLAB/R2020a/toolbox/eml/lib/matlab/ops/power.m"/* pathName */
};

static emlrtRSInfo q_emlrtRSI = { 79,  /* lineNo */
  "fltpower",                          /* fcnName */
  "/usr/local/MATLAB/R2020a/toolbox/eml/lib/matlab/ops/power.m"/* pathName */
};

static emlrtRSInfo s_emlrtRSI = { 188, /* lineNo */
  "flatIter",                          /* fcnName */
  "/usr/local/MATLAB/R2020a/toolbox/eml/eml/+coder/+internal/applyBinaryScalarFunction.m"/* pathName */
};

static emlrtRTEInfo sb_emlrtRTEI = { 79,/* lineNo */
  5,                                   /* colNo */
  "power",                             /* fName */
  "/usr/local/MATLAB/R2020a/toolbox/eml/lib/matlab/ops/power.m"/* pName */
};

/* Function Definitions */
void power(const emlrtStack *sp, const emxArray_real_T *a, emxArray_real_T *y)
{
  uint32_T unnamed_idx_0;
  uint32_T unnamed_idx_1;
  int32_T nx;
  int32_T k;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  emlrtStack e_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &p_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  d_st.prev = &c_st;
  d_st.tls = c_st.tls;
  e_st.prev = &d_st;
  e_st.tls = d_st.tls;
  b_st.site = &q_emlrtRSI;
  unnamed_idx_0 = (uint32_T)a->size[0];
  unnamed_idx_1 = (uint32_T)a->size[1];
  nx = y->size[0] * y->size[1];
  y->size[0] = (int32_T)unnamed_idx_0;
  y->size[1] = (int32_T)unnamed_idx_1;
  emxEnsureCapacity_real_T(&b_st, y, nx, &sb_emlrtRTEI);
  c_st.site = &r_emlrtRSI;
  nx = (int32_T)unnamed_idx_0 * (int32_T)unnamed_idx_1;
  d_st.site = &s_emlrtRSI;
  if ((1 <= nx) && (nx > 2147483646)) {
    e_st.site = &m_emlrtRSI;
    check_forloop_overflow_error(&e_st);
  }

  for (k = 0; k < nx; k++) {
    y->data[k] = a->data[k] * a->data[k];
  }
}

/* End of code generation (power.c) */
