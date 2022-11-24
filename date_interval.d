int main()
{
    import std.datetime.date : Date;
    import std.datetime.interval : Interval, everyDuration;
    import core.time : days;
    import std.stdio : writeln;

    const beg = Date(2000, 1, 1);
    const end = Date(2000, 1, 2);

    auto func = everyDuration!Date(1.days);

    writeln("interval:", beg, " => ", end);

    writeln("fwdRange");
    foreach (const date; Interval!Date(beg, end + 1.days).fwdRange(func)) {
        writeln("date:", date);
    }

    writeln("bwdRange");
    foreach (const date; Interval!Date(beg, end + 1.days).bwdRange(func)) {
        writeln("date:", date);
    }

    return 0;
}
