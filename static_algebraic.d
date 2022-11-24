import std.variant : Algebraic;

///
@safe pure unittest
{
    alias A = Algebraic!(int,
                         const(long),
                         immutable(int*));
    A x;
}

/// assignment is unsafe and unpure
unittest
{
    alias A = Algebraic!(int, string);
    A x;
    x = 42;                     // NOTE fails for `Algebraic!(long, string)`
    x = x;                      // BAD unsafe unpure assignment
}

///
@safe pure unittest
{
    alias A = Algebraic!(int, string);
    static immutable A x;
    A y;
}
