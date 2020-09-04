/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * atan2.c
 *
 * Code generation for function 'atan2'
 *
 */

/* Include files */
#include "atan2.h"
#include "RD_Gray_Scott.h"
#include "RD_Gray_Scott_data.h"
#include "RD_Gray_Scott_emxutil.h"
#include "eml_int_forloop_overflow_check.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include "scalexpAlloc.h"

/* Variable Definitions */
static emlrtRSInfo v_emlrtRSI = { 12,  /* lineNo */
  "atan2",                             /* fcnName */
  "/usr/local/MATLAB/R2020a/toolbox/eml/lib/matlab/elfun/atan2.m"/* pathName */
};

static emlrtRSInfo w_emlrtRSI = { 46,  /* lineNo */
  "applyBinaryScalarFunction",         /* fcnName */
  "/usr/local/MATLAB/R2020a/toolbox/eml/eml/+coder/+internal/applyBinaryScalarFunction.m"/* pathName */
};

static emlrtRSInfo x_emlrtRSI = { 202, /* lineNo */
  "flatIter",                          /* fcnName */
  "/usr/local/MATLAB/R2020a/toolbox/eml/eml/+coder/+internal/applyBinaryScalarFunction.m"/* pathName */
};

static emlrtRTEInfo c_emlrtRTEI = { 19,/* lineNo */
  23,                                  /* colNo */
  "scalexpAlloc",                      /* fName */
  "/usr/local/MATLAB/R2020a/toolbox/eml/eml/+coder/+internal/scalexpAlloc.m"/* pName */
};

static emlrtRTEInfo tb_emlrtRTEI = { 46,/* lineNo */
  6,                                   /* colNo */
  "applyBinaryScalarFunction",         /* fName */
  "/usr/local/MATLAB/R2020a/toolbox/eml/eml/+coder/+internal/applyBinaryScalarFunction.m"/* pName */
};

static emlrtRTEInfo ub_emlrtRTEI = { 12,/* lineNo */
  5,                                   /* colNo */
  "atan2",                             /* fName */
  "/usr/local/MATLAB/R2020a/toolbox/eml/lib/matlab/elfun/atan2.m"/* pName */
};

/* Function Definitions */
void b_atan2(const emlrtStack *sp, const emxArray_real_T *y, const
             emxArray_real_T *x, emxArray_real_T *r)
{
  emxArray_real_T *z;
  int32_T csz_idx_0;
  int32_T csz_idx_1;
  int32_T i;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  d_st.prev = &c_st;
  d_st.tls = c_st.tls;
  emlrtHeapReferenceStackEnterFcnR2012b(sp);
  emxInit_real_T(sp, &z, 2, &tb_emlrtRTEI, true);
  st.site = &v_emlrtRSI;
  b_st.site = &w_emlrtRSI;
  if (y->size[0] <= x->size[0]) {
    csz_idx_0 = y->size[0];
  } else {
    csz_idx_0 = x->size[0];
  }

  if (y->size[1] <= x->size[1]) {
    csz_idx_1 = y->size[1];
  } else {
    csz_idx_1 = x->size[1];
  }

  i = z->size[0] * z->size[1];
  if (y->size[0] <= x->size[0]) {
    z->size[0] = y->size[0];
  } else {
    z->size[0] = x->size[0];
  }

  if (y->size[1] <= x->size[1]) {
    z->size[1] = y->size[1];
  } else {
    z->size[1] = x->size[1];
  }

  emxEnsureCapacity_real_T(&b_st, z, i, &tb_emlrtRTEI);
  if (!dimagree(z, y, x)) {
    emlrtErrorWithMessageIdR2018a(&b_st, &c_emlrtRTEI, "MATLAB:dimagree",
      "MATLAB:dimagree", 0);
  }

  emxFree_real_T(&z);
  i = r->size[0] * r->size[1];
  r->size[0] = csz_idx_0;
  r->size[1] = csz_idx_1;
  emxEnsureCapacity_real_T(&st, r, i, &ub_emlrtRTEI);
  b_st.site = &r_emlrtRSI;
  csz_idx_0 *= csz_idx_1;
  c_st.site = &x_emlrtRSI;
  if ((1 <= csz_idx_0) && (csz_idx_0 > 2147483646)) {
    d_st.site = &m_emlrtRSI;
    check_forloop_overflow_error(&d_st);
  }

  for (csz_idx_1 = 0; csz_idx_1 < csz_idx_0; csz_idx_1++) {
    r->data[csz_idx_1] = muDoubleScalarAtan2(y->data[csz_idx_1], x->
      data[csz_idx_1]);
  }

  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
}

/* End of code generation (atan2.c) */
