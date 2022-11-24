int main() @safe {
    auto a = ["foo": 1];
    auto r = a.byValue;
    r.popFront;
    return r.front; // oops
}
