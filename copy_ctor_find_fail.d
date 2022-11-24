@safe struct Service {
    this(inout ref return scope typeof(this) rhs) inout {}
}

@safe struct Session {
    void openAndGetService(in string key) scope {
        import std.algorithm.searching : find;
        auto hit = _pairs.find!((scope const ref x) => x.key == key)();
    }
    private Pair[] _pairs;
    private struct Pair {
        string key;
        Service service;
    }
}
