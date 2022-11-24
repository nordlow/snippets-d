// compile with -preview=dip1000

@safe struct CustomPtr {
	int* ptr;
	@safe ref int opUnary(string op)() return scope if (op == "*") {
		return *ptr;
	}
}

@safe ref int useGC() {
	return *CustomPtr(new int(5)); // ok
}

@safe ref int useStack() {
	int a;
	return *CustomPtr(&a);		// fail
}

@safe ref int useNulledStackCopy() {
	int a;
	auto x = CustomPtr(&a);
	auto y = x;
	y = y.init;
	return *y;					// shouldn’t fail
}
