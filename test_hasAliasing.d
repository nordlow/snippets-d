@safe pure nothrow @nogc:

import std.traits : hasAliasing;

private static void test1()
{
    static assert(hasAliasing!(void*));
    static assert(!hasAliasing!(void function()));

    class C { int a; }
    static assert(hasAliasing!(C));

    struct S1 { int a; Object b; }
    struct S2 { string a; }
    struct S3 { int a; immutable Object b; }
    struct S4 { float[3] vals; }
    struct S41 { int*[3] vals; }
    struct S42 { immutable(int)*[3] vals; }
    struct S5 { int[int] vals; } // not in std.traits
    struct S6 { const int[int] vals; } // not in std.traits
    struct S7 { immutable int[int] vals; } // not in std.traits

    static assert( hasAliasing!(S1));
    static assert(!hasAliasing!(S2));
    static assert(!hasAliasing!(S3));
    static assert(!hasAliasing!(S4));
    static assert( hasAliasing!(S41));
    static assert(!hasAliasing!(S42));
    static assert( hasAliasing!(S5));
    static assert( hasAliasing!(S6));
    static assert(!hasAliasing!(S7));

    static assert( hasAliasing!(S1, S41)); // multiple arguments, all have aliasing
    static assert( hasAliasing!(S1, S2)); // multiple arguments, some have aliasing
    static assert( hasAliasing!(S2, S1)); // multiple arguments, some have aliasing
    static assert(!hasAliasing!(S2, S4)); // multiple arguments, none have aliasing

    static assert( hasAliasing!(uint[uint]));
    static assert(!hasAliasing!(immutable(uint[uint])));
    static assert( hasAliasing!(void delegate()));
    static assert( hasAliasing!(void delegate() const));
    static assert(!hasAliasing!(void delegate() immutable));
    static assert( hasAliasing!(void delegate() shared));
    static assert( hasAliasing!(void delegate() shared const));
    static assert( hasAliasing!(const(void delegate())));
    static assert( hasAliasing!(const(void delegate() const)));
    static assert(!hasAliasing!(const(void delegate() immutable)));
    static assert( hasAliasing!(const(void delegate() shared)));
    static assert( hasAliasing!(const(void delegate() shared const)));
    static assert(!hasAliasing!(immutable(void delegate())));
    static assert(!hasAliasing!(immutable(void delegate() const)));
    static assert(!hasAliasing!(immutable(void delegate() immutable)));
    static assert(!hasAliasing!(immutable(void delegate() shared)));
    static assert(!hasAliasing!(immutable(void delegate() shared const)));
    static assert( hasAliasing!(shared(const(void delegate()))));
    static assert( hasAliasing!(shared(const(void delegate() const))));
    static assert(!hasAliasing!(shared(const(void delegate() immutable))));
    static assert( hasAliasing!(shared(const(void delegate() shared))));
    static assert( hasAliasing!(shared(const(void delegate() shared const))));
    static assert(!hasAliasing!(void function()));

    interface I;
    static assert( hasAliasing!(I));
    struct T1 { int a; I b; }
    struct T2 { int a; immutable I b; }

    static assert( hasAliasing!(T1));
    static assert(!hasAliasing!(T2));

    struct ST(T) { T a; }
    class CT(T) { T a; }
    static assert( hasAliasing!(ST!C));
    static assert( hasAliasing!(ST!I));
    static assert(!hasAliasing!(ST!int));
    static assert( hasAliasing!(CT!C));
    static assert( hasAliasing!(CT!I));
    static assert( hasAliasing!(CT!int));

    import std.typecons : Rebindable;
    static assert( hasAliasing!(Rebindable!(const Object)));
    static assert(!hasAliasing!(Rebindable!(immutable Object)));
    static assert( hasAliasing!(Rebindable!(shared Object)));
    static assert( hasAliasing!(Rebindable!Object));
}

private static test2()
{
    struct S5
    {
        void delegate() immutable b;
        shared(void delegate() immutable) f;
        immutable(void delegate() immutable) j;
        shared(const(void delegate() immutable)) n;
    }
    struct S6 { typeof(S5.tupleof) a; void delegate() p; }
    static assert(!hasAliasing!(S5));
    static assert( hasAliasing!(S6));

    struct S7 { void delegate() a; int b; Object c; }
    class S8 { int a; int b; }
    class S9 { typeof(S8.tupleof) a; }
    class S10 { typeof(S8.tupleof) a; int* b; }
    static assert( hasAliasing!(S7));
    static assert( hasAliasing!(S8));
    static assert( hasAliasing!(S9));
    static assert( hasAliasing!(S10));
    struct S11 {}
    class S12 {}
    interface S13 {}
    union S14 {}
    static assert(!hasAliasing!(S11));
    static assert( hasAliasing!(S12));
    static assert( hasAliasing!(S13));
    static assert(!hasAliasing!(S14));

    class S15 { S15[1] a; }
    static assert( hasAliasing!(S15));
    static assert(!hasAliasing!(immutable(S15)));
}

private static test3()
{
    enum Ei : string { a = "a", b = "b" }
    enum Ec : const(char)[] { a = "a", b = "b" }
    enum Em : char[] { a = null, b = null }

    static assert(!hasAliasing!(Ei));
    static assert( hasAliasing!(Ec));
    static assert( hasAliasing!(Em));
}
