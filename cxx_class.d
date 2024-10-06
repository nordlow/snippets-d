// https://dlang.slack.com/archives/C7FT6TPFG/p1600605823003100

extern(C++) class C {
}

pragma(msg, __FILE__, "(", __LINE__, ",1): Debug: ", C.sizeof);
pragma(msg, __FILE__, "(", __LINE__, ",1): Debug: ", __traits(classInstanceSize, C));
