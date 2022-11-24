import std.range.primitives : isInputRange, ElementType;

/** Relaxed version of assocArray allowing R to be a type having members key and value
 *
 * TODO: Move to Phobos’s std.array
 */
auto assocArray(Range)(Range r) if (isInputRange!Range) {
	alias E = ElementType!Range;
	enum hasKeyValueE = (!is(typeof(E.key) == void) &&
						 !is(typeof(E.value) == void));
    static if (hasKeyValueE) {
		alias KeyType = typeof(E.key);
		alias ValueType = typeof(E.value);
	} else {
		import std.typecons : isTuple;
		static assert(
			isTuple!E,
			"assocArray: argument must be a range of tuples,"
			~ " but was a range of " ~ E.stringof
		);
		static assert(E.length == 2, "assocArray: tuple dimension must be 2");
		alias KeyType = E.Types[0];
		alias ValueType = E.Types[1];
	}

	ValueType[KeyType] aa;

	import std.traits : isMutable;
	static assert(isMutable!ValueType,
				  __FUNCTION__ ~ ": non-mutable value type `" ~ ValueType.stringof ~ "`");

	foreach (ref t; r)
	{
		static if (hasKeyValueE)
			aa[t.key] = t.value;
		else
			aa[t[0]] = t[1];
	}

	return aa;
}

int main(in string[] args) @safe pure {
	alias A = int[string];
	A x = ["0":0, "1":1];
	import std.algorithm.iteration : map;
	struct Pair(K, V) { K key; V value; }
	auto y = x.byKeyValue.map!((e) => Pair!(string, int)(e.key, -e.value)).assocArray;
	static assert(is(typeof(x) == typeof(y)));
	return 0;
}
