void main()
{
    import std.algorithm.comparison : equal;
    import std.algorithm : filter;
    import nxt.trie : RadixTreeSet;

    alias Key = int;
    auto set = RadixTreeSet!(Key)();

    set.clear();

    enum n = 200;
    foreach (const e; 0 .. n)
    {
        set.insert(e);
    }

    set.insert(n*2);
    foreach (const e; n*3 .. n*3 + n)
    {
        set.insert(e);
    }

    // set.print();

    enum limit = n*2;
    // dbg(set.upperBound(limit));
    // dbg(set[].filter!(_ => _ > limit));

    assert(set.upperBound(limit)
           .equal(set[].filter!(_ => _ > limit)));
}
