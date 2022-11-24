@safe struct S
{
    int value;
    this(int value)
    {
        value = value;
    }
    this(typeof(this) rhs) pure // if pure this is a nop-op
    {
        value = rhs.value;
    }
}

int main(string[] args)
{
    auto _ = S(S(S(42)));
	return 0;
}
