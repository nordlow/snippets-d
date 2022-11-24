import std.meta : allSatisfy;

enum isHashable(T) = __traits(compiles, () { T.init; } );

unittest
{
}

class C
{
    static if (allSatisfy!(isHashable, int, B)) {}
}

class A
{
    static if (isHashable!B) {}
}

class B
{
    static if (isHashable!C) {}
}
