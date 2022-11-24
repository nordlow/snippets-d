import std.datetime;
import std.stdio;

@safe unittest
{
    auto st = Clock.currTime();
    writeln(st.year);
    writeln(cast(int)st.month);
    writeln(st.day);
}
