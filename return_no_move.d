struct S { @disable this(this); }

S f(S s) @safe pure nothrow @nogc
{
	return s;					// should move here
}
