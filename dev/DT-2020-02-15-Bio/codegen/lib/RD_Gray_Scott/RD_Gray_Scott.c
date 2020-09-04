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
#include <math.h>
#include <string.h>
#include "rt_nonfinite.h"
#include "RD_Gray_Scott.h"
#include "rand.h"
#include "power.h"
#include "sqrt.h"
#include "atan2.h"
#include "meshgrid.h"

/* Function Definitions */
void RD_Gray_Scott(double cDt[100000000], double cEt[100000000])
{
  int i0;
  double dv0[100];
  double dv1[100];
  static double xms[10000];
  static double yms[10000];
  double d0;
  static double lap[10000];
  static double cD[20000];
  static double cE[20000];
  static double y[10000];
  double dv2[10000];
  double x_tmp[10000];
  int k;
  int i1;
  int it;
  int i2;
  double d1;

  /* 0.4 0.5 0.3 7.5 */
  /* L=80; */
  for (i0 = 0; i0 < 100; i0++) {
    d0 = -198.0 + 4.0 * (double)i0;
    dv0[i0] = d0;
    dv1[i0] = d0;
  }

  meshgrid(dv0, dv1, xms, yms);

  /* parameters */
  /* *(1/7.5^2); */
  /* *(1/7.5^2); */
  memset(&lap[0], 0, 10000U * sizeof(double));
  memset(&cD[0], 0, 20000U * sizeof(double));
  memset(&cE[0], 0, 20000U * sizeof(double));

  /* cD(:,:,1) = 0.1*rand(L,L) + ones(L,L); */
  /* cE(60:65 ,60:65,1) = 1; */
  /* cE(:,:,1) = cE(:,:,1) + 0.01*rand(L,L); */
  b_atan2(yms, xms, y);
  power(xms, dv2);
  power(yms, x_tmp);
  for (k = 0; k < 10000; k++) {
    y[k] = sin(6.0 * y[k]);
    dv2[k] += x_tmp[k];
  }

  b_sqrt(dv2);
  power(dv2, x_tmp);
  for (k = 0; k < 10000; k++) {
    xms[k] = exp(-x_tmp[k] / 100.0);
  }

  power(y, dv2);
  for (i0 = 0; i0 < 100; i0++) {
    for (i1 = 0; i1 < 100; i1++) {
      k = i1 + 100 * i0;
      cE[k] = dv2[k] * xms[k];
      cD[k] = 1.0 + 0.0001 * x_tmp[k];
    }
  }

  /*  */
  for (it = 0; it < 10000; it++) {
    for (i0 = 0; i0 < 98; i0++) {
      for (i1 = 0; i1 < 98; i1++) {
        k = i1 + 100 * (1 + i0);
        i2 = k + 1;
        d0 = 2.0 * cD[i2];
        lap[i2] = 0.0625 * ((cD[k] - d0) + cD[k + 2]) + 0.0625 * ((cD[(i1 + 100 *
          i0) + 1] - d0) + cD[(i1 + 100 * (2 + i0)) + 1]);
      }
    }

    for (i0 = 0; i0 < 100; i0++) {
      lap[100 * i0] = 0.0;
    }

    memset(&lap[0], 0, 100U * sizeof(double));
    for (i0 = 0; i0 < 100; i0++) {
      lap[99 + 100 * i0] = 0.0;
    }

    memset(&lap[9900], 0, 100U * sizeof(double));
    power(*(double (*)[10000])&cE[0], xms);
    b_rand(x_tmp);
    for (i0 = 0; i0 < 100; i0++) {
      for (i1 = 0; i1 < 100; i1++) {
        k = i1 + 100 * i0;
        cD[10000 + k] = (0.25 * ((0.018 * (1.0 - cD[k]) - cD[k] * xms[k]) +
          lap[k]) + cD[k]) + 0.001 * x_tmp[k];
      }
    }

    for (i0 = 0; i0 < 98; i0++) {
      for (i1 = 0; i1 < 98; i1++) {
        k = i1 + 100 * (1 + i0);
        i2 = k + 1;
        d0 = 2.0 * cE[i2];
        lap[i2] = 0.0625 * ((cE[k] - d0) + cE[k + 2]) + 0.0625 * ((cE[(i1 + 100 *
          i0) + 1] - d0) + cE[(i1 + 100 * (2 + i0)) + 1]);
      }
    }

    for (i0 = 0; i0 < 100; i0++) {
      lap[100 * i0] = 0.0;
    }

    memset(&lap[0], 0, 100U * sizeof(double));
    for (i0 = 0; i0 < 100; i0++) {
      lap[99 + 100 * i0] = 0.0;
    }

    memset(&lap[9900], 0, 100U * sizeof(double));
    for (i0 = 0; i0 < 100; i0++) {
      for (i1 = 0; i1 < 100; i1++) {
        k = i1 + 100 * i0;
        cE[10000 + k] = 0.25 * ((cD[k] * xms[k] - 0.059 * cE[k]) + 0.05 * lap[k])
          + cE[k];
      }
    }

    for (i0 = 0; i0 < 2; i0++) {
      for (i1 = 0; i1 < 98; i1++) {
        k = 100 * (1 + i1) + 10000 * i0;
        cD[k] = cD[1 + k];
      }
    }

    /*  Neumann No flux boundary condition */
    for (i0 = 0; i0 < 2; i0++) {
      for (i1 = 0; i1 < 98; i1++) {
        k = 100 * (1 + i1) + 10000 * i0;
        cD[99 + k] = cD[98 + k];
        k = i1 + 10000 * i0;
        cD[k + 1] = cD[k + 101];
      }
    }

    for (i0 = 0; i0 < 2; i0++) {
      for (i1 = 0; i1 < 98; i1++) {
        k = i1 + 10000 * i0;
        cD[k + 9901] = cD[k + 9801];
        k = 100 * (1 + i1) + 10000 * i0;
        cE[k] = cE[1 + k];
      }
    }

    /*  Neumann No flux boundary condition */
    for (i0 = 0; i0 < 2; i0++) {
      for (i1 = 0; i1 < 98; i1++) {
        k = 100 * (1 + i1) + 10000 * i0;
        cE[99 + k] = cE[98 + k];
        k = i1 + 10000 * i0;
        cE[k + 1] = cE[k + 101];
      }
    }

    for (i0 = 0; i0 < 2; i0++) {
      for (i1 = 0; i1 < 98; i1++) {
        k = i1 + 10000 * i0;
        cE[k + 9901] = cE[k + 9801];
      }
    }

    for (i0 = 0; i0 < 100; i0++) {
      for (i1 = 0; i1 < 100; i1++) {
        k = i1 + 100 * i0;
        i2 = 10000 + k;
        d0 = cD[i2];
        cD[k] = cD[i2];
        d1 = cE[i2];
        cE[k] = cE[i2];
        k += 10000 * it;
        cDt[k] = d0;
        cEt[k] = d1;
      }
    }
  }
}

/* End of code generation (RD_Gray_Scott.c) */
