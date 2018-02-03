#1
//--------------------------------------------------------
// 7.2.12 Abstract Equality Comparison
//--------------------------------------------------------

#2
//--------------------------------------------------------
// Object.keys -> enumerable own property
// Object.getOwnProperyNames -> all own property
//--------------------------------------------------------

#3
//--------------------------------------------------------
//  Google edvise(V8 is supposed)
//
// /** @constructor */
//      function SomeConstructor() { this.someProperty = 1; }
//      Foo.prototype.someMethod = function() { ... };
//
// While there are several ways to attach methods and properties to an object created via
// "new", the preferred style for methods is:
// 
// Foo.prototype.bar = function() {
//   /* ... */
// };
// The preferred style for other properties is to initialize the field in the constructor:
// 
// /** @constructor */
// function Foo() {
//   this.bar = value;
// }
// Why?
// 
// Current JavaScript engines optimize based on the "shape" of an object, adding a property to
// an object (including overriding a value set on the prototype) changes the shape and can
// degrade performance.
//--------------------------------------------------------

#4
//--------------------------------------------------------
// (V8) - try not to use `delete`
//
// In modern JavaScript engines, changing the number of properties on an object is much slower
// than reassigning the values. The delete keyword should be avoided except when it is necessary
// to remove a property from an object's iterated list of keys, or to change the result of if
// (key in obj).
//--------------------------------------------------------

#5
//--------------------------------------------------------
var fns = [];
for (let i = 0; i < 5; i++)
    fns.push(() => console.log(i));

fns[3]();  // >> 3 , but if `for (var i...)` >> 5
//--------------------------------------------------------

#7
//--------------------------------------------------------
// Warning: Assigning an object or array as a constant means that value will not be able to be 
// garbage collected until that constant's lexical scope goes away, as the reference to the value 
// can never be unset. That may be desirable, but be careful if it's not your intent!
//--------------------------------------------------------

#8
//--------------------------------------------------------
var something = true;
if (something) {
    function foo() { console.log(1); }
} else {
    function foo() { console.log(2); }
}
// earlier (before ES6, before block-scoping [was only fun-scoping]]) `fun` was hoisted, and as 
// result regardless of `something` value the res of `foo()` was 2
// BUT, for now in `non-strict` mode it's depends of `something` value,
// BUT in `strict-mode` we have ReferenceError
//
// also it's example of good optimisation, since could write
function foo() {
    if (something)  console.log(1);
    else console.log(2);
}
// maybe JS can somehow optimize it (if none have acces to `something`, but AFM it's unlikely that 
// engines do such analisys(JS should start quickly) )
// p.s. AFM == as for me
//--------------------------------------------------------

#9
//--------------------------------------------------------
//
var o = {
    x: 33,
    fun() {
        [1,2,3].forEach(function (e) {
            var f = () => console.log(this.x + e);
            f();
        }, { x: 11 });
    },
}
o.fun(); // 12, 13, 14
// .. BUT IF ..
var o = {
    x: 33,
    fun() {
        [1,2,3].forEach((e) => {
            var f = () => console.log(this.x + e);
            f();
        }, { x: 11 });
    },
}
o.fun(); // 34, 35, 36
//--------------------------------------------------------

#6
//--------------------------------------------------------
//--------------------------------------------------------

#6
//--------------------------------------------------------
//--------------------------------------------------------

#6
//--------------------------------------------------------
//--------------------------------------------------------

#6
//--------------------------------------------------------
//--------------------------------------------------------

#6
//--------------------------------------------------------
//--------------------------------------------------------

#6
//--------------------------------------------------------
//--------------------------------------------------------

#6
//--------------------------------------------------------
//--------------------------------------------------------
