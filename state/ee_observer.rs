// exmps - is a mix of Rust/JS/pseudocode

trait Observable<T> { fn subscribe(Box<Observer<T>>); }
trait Observer<T> {
    fn onError<E: Throwable>(E);    // if Err(E)
    fn onCompleted();               // if Ok(None)
    fn onNext(T);                   // if Ok(Some(T))
    // also
    // to protect fast producer against slow consumer
    fn onError<E: Throwable>(E) -> Future<()>;  // we "aware" and "explicit" about side-effs
    fn onCompleted()            -> Future<()>;  // here - "latency"
    fn onNext(T)                -> Future<()>;
}


@1
// in JS..                          here: local_state_machine === Observer
let ee = some_async_fn();
fn one_local_state_machine(file) {
    let list = [];
    ee.on("data", |data| list.push(data));                          // Some(Ok(data))
    ee.on("end", || fs.write(file, list.join(", ")) )               // None
    ee.on("error", |err| fs.write(file, "error: " + err.message));  // Some(Err(error))
}
fn some_another_loc_state_machine(..) {
    let some_state = ...;
    ee.on("data"..); ee.on("end"..); ee.on("error", ..)
}
@2
//
// in Rust-like with Observer/Observable interface;
//
let ee = some_async_fn(); // <- get Observable

struct Observer_1<T> { list: Vec<T>, file: String }
impl<T> Observer_1<T> {
    fn new(file: String) -> Observer_1<T> { Observer_1 { }}
}
impl<T> Observer<T> for Observer_1<T> {
    fn onNext(data: T) { self.list.push(data); }
    fn onCompleted() { fs.write(self.file, self.data.join(", ")) }
    fn onError(err: Error) { fs.write(self.file, "error: " + err.message) }

    // async manere..
    // (like in koa generators combine Promises, here `Observable` will combine `Observers`)
    fn onNext(data: T) -> Future<()> { self.list.push(data); Future::resolve( () ) }
    // `write_async` return Future, as all meths like `meth(.., cb)` should do in Node, so that we
    // have `meth(..).then(cb_on_data).catch(cb_on_err)`
    fn onCompleted() -> Future<()> { fs.write_async(self.file, self.data.join(",.")) as Future<()> }
    fn onError(err: Error) -> Future<()> { fs.write_async(self.file, "error: " + err.message) }
    // .. SO..
    // the disadvanteage of EventEmitter that it's can't combine `handlers` in async-way
    // like : SEE: ::@3
}
ee.subscribe(Box::new(Observer_1::new("some_file.txt")) as Box<Observer<SomeData>>)

@3
ee.on("data", data => do_something_in_async_way(data) :: Promise)
ee.on("data", some_thing)
// .. SO .. `some_thing` run only when `do_something_in_async_way` will completed...
// I think ignore the "result" of Promise, like in Observer( Future<()>) is most simple and correct
// way, otherwise we overcomplicate the logic of combining of Observers/handlers.

@4
// so wiht Observers I have such Observable::subscribe
struct SomeObservable<T> {
    io: Future<Option<Result<T>>>,
    observers: Vec<Box<Observer<T>>>
}
impl SomeObservable<T> {
    fn new(io: Future<T>) -> SomeObservable<T> {
        let this = SomeObservable {
            io: Future<T>,
            observers: Vec::new(),
        }
        // I don't care here about ownership -- treat it like JS
        io.and_then(|val| {
            let iter = this.observers.into_iter();
            let fn = match val {
                Some(data) => match data {
                    Ok(data) => on_succes(data, iter);
                    Err(Error) => on_error.....
                }
                ......
            }
        })

        fn on_succes(data: T, iter: vec::IntoIter<T>) {
            if let Some(observer) =  iter.next() {
                observer.onNext(data).and_then(|| on_succes(data, iter));
            }
        }
        ......
    }

    fn subscribe(&mut self, o: Box<Observer<T>>) {
        self.observers.push(o);
    }
}
//
// From the other side instead of Observers we can just combine a Monads
ee.subscribe(foo as Result<Option<Future<()>>>);

struct SomeObservable<T> {
    io: Future<Option<Result<T>>>,
    observers: Vec<Future<Option<Result<T>>>>,
}
impl SomeObservable<T> {
    fn new(io: Future<Option<Result<T>>>) -> SomeObservable<T> {
        ...
        io.and_then(|val| {
            let iter = this.observer.into_iter();
            handle(val, iter);

        });

        fn handle(data: T, iter: vec::IntoIter<T>) {
            if let Some(observer) =  iter.next() {
                observer.onNext(data).and_then(|| handle(data, iter));
            }
        }
    }
}
ee.subscribe( Future::new(|data| match data { Some(..) => .., None => .. } ) )
