import std;

struct S
{
@safe pure nothrow @nogc:

    struct T
    {
        int _z;
    }

    this(float x, T t)
    {
        x = x;                  // warn
        t = t;                  // warn

        _x = _x;                // error
        this._x = _x;           // error
        _x = this._x;           // error

        _x = _y;

        _xp = _xp;              // error
        _xp = _yp;

        _t = _t;                // error
        _t._z = _t._z;          // error (transitive)
    }

    void foo()
    {
        _x = _x;                // error
        this._x = _x;           // error
        _x = this._x;           // error
    }

    this(this) { count += 1;}   // posblit

    int count;

    float _x;
    float _y;

    float* _xp;
    float* _yp;

    T _t;
}

pure nothrow @nogc void test1()
{
    S s;
    s = s;

    S t;
    s._x = s._x;                // warn
    s._x = t._x;

    int x;
    x = x;                      // warn

    int y;
    y = x;

    int* xp;
    xp = xp;                    // warn

    *xp = *xp;                  // warn

    (&*xp) = (&*xp);            // warn

    (*&x) = (*&x);              // warn

    (*&*&x) = (*&*&x);          // warn

    static assert(__traits(compiles, { int t; t = t; }));
}

int g_x;

alias g_y = g_x;

/**
 * See_Also: https://forum.dlang.org/post/cjccfvhbtbgnajplrvbd@forum.dlang.org
 */
@safe nothrow @nogc void test2()
{
    int x;
    x = g_x;          // x is in another scope so this doesn't cause shadowing
    g_x = g_x;        // warn
    g_y = g_y;        // warn
}

struct U
{
@safe pure nothrow @nogc:
    void opAssign(U) {}
}

@safe pure nothrow @nogc void test2()
{
    U u;
    u = u;
}

@system unittest
{
    import std.exception : assertThrown;
    import std.typecons : Nullable;
    Nullable!int a;
    assert(a.isNull);
    assertThrown!Throwable(a.get);
    a = 5;
    assert(!a.isNull);
    assert(a == 5);
    assert(a != 3);
    assert(a.get != 3);
    a.nullify();
    assert(a.isNull);
    a = 3;
    assert(a == 3);
    a *= 6;
    assert(a == 18);
    auto b = a;
    a = b;
    assert(a == 18);
    a.nullify();
    assertThrown!Throwable(a += 2);
}
/// Neither GCC 10` nor Clang 10 warn here.
void check_equal_lhs_and_rhs(int i)
{
    bool x, y;
    alias xa = x;

    enum { a = 0, b = 1 }
    enum { x1 = (0 | 1), x2 }

    if (a & a)
        i = 42;

    if (b & b)
        i = 42;

    if (a & b)
        i = 42;

    if (1 & 2)
        i = 42;

    if (false & false)
        i = 42;

    if (true & true)
        i = 42;

    if (x1 & x1)
        i = 42;

    if (x & x)                  // warn
        i = 42;

    i = x + x;
    i = x - x;
    i = x * x;

    if (x & xa)                 // warn
        i = 42;

    if (x & y)
        i = 42;

    if (x | x)                  // warn
        i = 42;

    if (x & x |                 // warn
        x & x)                  // warn
        i = 42;

    if (x && x)                 // warn
        i = 42;

    if (x || x)                 // warn
        i = 42;

    if ((x && x) ||             // warn
        (x && x))               // warn
        i = 42;

    const i1 = true ? 42 : 42;
    const i2 = true ? a : a;
    const i3 = true ? x : x;    // warn
    const i4 = true ? (x && x) : (x && x); // warn

    enum int ei2 = 2;
    enum int ei3 = 3;
    assert(ei2 & ei3);
    assert(ei2 && ei3);
}

/** Fuzzy logic State.
 */
struct Fuzzy
{
    @safe pure nothrow @nogc:

    enum defaultCode = 0;

    enum no       = make(defaultCode); // probability: 0
    enum yes      = make(1);    // probability: 1
    enum likely   = make(2);    // probability: > 1/2
    enum unlikely = make(3);    // probability: < 1/2
    enum unknown  = make(4);    // probability: any

    this(bool b)
    {
        _v = b ? yes._v : no._v;
    }

    void opAssign(bool b)
    {
        _v = b ? yes._v : no._v;
    }

    Fuzzy opUnary(string s)() if (s == "~")
    {
        final switch (_v)
        {
        case no._v: return yes;
        case yes._v: return no;
        case likely._v: return unlikely;
        case unlikely._v: return likely;
        }
    }

    Fuzzy opBinary(string s)(Fuzzy rhs) if (s == "|")
    {
        import std.algorithm.comparion : among;
        if (_v.among!(yes._v, no._v) && rhs._v.among!(yes._v, no._v))
        {
            return _v | rhs._v;
        }
        else if (_v == yes._v || rhs._v == yes._v)
        {
            return yes;
        }
        else if (_v == no._v)
        {
            return rhs._v;
        }
        else if (rhs._v == no._v)
        {
            return _v;
        }
        else if (_v == rhs._v) // both likely or unlikely or unknown
        {
            return _v;
        }
        else
        {
            return unknown;
        }
    }

    // Fuzzy opBinary(string s)(Fuzzy rhs) if (s == "&")
    // {
    //     return make(_v & rhs._v);
    // }

    // Fuzzy opBinary(string s)(Fuzzy rhs) if (s == "^")
    // {
    //     auto v = _v + rhs._v;
    //     return v >= 4 ? unknown : make(!!v);
    // }

private:
    ubyte _v = defaultCode;
    static Fuzzy make(ubyte b)
    {
        Fuzzy r = void;
        r._v = b;
        return r;
    }
}

@safe pure nothrow @nogc unittest
{
    alias T = Fuzzy;
    T a;
    assert(a == T.no);

    a = true;
    assert(a == T.yes);

    a = T.likely;
    assert(a == T.likely);

    a = T.unlikely;
    assert(a == T.unlikely);

    with (T)
    {
        assert(~no == yes);
        assert(no == ~yes);
        assert(~unlikely == likely);
        assert(unlikely == ~likely);
    }
}

/** State being either `yes`, `no` or `unknown`.
 */
struct Tristate
{
    @safe pure nothrow @nogc:

    enum defaultCode = 0;

    enum no      = make(defaultCode);
    enum yes     = make(2);
    enum unknown = make(6);

    this(bool b)
    {
        _v = b ? yes._v : no._v;
    }

    void opAssign(bool b)
    {
        _v = b ? yes._v : no._v;
    }

    Tristate opUnary(string s)() if (s == "~")
    {
        return make((193 >> _v & 3) << 1);
    }

    Tristate opBinary(string s)(Tristate rhs) if (s == "|")
    {
        return make((12756 >> (_v + rhs._v) & 3) << 1);
    }

    Tristate opBinary(string s)(Tristate rhs) if (s == "&")
    {
        return make((13072 >> (_v + rhs._v) & 3) << 1);
    }

    Tristate opBinary(string s)(Tristate rhs) if (s == "^")
    {
        return make((13252 >> (_v + rhs._v) & 3) << 1);
    }

private:
    ubyte _v = defaultCode;
    static Tristate make(ubyte b)
    {
        Tristate r = void;
        r._v = b;
        return r;
    }
}

@safe pure nothrow @nogc unittest
{
    alias T = Tristate;
    T a;
    assert(a == T.no);
    static assert(!is(typeof({ if (a) {} })));
    assert(!is(typeof({ auto b = T(3); })));

    a = true;
    assert(a == T.yes);

    a = false;
    assert(a == T.no);

    a = T.unknown;
    T b;

    b = a;
    assert(b == a);

    auto c = a | b;
    assert(c == T.unknown);
    assert((a & b) == T.unknown);

    a = true;
    assert(~a == T.no);

    a = true;
    b = false;
    assert((a ^ b) == T.yes);

    with (T)
    {
        // not
        assert(~no == yes);
        assert(~yes == no);
        assert(~unknown == unknown);

        // or
        assert((no | no) == no);
        assert((no | yes) == yes);
        assert((yes | no) == yes);
        assert((yes | yes) == yes);
        assert((no | unknown) == unknown);
        assert((yes | unknown) == yes);
        assert((unknown | no) == unknown);
        assert((unknown | yes) == yes);
        assert((unknown | unknown) == unknown);

        // and
        assert((no & no) == no);
        assert((no & yes) == no);
        assert((yes & no) == no);
        assert((yes & yes) == yes);
        assert((no & unknown) == no);
        assert((unknown & no) == no);
        assert((unknown & unknown) == unknown);
        assert((yes & unknown) == unknown);
        assert((unknown & yes) == unknown);

        // exclusive or
        assert((yes ^ yes) == no);
        assert((no ^ no) == no);
        assert((no ^ yes) == yes);
        assert((yes ^ no) == yes);
        assert((no ^ unknown) == unknown);
        assert((yes ^ unknown) == unknown);
        assert((unknown ^ no) == unknown);
        assert((unknown ^ yes) == unknown);
        assert((unknown ^ unknown) == unknown);
    }
}

/** Tristate: Three-state logic.
*/
struct TristateCond
{
    @safe pure nothrow @nogc:

    enum defaultCode = 0;

    enum no      = make(defaultCode);
    enum yes     = make(1);
    enum unknown = make(4);

    this(bool b)
    {
        _v = b ? yes._v : no._v;
    }

    void opAssign(bool b)
    {
        _v = b ? yes._v : no._v;
    }

    TristateCond opUnary(string s)() if (s == "~")
    {
        return this == unknown ? this : make(!_v);
    }

    TristateCond opBinary(string s)(TristateCond rhs) if (s == "|")
    {
        // | yields 0, 1, 4, 5
        auto v = _v | rhs._v;
        return v == 4 ? unknown : make(v & 1);
    }

    TristateCond opBinary(string s)(TristateCond rhs) if (s == "&")
    {
        // & yields 0, 1, 4
        return make(_v & rhs._v);
    }

    TristateCond opBinary(string s)(TristateCond rhs) if (s == "^")
    {
        // + yields 0, 1, 2, 4, 5, 8
        auto v = _v + rhs._v;
        return v >= 4 ? unknown : make(!!v);
    }

private:
    ubyte _v = defaultCode;
    static TristateCond make(ubyte b)
    {
        TristateCond r = void;
        r._v = b;
        return r;
    }
}

@safe pure nothrow @nogc unittest
{
    TristateCond a;
    assert(a == TristateCond.no);
    static assert(!is(typeof({ if (a) {} })));
    assert(!is(typeof({ auto b = TristateCond(3); })));
    a = true;
    assert(a == TristateCond.yes);
    a = false;
    assert(a == TristateCond.no);
    a = TristateCond.unknown;
    TristateCond b;
    b = a;
    assert(b == a);
    auto c = a | b;
    assert(c == TristateCond.unknown);
    assert((a & b) == TristateCond.unknown);
    a = true;
    assert(~a == TristateCond.no);
    a = true;
    b = false;
    assert((a ^ b) == TristateCond.yes);
}
