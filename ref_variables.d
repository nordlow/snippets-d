@safe pure unittest {
	int x = 42;
	ref y = x;
	y += 1;
	assert(x == 43);
}
