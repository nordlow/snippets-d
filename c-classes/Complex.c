#include "Complex.h"

static struct Complex new(double real, double imag) {
  return (struct Complex){.re=real, .im=imag};
}

const struct ComplexClass Complex = { .new=&new };
