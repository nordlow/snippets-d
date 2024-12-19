@safe unittest {
	auto x = S(42);
	assert(_moveCounter == 0);
	const y = __rvalue(x);
	assert(_moveCounter == 1);
	assert(x.v == 42);
	assert(y.v == 42);
}

@safe struct S {
	this(int v) {
		this.v = v;
	}
	this(typeof(this) rhs) {
		this.v = rhs.v;
		_moveCounter += 1;
	}
	private int v;
}
static private size_t _moveCounter;
