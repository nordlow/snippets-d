@safe struct C
{
    private void assign(scope string arg) scope
    {
        string t = arg;
        this.arg = t;
    }
    string arg;
}

@safe pure unittest
{
	C c;
}
