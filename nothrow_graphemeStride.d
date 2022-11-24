import std;

@safe pure nothrow unittest {
	import std.uni : graphemeStride;
	debug writeln(graphemeStride("  ", 1));
	string city = "A\u030Arhus";
	size_t first = graphemeStride(city, 0);
	assert(first == 3); //\u030A has 2 UTF-8 code units
	debug writeln(city[0 .. first]); // "A\u030A"
	debug writeln(city[first .. $]); // "rhus"
}
