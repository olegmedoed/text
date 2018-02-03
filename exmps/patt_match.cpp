// visitor is OO way to replace PattM
// https://www.reddit.com/r/programming/comments/33us7z/what_will_c17_be_bjarne_stroustrup_on_c17_goals/cqp1iay
#include <iostream>

class Visitor;

class AbstHandled {
public:
    virtual void accept(Visitor& v) = 0;
    // we can use inheritance to accept different Visitors, or overload this
    // meth to handle diff visitors differently
//  virtual void accept(AnotherVisitor& v) = 0; (not sure about syntax)
};
class Handled1 : public AbstHandled {
public: void accept(Visitor& v);
};
class Handled2 : public AbstHandled {
public: void accept(Visitor& v);
};

class Visitor {
public:
    // Actual PattM is happened here
    void matcher(Handled1* o) { std::cout << "Handled1 is handled in PattM\n"; }
    void matcher(Handled2* o) { std::cout << "Handled2 is handled in PattM\n"; }
};


void Handled1::accept(Visitor& v) {
    v.matcher(this);
}
void Handled2::accept(Visitor& v) {
    v.matcher(this);
}

AbstHandled& some_meth (bool val) {
    if (val) return *(new Handled1);
    else     return *(new Handled2);
}

class Handler {
public:
    void handler(bool val, Visitor& v) {
        auto &o = some_meth(val);
        o.accept(v); // << here should be PattM
    }
};


int main () {
    auto &v = *(new Visitor);
    Handler h;
    h.handler(true, v);

    return 0;
}
