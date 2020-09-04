/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * colon.c
 *
 * Code generation for function 'colon'
 *
 */

/* Include files */
#include "colon.h"
#include "RD_Gray_Scott.h"
#include "RD_Gray_Scott_emxutil.h"
#include "mwmathutil.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRSInfo k_emlrtRSI = { 288, /* lineNo */
  "eml_float_colon",                   /* fcnName */
  "/usr/local/MATLAB/R2020a/toolbox/eml/lib/matlab/ops/colon.m"/* pathName */
};

static emlrtRTEInfo emlrtRTEI = { 405, /* lineNo */
  15,                                  /* colNo */
  "assert_pmaxsize",                   /* fName */
  "/usr/local/MATLAB/R2020a/toolbox/eml/lib/matlab/ops/colon.m"/* pName */
};

static emlrtRTEInfo qb_emlrtRTEI = { 279,/* lineNo */
  14,                                  /* colNo */
  "colon",                             /* fName */
  "/usr/local/MATLAB/R2020a/toolbox/eml/lib/matlab/ops/colon.m"/* pName */
};

/* Function Definitions */
void eml_float_colon(const emlrtStack *sp, real_T a, real_T b, emxArray_real_T
                     *y)
{
  real_T ndbl;
  real_T apnd;
  real_T cdiff;
  int32_T n;
  int32_T nm1d2;
  int32_T k;
  uint32_T kd;
  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;
  ndbl = muDoubleScalarFloor((b - a) / 4.0 + 0.5);
  apnd = a + ndbl * 4.0;
  cdiff = apnd - b;
  if (muDoubleScalarAbs(cdiff) < 4.4408920985006262E-16 * muDoubleScalarMax
      (muDoubleScalarAbs(a), muDoubleScalarAbs(b))) {
    ndbl++;
    apnd = b;
  } else if (cdiff > 0.0) {
    apnd = a + (ndbl - 1.0) * 4.0;
  } else {
    ndbl++;
  }

  if (ndbl >= 0.0) {
    n = (int32_T)ndbl;
  } else {
    n = 0;
  }

  st.site = &k_emlrtRSI;
  if (ndbl > 2.147483647E+9) {
    emlrtErrorWithMessageIdR2018a(&st, &emlrtRTEI, "Coder:MATLAB:pmaxsize",
      "Coder:MATLAB:pmaxsize", 0);
  }

  nm1d2 = y->size[0] * y->size[1];
  y->size[0] = 1;
  y->size[1] = n;
  emxEnsureCapacity_real_T(sp, y, nm1d2, &qb_emlrtRTEI);
  if (n > 0) {
    y->data[0] = a;
    if (n > 1) {
      y->data[n - 1] = apnd;
      nm1d2 = (n - 1) / 2;
      for (k = 0; k <= nm1d2 - 2; k++) {
        kd = (uint32_T)(k + 1) << 2;
        y->data[k + 1] = a + (real_T)kd;
        y->data[(n - k) - 2] = apnd - (real_T)kd;
      }

      if (nm1d2 << 1 == n - 1) {
        y->data[nm1d2] = (a + apnd) / 2.0;
      } else {
        kd = (uint32_T)nm1d2 << 2;
        y->data[nm1d2] = a + (real_T)kd;
        y->data[nm1d2 + 1] = apnd - (real_T)kd;
      }
    }
  }
}

/* End of code generation (colon.c) */
