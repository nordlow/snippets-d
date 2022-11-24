module benchmark_types.d;

alias AliasSeq(T...) = T;

alias SampleTypes = AliasSeq!(ubyte, ushort, uint, ulong,
                              byte, short, int, long,
                              float, double, real,
                              char, wchar, dchar);

enum qualifiers = AliasSeq!("", "const",  "immutable", "shared",  "const shared", "immutable shared");
