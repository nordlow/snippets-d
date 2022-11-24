// https://forum.dlang.org/post/wxmbgqhaosmbxjdngbjg@forum.dlang.org

string __ARGUMENTS__(string fn = __FUNCTION__)()
{
    import std.traits : ParameterIdentifierTuple;
    import std.array : join;
    mixin("enum parameterNames = [ParameterIdentifierTuple!(" ~ fn ~ ")];");
    return "auto __arguments = [" ~ parameterNames.join(",") ~ "];";
}

void test(int x, int y)
{
    mixin(__ARGUMENTS__);

    auto c = __arguments[0];
    auto d = __arguments[1];

    import std.stdio;
    writefln("%d %d", c, d);
}

void main()
{
    test(1, 2);
}
