/** Test multiple overloads of toString()
 */
module nxt.to_string;

class Long
{
@safe:

    void toString(Sink)(ref scope Sink sink) const
    {
        import std.conv : to;
        sink(_data.to!(string));
    }

    pure nothrow:

    this(long data) @nogc
    {
        _data = data;
    }

    @property override string toString() @safe pure const
    {
        import std.conv : to;
        return _data.to!(typeof(return));
    }

    private long _data;
}

@safe pure nothrow unittest
{
    scope i = new Long(42);
    assert(i.toString == `42`); // picks non-delegate version
}

@safe unittest
{
    import std.array : Appender;
    Appender!(int[]) app;
    scope i = new Long(42);
    i.toString(&(app.put!(const(char)[])));
    assert(app.data == `42`);
}
