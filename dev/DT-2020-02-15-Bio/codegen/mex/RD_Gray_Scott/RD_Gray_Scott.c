/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * RD_Gray_Scott.c
 *
 * Code generation for function 'RD_Gray_Scott'
 *
 */

/* Include files */
#include "RD_Gray_Scott.h"
#include "RD_Gray_Scott_data.h"
#include "RD_Gray_Scott_emxutil.h"
#include "atan2.h"
#include "colon.h"
#include "exp.h"
#include "meshgrid.h"
#include "mwmathutil.h"
#include "power.h"
#include "rand.h"
#include "rt_nonfinite.h"
#include "sin.h"
#include "sqrt.h"

/* Variable Definitions */
static emlrtRSInfo emlrtRSI = { 8,     /* lineNo */
  "RD_Gray_Scott",                     /* fcnName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pathName */
};

static emlrtRSInfo b_emlrtRSI = { 9,   /* lineNo */
  "RD_Gray_Scott",                     /* fcnName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pathName */
};

static emlrtRSInfo c_emlrtRSI = { 11,  /* lineNo */
  "RD_Gray_Scott",                     /* fcnName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pathName */
};

static emlrtRSInfo d_emlrtRSI = { 37,  /* lineNo */
  "RD_Gray_Scott",                     /* fcnName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pathName */
};

static emlrtRSInfo e_emlrtRSI = { 38,  /* lineNo */
  "RD_Gray_Scott",                     /* fcnName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pathName */
};

static emlrtRSInfo f_emlrtRSI = { 40,  /* lineNo */
  "RD_Gray_Scott",                     /* fcnName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pathName */
};

static emlrtRSInfo g_emlrtRSI = { 41,  /* lineNo */
  "RD_Gray_Scott",                     /* fcnName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pathName */
};

static emlrtRSInfo h_emlrtRSI = { 63,  /* lineNo */
  "RD_Gray_Scott",                     /* fcnName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pathName */
};

static emlrtRSInfo i_emlrtRSI = { 72,  /* lineNo */
  "RD_Gray_Scott",                     /* fcnName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pathName */
};

static emlrtRSInfo j_emlrtRSI = { 103, /* lineNo */
  "colon",                             /* fcnName */
  "/usr/local/MATLAB/R2020a/toolbox/eml/lib/matlab/ops/colon.m"/* pathName */
};

static emlrtDCInfo emlrtDCI = { 51,    /* lineNo */
  1,                                   /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  1                                    /* checkKind */
};

static emlrtDCInfo b_emlrtDCI = { 50,  /* lineNo */
  1,                                   /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  1                                    /* checkKind */
};

static emlrtDCInfo c_emlrtDCI = { 26,  /* lineNo */
  1,                                   /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  1                                    /* checkKind */
};

static emlrtDCInfo d_emlrtDCI = { 25,  /* lineNo */
  1,                                   /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  1                                    /* checkKind */
};

static emlrtDCInfo e_emlrtDCI = { 23,  /* lineNo */
  1,                                   /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  1                                    /* checkKind */
};

static emlrtDCInfo f_emlrtDCI = { 51,  /* lineNo */
  13,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  1                                    /* checkKind */
};

static emlrtDCInfo g_emlrtDCI = { 51,  /* lineNo */
  11,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  1                                    /* checkKind */
};

static emlrtDCInfo h_emlrtDCI = { 50,  /* lineNo */
  13,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  1                                    /* checkKind */
};

static emlrtDCInfo i_emlrtDCI = { 50,  /* lineNo */
  11,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  1                                    /* checkKind */
};

static emlrtDCInfo j_emlrtDCI = { 26,  /* lineNo */
  12,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  1                                    /* checkKind */
};

static emlrtDCInfo k_emlrtDCI = { 26,  /* lineNo */
  10,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  1                                    /* checkKind */
};

static emlrtDCInfo l_emlrtDCI = { 25,  /* lineNo */
  12,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  1                                    /* checkKind */
};

static emlrtDCInfo m_emlrtDCI = { 25,  /* lineNo */
  10,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  1                                    /* checkKind */
};

static emlrtDCInfo n_emlrtDCI = { 23,  /* lineNo */
  13,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  1                                    /* checkKind */
};

static emlrtDCInfo o_emlrtDCI = { 23,  /* lineNo */
  11,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  4                                    /* checkKind */
};

static emlrtDCInfo p_emlrtDCI = { 23,  /* lineNo */
  11,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  1                                    /* checkKind */
};

static emlrtECInfo emlrtECI = { -1,    /* nDims */
  91,                                  /* lineNo */
  5,                                   /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtECInfo b_emlrtECI = { -1,  /* nDims */
  90,                                  /* lineNo */
  5,                                   /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtECInfo c_emlrtECI = { -1,  /* nDims */
  88,                                  /* lineNo */
  5,                                   /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtECInfo d_emlrtECI = { -1,  /* nDims */
  87,                                  /* lineNo */
  5,                                   /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtECInfo e_emlrtECI = { -1,  /* nDims */
  82,                                  /* lineNo */
  5,                                   /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtBCInfo emlrtBCI = { -1,    /* iFirst */
  -1,                                  /* iLast */
  82,                                  /* lineNo */
  16,                                  /* colNo */
  "cE",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo b_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  82,                                  /* lineNo */
  10,                                  /* colNo */
  "cE",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo c_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  82,                                  /* lineNo */
  8,                                   /* colNo */
  "cE",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo d_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  82,                                  /* lineNo */
  38,                                  /* colNo */
  "cE",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo e_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  82,                                  /* lineNo */
  32,                                  /* colNo */
  "cE",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo f_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  82,                                  /* lineNo */
  30,                                  /* colNo */
  "cE",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtECInfo f_emlrtECI = { -1,  /* nDims */
  81,                                  /* lineNo */
  5,                                   /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtBCInfo g_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  81,                                  /* lineNo */
  16,                                  /* colNo */
  "cE",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo h_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  81,                                  /* lineNo */
  10,                                  /* colNo */
  "cE",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo i_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  81,                                  /* lineNo */
  8,                                   /* colNo */
  "cE",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo j_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  81,                                  /* lineNo */
  38,                                  /* colNo */
  "cE",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo k_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  81,                                  /* lineNo */
  32,                                  /* colNo */
  "cE",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo l_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  81,                                  /* lineNo */
  30,                                  /* colNo */
  "cE",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtECInfo g_emlrtECI = { -1,  /* nDims */
  80,                                  /* lineNo */
  5,                                   /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtBCInfo m_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  80,                                  /* lineNo */
  14,                                  /* colNo */
  "cE",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo n_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  80,                                  /* lineNo */
  12,                                  /* colNo */
  "cE",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo o_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  80,                                  /* lineNo */
  8,                                   /* colNo */
  "cE",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo p_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  80,                                  /* lineNo */
  38,                                  /* colNo */
  "cE",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo q_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  80,                                  /* lineNo */
  36,                                  /* colNo */
  "cE",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo r_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  80,                                  /* lineNo */
  30,                                  /* colNo */
  "cE",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtECInfo h_emlrtECI = { -1,  /* nDims */
  79,                                  /* lineNo */
  5,                                   /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtBCInfo s_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  79,                                  /* lineNo */
  12,                                  /* colNo */
  "cE",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo t_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  79,                                  /* lineNo */
  10,                                  /* colNo */
  "cE",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo u_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  79,                                  /* lineNo */
  8,                                   /* colNo */
  "cE",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo v_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  79,                                  /* lineNo */
  34,                                  /* colNo */
  "cE",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo w_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  79,                                  /* lineNo */
  32,                                  /* colNo */
  "cE",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo x_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  79,                                  /* lineNo */
  30,                                  /* colNo */
  "cE",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtECInfo i_emlrtECI = { -1,  /* nDims */
  77,                                  /* lineNo */
  5,                                   /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtBCInfo y_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  77,                                  /* lineNo */
  16,                                  /* colNo */
  "cD",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ab_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  77,                                  /* lineNo */
  10,                                  /* colNo */
  "cD",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo bb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  77,                                  /* lineNo */
  8,                                   /* colNo */
  "cD",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo cb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  77,                                  /* lineNo */
  38,                                  /* colNo */
  "cD",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo db_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  77,                                  /* lineNo */
  32,                                  /* colNo */
  "cD",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo eb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  77,                                  /* lineNo */
  30,                                  /* colNo */
  "cD",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtECInfo j_emlrtECI = { -1,  /* nDims */
  76,                                  /* lineNo */
  5,                                   /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtBCInfo fb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  76,                                  /* lineNo */
  16,                                  /* colNo */
  "cD",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo gb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  76,                                  /* lineNo */
  10,                                  /* colNo */
  "cD",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo hb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  76,                                  /* lineNo */
  8,                                   /* colNo */
  "cD",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ib_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  76,                                  /* lineNo */
  38,                                  /* colNo */
  "cD",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo jb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  76,                                  /* lineNo */
  32,                                  /* colNo */
  "cD",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo kb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  76,                                  /* lineNo */
  30,                                  /* colNo */
  "cD",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtECInfo k_emlrtECI = { -1,  /* nDims */
  75,                                  /* lineNo */
  5,                                   /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtBCInfo lb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  75,                                  /* lineNo */
  14,                                  /* colNo */
  "cD",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo mb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  75,                                  /* lineNo */
  12,                                  /* colNo */
  "cD",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo nb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  75,                                  /* lineNo */
  8,                                   /* colNo */
  "cD",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ob_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  75,                                  /* lineNo */
  38,                                  /* colNo */
  "cD",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo pb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  75,                                  /* lineNo */
  36,                                  /* colNo */
  "cD",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo qb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  75,                                  /* lineNo */
  30,                                  /* colNo */
  "cD",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtECInfo l_emlrtECI = { -1,  /* nDims */
  74,                                  /* lineNo */
  5,                                   /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtBCInfo rb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  74,                                  /* lineNo */
  12,                                  /* colNo */
  "cD",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo sb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  74,                                  /* lineNo */
  10,                                  /* colNo */
  "cD",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo tb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  74,                                  /* lineNo */
  8,                                   /* colNo */
  "cD",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ub_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  74,                                  /* lineNo */
  34,                                  /* colNo */
  "cD",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo vb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  74,                                  /* lineNo */
  32,                                  /* colNo */
  "cD",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo wb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  74,                                  /* lineNo */
  30,                                  /* colNo */
  "cD",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtECInfo m_emlrtECI = { -1,  /* nDims */
  72,                                  /* lineNo */
  5,                                   /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtECInfo n_emlrtECI = { 2,   /* nDims */
  72,                                  /* lineNo */
  15,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtECInfo o_emlrtECI = { 2,   /* nDims */
  72,                                  /* lineNo */
  22,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtBCInfo xb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  70,                                  /* lineNo */
  11,                                  /* colNo */
  "lap",                               /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo yb_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  69,                                  /* lineNo */
  9,                                   /* colNo */
  "lap",                               /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ac_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  68,                                  /* lineNo */
  11,                                  /* colNo */
  "lap",                               /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo bc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  67,                                  /* lineNo */
  9,                                   /* colNo */
  "lap",                               /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtECInfo p_emlrtECI = { -1,  /* nDims */
  65,                                  /* lineNo */
  5,                                   /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtBCInfo cc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  65,                                  /* lineNo */
  19,                                  /* colNo */
  "lap",                               /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo dc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  65,                                  /* lineNo */
  17,                                  /* colNo */
  "lap",                               /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ec_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  65,                                  /* lineNo */
  11,                                  /* colNo */
  "lap",                               /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo fc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  65,                                  /* lineNo */
  9,                                   /* colNo */
  "lap",                               /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtECInfo q_emlrtECI = { 2,   /* nDims */
  65,                                  /* lineNo */
  27,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtECInfo r_emlrtECI = { 2,   /* nDims */
  66,                                  /* lineNo */
  37,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtBCInfo gc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  66,                                  /* lineNo */
  96,                                  /* colNo */
  "cE",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo hc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  66,                                  /* lineNo */
  88,                                  /* colNo */
  "cE",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ic_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  66,                                  /* lineNo */
  86,                                  /* colNo */
  "cE",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo jc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  66,                                  /* lineNo */
  74,                                  /* colNo */
  "cE",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo kc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  66,                                  /* lineNo */
  72,                                  /* colNo */
  "cE",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo lc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  66,                                  /* lineNo */
  66,                                  /* colNo */
  "cE",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo mc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  66,                                  /* lineNo */
  64,                                  /* colNo */
  "cE",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo nc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  66,                                  /* lineNo */
  50,                                  /* colNo */
  "cE",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo oc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  66,                                  /* lineNo */
  48,                                  /* colNo */
  "cE",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo pc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  66,                                  /* lineNo */
  42,                                  /* colNo */
  "cE",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo qc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  66,                                  /* lineNo */
  40,                                  /* colNo */
  "cE",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtECInfo s_emlrtECI = { 2,   /* nDims */
  65,                                  /* lineNo */
  37,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtBCInfo rc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  65,                                  /* lineNo */
  94,                                  /* colNo */
  "cE",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo sc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  65,                                  /* lineNo */
  92,                                  /* colNo */
  "cE",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo tc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  65,                                  /* lineNo */
  88,                                  /* colNo */
  "cE",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo uc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  65,                                  /* lineNo */
  74,                                  /* colNo */
  "cE",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo vc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  65,                                  /* lineNo */
  72,                                  /* colNo */
  "cE",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo wc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  65,                                  /* lineNo */
  66,                                  /* colNo */
  "cE",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo xc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  65,                                  /* lineNo */
  64,                                  /* colNo */
  "cE",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo yc_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  65,                                  /* lineNo */
  50,                                  /* colNo */
  "cE",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ad_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  65,                                  /* lineNo */
  48,                                  /* colNo */
  "cE",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo bd_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  65,                                  /* lineNo */
  42,                                  /* colNo */
  "cE",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo cd_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  65,                                  /* lineNo */
  40,                                  /* colNo */
  "cE",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtECInfo t_emlrtECI = { -1,  /* nDims */
  63,                                  /* lineNo */
  5,                                   /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtECInfo u_emlrtECI = { 2,   /* nDims */
  63,                                  /* lineNo */
  15,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtECInfo v_emlrtECI = { 2,   /* nDims */
  63,                                  /* lineNo */
  22,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtBCInfo dd_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  61,                                  /* lineNo */
  11,                                  /* colNo */
  "lap",                               /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ed_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  60,                                  /* lineNo */
  9,                                   /* colNo */
  "lap",                               /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo fd_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  59,                                  /* lineNo */
  11,                                  /* colNo */
  "lap",                               /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo gd_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  58,                                  /* lineNo */
  9,                                   /* colNo */
  "lap",                               /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtECInfo w_emlrtECI = { -1,  /* nDims */
  55,                                  /* lineNo */
  5,                                   /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtBCInfo hd_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  55,                                  /* lineNo */
  19,                                  /* colNo */
  "lap",                               /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo id_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  55,                                  /* lineNo */
  17,                                  /* colNo */
  "lap",                               /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo jd_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  55,                                  /* lineNo */
  11,                                  /* colNo */
  "lap",                               /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo kd_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  55,                                  /* lineNo */
  9,                                   /* colNo */
  "lap",                               /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtECInfo x_emlrtECI = { 2,   /* nDims */
  63,                                  /* lineNo */
  41,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtECInfo y_emlrtECI = { -1,  /* nDims */
  40,                                  /* lineNo */
  1,                                   /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtECInfo ab_emlrtECI = { 2,  /* nDims */
  55,                                  /* lineNo */
  27,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtECInfo bb_emlrtECI = { 2,  /* nDims */
  56,                                  /* lineNo */
  37,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtBCInfo ld_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  56,                                  /* lineNo */
  96,                                  /* colNo */
  "cD",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo md_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  56,                                  /* lineNo */
  88,                                  /* colNo */
  "cD",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo nd_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  56,                                  /* lineNo */
  86,                                  /* colNo */
  "cD",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo od_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  56,                                  /* lineNo */
  74,                                  /* colNo */
  "cD",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo pd_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  56,                                  /* lineNo */
  72,                                  /* colNo */
  "cD",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo qd_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  56,                                  /* lineNo */
  66,                                  /* colNo */
  "cD",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo rd_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  56,                                  /* lineNo */
  64,                                  /* colNo */
  "cD",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo sd_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  56,                                  /* lineNo */
  50,                                  /* colNo */
  "cD",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo td_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  56,                                  /* lineNo */
  48,                                  /* colNo */
  "cD",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ud_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  56,                                  /* lineNo */
  42,                                  /* colNo */
  "cD",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo vd_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  56,                                  /* lineNo */
  40,                                  /* colNo */
  "cD",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtECInfo cb_emlrtECI = { 2,  /* nDims */
  55,                                  /* lineNo */
  37,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtBCInfo wd_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  55,                                  /* lineNo */
  94,                                  /* colNo */
  "cD",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo xd_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  55,                                  /* lineNo */
  92,                                  /* colNo */
  "cD",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo yd_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  55,                                  /* lineNo */
  88,                                  /* colNo */
  "cD",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ae_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  55,                                  /* lineNo */
  74,                                  /* colNo */
  "cD",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo be_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  55,                                  /* lineNo */
  72,                                  /* colNo */
  "cD",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ce_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  55,                                  /* lineNo */
  66,                                  /* colNo */
  "cD",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo de_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  55,                                  /* lineNo */
  64,                                  /* colNo */
  "cD",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ee_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  55,                                  /* lineNo */
  50,                                  /* colNo */
  "cD",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo fe_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  55,                                  /* lineNo */
  48,                                  /* colNo */
  "cD",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo ge_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  55,                                  /* lineNo */
  42,                                  /* colNo */
  "cD",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo he_emlrtBCI = { -1, /* iFirst */
  -1,                                  /* iLast */
  55,                                  /* lineNo */
  40,                                  /* colNo */
  "cD",                                /* aName */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  0                                    /* checkKind */
};

static emlrtECInfo db_emlrtECI = { -1, /* nDims */
  41,                                  /* lineNo */
  1,                                   /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtECInfo eb_emlrtECI = { 2,  /* nDims */
  40,                                  /* lineNo */
  13,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtECInfo fb_emlrtECI = { 2,  /* nDims */
  37,                                  /* lineNo */
  12,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtDCInfo q_emlrtDCI = { 28,  /* lineNo */
  9,                                   /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m",/* pName */
  1                                    /* checkKind */
};

static emlrtRTEInfo e_emlrtRTEI = { 8, /* lineNo */
  1,                                   /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtRTEInfo f_emlrtRTEI = { 9, /* lineNo */
  1,                                   /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtRTEInfo g_emlrtRTEI = { 23,/* lineNo */
  1,                                   /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtRTEInfo h_emlrtRTEI = { 25,/* lineNo */
  1,                                   /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtRTEInfo i_emlrtRTEI = { 26,/* lineNo */
  1,                                   /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtRTEInfo j_emlrtRTEI = { 50,/* lineNo */
  1,                                   /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtRTEInfo k_emlrtRTEI = { 51,/* lineNo */
  1,                                   /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtRTEInfo l_emlrtRTEI = { 55,/* lineNo */
  59,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtRTEInfo m_emlrtRTEI = { 56,/* lineNo */
  59,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtRTEInfo n_emlrtRTEI = { 55,/* lineNo */
  27,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtRTEInfo o_emlrtRTEI = { 56,/* lineNo */
  27,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtRTEInfo p_emlrtRTEI = { 63,/* lineNo */
  52,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtRTEInfo q_emlrtRTEI = { 63,/* lineNo */
  22,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtRTEInfo r_emlrtRTEI = { 63,/* lineNo */
  41,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtRTEInfo s_emlrtRTEI = { 65,/* lineNo */
  59,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtRTEInfo t_emlrtRTEI = { 66,/* lineNo */
  59,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtRTEInfo u_emlrtRTEI = { 65,/* lineNo */
  27,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtRTEInfo v_emlrtRTEI = { 66,/* lineNo */
  27,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtRTEInfo w_emlrtRTEI = { 72,/* lineNo */
  33,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtRTEInfo x_emlrtRTEI = { 72,/* lineNo */
  22,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtRTEInfo y_emlrtRTEI = { 72,/* lineNo */
  48,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtRTEInfo ab_emlrtRTEI = { 72,/* lineNo */
  68,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtRTEInfo bb_emlrtRTEI = { 74,/* lineNo */
  27,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtRTEInfo cb_emlrtRTEI = { 75,/* lineNo */
  27,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtRTEInfo db_emlrtRTEI = { 76,/* lineNo */
  27,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtRTEInfo eb_emlrtRTEI = { 77,/* lineNo */
  27,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtRTEInfo fb_emlrtRTEI = { 79,/* lineNo */
  27,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtRTEInfo gb_emlrtRTEI = { 80,/* lineNo */
  27,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtRTEInfo hb_emlrtRTEI = { 81,/* lineNo */
  27,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtRTEInfo ib_emlrtRTEI = { 82,/* lineNo */
  27,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtRTEInfo jb_emlrtRTEI = { 87,/* lineNo */
  17,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtRTEInfo kb_emlrtRTEI = { 88,/* lineNo */
  17,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtRTEInfo lb_emlrtRTEI = { 37,/* lineNo */
  1,                                   /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtRTEInfo mb_emlrtRTEI = { 38,/* lineNo */
  1,                                   /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtRTEInfo nb_emlrtRTEI = { 41,/* lineNo */
  22,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtRTEInfo ob_emlrtRTEI = { 40,/* lineNo */
  34,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

static emlrtRTEInfo pb_emlrtRTEI = { 72,/* lineNo */
  15,                                  /* colNo */
  "RD_Gray_Scott",                     /* fName */
  "/home/djoroya/Documentos/GitHub/CCM/Software/DyCon-toolbox/dev/DT-2020-02-15-Bio/RD_Gray_Scott.m"/* pName */
};

/* Function Definitions */
void RD_Gray_Scott(const emlrtStack *sp, real_T L, emxArray_real_T *cDt,
                   emxArray_real_T *cEt)
{
  real_T a_tmp;
  real_T b_tmp;
  emxArray_real_T *xline;
  int32_T i;
  int32_T loop_ub;
  emxArray_real_T *yline;
  emxArray_real_T *lap;
  emxArray_real_T *xms;
  emxArray_real_T *yms;
  int32_T i1;
  int32_T loop_ub_tmp;
  emxArray_real_T *cD;
  int32_T b_loop_ub_tmp;
  emxArray_real_T *cE;
  emxArray_real_T *rms;
  emxArray_real_T *r;
  emxArray_real_T *thms;
  int32_T b_L[2];
  int32_T b_loop_ub;
  int32_T i2;
  emxArray_real_T *b_cD;
  emxArray_real_T *c_cD;
  int32_T it;
  int32_T i3;
  int32_T i4;
  int32_T iv[2];
  int32_T i5;
  int32_T i6;
  int32_T i7;
  int32_T c_loop_ub;
  int32_T d_loop_ub;
  real_T dv[2];
  int32_T iv1[3];
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  emlrtHeapReferenceStackEnterFcnR2012b(sp);

  /* 0.4 0.5 0.3 7.5 */
  /* L=80; */
  /* L=100; */
  st.site = &emlrtRSI;
  a_tmp = -(L - 1.0) * 4.0 * 0.5;
  b_tmp = (L - 1.0) * 4.0 * 0.5;
  emxInit_real_T(&st, &xline, 2, &e_emlrtRTEI, true);
  if (muDoubleScalarIsNaN(a_tmp) || muDoubleScalarIsNaN(b_tmp)) {
    i = xline->size[0] * xline->size[1];
    xline->size[0] = 1;
    xline->size[1] = 1;
    emxEnsureCapacity_real_T(&st, xline, i, &e_emlrtRTEI);
    xline->data[0] = rtNaN;
  } else if (b_tmp < a_tmp) {
    xline->size[0] = 1;
    xline->size[1] = 0;
  } else if ((muDoubleScalarIsInf(a_tmp) || muDoubleScalarIsInf(b_tmp)) &&
             (a_tmp == b_tmp)) {
    i = xline->size[0] * xline->size[1];
    xline->size[0] = 1;
    xline->size[1] = 1;
    emxEnsureCapacity_real_T(&st, xline, i, &e_emlrtRTEI);
    xline->data[0] = rtNaN;
  } else if (muDoubleScalarFloor(a_tmp) == a_tmp) {
    i = xline->size[0] * xline->size[1];
    xline->size[0] = 1;
    loop_ub = (int32_T)muDoubleScalarFloor((b_tmp - a_tmp) / 4.0);
    xline->size[1] = loop_ub + 1;
    emxEnsureCapacity_real_T(&st, xline, i, &e_emlrtRTEI);
    for (i = 0; i <= loop_ub; i++) {
      xline->data[i] = a_tmp + 4.0 * (real_T)i;
    }
  } else {
    b_st.site = &j_emlrtRSI;
    eml_float_colon(&b_st, a_tmp, b_tmp, xline);
  }

  st.site = &b_emlrtRSI;
  emxInit_real_T(&st, &yline, 2, &f_emlrtRTEI, true);
  if (muDoubleScalarIsNaN(a_tmp) || muDoubleScalarIsNaN(b_tmp)) {
    i = yline->size[0] * yline->size[1];
    yline->size[0] = 1;
    yline->size[1] = 1;
    emxEnsureCapacity_real_T(&st, yline, i, &f_emlrtRTEI);
    yline->data[0] = rtNaN;
  } else if (b_tmp < a_tmp) {
    yline->size[0] = 1;
    yline->size[1] = 0;
  } else if ((muDoubleScalarIsInf(a_tmp) || muDoubleScalarIsInf(b_tmp)) &&
             (a_tmp == b_tmp)) {
    i = yline->size[0] * yline->size[1];
    yline->size[0] = 1;
    yline->size[1] = 1;
    emxEnsureCapacity_real_T(&st, yline, i, &f_emlrtRTEI);
    yline->data[0] = rtNaN;
  } else if (muDoubleScalarFloor(a_tmp) == a_tmp) {
    i = yline->size[0] * yline->size[1];
    yline->size[0] = 1;
    loop_ub = (int32_T)muDoubleScalarFloor((b_tmp - a_tmp) / 4.0);
    yline->size[1] = loop_ub + 1;
    emxEnsureCapacity_real_T(&st, yline, i, &f_emlrtRTEI);
    for (i = 0; i <= loop_ub; i++) {
      yline->data[i] = a_tmp + 4.0 * (real_T)i;
    }
  } else {
    b_st.site = &j_emlrtRSI;
    eml_float_colon(&b_st, a_tmp, b_tmp, yline);
  }

  emxInit_real_T(&st, &lap, 2, &g_emlrtRTEI, true);
  emxInit_real_T(&st, &xms, 2, &nb_emlrtRTEI, true);
  emxInit_real_T(&st, &yms, 2, &ob_emlrtRTEI, true);
  st.site = &c_emlrtRSI;
  meshgrid(&st, xline, yline, xms, yms);

  /* parameters */
  /* *(1/7.5^2); */
  /* *(1/7.5^2); */
  emxFree_real_T(&yline);
  emxFree_real_T(&xline);
  if (!(L >= 0.0)) {
    emlrtNonNegativeCheckR2012b(L, &o_emlrtDCI, sp);
  }

  i = (int32_T)muDoubleScalarFloor(L);
  if (L != i) {
    emlrtIntegerCheckR2012b(L, &p_emlrtDCI, sp);
  }

  i1 = lap->size[0] * lap->size[1];
  lap->size[0] = (int32_T)L;
  emxEnsureCapacity_real_T(sp, lap, i1, &g_emlrtRTEI);
  if ((int32_T)L != i) {
    emlrtIntegerCheckR2012b(L, &n_emlrtDCI, sp);
  }

  i1 = lap->size[0] * lap->size[1];
  lap->size[1] = (int32_T)L;
  emxEnsureCapacity_real_T(sp, lap, i1, &g_emlrtRTEI);
  if ((int32_T)L != i) {
    emlrtIntegerCheckR2012b(L, &e_emlrtDCI, sp);
  }

  loop_ub_tmp = (int32_T)L * (int32_T)L;
  for (i1 = 0; i1 < loop_ub_tmp; i1++) {
    lap->data[i1] = 0.0;
  }

  emxInit_real_T(sp, &cD, 3, &h_emlrtRTEI, true);
  if ((int32_T)L != i) {
    emlrtIntegerCheckR2012b(L, &m_emlrtDCI, sp);
  }

  i1 = cD->size[0] * cD->size[1] * cD->size[2];
  cD->size[0] = (int32_T)L;
  emxEnsureCapacity_real_T(sp, cD, i1, &h_emlrtRTEI);
  if ((int32_T)L != i) {
    emlrtIntegerCheckR2012b(L, &l_emlrtDCI, sp);
  }

  i1 = cD->size[0] * cD->size[1] * cD->size[2];
  cD->size[1] = (int32_T)L;
  cD->size[2] = 2;
  emxEnsureCapacity_real_T(sp, cD, i1, &h_emlrtRTEI);
  if ((int32_T)L != i) {
    emlrtIntegerCheckR2012b(L, &d_emlrtDCI, sp);
  }

  b_loop_ub_tmp = loop_ub_tmp << 1;
  for (i1 = 0; i1 < b_loop_ub_tmp; i1++) {
    cD->data[i1] = 0.0;
  }

  emxInit_real_T(sp, &cE, 3, &i_emlrtRTEI, true);
  if ((int32_T)L != i) {
    emlrtIntegerCheckR2012b(L, &k_emlrtDCI, sp);
  }

  i1 = cE->size[0] * cE->size[1] * cE->size[2];
  cE->size[0] = (int32_T)L;
  emxEnsureCapacity_real_T(sp, cE, i1, &i_emlrtRTEI);
  if ((int32_T)L != i) {
    emlrtIntegerCheckR2012b(L, &j_emlrtDCI, sp);
  }

  i1 = cE->size[0] * cE->size[1] * cE->size[2];
  cE->size[1] = (int32_T)L;
  cE->size[2] = 2;
  emxEnsureCapacity_real_T(sp, cE, i1, &i_emlrtRTEI);
  if ((int32_T)L != i) {
    emlrtIntegerCheckR2012b(L, &c_emlrtDCI, sp);
  }

  for (i1 = 0; i1 < b_loop_ub_tmp; i1++) {
    cE->data[i1] = 0.0;
  }

  if ((int32_T)L != i) {
    emlrtIntegerCheckR2012b(L, &q_emlrtDCI, sp);
  }

  emxInit_real_T(sp, &rms, 2, &lb_emlrtRTEI, true);
  emxInit_real_T(sp, &r, 2, &pb_emlrtRTEI, true);

  /* cD(:,:,1) = 0.1*rand(L,L) + ones(L,L); */
  /* cE(60:65 ,60:65,1) = 1; */
  /* cE(:,:,1) = cE(:,:,1) + 0.01*rand(L,L); */
  st.site = &d_emlrtRSI;
  power(&st, xms, rms);
  st.site = &d_emlrtRSI;
  power(&st, yms, r);
  emlrtSizeEqCheckNDR2012b(*(int32_T (*)[2])rms->size, *(int32_T (*)[2])r->size,
    &fb_emlrtECI, sp);
  loop_ub = rms->size[0] * rms->size[1];
  for (i1 = 0; i1 < loop_ub; i1++) {
    rms->data[i1] += r->data[i1];
  }

  emxInit_real_T(sp, &thms, 2, &mb_emlrtRTEI, true);
  st.site = &d_emlrtRSI;
  b_sqrt(&st, rms);
  st.site = &e_emlrtRSI;
  b_atan2(&st, yms, xms, thms);
  loop_ub = thms->size[0] * thms->size[1];
  for (i1 = 0; i1 < loop_ub; i1++) {
    thms->data[i1] *= 6.0;
  }

  st.site = &f_emlrtRSI;
  b_sin(&st, thms);
  st.site = &f_emlrtRSI;
  power(&st, thms, r);
  st.site = &f_emlrtRSI;
  power(&st, rms, yms);
  loop_ub = yms->size[0] * yms->size[1];
  emxFree_real_T(&thms);
  for (i1 = 0; i1 < loop_ub; i1++) {
    yms->data[i1] = -yms->data[i1] / 100.0;
  }

  st.site = &f_emlrtRSI;
  b_exp(&st, yms);
  emlrtSizeEqCheckNDR2012b(*(int32_T (*)[2])r->size, *(int32_T (*)[2])yms->size,
    &eb_emlrtECI, sp);
  loop_ub = r->size[0] * r->size[1];
  for (i1 = 0; i1 < loop_ub; i1++) {
    r->data[i1] *= yms->data[i1];
  }

  b_L[0] = (int32_T)L;
  b_L[1] = (int32_T)L;
  emlrtSubAssignSizeCheckR2012b(&b_L[0], 2, &r->size[0], 2, &y_emlrtECI, sp);
  loop_ub = r->size[1];
  for (i1 = 0; i1 < loop_ub; i1++) {
    b_loop_ub = r->size[0];
    for (i2 = 0; i2 < b_loop_ub; i2++) {
      cE->data[i2 + cE->size[0] * i1] = r->data[i2 + r->size[0] * i1];
    }
  }

  st.site = &g_emlrtRSI;
  power(&st, rms, xms);
  loop_ub = xms->size[0] * xms->size[1];
  emxFree_real_T(&rms);
  for (i1 = 0; i1 < loop_ub; i1++) {
    xms->data[i1] *= 0.0001;
  }

  b_L[0] = (int32_T)L;
  b_L[1] = (int32_T)L;
  emlrtSubAssignSizeCheckR2012b(&b_L[0], 2, &xms->size[0], 2, &db_emlrtECI, sp);
  loop_ub = xms->size[1];
  for (i1 = 0; i1 < loop_ub; i1++) {
    b_loop_ub = xms->size[0];
    for (i2 = 0; i2 < b_loop_ub; i2++) {
      cD->data[i2 + cD->size[0] * i1] = xms->data[i2 + xms->size[0] * i1] + 1.0;
    }
  }

  /*  */
  if ((int32_T)L != i) {
    emlrtIntegerCheckR2012b(L, &i_emlrtDCI, sp);
  }

  i1 = cDt->size[0] * cDt->size[1] * cDt->size[2];
  cDt->size[0] = (int32_T)L;
  emxEnsureCapacity_real_T(sp, cDt, i1, &j_emlrtRTEI);
  if ((int32_T)L != i) {
    emlrtIntegerCheckR2012b(L, &h_emlrtDCI, sp);
  }

  i1 = cDt->size[0] * cDt->size[1] * cDt->size[2];
  cDt->size[1] = (int32_T)L;
  cDt->size[2] = 10000;
  emxEnsureCapacity_real_T(sp, cDt, i1, &j_emlrtRTEI);
  if ((int32_T)L != i) {
    emlrtIntegerCheckR2012b(L, &b_emlrtDCI, sp);
  }

  loop_ub_tmp *= 10000;
  for (i1 = 0; i1 < loop_ub_tmp; i1++) {
    cDt->data[i1] = 0.0;
  }

  if ((int32_T)L != i) {
    emlrtIntegerCheckR2012b(L, &g_emlrtDCI, sp);
  }

  i1 = cEt->size[0] * cEt->size[1] * cEt->size[2];
  cEt->size[0] = (int32_T)L;
  emxEnsureCapacity_real_T(sp, cEt, i1, &k_emlrtRTEI);
  if ((int32_T)L != i) {
    emlrtIntegerCheckR2012b(L, &f_emlrtDCI, sp);
  }

  i1 = cEt->size[0] * cEt->size[1] * cEt->size[2];
  cEt->size[1] = (int32_T)L;
  cEt->size[2] = 10000;
  emxEnsureCapacity_real_T(sp, cEt, i1, &k_emlrtRTEI);
  if ((int32_T)L != i) {
    emlrtIntegerCheckR2012b(L, &emlrtDCI, sp);
  }

  for (i = 0; i < loop_ub_tmp; i++) {
    cEt->data[i] = 0.0;
  }

  emxInit_real_T(sp, &b_cD, 3, &bb_emlrtRTEI, true);
  emxInit_real_T(sp, &c_cD, 3, &db_emlrtRTEI, true);
  for (it = 0; it < 10000; it++) {
    if (1 > cD->size[0] - 2) {
      loop_ub = 0;
    } else {
      if (1 > cD->size[0]) {
        emlrtDynamicBoundsCheckR2012b(1, 1, cD->size[0], &he_emlrtBCI, sp);
      }

      loop_ub = cD->size[0] - 2;
      if ((loop_ub < 1) || (loop_ub > cD->size[0])) {
        emlrtDynamicBoundsCheckR2012b(loop_ub, 1, cD->size[0], &ge_emlrtBCI, sp);
      }
    }

    if (2 > cD->size[1] - 1) {
      i = -1;
      i1 = -1;
    } else {
      if (2 > cD->size[1]) {
        emlrtDynamicBoundsCheckR2012b(2, 1, cD->size[1], &fe_emlrtBCI, sp);
      }

      i = 0;
      i1 = cD->size[1] - 1;
      if ((i1 < 1) || (i1 > cD->size[1])) {
        emlrtDynamicBoundsCheckR2012b(i1, 1, cD->size[1], &ee_emlrtBCI, sp);
      }

      i1--;
    }

    if (2 > cD->size[0] - 1) {
      i2 = 0;
      i3 = 0;
    } else {
      if (2 > cD->size[0]) {
        emlrtDynamicBoundsCheckR2012b(2, 1, cD->size[0], &de_emlrtBCI, sp);
      }

      i2 = 1;
      i3 = cD->size[0] - 1;
      if ((i3 < 1) || (i3 > cD->size[0])) {
        emlrtDynamicBoundsCheckR2012b(i3, 1, cD->size[0], &ce_emlrtBCI, sp);
      }
    }

    if (2 > cD->size[1] - 1) {
      b_loop_ub_tmp = 0;
      i4 = 0;
    } else {
      if (2 > cD->size[1]) {
        emlrtDynamicBoundsCheckR2012b(2, 1, cD->size[1], &be_emlrtBCI, sp);
      }

      b_loop_ub_tmp = 1;
      i4 = cD->size[1] - 1;
      if ((i4 < 1) || (i4 > cD->size[1])) {
        emlrtDynamicBoundsCheckR2012b(i4, 1, cD->size[1], &ae_emlrtBCI, sp);
      }
    }

    b_loop_ub = i3 - i2;
    i3 = r->size[0] * r->size[1];
    r->size[0] = b_loop_ub;
    loop_ub_tmp = i4 - b_loop_ub_tmp;
    r->size[1] = loop_ub_tmp;
    emxEnsureCapacity_real_T(sp, r, i3, &l_emlrtRTEI);
    for (i3 = 0; i3 < loop_ub_tmp; i3++) {
      for (i4 = 0; i4 < b_loop_ub; i4++) {
        r->data[i4 + r->size[0] * i3] = 2.0 * cD->data[(i2 + i4) + cD->size[0] *
          (b_loop_ub_tmp + i3)];
      }
    }

    iv[0] = loop_ub;
    b_loop_ub = i1 - i;
    iv[1] = b_loop_ub;
    emlrtSizeEqCheckNDR2012b(iv, *(int32_T (*)[2])r->size, &cb_emlrtECI, sp);
    if (3 > cD->size[0]) {
      i1 = -1;
      i2 = 0;
    } else {
      i1 = 1;
      if (cD->size[0] < 1) {
        emlrtDynamicBoundsCheckR2012b(cD->size[0], 1, cD->size[0], &yd_emlrtBCI,
          sp);
      }

      i2 = cD->size[0];
    }

    if (2 > cD->size[1] - 1) {
      i3 = -1;
      b_loop_ub_tmp = 0;
    } else {
      if (2 > cD->size[1]) {
        emlrtDynamicBoundsCheckR2012b(2, 1, cD->size[1], &xd_emlrtBCI, sp);
      }

      i3 = 0;
      b_loop_ub_tmp = cD->size[1] - 1;
      if ((b_loop_ub_tmp < 1) || (b_loop_ub_tmp > cD->size[1])) {
        emlrtDynamicBoundsCheckR2012b(b_loop_ub_tmp, 1, cD->size[1],
          &wd_emlrtBCI, sp);
      }
    }

    iv[0] = loop_ub;
    iv[1] = b_loop_ub;
    b_L[0] = (i2 - i1) - 1;
    b_L[1] = (b_loop_ub_tmp - i3) - 1;
    if ((loop_ub != b_L[0]) || (b_loop_ub != b_L[1])) {
      emlrtSizeEqCheckNDR2012b(&iv[0], &b_L[0], &cb_emlrtECI, sp);
    }

    if (2 > cD->size[0] - 1) {
      i2 = -1;
      b_loop_ub_tmp = -1;
    } else {
      if (2 > cD->size[0]) {
        emlrtDynamicBoundsCheckR2012b(2, 1, cD->size[0], &vd_emlrtBCI, sp);
      }

      i2 = 0;
      b_loop_ub_tmp = cD->size[0] - 1;
      if ((b_loop_ub_tmp < 1) || (b_loop_ub_tmp > cD->size[0])) {
        emlrtDynamicBoundsCheckR2012b(b_loop_ub_tmp, 1, cD->size[0],
          &ud_emlrtBCI, sp);
      }

      b_loop_ub_tmp--;
    }

    if (1 > cD->size[1] - 2) {
      loop_ub_tmp = 0;
    } else {
      if (1 > cD->size[1]) {
        emlrtDynamicBoundsCheckR2012b(1, 1, cD->size[1], &td_emlrtBCI, sp);
      }

      loop_ub_tmp = cD->size[1] - 2;
      if ((loop_ub_tmp < 1) || (loop_ub_tmp > cD->size[1])) {
        emlrtDynamicBoundsCheckR2012b(loop_ub_tmp, 1, cD->size[1], &sd_emlrtBCI,
          sp);
      }
    }

    if (2 > cD->size[0] - 1) {
      i4 = 0;
      i5 = 0;
    } else {
      if (2 > cD->size[0]) {
        emlrtDynamicBoundsCheckR2012b(2, 1, cD->size[0], &rd_emlrtBCI, sp);
      }

      i4 = 1;
      i5 = cD->size[0] - 1;
      if ((i5 < 1) || (i5 > cD->size[0])) {
        emlrtDynamicBoundsCheckR2012b(i5, 1, cD->size[0], &qd_emlrtBCI, sp);
      }
    }

    if (2 > cD->size[1] - 1) {
      i6 = 0;
      i7 = 0;
    } else {
      if (2 > cD->size[1]) {
        emlrtDynamicBoundsCheckR2012b(2, 1, cD->size[1], &pd_emlrtBCI, sp);
      }

      i6 = 1;
      i7 = cD->size[1] - 1;
      if ((i7 < 1) || (i7 > cD->size[1])) {
        emlrtDynamicBoundsCheckR2012b(i7, 1, cD->size[1], &od_emlrtBCI, sp);
      }
    }

    c_loop_ub = i5 - i4;
    i5 = yms->size[0] * yms->size[1];
    yms->size[0] = c_loop_ub;
    d_loop_ub = i7 - i6;
    yms->size[1] = d_loop_ub;
    emxEnsureCapacity_real_T(sp, yms, i5, &m_emlrtRTEI);
    for (i5 = 0; i5 < d_loop_ub; i5++) {
      for (i7 = 0; i7 < c_loop_ub; i7++) {
        yms->data[i7 + yms->size[0] * i5] = 2.0 * cD->data[(i4 + i7) + cD->size
          [0] * (i6 + i5)];
      }
    }

    c_loop_ub = b_loop_ub_tmp - i2;
    iv[0] = c_loop_ub;
    iv[1] = loop_ub_tmp;
    emlrtSizeEqCheckNDR2012b(iv, *(int32_T (*)[2])yms->size, &bb_emlrtECI, sp);
    if (2 > cD->size[0] - 1) {
      b_loop_ub_tmp = -1;
      i4 = 0;
    } else {
      if (2 > cD->size[0]) {
        emlrtDynamicBoundsCheckR2012b(2, 1, cD->size[0], &nd_emlrtBCI, sp);
      }

      b_loop_ub_tmp = 0;
      i4 = cD->size[0] - 1;
      if ((i4 < 1) || (i4 > cD->size[0])) {
        emlrtDynamicBoundsCheckR2012b(i4, 1, cD->size[0], &md_emlrtBCI, sp);
      }
    }

    if (3 > cD->size[1]) {
      i5 = -1;
      i6 = 0;
    } else {
      i5 = 1;
      if (cD->size[1] < 1) {
        emlrtDynamicBoundsCheckR2012b(cD->size[1], 1, cD->size[1], &ld_emlrtBCI,
          sp);
      }

      i6 = cD->size[1];
    }

    iv[0] = c_loop_ub;
    iv[1] = loop_ub_tmp;
    b_L[0] = (i4 - b_loop_ub_tmp) - 1;
    b_L[1] = (i6 - i5) - 1;
    if ((c_loop_ub != b_L[0]) || (loop_ub_tmp != b_L[1])) {
      emlrtSizeEqCheckNDR2012b(&iv[0], &b_L[0], &bb_emlrtECI, sp);
    }

    i4 = r->size[0] * r->size[1];
    r->size[0] = loop_ub;
    r->size[1] = b_loop_ub;
    emxEnsureCapacity_real_T(sp, r, i4, &n_emlrtRTEI);
    for (i4 = 0; i4 < b_loop_ub; i4++) {
      for (i6 = 0; i6 < loop_ub; i6++) {
        r->data[i6 + r->size[0] * i4] = 0.0625 * ((cD->data[i6 + cD->size[0] *
          ((i + i4) + 1)] - r->data[i6 + r->size[0] * i4]) + cD->data[((i1 + i6)
          + cD->size[0] * ((i3 + i4) + 1)) + 1]);
      }
    }

    i = yms->size[0] * yms->size[1];
    yms->size[0] = c_loop_ub;
    yms->size[1] = loop_ub_tmp;
    emxEnsureCapacity_real_T(sp, yms, i, &o_emlrtRTEI);
    for (i = 0; i < loop_ub_tmp; i++) {
      for (i1 = 0; i1 < c_loop_ub; i1++) {
        yms->data[i1 + yms->size[0] * i] = 0.0625 * ((cD->data[((i2 + i1) +
          cD->size[0] * i) + 1] - yms->data[i1 + yms->size[0] * i]) + cD->data
          [((b_loop_ub_tmp + i1) + cD->size[0] * ((i5 + i) + 1)) + 1]);
      }
    }

    emlrtSizeEqCheckNDR2012b(*(int32_T (*)[2])r->size, *(int32_T (*)[2])
      yms->size, &ab_emlrtECI, sp);
    if (2 > lap->size[0] - 1) {
      i = 0;
      i1 = 0;
    } else {
      if (2 > lap->size[0]) {
        emlrtDynamicBoundsCheckR2012b(2, 1, lap->size[0], &kd_emlrtBCI, sp);
      }

      i = 1;
      i1 = lap->size[0] - 1;
      if ((i1 < 1) || (i1 > lap->size[0])) {
        emlrtDynamicBoundsCheckR2012b(i1, 1, lap->size[0], &jd_emlrtBCI, sp);
      }
    }

    if (2 > lap->size[1] - 1) {
      i2 = 0;
      i3 = 0;
    } else {
      if (2 > lap->size[1]) {
        emlrtDynamicBoundsCheckR2012b(2, 1, lap->size[1], &id_emlrtBCI, sp);
      }

      i2 = 1;
      i3 = lap->size[1] - 1;
      if ((i3 < 1) || (i3 > lap->size[1])) {
        emlrtDynamicBoundsCheckR2012b(i3, 1, lap->size[1], &hd_emlrtBCI, sp);
      }
    }

    iv[0] = i1 - i;
    iv[1] = i3 - i2;
    emlrtSubAssignSizeCheckR2012b(&iv[0], 2, &r->size[0], 2, &w_emlrtECI, sp);
    loop_ub = r->size[1];
    for (i1 = 0; i1 < loop_ub; i1++) {
      b_loop_ub = r->size[0];
      for (i3 = 0; i3 < b_loop_ub; i3++) {
        lap->data[(i + i3) + lap->size[0] * (i2 + i1)] = r->data[i3 + r->size[0]
          * i1] + yms->data[i3 + yms->size[0] * i1];
      }
    }

    if (1 > lap->size[0]) {
      emlrtDynamicBoundsCheckR2012b(1, 1, lap->size[0], &gd_emlrtBCI, sp);
    }

    loop_ub = lap->size[1];
    for (i = 0; i < loop_ub; i++) {
      lap->data[lap->size[0] * i] = 0.0;
    }

    if (1 > lap->size[1]) {
      emlrtDynamicBoundsCheckR2012b(1, 1, lap->size[1], &fd_emlrtBCI, sp);
    }

    loop_ub = lap->size[0];
    for (i = 0; i < loop_ub; i++) {
      lap->data[i] = 0.0;
    }

    i = lap->size[0];
    if (lap->size[0] < 1) {
      emlrtDynamicBoundsCheckR2012b(lap->size[0], 1, lap->size[0], &ed_emlrtBCI,
        sp);
    }

    loop_ub = lap->size[1];
    for (i1 = 0; i1 < loop_ub; i1++) {
      lap->data[(i + lap->size[0] * i1) - 1] = 0.0;
    }

    i = lap->size[1];
    if (lap->size[1] < 1) {
      emlrtDynamicBoundsCheckR2012b(lap->size[1], 1, lap->size[1], &dd_emlrtBCI,
        sp);
    }

    loop_ub = lap->size[0];
    for (i1 = 0; i1 < loop_ub; i1++) {
      lap->data[i1 + lap->size[0] * (i - 1)] = 0.0;
    }

    loop_ub = cE->size[0];
    b_loop_ub = cE->size[1];
    i = xms->size[0] * xms->size[1];
    xms->size[0] = cE->size[0];
    xms->size[1] = cE->size[1];
    emxEnsureCapacity_real_T(sp, xms, i, &p_emlrtRTEI);
    for (i = 0; i < b_loop_ub; i++) {
      for (i1 = 0; i1 < loop_ub; i1++) {
        xms->data[i1 + xms->size[0] * i] = cE->data[i1 + cE->size[0] * i];
      }
    }

    st.site = &h_emlrtRSI;
    power(&st, xms, r);
    loop_ub = cD->size[0];
    b_loop_ub = cD->size[1];
    iv[0] = cD->size[0];
    iv[1] = cD->size[1];
    emlrtSizeEqCheckNDR2012b(iv, *(int32_T (*)[2])r->size, &x_emlrtECI, sp);
    i = yms->size[0] * yms->size[1];
    yms->size[0] = cD->size[0];
    yms->size[1] = cD->size[1];
    emxEnsureCapacity_real_T(sp, yms, i, &q_emlrtRTEI);
    i = r->size[0] * r->size[1];
    r->size[0] = cD->size[0];
    r->size[1] = cD->size[1];
    emxEnsureCapacity_real_T(sp, r, i, &r_emlrtRTEI);
    for (i = 0; i < b_loop_ub; i++) {
      for (i1 = 0; i1 < loop_ub; i1++) {
        a_tmp = cD->data[i1 + cD->size[0] * i];
        yms->data[i1 + yms->size[0] * i] = 0.018 * (1.0 - a_tmp);
        r->data[i1 + r->size[0] * i] *= a_tmp;
      }
    }

    emlrtSizeEqCheckNDR2012b(*(int32_T (*)[2])yms->size, *(int32_T (*)[2])
      r->size, &v_emlrtECI, sp);
    emlrtSizeEqCheckNDR2012b(*(int32_T (*)[2])yms->size, *(int32_T (*)[2])
      lap->size, &v_emlrtECI, sp);
    loop_ub = yms->size[0] * yms->size[1];
    for (i = 0; i < loop_ub; i++) {
      yms->data[i] = 0.25 * ((yms->data[i] - r->data[i]) + lap->data[i]);
    }

    iv[0] = cD->size[0];
    iv[1] = cD->size[1];
    emlrtSizeEqCheckNDR2012b(*(int32_T (*)[2])yms->size, iv, &u_emlrtECI, sp);
    dv[0] = cE->size[0];
    dv[1] = cE->size[1];
    st.site = &h_emlrtRSI;
    b_rand(&st, dv, xms);
    loop_ub = xms->size[0] * xms->size[1];
    for (i = 0; i < loop_ub; i++) {
      xms->data[i] *= 0.001;
    }

    emlrtSizeEqCheckNDR2012b(*(int32_T (*)[2])yms->size, *(int32_T (*)[2])
      xms->size, &u_emlrtECI, sp);
    b_L[0] = cD->size[0];
    b_L[1] = cD->size[1];
    emlrtSubAssignSizeCheckR2012b(&b_L[0], 2, &yms->size[0], 2, &t_emlrtECI, sp);
    loop_ub = yms->size[1];
    for (i = 0; i < loop_ub; i++) {
      b_loop_ub = yms->size[0];
      for (i1 = 0; i1 < b_loop_ub; i1++) {
        yms->data[i1 + yms->size[0] * i] = (yms->data[i1 + yms->size[0] * i] +
          cD->data[i1 + cD->size[0] * i]) + xms->data[i1 + xms->size[0] * i];
      }
    }

    loop_ub = yms->size[1];
    for (i = 0; i < loop_ub; i++) {
      b_loop_ub = yms->size[0];
      for (i1 = 0; i1 < b_loop_ub; i1++) {
        cD->data[(i1 + cD->size[0] * i) + cD->size[0] * cD->size[1]] = yms->
          data[i1 + yms->size[0] * i];
      }
    }

    if (1 > cE->size[0] - 2) {
      loop_ub = 0;
    } else {
      if (1 > cE->size[0]) {
        emlrtDynamicBoundsCheckR2012b(1, 1, cE->size[0], &cd_emlrtBCI, sp);
      }

      loop_ub = cE->size[0] - 2;
      if ((loop_ub < 1) || (loop_ub > cE->size[0])) {
        emlrtDynamicBoundsCheckR2012b(loop_ub, 1, cE->size[0], &bd_emlrtBCI, sp);
      }
    }

    if (2 > cE->size[1] - 1) {
      i = -1;
      i1 = -1;
    } else {
      if (2 > cE->size[1]) {
        emlrtDynamicBoundsCheckR2012b(2, 1, cE->size[1], &ad_emlrtBCI, sp);
      }

      i = 0;
      i1 = cE->size[1] - 1;
      if ((i1 < 1) || (i1 > cE->size[1])) {
        emlrtDynamicBoundsCheckR2012b(i1, 1, cE->size[1], &yc_emlrtBCI, sp);
      }

      i1--;
    }

    if (2 > cE->size[0] - 1) {
      i2 = 0;
      i3 = 0;
    } else {
      if (2 > cE->size[0]) {
        emlrtDynamicBoundsCheckR2012b(2, 1, cE->size[0], &xc_emlrtBCI, sp);
      }

      i2 = 1;
      i3 = cE->size[0] - 1;
      if ((i3 < 1) || (i3 > cE->size[0])) {
        emlrtDynamicBoundsCheckR2012b(i3, 1, cE->size[0], &wc_emlrtBCI, sp);
      }
    }

    if (2 > cE->size[1] - 1) {
      b_loop_ub_tmp = 0;
      i4 = 0;
    } else {
      if (2 > cE->size[1]) {
        emlrtDynamicBoundsCheckR2012b(2, 1, cE->size[1], &vc_emlrtBCI, sp);
      }

      b_loop_ub_tmp = 1;
      i4 = cE->size[1] - 1;
      if ((i4 < 1) || (i4 > cE->size[1])) {
        emlrtDynamicBoundsCheckR2012b(i4, 1, cE->size[1], &uc_emlrtBCI, sp);
      }
    }

    b_loop_ub = i3 - i2;
    i3 = r->size[0] * r->size[1];
    r->size[0] = b_loop_ub;
    loop_ub_tmp = i4 - b_loop_ub_tmp;
    r->size[1] = loop_ub_tmp;
    emxEnsureCapacity_real_T(sp, r, i3, &s_emlrtRTEI);
    for (i3 = 0; i3 < loop_ub_tmp; i3++) {
      for (i4 = 0; i4 < b_loop_ub; i4++) {
        r->data[i4 + r->size[0] * i3] = 2.0 * cE->data[(i2 + i4) + cE->size[0] *
          (b_loop_ub_tmp + i3)];
      }
    }

    iv[0] = loop_ub;
    b_loop_ub = i1 - i;
    iv[1] = b_loop_ub;
    emlrtSizeEqCheckNDR2012b(iv, *(int32_T (*)[2])r->size, &s_emlrtECI, sp);
    if (3 > cE->size[0]) {
      i1 = -1;
      i2 = 0;
    } else {
      i1 = 1;
      if (cE->size[0] < 1) {
        emlrtDynamicBoundsCheckR2012b(cE->size[0], 1, cE->size[0], &tc_emlrtBCI,
          sp);
      }

      i2 = cE->size[0];
    }

    if (2 > cE->size[1] - 1) {
      i3 = -1;
      b_loop_ub_tmp = 0;
    } else {
      if (2 > cE->size[1]) {
        emlrtDynamicBoundsCheckR2012b(2, 1, cE->size[1], &sc_emlrtBCI, sp);
      }

      i3 = 0;
      b_loop_ub_tmp = cE->size[1] - 1;
      if ((b_loop_ub_tmp < 1) || (b_loop_ub_tmp > cE->size[1])) {
        emlrtDynamicBoundsCheckR2012b(b_loop_ub_tmp, 1, cE->size[1],
          &rc_emlrtBCI, sp);
      }
    }

    iv[0] = loop_ub;
    iv[1] = b_loop_ub;
    b_L[0] = (i2 - i1) - 1;
    b_L[1] = (b_loop_ub_tmp - i3) - 1;
    if ((loop_ub != b_L[0]) || (b_loop_ub != b_L[1])) {
      emlrtSizeEqCheckNDR2012b(&iv[0], &b_L[0], &s_emlrtECI, sp);
    }

    if (2 > cE->size[0] - 1) {
      i2 = -1;
      b_loop_ub_tmp = -1;
    } else {
      if (2 > cE->size[0]) {
        emlrtDynamicBoundsCheckR2012b(2, 1, cE->size[0], &qc_emlrtBCI, sp);
      }

      i2 = 0;
      b_loop_ub_tmp = cE->size[0] - 1;
      if ((b_loop_ub_tmp < 1) || (b_loop_ub_tmp > cE->size[0])) {
        emlrtDynamicBoundsCheckR2012b(b_loop_ub_tmp, 1, cE->size[0],
          &pc_emlrtBCI, sp);
      }

      b_loop_ub_tmp--;
    }

    if (1 > cE->size[1] - 2) {
      loop_ub_tmp = 0;
    } else {
      if (1 > cE->size[1]) {
        emlrtDynamicBoundsCheckR2012b(1, 1, cE->size[1], &oc_emlrtBCI, sp);
      }

      loop_ub_tmp = cE->size[1] - 2;
      if ((loop_ub_tmp < 1) || (loop_ub_tmp > cE->size[1])) {
        emlrtDynamicBoundsCheckR2012b(loop_ub_tmp, 1, cE->size[1], &nc_emlrtBCI,
          sp);
      }
    }

    if (2 > cE->size[0] - 1) {
      i4 = 0;
      i5 = 0;
    } else {
      if (2 > cE->size[0]) {
        emlrtDynamicBoundsCheckR2012b(2, 1, cE->size[0], &mc_emlrtBCI, sp);
      }

      i4 = 1;
      i5 = cE->size[0] - 1;
      if ((i5 < 1) || (i5 > cE->size[0])) {
        emlrtDynamicBoundsCheckR2012b(i5, 1, cE->size[0], &lc_emlrtBCI, sp);
      }
    }

    if (2 > cE->size[1] - 1) {
      i6 = 0;
      i7 = 0;
    } else {
      if (2 > cE->size[1]) {
        emlrtDynamicBoundsCheckR2012b(2, 1, cE->size[1], &kc_emlrtBCI, sp);
      }

      i6 = 1;
      i7 = cE->size[1] - 1;
      if ((i7 < 1) || (i7 > cE->size[1])) {
        emlrtDynamicBoundsCheckR2012b(i7, 1, cE->size[1], &jc_emlrtBCI, sp);
      }
    }

    c_loop_ub = i5 - i4;
    i5 = yms->size[0] * yms->size[1];
    yms->size[0] = c_loop_ub;
    d_loop_ub = i7 - i6;
    yms->size[1] = d_loop_ub;
    emxEnsureCapacity_real_T(sp, yms, i5, &t_emlrtRTEI);
    for (i5 = 0; i5 < d_loop_ub; i5++) {
      for (i7 = 0; i7 < c_loop_ub; i7++) {
        yms->data[i7 + yms->size[0] * i5] = 2.0 * cE->data[(i4 + i7) + cE->size
          [0] * (i6 + i5)];
      }
    }

    c_loop_ub = b_loop_ub_tmp - i2;
    iv[0] = c_loop_ub;
    iv[1] = loop_ub_tmp;
    emlrtSizeEqCheckNDR2012b(iv, *(int32_T (*)[2])yms->size, &r_emlrtECI, sp);
    if (2 > cE->size[0] - 1) {
      b_loop_ub_tmp = -1;
      i4 = 0;
    } else {
      if (2 > cE->size[0]) {
        emlrtDynamicBoundsCheckR2012b(2, 1, cE->size[0], &ic_emlrtBCI, sp);
      }

      b_loop_ub_tmp = 0;
      i4 = cE->size[0] - 1;
      if ((i4 < 1) || (i4 > cE->size[0])) {
        emlrtDynamicBoundsCheckR2012b(i4, 1, cE->size[0], &hc_emlrtBCI, sp);
      }
    }

    if (3 > cE->size[1]) {
      i5 = -1;
      i6 = 0;
    } else {
      i5 = 1;
      if (cE->size[1] < 1) {
        emlrtDynamicBoundsCheckR2012b(cE->size[1], 1, cE->size[1], &gc_emlrtBCI,
          sp);
      }

      i6 = cE->size[1];
    }

    iv[0] = c_loop_ub;
    iv[1] = loop_ub_tmp;
    b_L[0] = (i4 - b_loop_ub_tmp) - 1;
    b_L[1] = (i6 - i5) - 1;
    if ((c_loop_ub != b_L[0]) || (loop_ub_tmp != b_L[1])) {
      emlrtSizeEqCheckNDR2012b(&iv[0], &b_L[0], &r_emlrtECI, sp);
    }

    i4 = r->size[0] * r->size[1];
    r->size[0] = loop_ub;
    r->size[1] = b_loop_ub;
    emxEnsureCapacity_real_T(sp, r, i4, &u_emlrtRTEI);
    for (i4 = 0; i4 < b_loop_ub; i4++) {
      for (i6 = 0; i6 < loop_ub; i6++) {
        r->data[i6 + r->size[0] * i4] = 0.0625 * ((cE->data[i6 + cE->size[0] *
          ((i + i4) + 1)] - r->data[i6 + r->size[0] * i4]) + cE->data[((i1 + i6)
          + cE->size[0] * ((i3 + i4) + 1)) + 1]);
      }
    }

    i = yms->size[0] * yms->size[1];
    yms->size[0] = c_loop_ub;
    yms->size[1] = loop_ub_tmp;
    emxEnsureCapacity_real_T(sp, yms, i, &v_emlrtRTEI);
    for (i = 0; i < loop_ub_tmp; i++) {
      for (i1 = 0; i1 < c_loop_ub; i1++) {
        yms->data[i1 + yms->size[0] * i] = 0.0625 * ((cE->data[((i2 + i1) +
          cE->size[0] * i) + 1] - yms->data[i1 + yms->size[0] * i]) + cE->data
          [((b_loop_ub_tmp + i1) + cE->size[0] * ((i5 + i) + 1)) + 1]);
      }
    }

    emlrtSizeEqCheckNDR2012b(*(int32_T (*)[2])r->size, *(int32_T (*)[2])
      yms->size, &q_emlrtECI, sp);
    if (2 > lap->size[0] - 1) {
      i = 0;
      i1 = 0;
    } else {
      if (2 > lap->size[0]) {
        emlrtDynamicBoundsCheckR2012b(2, 1, lap->size[0], &fc_emlrtBCI, sp);
      }

      i = 1;
      i1 = lap->size[0] - 1;
      if ((i1 < 1) || (i1 > lap->size[0])) {
        emlrtDynamicBoundsCheckR2012b(i1, 1, lap->size[0], &ec_emlrtBCI, sp);
      }
    }

    if (2 > lap->size[1] - 1) {
      i2 = 0;
      i3 = 0;
    } else {
      if (2 > lap->size[1]) {
        emlrtDynamicBoundsCheckR2012b(2, 1, lap->size[1], &dc_emlrtBCI, sp);
      }

      i2 = 1;
      i3 = lap->size[1] - 1;
      if ((i3 < 1) || (i3 > lap->size[1])) {
        emlrtDynamicBoundsCheckR2012b(i3, 1, lap->size[1], &cc_emlrtBCI, sp);
      }
    }

    iv[0] = i1 - i;
    iv[1] = i3 - i2;
    emlrtSubAssignSizeCheckR2012b(&iv[0], 2, &r->size[0], 2, &p_emlrtECI, sp);
    loop_ub = r->size[1];
    for (i1 = 0; i1 < loop_ub; i1++) {
      b_loop_ub = r->size[0];
      for (i3 = 0; i3 < b_loop_ub; i3++) {
        lap->data[(i + i3) + lap->size[0] * (i2 + i1)] = r->data[i3 + r->size[0]
          * i1] + yms->data[i3 + yms->size[0] * i1];
      }
    }

    if (1 > lap->size[0]) {
      emlrtDynamicBoundsCheckR2012b(1, 1, lap->size[0], &bc_emlrtBCI, sp);
    }

    loop_ub = lap->size[1];
    for (i = 0; i < loop_ub; i++) {
      lap->data[lap->size[0] * i] = 0.0;
    }

    if (1 > lap->size[1]) {
      emlrtDynamicBoundsCheckR2012b(1, 1, lap->size[1], &ac_emlrtBCI, sp);
    }

    loop_ub = lap->size[0];
    for (i = 0; i < loop_ub; i++) {
      lap->data[i] = 0.0;
    }

    i = lap->size[0];
    if (lap->size[0] < 1) {
      emlrtDynamicBoundsCheckR2012b(lap->size[0], 1, lap->size[0], &yb_emlrtBCI,
        sp);
    }

    loop_ub = lap->size[1];
    for (i1 = 0; i1 < loop_ub; i1++) {
      lap->data[(i + lap->size[0] * i1) - 1] = 0.0;
    }

    i = lap->size[1];
    if (lap->size[1] < 1) {
      emlrtDynamicBoundsCheckR2012b(lap->size[1], 1, lap->size[1], &xb_emlrtBCI,
        sp);
    }

    loop_ub = lap->size[0];
    for (i1 = 0; i1 < loop_ub; i1++) {
      lap->data[i1 + lap->size[0] * (i - 1)] = 0.0;
    }

    loop_ub = cE->size[0];
    b_loop_ub = cE->size[1];
    i = xms->size[0] * xms->size[1];
    xms->size[0] = cE->size[0];
    xms->size[1] = cE->size[1];
    emxEnsureCapacity_real_T(sp, xms, i, &w_emlrtRTEI);
    for (i = 0; i < b_loop_ub; i++) {
      for (i1 = 0; i1 < loop_ub; i1++) {
        xms->data[i1 + xms->size[0] * i] = cE->data[i1 + cE->size[0] * i];
      }
    }

    st.site = &i_emlrtRSI;
    power(&st, xms, r);
    loop_ub = cD->size[0];
    b_loop_ub = cD->size[1];
    iv[0] = cD->size[0];
    iv[1] = cD->size[1];
    emlrtSizeEqCheckNDR2012b(iv, *(int32_T (*)[2])r->size, &o_emlrtECI, sp);
    i = r->size[0] * r->size[1];
    r->size[0] = cD->size[0];
    r->size[1] = cD->size[1];
    emxEnsureCapacity_real_T(sp, r, i, &x_emlrtRTEI);
    for (i = 0; i < b_loop_ub; i++) {
      for (i1 = 0; i1 < loop_ub; i1++) {
        r->data[i1 + r->size[0] * i] *= cD->data[i1 + cD->size[0] * i];
      }
    }

    loop_ub = cE->size[0];
    b_loop_ub = cE->size[1];
    i = yms->size[0] * yms->size[1];
    yms->size[0] = cE->size[0];
    yms->size[1] = cE->size[1];
    emxEnsureCapacity_real_T(sp, yms, i, &y_emlrtRTEI);
    for (i = 0; i < b_loop_ub; i++) {
      for (i1 = 0; i1 < loop_ub; i1++) {
        yms->data[i1 + yms->size[0] * i] = 0.059 * cE->data[i1 + cE->size[0] * i];
      }
    }

    emlrtSizeEqCheckNDR2012b(*(int32_T (*)[2])r->size, *(int32_T (*)[2])
      yms->size, &o_emlrtECI, sp);
    i = xms->size[0] * xms->size[1];
    xms->size[0] = lap->size[0];
    xms->size[1] = lap->size[1];
    emxEnsureCapacity_real_T(sp, xms, i, &ab_emlrtRTEI);
    loop_ub = lap->size[0] * lap->size[1];
    for (i = 0; i < loop_ub; i++) {
      xms->data[i] = 0.05 * lap->data[i];
    }

    emlrtSizeEqCheckNDR2012b(*(int32_T (*)[2])r->size, *(int32_T (*)[2])
      xms->size, &o_emlrtECI, sp);
    loop_ub = r->size[0] * r->size[1];
    for (i = 0; i < loop_ub; i++) {
      r->data[i] = 0.25 * ((r->data[i] - yms->data[i]) + xms->data[i]);
    }

    iv[0] = cE->size[0];
    iv[1] = cE->size[1];
    emlrtSizeEqCheckNDR2012b(*(int32_T (*)[2])r->size, iv, &n_emlrtECI, sp);
    b_L[0] = cE->size[0];
    b_L[1] = cE->size[1];
    emlrtSubAssignSizeCheckR2012b(&b_L[0], 2, &r->size[0], 2, &m_emlrtECI, sp);
    loop_ub = r->size[1];
    for (i = 0; i < loop_ub; i++) {
      b_loop_ub = r->size[0];
      for (i1 = 0; i1 < b_loop_ub; i1++) {
        r->data[i1 + r->size[0] * i] += cE->data[i1 + cE->size[0] * i];
      }
    }

    loop_ub = r->size[1];
    for (i = 0; i < loop_ub; i++) {
      b_loop_ub = r->size[0];
      for (i1 = 0; i1 < b_loop_ub; i1++) {
        cE->data[(i1 + cE->size[0] * i) + cE->size[0] * cE->size[1]] = r->
          data[i1 + r->size[0] * i];
      }
    }

    if (2 > cD->size[1] - 1) {
      i = 0;
      i1 = 0;
      i2 = 0;
      i3 = 0;
    } else {
      if (2 > cD->size[1]) {
        emlrtDynamicBoundsCheckR2012b(2, 1, cD->size[1], &vb_emlrtBCI, sp);
      }

      i = 1;
      i1 = cD->size[1] - 1;
      if ((i1 < 1) || (i1 > cD->size[1])) {
        emlrtDynamicBoundsCheckR2012b(i1, 1, cD->size[1], &ub_emlrtBCI, sp);
      }

      if (2 > cD->size[1]) {
        emlrtDynamicBoundsCheckR2012b(2, 1, cD->size[1], &sb_emlrtBCI, sp);
      }

      i2 = 1;
      i3 = cD->size[1] - 1;
      if ((i3 < 1) || (i3 > cD->size[1])) {
        emlrtDynamicBoundsCheckR2012b(i3, 1, cD->size[1], &rb_emlrtBCI, sp);
      }
    }

    if (1 > cD->size[0]) {
      emlrtDynamicBoundsCheckR2012b(1, 1, cD->size[0], &tb_emlrtBCI, sp);
    }

    if (2 > cD->size[0]) {
      emlrtDynamicBoundsCheckR2012b(2, 1, cD->size[0], &wb_emlrtBCI, sp);
    }

    b_loop_ub_tmp = b_cD->size[0] * b_cD->size[1] * b_cD->size[2];
    b_cD->size[0] = 1;
    loop_ub = i1 - i;
    b_cD->size[1] = loop_ub;
    b_cD->size[2] = 2;
    emxEnsureCapacity_real_T(sp, b_cD, b_loop_ub_tmp, &bb_emlrtRTEI);
    for (i1 = 0; i1 < loop_ub; i1++) {
      b_cD->data[i1] = cD->data[cD->size[0] * (i + i1) + 1];
    }

    for (i1 = 0; i1 < loop_ub; i1++) {
      b_cD->data[i1 + b_cD->size[1]] = cD->data[(cD->size[0] * (i + i1) +
        cD->size[0] * cD->size[1]) + 1];
    }

    iv1[0] = 1;
    iv1[1] = i3 - i2;
    iv1[2] = 2;
    emlrtSubAssignSizeCheckR2012b(&iv1[0], 3, &b_cD->size[0], 3, &l_emlrtECI, sp);
    i1 = b_cD->size[0] * b_cD->size[1] * b_cD->size[2];
    b_cD->size[0] = 1;
    b_cD->size[1] = loop_ub;
    b_cD->size[2] = 2;
    emxEnsureCapacity_real_T(sp, b_cD, i1, &bb_emlrtRTEI);
    for (i1 = 0; i1 < loop_ub; i1++) {
      b_cD->data[i1] = cD->data[cD->size[0] * (i + i1) + 1];
    }

    for (i1 = 0; i1 < loop_ub; i1++) {
      b_cD->data[i1 + b_cD->size[1]] = cD->data[(cD->size[0] * (i + i1) +
        cD->size[0] * cD->size[1]) + 1];
    }

    loop_ub = b_cD->size[1];
    for (i = 0; i < loop_ub; i++) {
      cD->data[cD->size[0] * (i2 + i)] = b_cD->data[i];
    }

    for (i = 0; i < loop_ub; i++) {
      cD->data[cD->size[0] * (i2 + i) + cD->size[0] * cD->size[1]] = b_cD->
        data[i + b_cD->size[1]];
    }

    /*  Neumann No flux boundary condition */
    if (2 > cD->size[1] - 1) {
      i = 0;
      i1 = 0;
      i2 = 0;
      i3 = 0;
    } else {
      if (2 > cD->size[1]) {
        emlrtDynamicBoundsCheckR2012b(2, 1, cD->size[1], &pb_emlrtBCI, sp);
      }

      i = 1;
      i1 = cD->size[1] - 1;
      if ((i1 < 1) || (i1 > cD->size[1])) {
        emlrtDynamicBoundsCheckR2012b(i1, 1, cD->size[1], &ob_emlrtBCI, sp);
      }

      if (2 > cD->size[1]) {
        emlrtDynamicBoundsCheckR2012b(2, 1, cD->size[1], &mb_emlrtBCI, sp);
      }

      i2 = 1;
      i3 = cD->size[1] - 1;
      if ((i3 < 1) || (i3 > cD->size[1])) {
        emlrtDynamicBoundsCheckR2012b(i3, 1, cD->size[1], &lb_emlrtBCI, sp);
      }
    }

    if (cD->size[0] < 1) {
      emlrtDynamicBoundsCheckR2012b(cD->size[0], 1, cD->size[0], &nb_emlrtBCI,
        sp);
    }

    b_loop_ub_tmp = cD->size[0] - 1;
    if ((b_loop_ub_tmp < 1) || (b_loop_ub_tmp > cD->size[0])) {
      emlrtDynamicBoundsCheckR2012b(b_loop_ub_tmp, 1, cD->size[0], &qb_emlrtBCI,
        sp);
    }

    b_loop_ub_tmp = b_cD->size[0] * b_cD->size[1] * b_cD->size[2];
    b_cD->size[0] = 1;
    loop_ub = i1 - i;
    b_cD->size[1] = loop_ub;
    b_cD->size[2] = 2;
    emxEnsureCapacity_real_T(sp, b_cD, b_loop_ub_tmp, &cb_emlrtRTEI);
    for (i1 = 0; i1 < loop_ub; i1++) {
      b_cD->data[i1] = cD->data[(cD->size[0] + cD->size[0] * (i + i1)) - 2];
    }

    for (i1 = 0; i1 < loop_ub; i1++) {
      b_cD->data[i1 + b_cD->size[1]] = cD->data[((cD->size[0] + cD->size[0] * (i
        + i1)) + cD->size[0] * cD->size[1]) - 2];
    }

    iv1[0] = 1;
    iv1[1] = i3 - i2;
    iv1[2] = 2;
    emlrtSubAssignSizeCheckR2012b(&iv1[0], 3, &b_cD->size[0], 3, &k_emlrtECI, sp);
    i1 = cD->size[0];
    i3 = b_cD->size[0] * b_cD->size[1] * b_cD->size[2];
    b_cD->size[0] = 1;
    b_cD->size[1] = loop_ub;
    b_cD->size[2] = 2;
    emxEnsureCapacity_real_T(sp, b_cD, i3, &cb_emlrtRTEI);
    for (i3 = 0; i3 < loop_ub; i3++) {
      b_cD->data[i3] = cD->data[(i1 + cD->size[0] * (i + i3)) - 2];
    }

    for (i3 = 0; i3 < loop_ub; i3++) {
      b_cD->data[i3 + b_cD->size[1]] = cD->data[((i1 + cD->size[0] * (i + i3)) +
        cD->size[0] * cD->size[1]) - 2];
    }

    loop_ub = b_cD->size[1];
    for (i = 0; i < loop_ub; i++) {
      cD->data[(i1 + cD->size[0] * (i2 + i)) - 1] = b_cD->data[i];
    }

    for (i = 0; i < loop_ub; i++) {
      cD->data[((i1 + cD->size[0] * (i2 + i)) + cD->size[0] * cD->size[1]) - 1] =
        b_cD->data[i + b_cD->size[1]];
    }

    if (2 > cD->size[0] - 1) {
      i = 0;
      i1 = 0;
      i2 = 0;
      i3 = 0;
    } else {
      if (2 > cD->size[0]) {
        emlrtDynamicBoundsCheckR2012b(2, 1, cD->size[0], &kb_emlrtBCI, sp);
      }

      i = 1;
      i1 = cD->size[0] - 1;
      if ((i1 < 1) || (i1 > cD->size[0])) {
        emlrtDynamicBoundsCheckR2012b(i1, 1, cD->size[0], &jb_emlrtBCI, sp);
      }

      if (2 > cD->size[0]) {
        emlrtDynamicBoundsCheckR2012b(2, 1, cD->size[0], &hb_emlrtBCI, sp);
      }

      i2 = 1;
      i3 = cD->size[0] - 1;
      if ((i3 < 1) || (i3 > cD->size[0])) {
        emlrtDynamicBoundsCheckR2012b(i3, 1, cD->size[0], &gb_emlrtBCI, sp);
      }
    }

    if (1 > cD->size[1]) {
      emlrtDynamicBoundsCheckR2012b(1, 1, cD->size[1], &fb_emlrtBCI, sp);
    }

    if (2 > cD->size[1]) {
      emlrtDynamicBoundsCheckR2012b(2, 1, cD->size[1], &ib_emlrtBCI, sp);
    }

    loop_ub = i1 - i;
    i1 = c_cD->size[0] * c_cD->size[1] * c_cD->size[2];
    c_cD->size[0] = loop_ub;
    c_cD->size[1] = 1;
    c_cD->size[2] = 2;
    emxEnsureCapacity_real_T(sp, c_cD, i1, &db_emlrtRTEI);
    for (i1 = 0; i1 < loop_ub; i1++) {
      c_cD->data[i1] = cD->data[(i + i1) + cD->size[0]];
    }

    for (i1 = 0; i1 < loop_ub; i1++) {
      c_cD->data[i1 + c_cD->size[0]] = cD->data[((i + i1) + cD->size[0]) +
        cD->size[0] * cD->size[1]];
    }

    iv1[0] = i3 - i2;
    iv1[1] = 1;
    iv1[2] = 2;
    emlrtSubAssignSizeCheckR2012b(&iv1[0], 3, &c_cD->size[0], 3, &j_emlrtECI, sp);
    i1 = c_cD->size[0] * c_cD->size[1] * c_cD->size[2];
    c_cD->size[0] = loop_ub;
    c_cD->size[1] = 1;
    c_cD->size[2] = 2;
    emxEnsureCapacity_real_T(sp, c_cD, i1, &db_emlrtRTEI);
    for (i1 = 0; i1 < loop_ub; i1++) {
      c_cD->data[i1] = cD->data[(i + i1) + cD->size[0]];
    }

    for (i1 = 0; i1 < loop_ub; i1++) {
      c_cD->data[i1 + c_cD->size[0]] = cD->data[((i + i1) + cD->size[0]) +
        cD->size[0] * cD->size[1]];
    }

    loop_ub = c_cD->size[0];
    for (i = 0; i < loop_ub; i++) {
      cD->data[i2 + i] = c_cD->data[i];
    }

    for (i = 0; i < loop_ub; i++) {
      cD->data[(i2 + i) + cD->size[0] * cD->size[1]] = c_cD->data[i + c_cD->
        size[0]];
    }

    if (2 > cD->size[0] - 1) {
      i = 0;
      i1 = 0;
      i2 = 0;
      i3 = 0;
    } else {
      if (2 > cD->size[0]) {
        emlrtDynamicBoundsCheckR2012b(2, 1, cD->size[0], &eb_emlrtBCI, sp);
      }

      i = 1;
      i1 = cD->size[0] - 1;
      if ((i1 < 1) || (i1 > cD->size[0])) {
        emlrtDynamicBoundsCheckR2012b(i1, 1, cD->size[0], &db_emlrtBCI, sp);
      }

      if (2 > cD->size[0]) {
        emlrtDynamicBoundsCheckR2012b(2, 1, cD->size[0], &bb_emlrtBCI, sp);
      }

      i2 = 1;
      i3 = cD->size[0] - 1;
      if ((i3 < 1) || (i3 > cD->size[0])) {
        emlrtDynamicBoundsCheckR2012b(i3, 1, cD->size[0], &ab_emlrtBCI, sp);
      }
    }

    if (cD->size[1] < 1) {
      emlrtDynamicBoundsCheckR2012b(cD->size[1], 1, cD->size[1], &y_emlrtBCI, sp);
    }

    b_loop_ub_tmp = cD->size[1] - 1;
    if ((b_loop_ub_tmp < 1) || (b_loop_ub_tmp > cD->size[1])) {
      emlrtDynamicBoundsCheckR2012b(b_loop_ub_tmp, 1, cD->size[1], &cb_emlrtBCI,
        sp);
    }

    loop_ub = i1 - i;
    i1 = c_cD->size[0] * c_cD->size[1] * c_cD->size[2];
    c_cD->size[0] = loop_ub;
    c_cD->size[1] = 1;
    c_cD->size[2] = 2;
    emxEnsureCapacity_real_T(sp, c_cD, i1, &eb_emlrtRTEI);
    for (i1 = 0; i1 < loop_ub; i1++) {
      c_cD->data[i1] = cD->data[(i + i1) + cD->size[0] * (cD->size[1] - 2)];
    }

    for (i1 = 0; i1 < loop_ub; i1++) {
      c_cD->data[i1 + c_cD->size[0]] = cD->data[((i + i1) + cD->size[0] *
        (cD->size[1] - 2)) + cD->size[0] * cD->size[1]];
    }

    iv1[0] = i3 - i2;
    iv1[1] = 1;
    iv1[2] = 2;
    emlrtSubAssignSizeCheckR2012b(&iv1[0], 3, &c_cD->size[0], 3, &i_emlrtECI, sp);
    i1 = cD->size[1];
    i3 = c_cD->size[0] * c_cD->size[1] * c_cD->size[2];
    c_cD->size[0] = loop_ub;
    c_cD->size[1] = 1;
    c_cD->size[2] = 2;
    emxEnsureCapacity_real_T(sp, c_cD, i3, &eb_emlrtRTEI);
    for (i3 = 0; i3 < loop_ub; i3++) {
      c_cD->data[i3] = cD->data[(i + i3) + cD->size[0] * (i1 - 2)];
    }

    for (i3 = 0; i3 < loop_ub; i3++) {
      c_cD->data[i3 + c_cD->size[0]] = cD->data[((i + i3) + cD->size[0] * (i1 -
        2)) + cD->size[0] * cD->size[1]];
    }

    loop_ub = c_cD->size[0];
    for (i = 0; i < loop_ub; i++) {
      cD->data[(i2 + i) + cD->size[0] * (i1 - 1)] = c_cD->data[i];
    }

    for (i = 0; i < loop_ub; i++) {
      cD->data[((i2 + i) + cD->size[0] * (i1 - 1)) + cD->size[0] * cD->size[1]] =
        c_cD->data[i + c_cD->size[0]];
    }

    if (2 > cE->size[1] - 1) {
      i = 0;
      i1 = 0;
      i2 = 0;
      i3 = 0;
    } else {
      if (2 > cE->size[1]) {
        emlrtDynamicBoundsCheckR2012b(2, 1, cE->size[1], &w_emlrtBCI, sp);
      }

      i = 1;
      i1 = cE->size[1] - 1;
      if ((i1 < 1) || (i1 > cE->size[1])) {
        emlrtDynamicBoundsCheckR2012b(i1, 1, cE->size[1], &v_emlrtBCI, sp);
      }

      if (2 > cE->size[1]) {
        emlrtDynamicBoundsCheckR2012b(2, 1, cE->size[1], &t_emlrtBCI, sp);
      }

      i2 = 1;
      i3 = cE->size[1] - 1;
      if ((i3 < 1) || (i3 > cE->size[1])) {
        emlrtDynamicBoundsCheckR2012b(i3, 1, cE->size[1], &s_emlrtBCI, sp);
      }
    }

    if (1 > cE->size[0]) {
      emlrtDynamicBoundsCheckR2012b(1, 1, cE->size[0], &u_emlrtBCI, sp);
    }

    if (2 > cE->size[0]) {
      emlrtDynamicBoundsCheckR2012b(2, 1, cE->size[0], &x_emlrtBCI, sp);
    }

    b_loop_ub_tmp = b_cD->size[0] * b_cD->size[1] * b_cD->size[2];
    b_cD->size[0] = 1;
    loop_ub = i1 - i;
    b_cD->size[1] = loop_ub;
    b_cD->size[2] = 2;
    emxEnsureCapacity_real_T(sp, b_cD, b_loop_ub_tmp, &fb_emlrtRTEI);
    for (i1 = 0; i1 < loop_ub; i1++) {
      b_cD->data[i1] = cE->data[cE->size[0] * (i + i1) + 1];
    }

    for (i1 = 0; i1 < loop_ub; i1++) {
      b_cD->data[i1 + b_cD->size[1]] = cE->data[(cE->size[0] * (i + i1) +
        cE->size[0] * cE->size[1]) + 1];
    }

    iv1[0] = 1;
    iv1[1] = i3 - i2;
    iv1[2] = 2;
    emlrtSubAssignSizeCheckR2012b(&iv1[0], 3, &b_cD->size[0], 3, &h_emlrtECI, sp);
    i1 = b_cD->size[0] * b_cD->size[1] * b_cD->size[2];
    b_cD->size[0] = 1;
    b_cD->size[1] = loop_ub;
    b_cD->size[2] = 2;
    emxEnsureCapacity_real_T(sp, b_cD, i1, &fb_emlrtRTEI);
    for (i1 = 0; i1 < loop_ub; i1++) {
      b_cD->data[i1] = cE->data[cE->size[0] * (i + i1) + 1];
    }

    for (i1 = 0; i1 < loop_ub; i1++) {
      b_cD->data[i1 + b_cD->size[1]] = cE->data[(cE->size[0] * (i + i1) +
        cE->size[0] * cE->size[1]) + 1];
    }

    loop_ub = b_cD->size[1];
    for (i = 0; i < loop_ub; i++) {
      cE->data[cE->size[0] * (i2 + i)] = b_cD->data[i];
    }

    for (i = 0; i < loop_ub; i++) {
      cE->data[cE->size[0] * (i2 + i) + cE->size[0] * cE->size[1]] = b_cD->
        data[i + b_cD->size[1]];
    }

    /*  Neumann No flux boundary condition */
    if (2 > cE->size[1] - 1) {
      i = 0;
      i1 = 0;
      i2 = 0;
      i3 = 0;
    } else {
      if (2 > cE->size[1]) {
        emlrtDynamicBoundsCheckR2012b(2, 1, cE->size[1], &q_emlrtBCI, sp);
      }

      i = 1;
      i1 = cE->size[1] - 1;
      if ((i1 < 1) || (i1 > cE->size[1])) {
        emlrtDynamicBoundsCheckR2012b(i1, 1, cE->size[1], &p_emlrtBCI, sp);
      }

      if (2 > cE->size[1]) {
        emlrtDynamicBoundsCheckR2012b(2, 1, cE->size[1], &n_emlrtBCI, sp);
      }

      i2 = 1;
      i3 = cE->size[1] - 1;
      if ((i3 < 1) || (i3 > cE->size[1])) {
        emlrtDynamicBoundsCheckR2012b(i3, 1, cE->size[1], &m_emlrtBCI, sp);
      }
    }

    if (cE->size[0] < 1) {
      emlrtDynamicBoundsCheckR2012b(cE->size[0], 1, cE->size[0], &o_emlrtBCI, sp);
    }

    b_loop_ub_tmp = cE->size[0] - 1;
    if ((b_loop_ub_tmp < 1) || (b_loop_ub_tmp > cE->size[0])) {
      emlrtDynamicBoundsCheckR2012b(b_loop_ub_tmp, 1, cE->size[0], &r_emlrtBCI,
        sp);
    }

    b_loop_ub_tmp = b_cD->size[0] * b_cD->size[1] * b_cD->size[2];
    b_cD->size[0] = 1;
    loop_ub = i1 - i;
    b_cD->size[1] = loop_ub;
    b_cD->size[2] = 2;
    emxEnsureCapacity_real_T(sp, b_cD, b_loop_ub_tmp, &gb_emlrtRTEI);
    for (i1 = 0; i1 < loop_ub; i1++) {
      b_cD->data[i1] = cE->data[(cE->size[0] + cE->size[0] * (i + i1)) - 2];
    }

    for (i1 = 0; i1 < loop_ub; i1++) {
      b_cD->data[i1 + b_cD->size[1]] = cE->data[((cE->size[0] + cE->size[0] * (i
        + i1)) + cE->size[0] * cE->size[1]) - 2];
    }

    iv1[0] = 1;
    iv1[1] = i3 - i2;
    iv1[2] = 2;
    emlrtSubAssignSizeCheckR2012b(&iv1[0], 3, &b_cD->size[0], 3, &g_emlrtECI, sp);
    i1 = cE->size[0];
    i3 = b_cD->size[0] * b_cD->size[1] * b_cD->size[2];
    b_cD->size[0] = 1;
    b_cD->size[1] = loop_ub;
    b_cD->size[2] = 2;
    emxEnsureCapacity_real_T(sp, b_cD, i3, &gb_emlrtRTEI);
    for (i3 = 0; i3 < loop_ub; i3++) {
      b_cD->data[i3] = cE->data[(i1 + cE->size[0] * (i + i3)) - 2];
    }

    for (i3 = 0; i3 < loop_ub; i3++) {
      b_cD->data[i3 + b_cD->size[1]] = cE->data[((i1 + cE->size[0] * (i + i3)) +
        cE->size[0] * cE->size[1]) - 2];
    }

    loop_ub = b_cD->size[1];
    for (i = 0; i < loop_ub; i++) {
      cE->data[(i1 + cE->size[0] * (i2 + i)) - 1] = b_cD->data[i];
    }

    for (i = 0; i < loop_ub; i++) {
      cE->data[((i1 + cE->size[0] * (i2 + i)) + cE->size[0] * cE->size[1]) - 1] =
        b_cD->data[i + b_cD->size[1]];
    }

    if (2 > cE->size[0] - 1) {
      i = 0;
      i1 = 0;
      i2 = 0;
      i3 = 0;
    } else {
      if (2 > cE->size[0]) {
        emlrtDynamicBoundsCheckR2012b(2, 1, cE->size[0], &l_emlrtBCI, sp);
      }

      i = 1;
      i1 = cE->size[0] - 1;
      if ((i1 < 1) || (i1 > cE->size[0])) {
        emlrtDynamicBoundsCheckR2012b(i1, 1, cE->size[0], &k_emlrtBCI, sp);
      }

      if (2 > cE->size[0]) {
        emlrtDynamicBoundsCheckR2012b(2, 1, cE->size[0], &i_emlrtBCI, sp);
      }

      i2 = 1;
      i3 = cE->size[0] - 1;
      if ((i3 < 1) || (i3 > cE->size[0])) {
        emlrtDynamicBoundsCheckR2012b(i3, 1, cE->size[0], &h_emlrtBCI, sp);
      }
    }

    if (1 > cE->size[1]) {
      emlrtDynamicBoundsCheckR2012b(1, 1, cE->size[1], &g_emlrtBCI, sp);
    }

    if (2 > cE->size[1]) {
      emlrtDynamicBoundsCheckR2012b(2, 1, cE->size[1], &j_emlrtBCI, sp);
    }

    loop_ub = i1 - i;
    i1 = c_cD->size[0] * c_cD->size[1] * c_cD->size[2];
    c_cD->size[0] = loop_ub;
    c_cD->size[1] = 1;
    c_cD->size[2] = 2;
    emxEnsureCapacity_real_T(sp, c_cD, i1, &hb_emlrtRTEI);
    for (i1 = 0; i1 < loop_ub; i1++) {
      c_cD->data[i1] = cE->data[(i + i1) + cE->size[0]];
    }

    for (i1 = 0; i1 < loop_ub; i1++) {
      c_cD->data[i1 + c_cD->size[0]] = cE->data[((i + i1) + cE->size[0]) +
        cE->size[0] * cE->size[1]];
    }

    iv1[0] = i3 - i2;
    iv1[1] = 1;
    iv1[2] = 2;
    emlrtSubAssignSizeCheckR2012b(&iv1[0], 3, &c_cD->size[0], 3, &f_emlrtECI, sp);
    i1 = c_cD->size[0] * c_cD->size[1] * c_cD->size[2];
    c_cD->size[0] = loop_ub;
    c_cD->size[1] = 1;
    c_cD->size[2] = 2;
    emxEnsureCapacity_real_T(sp, c_cD, i1, &hb_emlrtRTEI);
    for (i1 = 0; i1 < loop_ub; i1++) {
      c_cD->data[i1] = cE->data[(i + i1) + cE->size[0]];
    }

    for (i1 = 0; i1 < loop_ub; i1++) {
      c_cD->data[i1 + c_cD->size[0]] = cE->data[((i + i1) + cE->size[0]) +
        cE->size[0] * cE->size[1]];
    }

    loop_ub = c_cD->size[0];
    for (i = 0; i < loop_ub; i++) {
      cE->data[i2 + i] = c_cD->data[i];
    }

    for (i = 0; i < loop_ub; i++) {
      cE->data[(i2 + i) + cE->size[0] * cE->size[1]] = c_cD->data[i + c_cD->
        size[0]];
    }

    if (2 > cE->size[0] - 1) {
      i = 0;
      i1 = 0;
      i2 = 0;
      i3 = 0;
    } else {
      if (2 > cE->size[0]) {
        emlrtDynamicBoundsCheckR2012b(2, 1, cE->size[0], &f_emlrtBCI, sp);
      }

      i = 1;
      i1 = cE->size[0] - 1;
      if ((i1 < 1) || (i1 > cE->size[0])) {
        emlrtDynamicBoundsCheckR2012b(i1, 1, cE->size[0], &e_emlrtBCI, sp);
      }

      if (2 > cE->size[0]) {
        emlrtDynamicBoundsCheckR2012b(2, 1, cE->size[0], &c_emlrtBCI, sp);
      }

      i2 = 1;
      i3 = cE->size[0] - 1;
      if ((i3 < 1) || (i3 > cE->size[0])) {
        emlrtDynamicBoundsCheckR2012b(i3, 1, cE->size[0], &b_emlrtBCI, sp);
      }
    }

    if (cE->size[1] < 1) {
      emlrtDynamicBoundsCheckR2012b(cE->size[1], 1, cE->size[1], &emlrtBCI, sp);
    }

    b_loop_ub_tmp = cE->size[1] - 1;
    if ((b_loop_ub_tmp < 1) || (b_loop_ub_tmp > cE->size[1])) {
      emlrtDynamicBoundsCheckR2012b(b_loop_ub_tmp, 1, cE->size[1], &d_emlrtBCI,
        sp);
    }

    loop_ub = i1 - i;
    i1 = c_cD->size[0] * c_cD->size[1] * c_cD->size[2];
    c_cD->size[0] = loop_ub;
    c_cD->size[1] = 1;
    c_cD->size[2] = 2;
    emxEnsureCapacity_real_T(sp, c_cD, i1, &ib_emlrtRTEI);
    for (i1 = 0; i1 < loop_ub; i1++) {
      c_cD->data[i1] = cE->data[(i + i1) + cE->size[0] * (cE->size[1] - 2)];
    }

    for (i1 = 0; i1 < loop_ub; i1++) {
      c_cD->data[i1 + c_cD->size[0]] = cE->data[((i + i1) + cE->size[0] *
        (cE->size[1] - 2)) + cE->size[0] * cE->size[1]];
    }

    iv1[0] = i3 - i2;
    iv1[1] = 1;
    iv1[2] = 2;
    emlrtSubAssignSizeCheckR2012b(&iv1[0], 3, &c_cD->size[0], 3, &e_emlrtECI, sp);
    i1 = cE->size[1];
    i3 = c_cD->size[0] * c_cD->size[1] * c_cD->size[2];
    c_cD->size[0] = loop_ub;
    c_cD->size[1] = 1;
    c_cD->size[2] = 2;
    emxEnsureCapacity_real_T(sp, c_cD, i3, &ib_emlrtRTEI);
    for (i3 = 0; i3 < loop_ub; i3++) {
      c_cD->data[i3] = cE->data[(i + i3) + cE->size[0] * (i1 - 2)];
    }

    for (i3 = 0; i3 < loop_ub; i3++) {
      c_cD->data[i3 + c_cD->size[0]] = cE->data[((i + i3) + cE->size[0] * (i1 -
        2)) + cE->size[0] * cE->size[1]];
    }

    loop_ub = c_cD->size[0];
    for (i = 0; i < loop_ub; i++) {
      cE->data[(i2 + i) + cE->size[0] * (i1 - 1)] = c_cD->data[i];
    }

    for (i = 0; i < loop_ub; i++) {
      cE->data[((i2 + i) + cE->size[0] * (i1 - 1)) + cE->size[0] * cE->size[1]] =
        c_cD->data[i + c_cD->size[0]];
    }

    b_L[0] = cD->size[0];
    b_L[1] = cD->size[1];
    iv[0] = cD->size[0];
    iv[1] = cD->size[1];
    emlrtSubAssignSizeCheckR2012b(&b_L[0], 2, &iv[0], 2, &d_emlrtECI, sp);
    loop_ub = cD->size[0] - 1;
    b_loop_ub = cD->size[1] - 1;
    i = xms->size[0] * xms->size[1];
    xms->size[0] = cD->size[0];
    xms->size[1] = cD->size[1];
    emxEnsureCapacity_real_T(sp, xms, i, &jb_emlrtRTEI);
    for (i = 0; i <= b_loop_ub; i++) {
      for (i1 = 0; i1 <= loop_ub; i1++) {
        xms->data[i1 + xms->size[0] * i] = cD->data[(i1 + cD->size[0] * i) +
          cD->size[0] * cD->size[1]];
      }
    }

    loop_ub = xms->size[1];
    for (i = 0; i < loop_ub; i++) {
      b_loop_ub = xms->size[0];
      for (i1 = 0; i1 < b_loop_ub; i1++) {
        cD->data[i1 + cD->size[0] * i] = xms->data[i1 + xms->size[0] * i];
      }
    }

    b_L[0] = cE->size[0];
    b_L[1] = cE->size[1];
    iv[0] = cE->size[0];
    iv[1] = cE->size[1];
    emlrtSubAssignSizeCheckR2012b(&b_L[0], 2, &iv[0], 2, &c_emlrtECI, sp);
    loop_ub = cE->size[0] - 1;
    b_loop_ub = cE->size[1] - 1;
    i = xms->size[0] * xms->size[1];
    xms->size[0] = cE->size[0];
    xms->size[1] = cE->size[1];
    emxEnsureCapacity_real_T(sp, xms, i, &kb_emlrtRTEI);
    for (i = 0; i <= b_loop_ub; i++) {
      for (i1 = 0; i1 <= loop_ub; i1++) {
        xms->data[i1 + xms->size[0] * i] = cE->data[(i1 + cE->size[0] * i) +
          cE->size[0] * cE->size[1]];
      }
    }

    loop_ub = xms->size[1];
    for (i = 0; i < loop_ub; i++) {
      b_loop_ub = xms->size[0];
      for (i1 = 0; i1 < b_loop_ub; i1++) {
        cE->data[i1 + cE->size[0] * i] = xms->data[i1 + xms->size[0] * i];
      }
    }

    loop_ub = cD->size[0];
    b_loop_ub = cD->size[1];
    b_L[0] = cDt->size[0];
    b_L[1] = cDt->size[1];
    iv[0] = cD->size[0];
    iv[1] = cD->size[1];
    emlrtSubAssignSizeCheckR2012b(&b_L[0], 2, &iv[0], 2, &b_emlrtECI, sp);
    for (i = 0; i < b_loop_ub; i++) {
      for (i1 = 0; i1 < loop_ub; i1++) {
        cDt->data[(i1 + cDt->size[0] * i) + cDt->size[0] * cDt->size[1] * it] =
          cD->data[i1 + cD->size[0] * i];
      }
    }

    loop_ub = cE->size[0];
    b_loop_ub = cE->size[1];
    b_L[0] = cEt->size[0];
    b_L[1] = cEt->size[1];
    iv[0] = cE->size[0];
    iv[1] = cE->size[1];
    emlrtSubAssignSizeCheckR2012b(&b_L[0], 2, &iv[0], 2, &emlrtECI, sp);
    for (i = 0; i < b_loop_ub; i++) {
      for (i1 = 0; i1 < loop_ub; i1++) {
        cEt->data[(i1 + cEt->size[0] * i) + cEt->size[0] * cEt->size[1] * it] =
          cE->data[i1 + cE->size[0] * i];
      }
    }

    if (*emlrtBreakCheckR2012bFlagVar != 0) {
      emlrtBreakCheckR2012b(sp);
    }
  }

  emxFree_real_T(&c_cD);
  emxFree_real_T(&b_cD);
  emxFree_real_T(&r);
  emxFree_real_T(&yms);
  emxFree_real_T(&xms);
  emxFree_real_T(&cE);
  emxFree_real_T(&cD);
  emxFree_real_T(&lap);
  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
}

/* End of code generation (RD_Gray_Scott.c) */
