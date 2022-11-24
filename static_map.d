template staticMap(alias F, T...)
{
    alias A = AliasSeq!();
    static foreach (t; T)       // TODO: without static here
        A = AliasSeq!(A, F!t); // alias assignment here
    alias staticMap = A;
}

@safe pure unittest
{
    import std.meta : AliasSeq, ApplyLeft;
    import std.traits : Largest;

    alias Types = AliasSeq!(byte, short, int, long);

    // TODO: why doesn’t this work?
    static assert(is(staticMap!(ApplyLeft!(Largest, short), Types) ==
                     AliasSeq!(short, short, int, long)));
    static assert(is(staticMap!(ApplyLeft!(Largest, int), Types) ==
                     AliasSeq!(int, int, int, long)));
}
