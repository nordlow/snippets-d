static int m_x;

static assert(is(m_x == static)); // TODO: should work

@safe pure unittest {
    const int x;
    static assert(!is(x == static)); // TODO: should work
}
