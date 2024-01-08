import std.stdio;

class C {
	int[] x = [1, 2, 3];
}

void main() {
	auto c = new immutable C;
	writeln(c.x);
	new C().x[0] = 2;
	writeln(c.x);
}
