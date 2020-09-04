/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_RD_Gray_Scott_mex.c
 *
 * Code generation for function '_coder_RD_Gray_Scott_mex'
 *
 */

/* Include files */
#include "_coder_RD_Gray_Scott_api.h"
#include "_coder_RD_Gray_Scott_mex.h"

/* Function Declarations */
static void RD_Gray_Scott_mexFunction(int32_T nlhs, mxArray *plhs[2], int32_T
  nrhs);

/* Function Definitions */
static void RD_Gray_Scott_mexFunction(int32_T nlhs, mxArray *plhs[2], int32_T
  nrhs)
{
  const mxArray *outputs[2];
  int32_T b_nlhs;
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;

  /* Check for proper number of arguments. */
  if (nrhs != 0) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, 12, 0, 4,
                        13, "RD_Gray_Scott");
  }

  if (nlhs > 2) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, 4, 13,
                        "RD_Gray_Scott");
  }

  /* Call the function. */
  RD_Gray_Scott_api(nlhs, outputs);

  /* Copy over outputs to the caller. */
  if (nlhs < 1) {
    b_nlhs = 1;
  } else {
    b_nlhs = nlhs;
  }

  emlrtReturnArrays(b_nlhs, plhs, outputs);
}

void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs, const mxArray
                 *prhs[])
{
  (void)prhs;
  mexAtExit(RD_Gray_Scott_atexit);

  /* Module initialization. */
  RD_Gray_Scott_initialize();

  /* Dispatch the entry-point. */
  RD_Gray_Scott_mexFunction(nlhs, plhs, nrhs);

  /* Module termination. */
  RD_Gray_Scott_terminate();
}

emlrtCTX mexFunctionCreateRootTLS(void)
{
  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1);
  return emlrtRootTLSGlobal;
}

/* End of code generation (_coder_RD_Gray_Scott_mex.c) */
