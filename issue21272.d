////////////////// test.d //////////////////
void fun()
{
    int var1, var2, var3;

    void gun()
    {
        int var1; // OK?

        int[] arr;
        foreach (i, var2; arr) {} // OK?

        int[int] aa;
        foreach (k, var3; aa) {} // Not OK??
    }
}
////////////////////////////////////////////
