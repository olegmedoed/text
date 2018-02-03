//! it's just idea, not working code
//
//   zapp :: [a->b] -> [a] -> [b]           --- samoklepanna applicaive operation s uchebnika
//   zapp (f:fs) (x:xs) = f x : zapp fs xs
//   zapp _      _      = []
//   -- The general scheme is as follows:
//   --    zipWith-n :: (a1 → ... → an → b) → [a1] → ... → [an] → [b]
//   --    zipWith-n f xs1 ... xsn = repeat f ‘zapp‘ xs1 ‘zapp‘ ... ‘zapp‘ xsn
//   -- so,
//   transpose_ [] = repeat []
//   transpose_ (xs:xss) = repeat (:) `zapp` xs `zapp` (transpose xss)
//   --
//   myTranspose_ [] = repeat []
//   myTranspose_ (xs:xss) = do
//       (x', xs') <- (zip xs (myTranspose_ xss))
//       return (x' : xs')
//   -- 
//   anmyTranspose_ [] = repeat []
//   anmyTranspose_ (xs:xss) = map (\(x', xs') -> (x' : xs')) (zip xs (anmyTranspose_ xss))
//! [GIST] `anmyTranspose_` naibolee priblizhenna9 k `9zikam poprowe (Hskl)` versi9, bez monad i
//! aplicativov, tut fishka v lenivosti Hskl, izza etogo `(anmyTranspose_ xss)` mozhet
//! vosporinimat's9 ne kak recursivnyi vyzov, a kak iterator, potomu v Rust, poskol'ku on `strogiy`
//! nuzhno pytat's9 pushit' podobnye funcs v iteratory
//! v--- Popytka zapushit' `(anmyTranspose_ xss) v iterator

struct TransposeMatrIter<I> {
    n:    u32,
    cols: u32,
    head: Vec<I>,
    tail: TransposeMatrIter<I>
}

impl<I> IntoIterator for Matr<I>  {
    type Item = Vec<I>;
    type IntoIter = TransposeMatrIter<I>;

    fn into_iter(mut self) -> TransposeMatrIter<I> {
        let cols = self.cols();
        let left_row = self.left_row() // p.s. self now without left row
        TransposeMatrIter {
            n:    0
            cols: cols,
            head: left_row,
            tail: self.into_iter(), // << recursi9(razlazhuem na urovni nelenivo... )
        }
    }
}

// [ 1 2 3 ] ---> iter.next() ---->  [ 1 4 7 ]     [ 1 4 7 ]
// [ 4 5 6 ]                                       [ 2 5 8 ]
// [ 7 8 9 ] ---> iter.collect( )----------------> [ 3 6 9 ]

impl<I> Iterator for TransposeMatrIter<I> {
    type Item = Vec<I>;

    fn next(&self) -> Option<Vec<I>> {           // << ... NO, t9nem lenivo(kak v Hskl)
        let res = Vec::with_capacity(self.cols);
        let el = unsafe {
            *self.head.as_ptr().offset(self.n)
        };
        res.push(el);
        res.concat(self.tails.next())
    }

    //!
    /// BTW, you can reiplement meth in Iterator, to chenge semantic, liki `bind` doint it
    /// depending on monad in Hskl   !!!
    //
    // fn map() .......
    //
    // ili mozhno pereopredelit' `zip` i dopolnit' side effect dl9 slieni9 dvoh iteratorov
}

//! Suka, iteratory ideal'nyi `abstractnyi interfais`, na ravne s Monads(Func, Appl) i REST
//! 9 vspomnil Http-parser(lexer) - to ego uhuenno zadelat' iteratorm tozhe, i samoe glavnoe vse
//! delaets9 v iteratorah lenivo, TUT TEBE I LENIVYE VYCHISLENI9 bez vs9kih Hskl
//!
//! V lispe pisalos' 'luchwe 100 funcyi dl9 1 structury, dannyh, chem 10 dl9 10', tak ot, tam eto
//! list. NO eto scrivaet sut'.
//!     ^-- ("sut'" takzhe obsudil E.Meijei in "FunProg" at the and of the speech at "goto"-conf)
//! Sut' v tom wo eto sootnosits'9  s moim pon9tiem `univarsal'nogo interfeisa`, REST v
//! raspredelennyh sistemah, Monads,Iterators v vychislenii,   Takie structury(interfeisy) i igraut
//! rol' kle9, kotoryi sluzhit kak bazova9 infrastructura, i poskil'ku etot interfais predostavl9et
//! nebol'woi naboi bazovyh funcs, to "on-top-of-that" stroi9ts ostal'nye `100 funcyi` , `100
//! funcyi dl9 etogo odnogo interfeise(tochnee dl9 structur vypoln9uw'h ih)`, potomu v lispe eta
//! fraza men9 ne tak perla, bo list(i ego API) ne sovsem univarsal'nyi interfais
//! p.s. (list vs iter)
//! vychislenie == recursi9 (p.s. ne vsegda, tochnee ee to mozhno tak vyrazit' aka Hskl compile
//! to lambda-calc), v list i iter udobmo perevodit' recur-process v dannye, no iteratory
//! eto bolee universal'na9 wtuka dl9 opisani9 recur-processa chem list(eto prosto mozhno skazat'
//! odna iz implementacyi iteratora)
//!     ^-- E.Meijer "recursion is a `goto` of FP"

//! V obwem kogda est' slozhna9 funcy9, s `mnogo dannyh`(chasto v vide local'nyh perem etoi func, 
//! de ew'e povro9uw'ihs9[bo func recursivna]), to vozmozhno stoit vydelit' eti dannye v
//! structuru(+ dobavit' nekotorye novye, dl9 dopolnitel'noi inforamcii o sosto9nii vychisleni9) i
//! zapushit' funcyu(vychislenie) v iterator(dannye), takim obrazom ty i mozhew uzat' ego lenivo, i
//! plus tebe otkryvaets9 univars9l'nyi interfaise iteratorov(plus v opredelennyh funcs ty mozhew
//! men9t'[korrectirovat'] povedenie(exmp: map, zip..) chto by nalazhyvat' dopolnitel'nye
//! side-effecty, umestnye dl9 etogo exempl9ra iteratora)
//!     ^-- Eto naverno imenno to o chem govoril E.Meijer v "FP from 1st principles" i 9 v
//!     "::js_state.js"  .. "generatory"/iterator/producery  .. let's us define "protocol" for
//!     explicit control of "control-flow" and localize "local state-machine"
