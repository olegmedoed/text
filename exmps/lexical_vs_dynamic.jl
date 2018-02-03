function xxx()
  println("I'm okey yet")
  rare_name + rare_name     # (1)
end
function yyy()
  rare_name = 44            # (3)
  xxx()
end
yyy() # error: rare_name not defined
###                   ......although.......
# function xxx(); ... end
# function yyy(); ... end
rare_name = 55              # (2)
yyy() # => 110, that is expr in (1) can catch only (2) [lexically], and can't
      # catch (3) [dynamically]
# so,
# foo in wonder catch x in scope of wonder, also, rare_name catch the scope
function wonder() # of xxx(and in this scope[lexical] rare_name is undefined)
  foo() = x + x   # whereas CL use dynamic  scope, and can catch dynamic vars
  x = 4           # if they are signed with *var*(stars), and for every call
  println(foo())  # CL create new dynamic-*var* (see: ch9-tdd-framework.EOF)
  x = 5
  println(foo())
  x = 6
  foo()
end;  wonder() # => 8 10 12

######### whereas in CL, dynamic scoping exist
(defun dynamic-func () (format t "~A~%" *fuck*)) ;# julia can only catch [1]
(defvar *fuck* nil)                     ;# [1]   ;# and can catch NO others
(let ((*fuck* '(1)))                    ;# [2]
  (let ((*fuck* (append '(2) *fuck*)))  ;# [3]
    (dynamic-func)) ;# (2 1)
  (let ((*fuck* (append '(3) *fuck*)))  ;# [4]
    (dynamic-func)) ;# (3 1)
  (dynamic-func))   ;# (1)
(dynamic-func)      ;# nil




foo = "global"
experiment() = println("experiment = $foo")
let foo = "foo loc1 $foo"
  experiment()
end
