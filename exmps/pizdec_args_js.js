'use strict';

const crypto = require('crypto');

var len = 128; // bytesize
var iterations = 12000; // iterations ~300ms

// Hashes a password with optional `salt`, otherwise
// generate a salt for `pass` and invoke `fn(err, salt, hash)`.
module.exports = function(pwd, salt, fn) {
    if (arguments.length === 3) {
        crypto.pbkdf2(pwd, salt, iterations, len, function(err, hash) {
            fn(err, hash.toString('base64'));
        });
    } else {
        fn = salt;
        crypto.randomBytes(len, function(err, salt) {
            if (err) return fn(err);
            salt = salt.toString('base64');
            crypto.pbkdf2(pwd, salt, iterations, len, function (err, hash) {
                if (err) fn(err);
                else fn(null, salt, hash.toString('base64'))
            })
        })
    }
}

// ANSWER:  one of reasone: TO NOT BLOWUP an INTERFACE
//
// bl9t' v chem profit odnoi fn kotora9 delaet raznuu huinu vzavisimosti ot
// kolichestva parametrov i t.d.  .. toest' esli ty piwew
//
// ` pass(pwd, (err, salt, hash) => { .... });  .. a potom vdruh rewil zamenit' eto na ...
// ` pass(pwd, salt, (err, hash) => { ... });    ... to tebe vseravno NADO MEN9T' VSE,
// interfaise tvoei fn sloman, interfaise callbacka sloman, tak pochemu 9vno ne
// napisat' chto eto druga9 fn ...
// ` pass_with_salt(pwd, salt, (err, hash) => { ... });
//
// ..  esli kakoito poc skazhet chto odnoi fn pol'zovat's9 prow'e chem neskol'kimi ..
// .. zapominat' tam nazvani9 .. TO BL9T' zapominat' por9dok argumentov kotoryi vli9t na
// ispolnenie eto ne vnapr9g suka ?
//
//
fn pass_with_salt(pwd; String, salt: String, cb: &Fn(Result<Bla, String>)) {
    crypto::pbkdf2(pwd, salt, iterations, len, |res|
        fn( res.map(|hash| hash.toString("base64")) ));
}
fn pass(pwd: String, cb: &Fn(Result<Bla, Bla>, String, String)) {
    crypto::random_byte(len, |res| {
        match res {
            Err(..) => fn(res),
            Ok(salt) => {
                let salt = salt.toString("base64");
                crypto::pbkdf2(pwd, salt, iters, len, |res|
                    fn( res.map(|hash| (salt, hash.toString("base64"))) ))

            }
        }
    })
}
