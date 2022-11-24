import mir.bignum.integer;

alias B2 = BigInt!2;
static assert(B2.sizeof == 24);

int main(string[] args) {
	B2 x, y;
	// auto z = x+y;
	return 0;
}
