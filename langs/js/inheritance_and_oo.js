"use strict"

//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
// When we create function its `prototype` property is set to `some obj`, and
// this obj has property `constructor` which is equal the function itself
function One(x) { this.x = x; }
console.log(One.prototype.constructor === One); // true

function Two(y) { this.y = y; }
console.log(Two.prototype.constructor === Two); // true
Two.prototype = new One(3);
console.log(Two.prototype.constructor === One); // true
var two = new Two(1);
console.log(two.constructor === One); // true

var xxx = new Function();
console.log(xxx.prototype.constructor === xxx) // true

// `constructor` is only read-only for primitive values such as 1, true and "test".

//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
function include_module(c, m) {
    if (typeof c !== 'function' || (typeof m !== 'object' && typeof m === null))
        throw TypeError("`c` should be function, and `m` should be object");

    Object.setPrototypeOf(m, c.prototype);
    c.prototype = m;
}

//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
