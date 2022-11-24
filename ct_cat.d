@safe pure:

void put(scope string s)
{
}

unittest
{
    put("cast(" ~ int.stringof ~ ")");
}
