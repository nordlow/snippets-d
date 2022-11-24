@safe struct S {
    this(int x) pure {
        _x = new int;
    }
    ~this() nothrow pure {
        _x = null;
    }
    void* _x;
    invariant { assert(_x !is null); }
}

@safe pure unittest
{
    auto s = S(32);
}
