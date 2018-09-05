run:
	ocamlbuild -use-ocamlfind -pkgs "yojson,unix" state.byte

server:
	ocamlbuild -use-ocamlfind  -pkgs "yojson,unix,cohttp-lwt-unix,csv,threads,lwt.preemptive" -lflags -thread -tag thread caml_server.byte && ./caml_server.byte


clean:
	ocamlbuild -clean

test:
	ocamlbuild -use-ocamlfind -pkgs "yojson,oUnit"  test.byte -r  && ./test.byte
