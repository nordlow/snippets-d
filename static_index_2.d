template staticIndexOf(args...)
if (args.length >= 1)
{
    enum staticIndexOf =
    {
        static foreach (idx, arg; args[1 .. $])
            static if (__traits(isSame, args[0], arg))
                // `if (__ctfe)` is redundant here but avoids the "Unreachable code" warning.
                if (__ctfe) return idx;
        return -1;
    }();
}

enum isSame(alias a, alias b) = __traits(isSame, a, b);
static assert(__traits(isSame, 0, 0));
static assert(__traits(isSame, "a", "a"));
static assert(!__traits(isSame, 0, 0.0));
static assert(!isSame!(0, 0));
static assert(!isSame!("a", "a"));

static assert(staticIndexOf!( byte, byte, short, int, long) ==  0);
static assert(staticIndexOf!(short, byte, short, int, long) ==  1);
static assert(staticIndexOf!(  int, byte, short, int, long) ==  2);
static assert(staticIndexOf!( long, byte, short, int, long) ==  3);
static assert(staticIndexOf!( char, byte, short, int, long) == -1);
static assert(staticIndexOf!(   -1, byte, short, int, long) == -1);
static assert(staticIndexOf!(void) == -1);

static assert(staticIndexOf!("abc", "abc", "def", "ghi", "jkl") == -1);
static assert(staticIndexOf!("mno", "abc", "def", "ghi", "jkl") == -1);
static assert(staticIndexOf!( void, "abc", "def", "ghi", "jkl") == -1);
static assert(staticIndexOf!(42) == -1);

static assert(staticIndexOf!(void, 0, "void", void) == 2);
// static assert(staticIndexOf!("void", 0, void, "void") == 2);

private template isSamePhobos(alias a, alias b)
{
    static if (!is(typeof(&a && &b))
               && __traits(compiles, { enum isSamePhobos = a == b; }))
    {
        enum isSamePhobos = a == b;
    }
    else
    {
        enum isSamePhobos = __traits(isSamePhobos, a, b);
    }
}
static assert(isSamePhobos!(0, 0));
static assert(isSamePhobos!(0, 0.0));
