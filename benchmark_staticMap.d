import benchmark_types;

alias AliasSeq(T...) = T;

// version = __staticMap_simplest_and_fastest;
// version = __staticMap_simplest_but_slow;

template staticMap(alias fun, args...)
{
    version (__staticMap_simplest_and_fastest)
    {
        alias staticMap = AliasSeq!();
        static foreach (arg; args)
             staticMap = AliasSeq!(staticMap, fun!arg);
    }
    else version (__staticMap_simpler_but_slow)
    {
        alias staticMap = AliasSeq!();
        static foreach (i; 0 .. args.length)
            staticMap = AliasSeq!(staticMap, fun!(args[i]));
    }
    else
    {
        static if (args.length <= 8)
        {
            alias staticMap = AliasSeq!();
            static foreach (i; 0 .. args.length)
                staticMap = AliasSeq!(staticMap, fun!(args[i]));
        }
        else
        {
            alias staticMap = AliasSeq!(staticMap!(fun, args[0 .. $ / 2]),
										staticMap!(fun, args[$ / 2 .. $]));
        }
    }
}

@safe unittest
{
    import std.traits : Unqual;
	static foreach (T; SampleTypes)
	{
		static foreach (U; SampleTypes)
		{
			static foreach (q; qualifiers)
			{
				static assert(staticMap!(Unqual, mixin("AliasSeq!", "(",
													   q," ",T, ",",
													   q," ",U, ",",
													   q," ",T, ",",
													   q," ",U, ",",
													   q," ",T, ",",
													   q," ",U, ",",
													   q," ",T, ",",
													   q," ",U, ",",
													   q," ",T, ",",
													   q," ",U, ",",
													   q," ",T, ",",
													   q," ",U, ",",
													   ")")).length != 0);
			}
		}
	}
}
