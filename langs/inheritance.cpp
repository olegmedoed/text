// Let:
class Base {
    public:
        int publicMember;
    protected:
        int protectedMember;
    private:
        int privateMember;
};
// - Everything that is aware of Base is also aware that Base contains
//    publicMember.
// - Only the children (and their children) are aware that Base contains
//    protectedMember.
// - No one but Base is aware of privateMember. By "is aware of", I mean
//    "acknowledge the existence of, and thus be able to access".
// next:
// The same happens with public, private and protected inheritance. Let's
// consider a class Base and a class Child that inherits from Base.
// - If the inheritance is public, everything that is aware of Base and Child
//    is also aware that Child inherits from Base.
// - If the inheritance is protected, only Child, and its children, are aware
//    that they inherit from Base.
// - If the inheritance is private, no one other than Child is aware of the 
//    inheritance.
////                another explanation
class A 
{
public:
    int x;
protected:
    int y;
private:
    int z;
};
class B : public A
{
    // x is public
    // y is protected
    // z is not accessible from B
};
class C : protected A
{
    // x is protected
    // y is protected
    // z is not accessible from C
};
class D : private A
{
    // x is private
    // y is private
    // z is not accessible from D
};
