/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_RD_Gray_Scott_api.h
 *
 * Code generation for function '_coder_RD_Gray_Scott_api'
 *
 */

#ifndef _CODER_RD_GRAY_SCOTT_API_H
#define _CODER_RD_GRAY_SCOTT_API_H

/* Include files */
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include <stddef.h>
#include <stdlib.h>
#include "_coder_RD_Gray_Scott_api.h"

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

/* Function Declarations */
extern void RD_Gray_Scott(real_T cDt[100000000], real_T cEt[100000000]);
extern void RD_Gray_Scott_api(int32_T nlhs, const mxArray *plhs[2]);
extern void RD_Gray_Scott_atexit(void);
extern void RD_Gray_Scott_initialize(void);
extern void RD_Gray_Scott_terminate(void);
extern void RD_Gray_Scott_xil_terminate(void);

#endif

/* End of code generation (_coder_RD_Gray_Scott_api.h) */
