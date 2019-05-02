#include "vpi_user.h"
#include <math.h>

int sine(char * user_data) {
  vpiHandle systfref, args_iter,argh;
  systfref = vpi_handle(vpiSysTfCall, 0);
  args_iter = vpi_iterate(vpiArgument, systfref);
  argh = vpi_scan(args_iter);
  struct t_vpi_value argval;
  argval.format = vpiRealVal;
  vpi_get_value(argh, &argval);
  argval.value.integer =  10 * sin(argval.value.real);
  argval.format = vpiIntVal;
  vpi_put_value(systfref, &argval, 0, vpiNoDelay);
  return 0;
}

int cosine(char * user_data) {
  vpiHandle systfref, args_iter,argh;
  systfref = vpi_handle(vpiSysTfCall, 0);
  args_iter = vpi_iterate(vpiArgument, systfref);
  argh = vpi_scan(args_iter);
  struct t_vpi_value argval;
  argval.format = vpiRealVal;
  vpi_get_value(argh, &argval);
  argval.value.integer =  10 * cos(argval.value.real);
  argval.format = vpiIntVal;
  vpi_put_value(systfref, &argval, 0, vpiNoDelay);
  return 0;
}

uint32_t sine_size(char * user_data) {
  return sizeof(int);
}

void registerSineFunc() {
  s_vpi_systf_data task_data_s;
  p_vpi_systf_data task_data_p = &task_data_s;
  task_data_p->type = vpiSysFunc;
  task_data_p->sysfunctype = vpiIntFunc;
  task_data_p->tfname = "$sine";
  task_data_p->calltf = sine;
  task_data_p->compiletf = 0;
  task_data_p->sizetf = sine_size;

  vpi_register_systf(task_data_p);
}

void registerCosineFunc() {
  s_vpi_systf_data task_data_s;
  p_vpi_systf_data task_data_p = &task_data_s;
  task_data_p->type = vpiSysFunc;
  task_data_p->sysfunctype = vpiIntFunc;
  task_data_p->tfname = "$cosine";
  task_data_p->calltf = cosine;
  task_data_p->compiletf = 0;
  task_data_p->sizetf = sine_size;

  vpi_register_systf(task_data_p);
}

#ifndef VCS_VPI

void (*vlog_startup_routines[ ]) () = {
  registerSineFunc,
  registerCosineFunc,
  0
};

#endif
