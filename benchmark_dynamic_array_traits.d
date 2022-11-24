/// Test as: /usr/bin/time -f %M dmd -i benchmark_dynamic_array_traits.d -o-
/// See_Also: https://github.com/dlang/dmd/pull/9014#issuecomment-674451700
/// See_Also: https://github.com/dlang/phobos/pull/7574

import benchmark_types;

// version = useBuiltin;           ///< Use new builtin trait __traits(isDynamicArray, ...)

static private template isDynamicArray(T)
{
    static if (is(T == U[], U))
        enum bool isDynamicArray = true;
    else static if (is(T U == enum))
        enum bool isDynamicArray = isDynamicArray!U;
    else
        enum bool isDynamicArray = false;
}

static foreach (T; SampleTypes)
{
    static foreach (U; SampleTypes)
    {
        static foreach (V; SampleTypes)
        {
            mixin("struct ",
                  T, "_" ,U, "_" ,V,
                  " {",
                  T, " t; ",
                  U, " u; ",
                  V, " v; ",
                  "}");
            static foreach (qualifier; qualifiers)
            {
                // mixin("enum ",
                //       T, "_", U, "_", V, // type
                //       " ",
                //       "e_", qualifier, "_", T, "_", U, "_", V, // name
                //       " = ",
                //       T, "_", U, "_", V, ".init",
                //       ";");
                version(useBuiltin)
                static assert(__traits(isDynamicArray, mixin(qualifier, "(", T, "_", U, "_", V, ")")[])); // min over 10 runs: 2.62s.
                else
                {
                    // static assert(is(mixin(qualifier, "(", T, "_", U, "_", V, ")")[] == X[], X)); // min over 10 runs: 2.75s
                    static assert(isDynamicArray!(mixin(qualifier, "(", T, "_", U, "_", V, ")")[])); // min over 10 runs: 3.19s
                }
            }
        }
    }
}
