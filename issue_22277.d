// See: https://github.com/dlang/dmd/pull/13047

bool secret = false;

void free(immutable void* x) pure nothrow
{
    debug secret = true;
}

void main()
{
    free(null);
    assert(secret);
}
