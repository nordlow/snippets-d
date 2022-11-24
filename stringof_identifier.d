alias S = string;
pragma(msg, __FILE__, "(", __LINE__, ",1): Debug: ", S.stringof); // ok
pragma(msg, __FILE__, "(", __LINE__, ",1): Debug: ", __traits(identifier, S)); // fails
