/** See_Also: https://forum.dlang.org/post/txvaejbblscjlckvtgsa@forum.dlang.org
 */
@safe pure @nogc unittest
{
    scope a = [1, 2];
}

@safe pure @nogc unittest
{
    string x, y;
    scope a = x ~ y;
}
