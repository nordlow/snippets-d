module nxt.projectEuler;

/** Solve Euler Problem 2.
    See_Also: https://www.reddit.com/r/programming/comments/rif9x/uniform_function_call_syntax_for_the_d/
 */
auto problem2()
{
    import std.range : recurrence;
    import std.algorithm.iteration : filter, reduce;
    import std.algorithm.searching : until;
    return recurrence!"a[n-1] + a[n-2]"(1, 1).until!"a > 4_000_000"()
                                             .filter!"a % 2 == 0"()
                                             .reduce!"a + b"();
}

unittest
{
    assert(problem2() == 4613732);
}
