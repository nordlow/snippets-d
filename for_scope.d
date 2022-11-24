// https://issues.dlang.org/show_bug.cgi?id=22227
@safe pure unittest
{
    for (scope i = 0; i < 1; ++i) {}
}
