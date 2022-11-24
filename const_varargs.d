// See_Also: https://github.com/dlang/phobos/pull/8251#issuecomment-926696257

class C {}
struct S0 { const(C) c; }
struct S1 { C c; }
struct S2 { int* c; }
struct S3 { const(int)* c; }
struct S4 { const int* c; }

@safe pure unittest { S1 x; S1 y = x; }
@safe pure unittest { S1 x; const(S1) y = x; }
@safe pure unittest { const(S0) x; S0 y = x; }

enum isAssignableFromConst(T) = __traits(compiles, { const(T) x; T y = x; } );

version (unittest)
{
    static assert( isAssignableFromConst!(int));
    static assert(!isAssignableFromConst!(S1));
    static assert( isAssignableFromConst!(S0));
    static assert(!isAssignableFromConst!(S2));
    static assert( isAssignableFromConst!(S3));
    static assert( isAssignableFromConst!(S4));
}

void f(T)(const(T) t)
{
    pragma(msg, __FILE__, "(", __LINE__, ",1): Debug: ", typeof(t), " ", typeof(t.c));
}
/// ditto
void f(T)(T t)
{
    pragma(msg, __FILE__, "(", __LINE__, ",1): Debug: ", typeof(t), " ", typeof(t.c));
}

void test()
{
    { S0 m; f(m); }
    { const S0 m; f(m); }
    { S1 m; f(m); }
    // { const S1 c; f(c); }
}

