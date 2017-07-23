BIN := ../jbuilder/_build/default/bin/main.exe

run_build:
	@$(BIN) build modcaml.exe.o ;\

postbuild:
	@mkdir -p output;\
    ocamlfind -toolchain ios ocamlc -c cwrapper/cwrapper.c;\
    mv cwrapper.o _build/ios+amd64/cwrapper.o;\
    cp `ocamlfind -toolchain ios ocamlc -where`/libasmrun.a output/libmod.a && chmod +w output/libmod.a ;\
    ar r output/libmod.a _build/ios+amd64/modcaml.exe.o _build/ios+amd64/cwrapper.o;\
	cp output/libmod.a CrossIOSTest/libmod.a

build:
	@make run_build;\
	make postbuild;\

clean:
	@rm -f *.a *.cmi *.cmx *.o;\
    rm -fR _build;\
	rm -fR output/*;\
	rm -f CrossIOSTest/libmod.a;\
	$(BIN) clean;\
