import std.datetime.date : Date;

@safe:

Date yesterdayish() {
    import std.datetime.systime : Clock;
    import core.time : hours;
    return cast(typeof(return))(Clock.currTime() - 25.hours);
}

int main(string[] args)
{
    import std.stdio : writeln;
    writeln(yesterdayish());
	return 0;
}
