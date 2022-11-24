import std.stdio;

// https://kaleidic.slack.com/archives/C9FJ6J5E3/p1633543168201000?thread_ts=1633513949.147400&cid=C9FJ6J5E3
int main(string[] args)
{
    {
        double[string] c;
        writeln(++c["a"]);      // pass
    }
    {
        double[string] c;
        writeln(c["a"]++);      // fails
    }
	return 0;
}
