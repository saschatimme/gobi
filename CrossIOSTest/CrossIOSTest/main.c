/* File main.c -- a sample client for the OCaml functions */

#include <stdio.h>
#include <string.h>
#include <caml/callback.h>

int fib(int n)
{
    static value * fib_closure = NULL;
    if (fib_closure == NULL) fib_closure = caml_named_value("fib");
    return Int_val(caml_callback(*fib_closure, Val_int(n)));
}

char * format_result(int n)
{
    static value * format_result_closure = NULL;
    if (format_result_closure == NULL)
        format_result_closure = caml_named_value("format_result");
    return strdup(String_val(caml_callback(*format_result_closure, Val_int(n))));
    /* We copy the C string returned by String_val to the C heap
     so that it remains valid after garbage collection. */
}
int main(int argc, char ** argv)
{
    int result;
    
    /* Initialize OCaml code */
    caml_startup(argv);
    /* Do some computation */
    result = fib(23);
    printf("fib(23) = %s\n", format_result(result));
    return 0;
}
