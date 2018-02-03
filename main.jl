# AIWE - as I wrote earlier

-4
# ot togo chto tvoi kod na paru strochek dolwe, on menee chitabl'nym ne staet,
# na to chtoby prochitat' eti 1-2 lywnie strochki nada vsego lyw 2-3 sekundi (da
# i napisat' nada lyw 6-10); kod nechitablenyi ot togo, kogda ty tratyw po
# neskolko minut chto by pon9t' chto etot kod delaet
#
  (p.s. Sedn9[04-aug-17] perechitival StateMonad na Hskl, i takzhe dal sebe
  kriterii pochemu "HSKL-ne-nuzhen", a luchwe Rust, .... i on takoi:
  wo ochen'-abstractnyi kod kotoryi pozvol9et napisat' sistema tipov Hskl, kak
  pravilo vyhodit za ramki "legko-ohvativaemosti-mozgom", a zachit eto uzhe plohoi
  design, .... da i esli vz9t' Reader,Writer,State monady .... to oni suka vyeli
  mne mozg-I-DOHU9-VREMENI ... hot9 na dele realizuut prostye koncepcii, tobiw
  Hskl uslozhnil sam sebe zhizn' svoim "PURITY" i teper' dl9 etogo pridumal super
  mownuu sistemu tipov ..... i slozhnie VNUTRI reweni9, kotory na ruzhu prosto
  vystavl9ut krasivyi interfais)
#
# No v tozhe vrema kak govoril YaronMinsky vazhno wob nebylo, type-boilerplate,
# takzhe drugogo boilerplate wo mewaet skoncentrirovat's9 na sute koda
# 
# p.s. exmp from js
getRawBody(stream, true, cb); # it's equivalent for
getRawBody(stream, {encoding: true}, cb)
# since
function getRawBody(stream, opts = {}, cb) # so, autor just make facility for
                                           # most used opt.
# ..
# .. So .. FUCK .. it's easier write some extra args, then (1) remember all this
# details(I no need it's for convention, this API is not my Bible(NOT_OTCHE_NAW),
# It's not even Rust where I want know any detail of its cool crates)
# (2) DO TONS OF TYPECHECKs and ARGS-REARRANGEs in `getRawBody` fn-body(actually
# they occupy !HALF! of the fn-body!!!)
#   again: R.Hickey: "EASY IS NOT SIMPLE",
#       ... pass `true` is EASY, pass {encoding: true} is SIMPLE

-3
# don't use exceptions/exception.handling for controll flow
# !!p.s.mar-2016(see how Rust erase this dilemma(with AvdiGr&friend))

-2
# UNLIKE TO POPULAR OO ADVERTISING ACDE(CLASSES) IS NOT REPRESENTATIONS OF REAL
# WORLD OBJECTS, IT'S JUST MEANS OF ABSTRACTION THAT REPRESENT SOME SCREW(PART)
# (ALSO: @ericnormand confirm this thesis)
#
# pizdec, vspomnil lol: When Dimon told me what he wrote the GameOfLife on
# interview, I came to home, and try to solve it to, and I want to represent
# every `cell` as separate object. SO, it's @@@ OOP-golovnogo_mosga @@@.
# | Again: OO is not about modelling all as objects(especially as RealWorld
# | objects), BUT, it is means for abstraction.
# In the case of GameOfLife we don't need this abstraction, it's excessive.
# Just Matrix is enough, IT'S NOT EVEN ACDE(both, the matrix and the cells)
#
# Ask himself, "ot chego ty abstragiruews9 etim novym superclassom?"
# Also remember how stupid you was with refactoring Petgraph, and don't
# actualy understand ISP.

-1
#          Karpinski(about break in loops):
# breaking out midway is at least as common as breaking right at the end.
# of our mechanism(program)

0
# Builder provide us well-defined interface to build some complex object.
# [exmp]
using Maze: make_maze, make_door, make_room, get_maze
# here --^ we can build "maze" and don't care how it builds, and which ACDE is
# used in process of building[maybe it represent it in the form of array,
# maibe as tree(linked nodes), whether we will build wall when build room]
# (except those we provide in args). Whereas Factory just returns concrete obj,
# what represents some ACDE

6
# as I wrote earlier, type is like a tags what gives data special semantic
# meanign, and imply that this data has appropriate data-form what suited to
# be handled proc(that what we called "appropriate semantic meaning"), so in..
type JSONString; str::UTF8String end    # it's not enough(sufficiently) just
# wrap string to this type. you should also supply appropriate constructor what
# check validity of the string(correct JSON)
# p.s.(confirmation from Julia manual)
#  There are, however, cases where more functionality is required when creating 
#  compos.objs. Sometimes INVARIANTS MUST BE ENFORCED, either by checking args
#  or by transforming them
#
# p.s. moreover, in stat-typed-langs we can use it to achive goals what F* and
# ATM gives us --> Refinements, that is imposing invariants on types
