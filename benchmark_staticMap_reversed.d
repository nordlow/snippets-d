import benchmark_types;

alias AliasSeq(T...) = T;

// version = __staticMap_reversed_simplest_and_fastest;
// version = __staticMap_reversed_simpler_but_slow;

template staticMap_reversed(alias fun, args...)
{
    version (__staticMap_reversed_simplest_and_fastest)
    {
        alias staticMap_reversed = AliasSeq!();
        static foreach (arg; args)
             staticMap_reversed = AliasSeq!(fun!arg, staticMap_reversed);
    }
    else version (__staticMap_reversed_simpler_but_slow)
    {
        alias staticMap_reversed = AliasSeq!();
        static foreach (i; 0 .. args.length)
            staticMap_reversed = AliasSeq!(fun!(args[i]), staticMap_reversed);
    }
    else
    {
        static if (args.length <= 8)
        {
            alias staticMap_reversed = AliasSeq!();
            static foreach (i; 0 .. args.length)
                staticMap_reversed = AliasSeq!(fun!(args[i]), staticMap_reversed);
        }
        else
        {
            alias staticMap_reversed = AliasSeq!(staticMap_reversed!(fun, args[$ / 2 .. $]),
										staticMap_reversed!(fun, args[0 .. $ / 2]));
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
				static assert(staticMap_reversed!(Unqual, mixin("AliasSeq!", "(",
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
