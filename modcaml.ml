let rec fib n = if n < 2 then 1 else fib(n-1) + fib(n-2)
let format_result n = Printf.sprintf "Result from OCaml is: %d!! \n" n

(* Export those two functions to C *)

let _ = Callback.register "fib" fib
let _ = Callback.register "format_result" format_result