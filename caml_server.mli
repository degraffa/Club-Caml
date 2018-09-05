(* We will be using the ocaml-cohttp library to implement our server.
* We don’t want to expose the internal types of this library, which is why made our function of type unit.
* From the cohottp docs, we will implement an internal server function of type
* "Cohttp.Request.t -> Cohttp_lwt.Body.t -> (Cohttp.Response.t * Cohttp_lwt.Body.t) Lwt.t."
* (signature from https://github.com/mirage/ocaml-cohttp)
* This function will take in a request and a request body and output a pair of response and response body.
* Additionally, we will have an internal function that takes in a JSON (from State.to_json)
* and outputs that as the Response body. *)

(* starts the server on port 8000 and
* leaves it running in the background and listening for
* updates in state *)
val start_server : unit Lwt.t
