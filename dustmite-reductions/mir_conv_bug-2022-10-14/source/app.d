import std.stdio;
import mir.algebraic_alias.json;
import mir.algebraic;

void main() @safe pure
{
	Algebraic!(void, JsonAlgebraic) v;
	writeln(v.toString);
}
