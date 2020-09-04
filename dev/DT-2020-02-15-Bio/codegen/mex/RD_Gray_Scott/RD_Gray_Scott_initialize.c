/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * RD_Gray_Scott_initialize.c
 *
 * Code generation for function 'RD_Gray_Scott_initialize'
 *
 */

/* Include files */
#include "RD_Gray_Scott_initialize.h"
#include "RD_Gray_Scott.h"
#include "RD_Gray_Scott_data.h"
#include "_coder_RD_Gray_Scott_mex.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void RD_Gray_Scott_initialize(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  mex_InitInfAndNan();
  mexFunctionCreateRootTLS();
  emlrtBreakCheckR2012bFlagVar = emlrtGetBreakCheckFlagAddressR2012b();
  st.tls = emlrtRootTLSGlobal;
  emlrtClearAllocCountR2012b(&st, false, 0U, 0);
  emlrtEnterRtStackR2012b(&st);
  emlrtFirstTimeR2012b(emlrtRootTLSGlobal);
}

/* End of code generation (RD_Gray_Scott_initialize.c) */
