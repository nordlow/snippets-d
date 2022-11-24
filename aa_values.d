@safe pure unittest
{
    string[string] a;
    a["a"] = "a";
    auto _ = a.values;
}
