@trusted pure unittest {
    size_t kc;                     // key copy count
    size_t vc;                     // value copy count

    @safe struct Key {
        this(ref return scope typeof(this) rhs) { kc++; }
        string _;
    }

    @safe struct Value {
        this(ref return scope typeof(this) rhs) { vc++; }
        string _;
    }

    alias AA = Value[Key];
    AA aa = [ Key("x") : Value("x") ];

    assert(kc == 0);
    const keys = aa.keys;
    assert(kc == 1);

    assert(vc == 0);
    const values = aa.values;
    assert(vc == 1);
}
