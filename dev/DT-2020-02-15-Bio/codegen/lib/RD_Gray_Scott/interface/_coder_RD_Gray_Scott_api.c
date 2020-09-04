/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_RD_Gray_Scott_api.c
 *
 * Code generation for function '_coder_RD_Gray_Scott_api'
 *
 */

/* Include files */
#include "tmwtypes.h"
#include "_coder_RD_Gray_Scott_api.h"
#include "_coder_RD_Gray_Scott_mex.h"

/* Variable Definitions */
emlrtCTX emlrtRootTLSGlobal = NULL;
emlrtContext emlrtContextGlobal = { true,/* bFirstTime */
  false,                               /* bInitialized */
  131467U,                             /* fVersionInfo */
  NULL,                                /* fErrorFunction */
  "RD_Gray_Scott",                     /* fFunctionName */
  NULL,                                /* fRTCallStack */
  false,                               /* bDebugMode */
  { 2045744189U, 2170104910U, 2743257031U, 4284093946U },/* fSigWrd */
  NULL                                 /* fSigMem */
};

/* Function Declarations */
static const mxArray *emlrt_marshallOut(const real_T u[100000000]);

/* Function Definitions */
static const mxArray *emlrt_marshallOut(const real_T u[100000000])
{
  const mxArray *y;
  const mxArray *m0;
  static const int32_T iv0[3] = { 0, 0, 0 };

  static const int32_T iv1[3] = { 100, 100, 10000 };

  y = NULL;
  m0 = emlrtCreateNumericArray(3, iv0, mxDOUBLE_CLASS, mxREAL);
  emlrtMxSetData((mxArray *)m0, (void *)&u[0]);
  emlrtSetDimensions((mxArray *)m0, iv1, 3);
  emlrtAssign(&y, m0);
  return y;
}

void RD_Gray_Scott_api(int32_T nlhs, const mxArray *plhs[2])
{
  real_T (*cDt)[100000000];
  real_T (*cEt)[100000000];
  cDt = (real_T (*)[100000000])mxMalloc(sizeof(real_T [100000000]));
  cEt = (real_T (*)[100000000])mxMalloc(sizeof(real_T [100000000]));

  /* Invoke the target function */
  RD_Gray_Scott(*cDt, *cEt);

  /* Marshall function outputs */
  plhs[0] = emlrt_marshallOut(*cDt);
  if (nlhs > 1) {
    plhs[1] = emlrt_marshallOut(*cEt);
  }
}

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
  RD_Gray_Scott_xil_terminate();
}

void RD_Gray_Scott_initialize(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtClearAllocCountR2012b(&st, false, 0U, 0);
  emlrtEnterRtStackR2012b(&st);
  emlrtFirstTimeR2012b(emlrtRootTLSGlobal);
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

/* End of code generation (_coder_RD_Gray_Scott_api.c) */
