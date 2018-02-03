# keywords: let, fn, catch, where ....
#
# also: strong vision about "Upper/Down/Capitalize"-case LEAD TO "ODNOOBRAZNOSTI" of syntax, as
# result it's easier to read it
#
# WE DONT HAVE MULTILINED "LAMBDAS", that's we like python ..  all "lambas" only through
# "explicit naming" in `where` statement    .... Why we better than python?
# Because we have `where` stateman which let's us "close" over environment of
# "caller" by our "callees"(lambdas otherwise)
#
# about `catch`: if we `throw "Error"` we obligated `.. catch (err) ..`
#                if we `throw` we obligated `.. catch ..`
#
# NAHUI def some_fn(a, ...args) << JUST PASS LIST

# Must have to be UpperCased
let GLOBAL = 3
# v-- Such object has type of `Any`
let SOME_OBJECT = {
    name: "Oleg",
    age: 33,
}

# DataTypes Must have to be Capitalized
data Man {
    name: String,
    age: Integer
}

data Error {
    message: String,
}
    
def with_mutation_of_global!(a) # << Parentheses in definition is OBLIGATED
    GLOBAL := 5

def with_mutation_of_arg(@a) # @arg  -- mutable arg
    a.name := "Helgi"

def without_mutation(a)
    GLOBAL = 5
    # here GLOBAL equal `5` .. BUT .. only here
    # ..
    # Also
    let man = Man { name: "Oleg", age: 25 } # "local_variables" only LowerCase
    man.name = "Helgi" # << this return new object (Hash TRIE like in Closure)
    man.name := "Helgi" # << BUT this modified old object, HOVEWER this def still pure, and should
                        # NOT BE marked with `!` since ..  `man` is NOT "GLOBAL_VARIABLE"  ..
                        # AND NOT BE marked wit `@` .. since NOT ARGUMENT is mutated


def with_exception(a)?
    throw "Some exception"

def return_null()?
    throw # if nothing => null

def catch_exception_so_it_pure()
    let num = 3
    let str = with_exception(3)? catch (err) # PARENTHESES is OBLIGATORY
        case err
            Integer: err.to_str  # if Number === err
            String: err
            Error: err.message
            "Hello": err.to_upper_case() # IF NO ARGS -- WE NEED PARENTHESES  | "Hello" === err
    let idx = return_null? catch num # here PARENTHESES is ABSENT, so `num` is not arg, but value
    # but of course we can
    let idx = return_null? catch
        num
            
    str[idx]
        

def $with_io(str)
    $print(str)

# combination can go in any order

def $with_io_or_exception(str)?   # NOTE: `or` is include `and` + `xor`
    $db_connect(str)?

def $with_io_or_globmutation!()
    GLOBAL := 4
    print$ "hello"

def with_exception_or_globmutation!()?
    GLOBAL := 19
    throw "mutate global"

def with_excep_or_argmut?(@a)
    a.name := "Helgi"
    throw "mutate arg"

def any_of_four*()
    GLOBAL := 1
    print$ "HELLO"
    throw Null
    
def with_where_statement$()
    some_fn_with_exception? catch $handle_it
where
    $handle_it(err: String)
        print$ err
    $handle_it(err: Object)
        print$ err.message
        

def some_fn(man: Man)
    man.name
def some_fn(name: String)
    name

some_def a, b # is the same as
a.some_def b # 
# ALSO we have restricted form of CARRYING
some_another_def a.some_fn # SO .. here `some` parametrized by first parameter
