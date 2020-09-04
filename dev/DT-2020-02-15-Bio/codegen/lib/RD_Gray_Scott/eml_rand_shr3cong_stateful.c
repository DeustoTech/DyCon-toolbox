/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * eml_rand_shr3cong_stateful.c
 *
 * Code generation for function 'eml_rand_shr3cong_stateful'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "RD_Gray_Scott.h"
#include "eml_rand_shr3cong_stateful.h"
#include "RD_Gray_Scott_data.h"

/* Function Definitions */
void eml_rand_shr3cong_stateful_init(void)
{
  b_state[0] = 362436069U;
  b_state[1] = 521288629U;
}

/* End of code generation (eml_rand_shr3cong_stateful.c) */
