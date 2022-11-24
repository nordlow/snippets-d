template isA(T) { pragma(msg, "isA!" ~ T.stringof); enum isA = false; }
template isB(T) { pragma(msg, "isB!" ~ T.stringof); enum isB = false; }

enum N = 24;

enum isX(T) = !isA!T && T.sizeof <= N;
enum isY(T) = T.sizeof <= N && !isB!T;

struct S { ubyte[N + 1] _; }

int main(string[] args) {
	static assert(!isX!S);
	static assert(!isY!S);
	return 0;
}
