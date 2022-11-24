@safe pure nothrow @nogc:

void f() {}
void g() { f(); }
void h() { g(); }

struct X {}
struct Y {}

int    identity(int x)    { return x; }
double identity(double x) { return x; }
string identity(string x) { return x; }
X identity(X x) { return x; }
Y identity(Y x) { return x; }

int main() {
	assert(identity(42) == 42.identity);	 // Works
	assert(identity(42.0) == 42.0.identity); // Wrongly picks int overload
	assert(identity("42") == "42".identity); // Wrongly picks int overload
	assert(identity(X()) == X().identity);	 // Wrongly picks int overload
	assert(identity(Y()) == Y().identity);	 // Wrongly picks int overload
	return 0;
}
