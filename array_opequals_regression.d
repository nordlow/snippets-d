@safe pure unittest
{
    class C
    {
        this(int x) { this.x = x; }
        int x;
        bool opEquals(scope const C rhs) const scope @safe pure nothrow @nogc
        {
            return x == rhs.x;
        }
    }
    const v0 = new C(42);
    const v1 = new C(43);
    assert([v0, v1] == [v0, v1]); // this fails when `unittest` is `pure`
    assert([v0, v1] != [v0, v1]); // this fails when unittest is pure
}
