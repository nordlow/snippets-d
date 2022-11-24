/** Test how destruction of scoped classes is handled.
 */
module scoped_class_dtor;

@safe class C
{
    ~this() nothrow { }
}

@safe class D : C
{
}

static assert(__traits(hasMember, C, "__dtor"));
static assert(__traits(hasMember, D, "__dtor"));

import core.internal.traits : hasElaborateDestructor;
static assert(!hasElaborateDestructor!C); // false to classes
