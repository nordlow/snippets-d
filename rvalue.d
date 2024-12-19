struct S {
	@disable this(this);
	int v;
}

pure @safe unittest {
	auto x = S(42);
	const y = __rvalue(x);
	assert(x.v == 42);
	assert(y.v == 42);
}
