immutable struct ArrayContainer
{
	int[] array;
}

@safe pure unittest
{
	ArrayContainer x;
	x.array = null;
}
