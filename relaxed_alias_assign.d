// This compiles with https://github.com/nordlow/dmd/tree/relax-alias-assign

template sort(A, B)
{
    alias C = A;
    alias D = C;
    pragma(msg, __FILE__, "(", __LINE__, ",1): Debug: ", D);
    C = B;
    pragma(msg, __FILE__, "(", __LINE__, ",1): Debug: ", D);
}

void main()
{
    alias X = short;
    alias Y = int;
    cast(void)sort!(X, Y);
}
