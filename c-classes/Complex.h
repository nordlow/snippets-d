#include <stdio.h>

struct Complex {
  double re, im;
};

extern const struct ComplexClass {
  struct Complex (*new)(double real, double imag);
} Complex;
