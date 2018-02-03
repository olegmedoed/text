// ranota eto uspeh, put' k zhizni, to bez chego vse ostal'noe ne imeet smysla,
//      kogda 9 rabotau 9 ni o chem drugom ne dumau, eto pusta9 trata vremeni.
//      eto sila, ne dat' zaleszt' sebe v golovu, i zarabotat' na norm zhizn'
//

// interesting exmps from `petgraph`(type definitions):
// pub fn from_edges
// pub fn index_twice_mut
//
// also, interesting definition
pub trait IntoIterator where Self::IntoIter::Item == Self::Item {
    type Item;
    type IntoIter: Iterator;
    fn into_iter(self) -> Self::IntoIter;
}


2
///----------------------------------------------------------------------------
///----------------------------------------------------------------------------

3
///----------------------------------------------------------------------------
// - Type<'a>: a generic lifetime parameter on a type;
// - Trait + 'a: a trait object's lifetime, as with generic bounds (dealt with below).
///----------------------------------------------------------------------------

4
///----------------------------------------------------------------------------
// resources within the same scope are freed in the opposite order they were
// declared     == stack == LIFO
///----------------------------------------------------------------------------

6
///----------------------------------------------------------------------------
fn id<T>(arg: &T) -> &T { arg } // in such case T = Vec<i32>
fn idr<T>(arg: T) -> T { arg }  // in such case T = &Vec<i32>

id(&vec![1,2,3]);    idr(&vec![1,2,3]);
///----------------------------------------------------------------------------

7
///----------------------------------------------------------------------------
#[derive(Debug)]
struct Pnt<'a, T: 'a> {
    a: &'a T,   // lifetime is option of reference, and here struct
    b: &'a T,   // has lifetime not biggest then reference lifetime
}

#[derive(Debug)]
struct Fuck<'a> {   var: &'a i32,   }

impl<'a> Fuck<'a> { // by default ret.val has lifetime of self, but here we
    fn get_var(&self) -> &'a i32 { // change it to lifetime of self.var
        self.var
    }
}

fn accept<T>(fuck: Fuck<T>) -> &T { fuck.a }

fn get_str() -> &'static str { "fuck the police" }


fn do_static<T: Foo>(x: &T) { x.method(); }
// in C++ is like `void do_dynamic(const Foo *x) {}
// and Foo is abstract.class, and we pass to do_dynamic the pointer to obj of 
// some concrete class(here in Rust it's reference)
fn do_dynamic(x: &Foo) { x.method(); }
// in main --v
    // when we cast(coerce) &x to trait-obj, then compiler at run-time looks the 
    // type of this pointer, then looks whether this trait is implemented for
    // this type and form the trait object(struc with pointer to val[here x], and
    // vtable wiht pointers to funcs for this type)
    do_dynamic(&x as &Foo);
///----------------------------------------------------------------------------

8
///----------------------------------------------------------------------------
use std::ops::Add;

trait ConvertTo<T> { fn convert(&self) -> T; }

impl ConvertTo<i64> for i32 {
    fn convert(&self) -> i64 { *self as i64 }
}

fn normal<T: ConvertTo<i64>>(x: &T) -> i64 { x.convert() }

fn invert<T>(x: i32, y: T) -> <T as Add>::Output
    where i32: ConvertTo<T>, T: Add
{
    y + x.convert()
}
///----------------------------------------------------------------------------

9
///----------------------------------------------------------------------------
fn call_with_one<F>(some_closure: F) -> i32 where F: Fn(i32) -> i32 {
    some_closure(1)
}

fn call_with_one_dyn(some_closure: &Fn(i32) -> i32) -> i32 { some_closure(1) }

fn sum(x: i32) -> i32 { x + x }

fn return_closure() -> Box<Fn(i32) -> i32> {
    let num = 5;
    Box::new(move |x| x + num)
}

fn main() {
    assert_eq!(call_with_one(sum), 2);
    assert_eq!(call_with_one_dyn(&sum), 2)
}
///----------------------------------------------------------------------------

10
///----------------------------------------------------------------------------
trait Display { fn show_me(&self); }
trait Graph {
    type E: Display;
    type N;

    fn has_edge(&self, &Self::N, &Self::N) -> bool;
    fn edges(&self, &Self::N) -> Vec<Self::E>;
}

fn distance<G: Graph>(graph: &G, start: &G::N, end: &G::N) -> u32 { 0u32 }

struct Node; struct Edge; struct MyGraph;

impl Display for Edge { fn show_me(&self) { println!("I'm Edge"); } }

impl Graph for MyGraph {
    type N = Node;
    type E = Edge;

    fn has_edge(&self, n1: &Node, n2: &Node) -> bool { true }
    fn edges(&self, n: &Node) -> Vec<Edge> { Vec::new() }
}

fn main() {
    let graph = MyGraph;
    let obj = Box::new(graph) as Box<Graph<N=Node, E=Edge>>;
}
///----------------------------------------------------------------------------

11
///----------------------------------------------------------------------------
use std::ops::{Add, Mul, Deref};

#[derive(Debug)]
struct Point { x: i32, y: i32, }

impl Add for Point {
    type Output = Point;

    fn add(self, other: Point) -> Self::Output {
        Point { x: self.x + other.x, y: self.y + other.y, }
    }
}

impl Add<i32> for Point {
    type Output = Point;

    fn add(self, other: i32) -> Self::Output {
        Point { x: self.x + other, y: self.y + other, }
    }
}

trait HasSquare<T> { fn area(&self) -> T; }

struct Square<T> { x: T, y: T, side: T, }

impl<T> HasSquare<T> for Square<T> where T: Mul<Output=T> + Copy {
    fn area(&self) -> T { self.side * self.side }
}

struct DerefExmp<T> { val: T, }

impl<T> Deref for DerefExmp<T> {
    type Target = T;

    fn deref(&self) -> &T { &self.val }
} 

fn main() {
    let (p1, p2) = (Point { x: 1, y: 2 }, Point { x: 11, y: 22 });
    let s = Square { x: 0.0f64, y: 0.064, side: 12.0f64 };
    let d = DerefExmp { val: "Oleg Tsyba" };

    println!("{:?}", p1 + p2 + 5);
    println!("square area {:?}", s.area());
    println!("deref = {:?}", *d);
}
///----------------------------------------------------------------------------

12
///----------------------------------------------------------------------------
macro_rules! my_vec {
    ( $( $x:expr ),* ) => {{
            let mut temp_vec = Vec::new();
            $( temp_vec.push($x);)*
            temp_vec
    }}; // semicolon is optional(since only one PattM.case)
}

macro_rules! foo {
    (x => $e:expr) => {println!("Mode X {}", $e)};
    (y => $e:expr) => {println!("Mode Y {}", $e)};
}

macro_rules! O_o {
    ($( $x:expr; [ $($y:expr),*]);*) => { &[$($($x + $y),*),*] }
}

fn main() {
    let v = my_vec![1, 2, 3];
    for x in &v { println!("x is {}", x); }
    foo![x => "Fuck the police"];
    println!("arr is {:?}", O_o![10; [1,2,3]; 20; [4,5,6]])
}
///----------------------------------------------------------------------------

13
///----------------------------------------------------------------------------
trait Functor {
    type In;
    type MainOut;
    fn fmap<Out>(&self, &Fn(Self::In) -> Out) -> Box<Functor::MainOut<Out>>;
}
// it's like define in Hskl
//      instance Functor (Maybe a) where ...
// instaed of
//      instance Functor Maybe where ...
//  SO, we can make some restrinctions on `a`|`T`, but can't manage by Option as 
//  Higher-kinded type
impl<T> Functor for Option<T> {
    type In = T;
    type MainOut = Self;

    fn fmap<Out>(&self, f: &Fn(Self::In) -> Out) -> Box<Functor::MainOut<Out>> {
        match self {
            Some(a) => Box::new(Some(f(a))),
            None => Box::new(None),
        }
    }
}

instance (Eq a) => Eq (Tree a) where
     Leaf a == Leaf b = a == b
     (Branch a1 b1) == (Branch a2 b2) = (a1 == a2) && (b1 == b2)
///----------------------------------------------------------------------------

14
///----------------------------------------------------------------------------
#![feature(box_syntax, box_patterns)]
enum Tree<T> {
    Leaf(T),
    Branch(Box<Tree<T>>, Box<Tree<T>>),
}

trait Eq {
    fn is_eq(&self, o: &Self) -> bool;
}

// instance (Eq a) => Eq (Tree a) where
//     Leaf a == Leaf b = a == b
//     Tree a1 b1 == Tree a2 b2 = (a1 == b1) && (a2 == b2)
impl<T> Eq for Tree<T> where T: Eq {
    fn is_eq(&self, o: &Self) -> bool {
        match *self {
            Tree::Leaf(ref a) => {
                match *o {
                    Tree::Leaf(ref b) => a.is_eq(b),
                    _ => false,
                }
            }
            
            Tree::Branch(box ref a1, box ref b1) => {
                match *o {
                    Tree::Branch(box ref a2, box ref b2) =>
                        a1.is_eq(a2) && b1.is_eq(b2),
                    _ => false,
                }
            }
        }
    }
}

impl Eq for i32 {
    fn is_eq(&self, o: &Self) -> bool {
        self == o
    }
}


fn main() {
    let t1 = Tree::Branch(Box::new(Tree::Leaf(3)), Box::new(Tree::Leaf(5)));
    let t2 = Tree::Branch(Box::new(Tree::Leaf(3)), Box::new(Tree::Leaf(5)));
    println!("is equal? - {}", t1.is_eq(&t2));
    println!("Hello, world!");
}
///----------------------------------------------------------------------------

15
///----------------------------------------------------------------------------
trait Fuck {     fn len(&self) -> &'static str { "Fuck the police" }    }

impl<T> Fuck for Vec<T> {}

fn fuck<T: Fuck>(x: &T) -> &'static str { x.len() }

fn main() {
    let x = vec![1,2,3];
    let n = x.len();
    let s = fuck(&x);

    println!("n - {}, s - {}", n, s); // n - 3, s - Fuck the police
}
///----------------------------------------------------------------------------

16
///----------------------------------------------------------------------------
trait Fuckit {}
trait Foo { fn foo(&self); }
// generally when we mark all types with Fuckit, then everywhere when we use
// Type variable it's supposed as implemetor of Fuckit(regardless of whether we 
// `use MarkerTrait` it or no), and when we point out Type: ?Fuckit => it's mean
// that it's really every variable(but of course it bounded others traits like
// Sized[really, in Rust only Sized. Why is this?], that is every empty trait that:
// impl Trait for .. {})
impl Fuckit for .. {}
impl !Fuckit for i32 {}

impl<T: ?Fuckit> Foo for T { fn foo(&self) { println!("I'm Fuckit"); } }

fn fuck<T>(o: T) -> T { o }

fn main() { fuck(5); fuck("hello"); 5.foo(); }
///----------------------------------------------------------------------------

17
///----------------------------------------------------------------------------
fn foo<'x, 'y:'x>(...) { ... }
// that would indicate that the lifetime 'x was shorter than (or equal to) 'y.
///----------------------------------------------------------------------------

18
///----------------------------------------------------------------------------
let mut a = vec![vec![1,2], vec![3,4]];
let mut b = unsafe {
    &mut *(a.get_unchecked_mut(1) as *mut Vec<_>)
    // a.get_unchecked_mut(0) <-- we can't write in such way since in this case
    //                            a stay borrowed mutably and we cannot use
    // it in println!({:?}, a)
};

b.push(5);       println!("{:?}", a);
///----------------------------------------------------------------------------

19
///----------------------------------------------------------------------------
struct SomeS<T> { a: T }

impl SomeS<i32> { fn sa(&self) { println!("S.sa"); } }
impl SomeS<f64> { fn sa(&self) { println!("S.sb"); } }

let si = SomeS { a: 23 };
let sf = SomeS { a: 13.11 };
let ss = SomeS { a: "Hello".to_owned() };

<SomeS<f64>>::sa(&sf);
// BUT, I dunno what we should do if

impl<T: TraitIsImpledForI64> SomeS<T> { fn sa (&self) { ... } }

// <SomeS<T: TB>>::sa(&si);   << it's wrong
///----------------------------------------------------------------------------

20
///----------------------------------------------------------------------------
mod fuck {
    mod inner {
        #[derive(Debug)]
        pub struct Fuck { a: i32 }

        pub fn new(a: i32) -> Fuck { Fuck { a: a } }

        impl Fuck {
            pub fn fuck(&self) { println!("I'm have number: {}", self.a) }
        }
    }
    pub use self::inner::new;
}

fn main() {     let x = fuck::new(33);
                x.fuck();                    }
///----------------------------------------------------------------------------

21
///----------------------------------------------------------------------------
struct Iterable<'a> {
    vals: &'a mut [Suck<i32>],
    cur: usize
}

impl<'a> Iterator for Iterable<'a> {
    type Item = &'a mut Suck<i32>;

    fn next(&mut self) -> Option<&'a mut Suck<i32>> {
        match self.vals.get_mut(self.cur) {
            None => None,
            Some(el) => {
                self.cur += 1;
                let res = unsafe { &mut *(el as *mut _) };
                Some(res)
            }
        }
    }
}

fn main() {
    let mut sucks = [Suck { a: 11 }, Suck { a: 22 }];

    {
        let mut iter = Iterable {
            vals: &mut sucks,
            cur: 0,
        };

        if let Some(r) = iter.next() {
            // Totally unsafe, we have 2 mutable refs on the same memory location
            // We should make sure that we use this 2 refs safely, and don't give
            // acces to users of our lib to this refs(at least simultaneously)
            iter.vals[0].a = 88;
            r.a = 99;
        }

        for e in iter {
            println!("e = {:?}", *e);
            e.a = e.a + e.a
        }
    }

    println!("sucks = {:?}", sucks);
}

// also
// AFAIU: when we have code like this:
    let mut v = vec![1,2,3];
    let r = &mut v;
    let rr = r.get_mut(0);
    r[1] = 33;
// 
// the compiler not allow us use r due to lifetimes, so in get_mut signature
fn get_mut(&mut self, index: usize) -> Option<&mut T>
// both refs(self, T) has the same lifetime, so, while `&mut T` exists we can't
// use `&mut self` that is r.
// The compiller gives error: we cannot borrow *r as mut more then once at a time:
//      r[1] = 1
//  since `r` and `rr`(or memory what they refer) have the same lifetime
//
    let mut v = vec![1,2,3];    // <<<  BUT, this work
    {
        let orig_ref = &mut v;      // v- `re` lifetime is not related with `v` lt
        let re: &mut Vec<_> = unsafe { &mut *(orig_ref as *mut _) };

        re.push(4);
        orig_ref.push(5);
    }

    println!("v = {:?}", v);

// ----------------- AGAIN ------------------------------
    let mut vec = vec![Suck { a: "Hello".to_owned() }, Suck { a: "Pomello".to_owned() }];
    {
        let mut it = vec.iter_mut();

        let mut a = it.next();
        let mut b = it.next();

        // We have 2 mut refs on the same vector
        // Hovewer! Iterator implementation is guarantee that they don't point to the
        // same memory location(here to the same Suck<String> objects)
        if let Some(a) = a {
            a.a = "One".to_owned();
        }
        if let Some(b) = b {
            b.a = "Two".to_owned();
        }
    }
    // But this -v- is illegally
    {
//      let a = &mut vec[0];
//      let b = &mut vec[1];
    }

    println!("vec = {:?}", vec);
///----------------------------------------------------------------------------

22
///----------------------------------------------------------------------------
struct Fuck<'a> {
    fuck: &'a mut [u8],
}

impl<'a> Fuck<'a> {
    // if `'a` is missed, we cannot use both ref in =[1]=
    // AFAIU: from lt-elision-rule:1  -  self has elided lt => it's distinct from 'a
    pub fn slice(&mut self) -> &'a mut [u8] {
        unsafe{
            std::slice::from_raw_parts_mut(self.fuck.as_mut_ptr(), self.fuck.len())
        }
    }
}

fn main() {
    let mut v: [u8; 5] = [1, 2, 3, 4, 5];
    let mut f = Fuck { fuck: &mut v };
    let mut sl = f.slice();

    // =[1]= --v
    sl[0] = 11;
    f.fuck[1] = 22;
}
///----------------------------------------------------------------------------

23
///----------------------------------------------------------------------------
// TypeId of the trait-obj is always the same, regardless of what type it represent, and
// distinct from TypeId of any type it represent
///----------------------------------------------------------------------------

24
///----------------------------------------------------------------------------
///----------------------------------------------------------------------------

25
///----------------------------------------------------------------------------
///----------------------------------------------------------------------------

26
///----------------------------------------------------------------------------
///----------------------------------------------------------------------------

27
///----------------------------------------------------------------------------
///----------------------------------------------------------------------------
