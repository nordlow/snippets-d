/** Test how destruction of scoped classes is handled.
 *
 * See_Also:
 */
module scoped_class_dtor;

bool g_dtor_called = false;

class C
{
@safe nothrow @nogc:
    this(int x) { this.x = x; }
    ~this() nothrow { g_dtor_called = true; }
    int x;
    // class fields cannot be scope so this fails: `scope D d = new D(3);`
}

class D
{
@safe nothrow @nogc:
    this(float x) { this.x = x; }
    float x;
}

void scopedC() @safe nothrow
{
    scope x = new C(42);
}

unittest
{
    import core.memory : GC;
    GC.disable();
    scopedC();
    assert(g_dtor_called);
    GC.enable();
}
