import std.range.primitives : isInputRange;
import std.traits : isSomeString, isPointer;

private enum isMutatingFormattingAggregate(T, Char) =
    ((is(T == struct) || is(T == class) || is(T == interface))
     && (isInputRange!T ||
         (hasToString!(T, Char) &&
          !is(typeof(const(T).init.toString) : const(char)[])))); // non-mutating toString

unittest
{
    struct S { string toString() const { return typeof(return).init; }; }
    static assert(isMutatingFormattingAggregate!(S, char));
    static assert(isMutatingFormattingAggregate!(const(S), char));
}

unittest
{
    struct S { string toString() { return typeof(return).init; }; }
    static assert(isMutatingFormattingAggregate!(S, char));
    static assert(!isMutatingFormattingAggregate!(const(S), char));
}

unittest
{
    import std.typecons : Nullable;
    import std.variant : VariantN;
    import std.array : appender;
    import std.format.spec : singleSpec;

    struct S
    {
    }

    auto writer = appender!string();
    auto spec = singleSpec("%08b");
    alias T = VariantN!(32LU);
    // writer.formatValue(T.init, spec);
    static assert(isMutatingFormattingAggregate!(T, char));
    static assert(isMutatingFormattingAggregate!(const(T), char));
}

private enum hasPreviewIn = !is(typeof(mixin(q{(in ref int a) => a})));

enum HasToStringResult
{
    none,
    hasSomeToString,
    inCharSink,
    inCharSinkFormatString,
    inCharSinkFormatSpec,
    constCharSink,
    constCharSinkFormatString,
    constCharSinkFormatSpec,
    customPutWriter,
    customPutWriterFormatSpec,
}

template hasToString(T, Char)
{
    static if (isPointer!T)
    {
        // X* does not have toString, even if X is aggregate type has toString.
        enum hasToString = HasToStringResult.none;
    }
    else static if (is(typeof(
        {
            T val = void;
            const FormatSpec!Char f;
            static struct S {void put(scope Char s){}}
            S s;
            val.toString(s, f);
            static assert(!__traits(compiles, val.toString(s, FormatSpec!Char())),
                          "force toString to take parameters by ref");
            static assert(!__traits(compiles, val.toString(S(), f)),
                          "force toString to take parameters by ref");
        })))
    {
        enum hasToString = HasToStringResult.customPutWriterFormatSpec;
    }
    else static if (is(typeof(
        {
            T val = void;
            static struct S {void put(scope Char s){}}
            S s;
            val.toString(s);
            static assert(!__traits(compiles, val.toString(S())),
                          "force toString to take parameters by ref");
        })))
    {
        enum hasToString = HasToStringResult.customPutWriter;
    }
    else static if (is(typeof({ T val = void; FormatSpec!Char f; val.toString((scope const(char)[] s){}, f); })))
    {
        enum hasToString = HasToStringResult.constCharSinkFormatSpec;
    }
    else static if (is(typeof({ T val = void; val.toString((scope const(char)[] s){}, "%s"); })))
    {
        enum hasToString = HasToStringResult.constCharSinkFormatString;
    }
    else static if (is(typeof({ T val = void; val.toString((scope const(char)[] s){}); })))
    {
        enum hasToString = HasToStringResult.constCharSink;
    }

    else static if (hasPreviewIn &&
                    is(typeof({ T val = void; FormatSpec!Char f; val.toString((in char[] s){}, f); })))
    {
        enum hasToString = HasToStringResult.inCharSinkFormatSpec;
    }
    else static if (hasPreviewIn &&
                    is(typeof({ T val = void; val.toString((in char[] s){}, "%s"); })))
    {
        enum hasToString = HasToStringResult.inCharSinkFormatString;
    }
    else static if (hasPreviewIn &&
                    is(typeof({ T val = void; val.toString((in char[] s){}); })))
    {
        enum hasToString = HasToStringResult.inCharSink;
    }

    else static if (is(typeof({ T val = void; return val.toString(); }()) S) && isSomeString!S)
    {
        enum hasToString = HasToStringResult.hasSomeToString;
    }
    else
    {
        enum hasToString = HasToStringResult.none;
    }
}
