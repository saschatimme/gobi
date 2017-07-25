# Gobi

A boilerplate based on [JBuilder](http://jbuilder.readthedocs.io/en/latest/) and [opam-cross-ios](https://github.com/whitequark/opam-cross-ios) for creating static iOS libraries with OCaml and Reason.

## Getting started

**Requirement**: You must have [OPAM](https://opam.ocaml.org/doc/Install.html) installed.
1. Clone this repo.
2. There is a script `gobi.sh` in the root of this project. Checkout the variables at the top of the script and see if you have to adapt them for your needs.
3. Source the bash script `gobi.sh` (e.g. with `source gobi.sh`)
4. Run `gobi_setup`. This will create a set of different switches, install the necessary compilers and dependencies.
5. Install some packages with `gobi_install`. For the example project we need to instal `re`. This can be done with `gobi_install re-ios`.
6. Create the static library with `gobi_create_library`
7. Open the CrossIOSTest project and run it :)


## Details
Okay here a lot of things going on and I try to explain the different parts.

### JBuilder
JBuilder is a build system for OCaml and Reason for details take look into the excellent [documentation]((http://jbuilder.readthedocs.io/en/latest/).
But that is not the complete truth. Currently JBuilder doesn't support creating object files or cross-compilation. I implemented these features in a fork of mine 