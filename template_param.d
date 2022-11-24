void f(T)(inout(T) x)
{
    pragma(msg, __FILE__, "(", __LINE__, ",1): Debug: f: ", T);
}

@safe pure unittest
{
    f(char.init);
    f(const(char).init);
    f(immutable(char).init);
    f(string.init);
    f(const(string).init);
    f(immutable(string).init);
}

void g(T)(auto ref inout(T) x)
{
    pragma(msg, __FILE__, "(", __LINE__, ",1): Debug: g: ", T);
}

@safe pure unittest
{
    g(char.init);
    g(const(char).init);
    g(immutable(char).init);
    g(string.init);
    g(const(string).init);
    g(immutable(string).init);
}

void f1(T)(auto ref inout(T) x)
{
    pragma(msg, __FILE__, "(", __LINE__, ",1): Debug: h: ", T);
}

void f2(T...)(auto ref inout(T) x)
{
    pragma(msg, __FILE__, "(", __LINE__, ",1): Debug: h: ", T);
}

// See_Also: https://discord.com/channels/242094594181955585/242122752436338688/888156510071455754
@safe pure unittest
{
    f1(const(string).init);
    f1(immutable(string).init);
    f2(const(string).init);
    f2(immutable(string).init);
}
