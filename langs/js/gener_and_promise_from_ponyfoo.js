function saveProducts(productList) {
    // frMe: the fact that you pass gener-fn instead of iter is GUARANTY that you don't reuse
    // you USED iterator
    var g = productList();
    var item = g.next();
    more();

    function more() {
        if (item.done) { return; }

        fetch(item.value)
            .then(res => res.json())
            .then(product => {
                item = g.next(product);
                more();
            });
    }
}

saveProducts(function* () {
    yield "/products/javascript-application-design";
    yield "/products/barbie-doll";
    // we can control here where to post "products" independently of `saveProducts`
    return addToCard ? '/part' : '/wishlist/nerd-items';
})

function saveProducts2(productList) {
    var products = [];
    var g = productList();
    // var item = g.next(); << frME: it's better to pass args explicitly then "ebannoe zamikanie"

    return more(g.next());

    function more(item) {
        return item.done ?  save(item.value) : details(item.value);
    }
    function details(endpoint) {
        return fetch(endpoint)
            .then(res => res.json())
            .then(product => {
                products.push(product);
                more(g.next(product));
            });
    }
    function save(endpoint) {
        return fetch(endpoint, {
            method: "POST",
            body: JSON.stringify({ products });
        })
        .then(res => res.json());
    }
}
// At this point product descriptions are being pulled down, cached in the products array, 
// forwarded to the generator body, and eventually saved in one fell swoop using the endpoint 
// provided by the return statement.
// "We’re also casting the save operation’s response as JSON, so that promises chained onto 
//  saveProducts can leverage response data."
//
// As you may notice the implementation doesn’t hardcode any important aspects of the operation, 
// which means you could use something like this pretty generically, as long as you have zero or 
// more inputs you want to pipe into one output. The consumer ends up with an elegant-looking 
// method that’s easy to understand – they yield input stores and return an output store. 
// Furthermore, our use of promises makes it easy to concatenate this operation with others. This 
// way, we’re keeping a potential tangle of conditional statements and flow control mechanisms in 
// check, by abstracting away flow control into the iteration mechanism under the saveProducts 
// method.

/// Comment:
// An excellent example of (such good pattern as HERE[of using generators]) is Koa.
// It’s like Express, but uses generators for middleware.
