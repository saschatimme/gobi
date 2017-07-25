/* File modwrap.c -- wrappers around the OCaml functions */

#include <stdio.h>
#include <string.h>
#include <caml/alloc.h>
#include <caml/memory.h>
#include <caml/mlvalues.h>
#include <caml/callback.h>

int fib(int n)
{
  static value *fib_closure = NULL;
  if (fib_closure == NULL)
    fib_closure = caml_named_value("fib");
  return Int_val(caml_callback(*fib_closure, Val_int(n)));
}

char *format_result(int n)
{
  CAMLparam0 ();
  CAMLlocal2 (on, ores);
  // avoid redefinition
  static value *format_result_closure = NULL;
  /* The pointer returned by caml_named_value is constant and can safely
    be cached in a C variable to avoid repeated name lookups */
  if (format_result_closure == NULL)
    format_result_closure = caml_named_value("format_result");
  on = Val_int(n);

  ores = caml_callback(*format_result_closure, on);
  CAMLreturnT(char *, String_val(ores));
}

char * match_string(char * pattern, char * string)
{
  CAMLparam0 ();
  CAMLlocal3 (opattern, ostring, ores);
  opattern = caml_copy_string(pattern); 
  ostring = caml_copy_string(string);
  static value * match_closure = NULL;
  if (match_closure == NULL)
    match_closure = caml_named_value("match_string");
  
  ores = caml_callback2(*match_closure, opattern, ostring);

  CAMLreturnT(char *, String_val(ores));
}