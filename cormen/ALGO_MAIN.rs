// ??? what advantages of rb_tree against b_tree(not binary) ???

//! 02-jan-16
// proid9 ew'e raz cherez cormena, etogo budet dostatochno, i pohui esli ty zabyl
// kakoito algorythm, smysl v tom chto ty ne budew znat' na zaebis' to chto ty
// ne ispol'zuew kazhdyi den', i uchit' eti vse algorythmy bezponty, glavnoe chto
// ty pon9l principy, kak obosnovyvat' pravotu algorithma(__FILE__:@1), i kak ih
// ocenivat', plus ty primerno znaew vse bazovye algorythmy, v dal'neiwem knigi po
// algorythmam dl9 teb9 prosto spravochniki v tom sluchae esli ty stolknuls9 s
// kakimto algorythmom po rabote

@1
/// the gist of all those loop.invarinats, recursive.steps.correctenss ...,
/// that's, in genereal, proofs about ALGO-CORRECTNESS, is all about that, the
/// algo have steps: iteration has steps, recursion has steps, and ... in every
/// algo-stage with some pattern(recursion, iteration), we have some amount steps
/// with the same computation, on similar data, and due to repeating this 
/// computation on the data we want receive the desired result. So, we should
/// prove that when we apply some computational pattern to data, after every stage
/// this data will have some consitence that is appropriate for applying this
/// computational pattern again, ..., and again(induction), and as result
/// achieving desired result(in merge-sort, it's that after combining 2 sorted
/// arrays we receive new sorted array, and so on, until we receive whole array
/// is sorted)

@2 CHTO CHITAT' S CORMENA
/// 9 dumal zabit' na Cormena voobw'e, dazhe kak na spravochnik(nahui eti teoremy, mne prosto 
/// nuzhno pon9t' kak ono rabotaet), NO, potom gl9nul na knigu, i podumal est' glavy gde mnogo 
/// vody(BinaryTree, BTree), eto chisto po Rustovskim ishodnikam. No est' i godnye(v plane wo 
/// ob'9sn9lok osobo luchwe ne naidew, a chisto po kodu ne trudno razobrat's9(DynProgr, 
/// AmortizAnalizis)). Potomu godnota eto(ostal'noe nahui, inache ty huilo)
///
/// 7 (tol'ko 2 polovi pro amortized analizys)
/// 8 9
/// (11 xz) 13 14
/// 15 16 17
/// 19 20 21
/// 27 (mojet podoidet dl9 Rayon + DynProgrammirovanie)
/// 29 32 35(ochen' somnevaus')
///
/// OSTAL'NYE GLAVY NIVKOEM SLUCHAE NE CHITAI, INache ty huilo
/// Da i etimi ne uvlekais9, glavnoe v pervuu ochered' practica, i tol'ko esli praktikoi ne mozhew
/// to togda teoriei
