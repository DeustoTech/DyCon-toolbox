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
#include "rt_nonfinite.h"
#include "RD_Gray_Scott.h"
#include "RD_Gray_Scott_initialize.h"
#include "eml_rand_shr3cong_stateful.h"
#include "eml_rand_mcg16807_stateful.h"
#include "eml_rand.h"
#include "eml_rand_mt19937ar_stateful.h"

/* Function Definitions */
void RD_Gray_Scott_initialize(void)
{
  rt_InitInfAndNaN(8U);
  state_not_empty_init();
  eml_rand_init();
  eml_rand_mcg16807_stateful_init();
  eml_rand_shr3cong_stateful_init();
}

/* End of code generation (RD_Gray_Scott_initialize.c) */
