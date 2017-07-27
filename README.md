Gobi
==============

A boilerplate based on [JBuilder](http://jbuilder.readthedocs.io/en/latest/) and [opam-cross-ios](https://github.com/whitequark/opam-cross-ios) for creating static iOS libraries with OCaml and Reason.

The name comes from the Gobi Desert, which is the [only desert with wild
camels](http://animals.nationalgeographic.com/animals/mammals/bactrian-camel/) (Thank you to [wokalski](https://github.com/wokalski) to let me take over this awesome name :))


Getting started
------------

**Requirements**:
* You must have [OPAM](https://opam.ocaml.org/doc/Install.html) installed.
* You must have the Xcode command line tools installed (e.g. with `xcode-select --install`)

1. Clone this repo.
2. There is a script `gobi.sh` in the root of this project. Checkout the variables at the top of the script and see if you have to adapt them for your needs.
3. Source the bash script `gobi.sh` (e.g. with `source gobi.sh`)
4. Run `gobi_setup`. This will create a set of different switches, install the necessary compilers and dependencies.
5. Install some packages with `gobi_install`. For the example project we need to instal `re`. This can be done with `gobi_install re-ios`.
6. Create the static library with `gobi_create_library`
7. Open the CrossIOSTest project and run it :)

**Note**: The install for `reason` seems to fail undeterministically. If it happens just try again with `gobi_install reason`.

Details
-------------
Okay here a lot of things going on and I try to explain the different parts.
Generally, any native iOS library would have to be compiled four times: for 64-bit (and 32-bit) device and simulator. OPAM offers no help here; due to the way OPAM packages currently work, the only realistic option is to create four switches, one switch per target, and build everything four times

### JBuilder
JBuilder is a build system for OCaml and Reason for details take look into the excellent [documentation]((http://jbuilder.readthedocs.io/en/latest/).
But that is not the complete truth. Currently JBuilder doesn't support creating object files nor cross-compilation. I implemented these features in a [fork](https://github.com/saschatimme/jbuilder/tree/output-object%2Bcross-compilation) of mine and installed this version previously.
I try to upstream my changes, but they are also on the Roadmap for 1.1 so soon we get a stable version!
In order to configure everything there are two ne stanzas available. A `jbuild-workspace` context now additionally has an optional `host` field
which enables toolchains like iOS. And the `executable` now has additionally a `targets` stanza which takes `(<targets>)` where `<targets` is a subset from `object` and `executable`. If `object` is set now additionally you can build `myFile.exe.o` for on object-file (with the `-output-obj` flag).

### gobi.sh
`gobi.sh` is actually just a bunch of helper scripts which took inspiration from [opam-cross-ios](https://github.com/whitequark/opam-cross-ios/).
The following functions are available:
* `gobi_working_switch` sets opam to the defined working switch (by default 64-bit simulator)
* `gobi_create_switches` creates all necessary switches
* `gobi_foreach <your_command>` iterates over all switches and executes each command once per switch
* `gobi_install <packages>` is just an alias for `gobi_foreach opam install <packages>`.
* `gobi_remove <packages>` is just an alias for `gobi_foreach opam remove <packages>`.
* `gobi_create_library` will create a fat static library (with lipo), i.e. all architectures in one.

### Packages
The best would be to just read the [description](https://github.com/whitequark/opam-cross-ios/#porting-packages) from whitequark.
[Here](https://github.com/whitequark/opam-cross-ios/tree/master/packages) is a list of already ported packages. `re-ios` is one example of these.

### Bindings / C-Interop
In order to call OCaml from Objective-C we have to do two things:
1. Register callbacks, this is done in `hello_world.re`
2. Write some thin C-wrappers. You can find examples in `bindings`. The best guide for the c-bindings is probably the [official manual](https://caml.inria.fr/pub/docs/manual-ocaml/intfc.html). A good way to start would propbably be to look at the examples in this repo and then search the functions in the manual to understand what happens.
**Note**: The better way would actually to use [ctypes](https://github.com/ocamllabs/ocaml-ctypes) to generate the functions, but I wasn't able to get that compiled for iOS ... Any help would be appreciated!


### JBuild configuration
The `jbuild` file in `src` has the following rule
```scheme
(rule
 ((targets (libgobi.a))
  (deps    (hello_world.exe.o ../bindings/bindings.o))
  (action  (bash "\
    cp ${ocaml_where}/libasmrun.a libgobi.a && chmod +w libgobi.a;\
    ar r libgobi.a hello_world.exe.o ../bindings/bindings.o;\
    "))))
```
This rule combines our OCaml code `hello_world.exe.o` and our bindings `../bindings/bindings.o` together with the ocaml (`libasmrun.a`) runtime to a static archive.


Acknowledgements
-------------------
Opam-cross-ios is based on the work by [whitequark](https://whitequark.org).
The OCaml cross-compiler in opam-cross-ios is based on a [patchset][psellos] by Gerd Stolpmann.

[psellos]: psellos.com/ocaml/compile-to-iphone.html

[JBuilder](http://jbuilder.readthedocs.io/en/latest/) is built by the fine folks at Jane Street
