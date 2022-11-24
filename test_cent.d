import std.stdio;

int main(string[] args) @safe {
	import core.int128;
	auto x = Cent(ulong.max);
	auto y = Cent(1);
	add(x, y).writeln();
	return 0;
}
