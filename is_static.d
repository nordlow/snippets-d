@safe pure unittest {
    const int x;
    static assert(!is(x == const));
    static assert(!is(x == static)); // TODO: should work
}
