/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_mcadd_mex.c
 *
 * Code generation for function '_coder_mcadd_mex'
 *
 */

/* Include files */
#include "_coder_mcadd_mex.h"
#include "_coder_mcadd_api.h"
#include "mcadd.h"
#include "mcadd_data.h"
#include "mcadd_initialize.h"
#include "mcadd_terminate.h"

/* Function Declarations */
MEXFUNCTION_LINKAGE void mcadd_mexFunction(int32_T nlhs, mxArray *plhs[1],
  int32_T nrhs, const mxArray *prhs[2]);

/* Function Definitions */
void mcadd_mexFunction(int32_T nlhs, mxArray *plhs[1], int32_T nrhs, const
  mxArray *prhs[2])
{
  const mxArray *outputs[1];
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;

  /* Check for proper number of arguments. */
  if (nrhs != 2) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, 12, 2, 4, 5,
                        "mcadd");
  }

  if (nlhs > 1) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, 4, 5,
                        "mcadd");
  }

  /* Call the function. */
  mcadd_api(prhs, nlhs, outputs);

  /* Copy over outputs to the caller. */
  emlrtReturnArrays(1, plhs, outputs);
}

void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs, const mxArray
                 *prhs[])
{
  mexAtExit(&mcadd_atexit);

  /* Module initialization. */
  mcadd_initialize();

  /* Dispatch the entry-point. */
  mcadd_mexFunction(nlhs, plhs, nrhs, prhs);

  /* Module termination. */
  mcadd_terminate();
}

emlrtCTX mexFunctionCreateRootTLS(void)
{
  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1);
  return emlrtRootTLSGlobal;
}

/* End of code generation (_coder_mcadd_mex.c) */
