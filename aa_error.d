int main(string[] args)
{
    f();
	return 0;
}

@safe pure nothrow f()
{
    int[int] x;
    auto _ = x[0];
}
