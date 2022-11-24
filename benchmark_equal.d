int main()
{
    import std.meta : AliasSeq;
    foreach (T; AliasSeq!(char, wchar, dchar,
                          byte, ubyte,
                          short, ushort,
                          int, uint,
                          long, ulong,
                          float, double, real))
    {
        auto x = test(T[].init);
        auto y = test((const(T)[]).init);
        auto z = test((immutable(T)[]).init);
    }
    return 0;
}

bool test(T)(T[] a)
{
    import std.algorithm.comparison : equal;
    version (variadic)
        return equal(a, a, a, a, a, a, a);
    else
        return equal(a, a) && equal(a, a) && equal(a, a) && equal(a, a) && equal(a, a) && equal(a, a);
}
