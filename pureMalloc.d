auto makeBytes(size_t n) @safe pure nothrow @nogc {
	import core.memory : pureMalloc;
	return pureMalloc(n);
}

@safe pure nothrow @nogc unittest {
	auto mb = makeBytes(42);
	immutable ib = makeBytes(42); // compiler knows that return is unique
	static assert(is(typeof(mb) == void*));
	static assert(is(typeof(ib) == immutable(void*)));
}
