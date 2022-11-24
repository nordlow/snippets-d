alias AliasSeq(T...) = T;

// See https://github.com/dlang/dmd/pull/14332
template Count(size_t n)
{
    alias Count = AliasSeq!();
    static foreach (i; 0 .. n)
        Count = AliasSeq!(Count, i);
}
alias c = Count!10000;
static assert(c.length == 10000);
static assert(c[0..5]   == AliasSeq!(0,1,2,3,4));
static assert(c[$-5..$] == AliasSeq!(9995,9996,9997,9998,9999));
