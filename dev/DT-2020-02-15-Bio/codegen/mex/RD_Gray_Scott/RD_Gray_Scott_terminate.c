/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * RD_Gray_Scott_terminate.c
 *
 * Code generation for function 'RD_Gray_Scott_terminate'
 *
 */

/* Include files */
#include "RD_Gray_Scott_terminate.h"
#include "RD_Gray_Scott.h"
#include "RD_Gray_Scott_data.h"
#include "_coder_RD_Gray_Scott_mex.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void RD_Gray_Scott_atexit(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtEnterRtStackR2012b(&st);
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
  emlrtExitTimeCleanup(&emlrtContextGlobal);
}

void RD_Gray_Scott_terminate(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/* End of code generation (RD_Gray_Scott_terminate.c) */
