#!/usr/bin/env dub
/+ dub.json:
 {
 "name": "testgsl",
 "dependencies": {"gsl": "~>0.1.8"}
 }
 +/

/* Run as: dub run --single testgsl.d --compiler=dmd --build=release-nobounds
 */

import std.stdio : writeln;
import std.math : exp, sqrt, PI;
import std.datetime.stopwatch;

import gsl.monte;
import gsl.rng;

struct my_f_params { double a; double b; double c; }

/** Normal distribution with mean `params[0]` and variance `params[1]`.
 *
 * See_Also: https://en.wikipedia.org/wiki/Normal_distribution
 */
extern(C) double normalDistribution1D(const scope double* x,
                                      size_t dim,
                                      const scope void* params) @trusted pure nothrow @nogc
{
    const typed_params = cast(double*)params;
    assert(dim == 1);
    return exp(-((x[0] - typed_params[0])^^2)/(2*typed_params[1])) / sqrt(2 * PI * typed_params[1]);
}

/** Normal distribution with mean 0 and variance 1.
 *
 * See_Also: https://en.wikipedia.org/wiki/Normal_distribution
 */
extern(C) double normalDistribution1D_1_1(const scope double* x,
                                          size_t dim,
                                          const scope void* params) @trusted pure nothrow @nogc
{
    assert(dim == 1);
    return exp(-(x[0]^^2)/(2)) / sqrt(2 * PI);
}

extern(C) double my_f(const scope double* x,
                      size_t dim,
                      const scope void* params) @trusted pure nothrow @nogc
{
    const typed_params = cast(my_f_params*)params;
    assert(dim == 2);
    return (typed_params.a * x[0] * x[0] +
            typed_params.b * x[0] * x[1] +
            typed_params.c * x[1] * x[1]);
}

double eval(scope gsl_monte_function* fn,
            const scope double[] x) @trusted
{
    return (*(fn.f))(cast(double*)x, fn.dim, fn.params);
}

/// Integration result and absolute error.
struct IntegrationResult
{
    double value;
    double absoluteError;
}

gsl_rng* rng;                   // thread-local rng

shared static this()
{
    gsl_rng_env_setup();
}

static this()
{
    const gsl_rng_type* T = gsl_rng_default;
    rng = gsl_rng_alloc(T);
}

static ~this()
{
    gsl_rng_free(rng);
}

/** High-level wrapper of `gsl_monte_plain_integrate`.
 *
 */
IntegrationResult montePlainIntegrate(const scope ref gsl_monte_function fn,
                                      const scope double[] lowerLimit, // lower limit of hypercubic region
                                      const scope double[] upperLimit, // upper limit of hypercubic region
                                      const size_t calls = 500_000) @trusted
{
    assert(fn.dim == lowerLimit.length);
    assert(lowerLimit.length == upperLimit.length);
    foreach (const i; 0 .. fn.dim)
    {
        assert(lowerLimit[i] < upperLimit[i]);
    }

    gsl_monte_plain_state* state = gsl_monte_plain_alloc(fn.dim);
    typeof(return) ir;

    const int i = gsl_monte_plain_integrate(cast(gsl_monte_function*)&fn,
                                            lowerLimit.ptr,
                                            upperLimit.ptr,
                                            fn.dim,
                                            calls,
                                            rng,
                                            state,
                                            &ir.value,
                                            &ir.absoluteError);

    gsl_monte_plain_free(state);

    return ir;
}

/** High-level wrapper of `gsl_monte_miser_integrate`.
 *
 */
IntegrationResult monteMISERIntegrate(const scope ref gsl_monte_function fn,
                                      const scope double[] lowerLimit, // lower limit of hypercubic region
                                      const scope double[] upperLimit, // upper limit of hypercubic region
                                      const size_t calls) @trusted
{
    assert(fn.dim == lowerLimit.length);
    assert(lowerLimit.length == upperLimit.length);
    foreach (const i; 0 .. fn.dim)
    {
        assert(lowerLimit[i] < upperLimit[i]);
    }

    gsl_monte_miser_state* state = gsl_monte_miser_alloc(fn.dim);
    typeof(return) ir;

    const int i = gsl_monte_miser_integrate(cast(gsl_monte_function*)&fn,
                                            lowerLimit.ptr,
                                            upperLimit.ptr,
                                            fn.dim,
                                            calls,
                                            rng,
                                            state,
                                            &ir.value,
                                            &ir.absoluteError);

    gsl_monte_miser_free(state);

    return ir;
}

/** High-level wrapper of `gsl_monte_vegas_integrate`.
 *
 */
version(none)                   // TODO: add wrappers missing in gsl bindings
IntegrationResult monteVEGASIntegrate(const scope ref gsl_monte_function fn,
                                      const scope double[] lowerLimit, // lower limit of hypercubic region
                                      const scope double[] upperLimit, // upper limit of hypercubic region
                                      const size_t calls) @trusted
{
    assert(fn.dim == lowerLimit.length);
    assert(lowerLimit.length == upperLimit.length);
    foreach (const i; 0 .. fn.dim)
    {
        assert(lowerLimit[i] < upperLimit[i]);
    }

    gsl_monte_vegas_state* state = gsl_monte_vegas_alloc(fn.dim);
    typeof(return) ir;

    const int i = gsl_monte_vegas_integrate(cast(gsl_monte_function*)&fn,
                                            lowerLimit.ptr,
                                            upperLimit.ptr,
                                            fn.dim,
                                            calls,
                                            rng,
                                            state,
                                            &ir.value,
                                            &ir.absoluteError);

    gsl_monte_vegas_free(state);

    return ir;
}

void test_1D()
{
    enum dim = 1;
    gsl_monte_function fn;
    my_f_params params = { 0.0, 1.0 };

    fn.f = &normalDistribution1D;
    fn.dim = dim;
    fn.params = &params;

    auto sw = StopWatch(AutoStart.yes);

    const size_t calls = 4_000;

    const double[dim] lowerLimit = [-100];
    const double[dim] upperLimit = [+100];

    // plain
    {
        sw.reset();
        const ir = montePlainIntegrate(fn, lowerLimit[], upperLimit, 16*calls);
        sw.stop();
        writeln("Plain: ", ir, " took ", sw.peek);
    }

    // MISER
    {
        sw.reset();
        const ir = monteMISERIntegrate(fn, lowerLimit[], upperLimit, calls);
        sw.stop();
        writeln("MISER: ", ir, " took ", sw.peek);
    }
}

void test_2D()
{
    enum dim = 2;
    gsl_monte_function fn;
    my_f_params params = { 3.0, 2.0, 1.0 };

    fn.f = &my_f;
    fn.dim = dim;
    fn.params = &params;

    const double[dim] x = [2, 2];
    assert(eval(&fn, x) == 24);

    auto sw = StopWatch(AutoStart.yes);

    const size_t calls = 4_000;

    const double[dim] lowerLimit = [0.0, 0.0];
    const double[dim] upperLimit = [1.0, 1.0];

    // plain
    {
        sw.reset();
        const ir = montePlainIntegrate(fn, lowerLimit[], upperLimit, 16*calls);
        sw.stop();
        writeln("Plain: ", ir, " took ", sw.peek);
    }

    // MISER
    {
        sw.reset();
        const ir = monteMISERIntegrate(fn, lowerLimit[], upperLimit, calls);
        sw.stop();
        writeln("MISER: ", ir, " took ", sw.peek);
    }

    // VEGAS
    version(none)               // TODO: activate
    {
        sw.reset();
        const ir = monteVEGASIntegrate(fn, lowerLimit[], upperLimit, calls);
        sw.stop();
        writeln("VEGAS: ", ir, " took ", sw.peek);
    }
}

void main()
{
    test_1D();
    test_2D();
}
