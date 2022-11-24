// Benchmark as: /usr/bin/time -f '%M kB' dmd -o- faster_CommonType.d

version = fast;

version(fast)
    template CommonType(T...)
    {
        static if (T.length == 0)
            alias CommonType = void;
        else
        {
            alias CommonType = T[0];
            static foreach (i; 1 .. T.length)
                static if (is(typeof(true ? CommonType.init : T[i].init) U))
                    CommonType = U;
                else
                    CommonType = void;
        }
    }
else
    template CommonType(T...)
    {
        static if (T.length == 1)
            alias CommonType = typeof(T[0].init);
        else static if (is(typeof(true ? T[0].init : T[1].init) U))
            alias CommonType = CommonType!(U, T[2 .. $]);
        else
            alias CommonType = void;
    }

int main(string[] args)
{
    alias X = CommonType!(int, long, short);
    static assert(is(X == long));
    alias Y = CommonType!(int, char[], short);
    static assert(is(Y == void));
	return 0;
}
