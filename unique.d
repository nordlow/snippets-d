unittest
{
    unique int x;               // unique type qualifier
    auto y = x;                 // should pass
    // TODO: y should have unique qualifier
}

unittest
{
    import core.lifetime : move;
    unique int* x;              // unique type qualifier
    auto y = x;                 // TODO: should fail
    auto z = move(x);           // pass
}

unittest
{
    unique x = new int;         // pass
    unique int* y = new int;    // pass
}
