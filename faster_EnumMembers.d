// Benchmark as: /usr/bin/time -f '%M kB' dmd -vtemplates -o- faster_EnumMembers.d
// See https://github.com/dlang/phobos/pull/8262#issuecomment-945579777

// version = useAllMembers;
// version = useStaticForeach;

alias AliasSeq(T...) = T;

alias SampleTypes = AliasSeq!(ubyte, ushort, uint, ulong,
                              byte, short, int, long,
                              float, double, real,
                              char, wchar, dchar);

enum qualifiers = AliasSeq!("", "const",  "immutable", "shared",  "const shared", "immutable shared");

E enumMemberAt(E)(uint i) if (is(E == enum)) {
	version(useAllMembers) {
		version(useStaticForeach) {
			static foreach (const j, memberString; __traits(allMembers, E))
				if (i == j)
					return __traits(getMember, E, memberString);
		} else {
			foreach (const j, memberString; __traits(allMembers, E))
				if (i == j)
					return __traits(getMember, E, memberString);
		}
		assert(0);
	}
	else {
		import std.traits : EnumMembers;
		return [EnumMembers!(E)][i];
	}
}

int main(string[] args) {
    static foreach (T; SampleTypes)
		static foreach (q; qualifiers)
		{{
				alias B = mixin(q, " ", T);
				enum U : B {
					_00 =  0, _01 =  1, _02 =  2, _03 =  3, _04 =  4, _05 =  5, _06 =  6, _07 =  7, _08 =  8, _09 =  9,
					_10 = 10, _11 = 11, _12 = 12, _13 = 13, _14 = 14, _15 = 15, _16 = 16, _17 = 17, _18 = 18, _19 = 19,
					_20 = 20, _21 = 21, _22 = 22, _23 = 23, _24 = 24, _25 = 25, _26 = 26, _27 = 27, _28 = 28, _29 = 29,
					_30 = 30, _31 = 31, _32 = 32, _33 = 33, _34 = 34, _35 = 35, _36 = 36, _37 = 37, _38 = 38, _39 = 39,
					_40 = 40, _41 = 41, _42 = 42, _43 = 43, _44 = 44, _45 = 45, _46 = 46, _47 = 47, _48 = 48, _49 = 49,
					_50 = 50, _51 = 51, _52 = 52, _53 = 53, _54 = 54, _55 = 55, _56 = 56, _57 = 57, _58 = 58, _59 = 59,
				}
				auto ms = enumMemberAt!(U)(0);
			}}
	return 0;
}
