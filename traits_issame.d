static assert(__traits(isSame, "a", "a"));
static assert(!__traits(isSame, "a", "b"));
static assert(__traits(isSame, 0, 0));
static assert(!__traits(isSame, 0, 1));
