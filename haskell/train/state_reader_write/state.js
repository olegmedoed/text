class State {
  constructor(fn) {
    this.runState = fn;
  }

  then(next) {
    return new State(s => {
      return this.runState(s).then(([a,s]) => next(a).runState(s))
    })
  }

  static get() {
    return State(s => Promise.resolve([s, s]))
  }

  static modify(fn) {
    return new State(s => Promise.resolve([null, fn(s)]))
  }

  static put(fn) {
    return new State()
  }

//static resolve(x) {
//  return new State()
//}
}

new State(x =>  Promise.resolve(x + x))
.then(x => Promise.resolve(x*x))
.runState(3)
.then(x => console.log(x))

process.on('unhandledRejection', console.error);
