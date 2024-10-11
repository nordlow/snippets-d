void main() {
    auto a = 0;
    auto b = 0;
    const c = 1;

    ref ptr = (c ? a : b);
    ptr = 8;
    assert(a == 8);
    ptr = (c ? b : a);
    ptr = 2;
    assert(b == 2); 			// why does this fail??
}
