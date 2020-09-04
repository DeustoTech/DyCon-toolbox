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
#include "_coder_RD_Gray_Scott_api.h"
#include "RD_Gray_Scott.h"
#include "RD_Gray_Scott_data.h"
#include "RD_Gray_Scott_emxutil.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
static emlrtRTEInfo wb_emlrtRTEI = { 1,/* lineNo */
  1,                                   /* colNo */
  "_coder_RD_Gray_Scott_api",          /* fName */
  ""                                   /* pName */
};

/* Function Declarations */
static real_T b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId);
static real_T c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId);
static real_T emlrt_marshallIn(const emlrtStack *sp, const mxArray *L, const
  char_T *identifier);
static const mxArray *emlrt_marshallOut(const emxArray_real_T *u);

/* Function Definitions */
static real_T b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId)
{
  real_T y;
  y = c_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

static real_T c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId)
{
  real_T ret;
  static const int32_T dims = 0;
  emlrtCheckBuiltInR2012b(sp, msgId, src, "double", false, 0U, &dims);
  ret = *(real_T *)emlrtMxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

static real_T emlrt_marshallIn(const emlrtStack *sp, const mxArray *L, const
  char_T *identifier)
{
  real_T y;
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = b_emlrt_marshallIn(sp, emlrtAlias(L), &thisId);
  emlrtDestroyArray(&L);
  return y;
}

static const mxArray *emlrt_marshallOut(const emxArray_real_T *u)
{
  const mxArray *y;
  const mxArray *m;
  static const int32_T iv[3] = { 0, 0, 0 };

  y = NULL;
  m = emlrtCreateNumericArray(3, &iv[0], mxDOUBLE_CLASS, mxREAL);
  emlrtMxSetData((mxArray *)m, &u->data[0]);
  emlrtSetDimensions((mxArray *)m, u->size, 3);
  emlrtAssign(&y, m);
  return y;
}

void RD_Gray_Scott_api(const mxArray * const prhs[1], int32_T nlhs, const
  mxArray *plhs[2])
{
  emxArray_real_T *cDt;
  emxArray_real_T *cEt;
  real_T L;
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;
  emlrtHeapReferenceStackEnterFcnR2012b(&st);
  emxInit_real_T(&st, &cDt, 3, &wb_emlrtRTEI, true);
  emxInit_real_T(&st, &cEt, 3, &wb_emlrtRTEI, true);

  /* Marshall function inputs */
  L = emlrt_marshallIn(&st, emlrtAliasP(prhs[0]), "L");

  /* Invoke the target function */
  RD_Gray_Scott(&st, L, cDt, cEt);

  /* Marshall function outputs */
  cDt->canFreeData = false;
  plhs[0] = emlrt_marshallOut(cDt);
  emxFree_real_T(&cDt);
  if (nlhs > 1) {
    cEt->canFreeData = false;
    plhs[1] = emlrt_marshallOut(cEt);
  }

  emxFree_real_T(&cEt);
  emlrtHeapReferenceStackLeaveFcnR2012b(&st);
}

/* End of code generation (_coder_RD_Gray_Scott_api.c) */
