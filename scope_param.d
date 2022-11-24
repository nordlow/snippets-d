@safe struct S
{
    this(scope char[] s) {
        this.s = s;             // fails
    }
    this(scope immutable(char)[] t) {
        this.t = t;             // fails
    }
    this(immutable(char)[] t) {
        this.t = t;             // ok
    }
    char[] s;
    immutable(char)[] t;
}

@safe pure unittest
{
    S s;
}
