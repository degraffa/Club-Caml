open Lwt
open Cohttp
open Cohttp_lwt_unix
open Yojson
open State
open Lwt_preemptive
open Connect_handler
open Yojson.Basic.Util

let curr_state = ref (new_state ())
let queue = ref []

(* [server_req] is the server callback, which is invoked after a request is
   sent to the server. It parses the request (which can be an update to the state,
   a login, or a logout) and send the appropriate JSON to the client.
*)
let server_req =
  let callback _conn req body =
    (body |> Cohttp_lwt.Body.to_string >|= Yojson.Basic.from_string)
    >|= member "req_type" >|= to_string >>= fun(connect_type)->
    begin
      match connect_type with
          |"update"->
            (body |> Cohttp_lwt.Body.to_string >|= Yojson.Basic.from_string >|=
            (fun masterjson ->
            queue := masterjson::!queue;
            State.to_json (!curr_state)))
          |"login"->
            let body =
              body |> Cohttp_lwt.Body.to_string >|= Yojson.Basic.from_string in
            body >|= member "name" >|= to_string >>= fun u ->
            body >|= member "password" >|= to_string >>= fun p ->
            (begin match (Connect_handler.login u p !curr_state.players) with
               |Some(x)-> queue:=(Yojson.Basic.from_string x)::!queue; return x
               |None-> return "{}"
              end)
          |"logoff"-> let body =
            body |> Cohttp_lwt.Body.to_string >|= Yojson.Basic.from_string in
            body >|= member "name" >|= to_string >>= fun u ->
            curr_state := dc_player !curr_state u;
            (Connect_handler.logoff u !curr_state.players); Lwt.return "{}"
          |_-> Lwt.return "{}"
        end
        >>=
        (fun body -> Server.respond_string
      ~headers:(Cohttp.Header.init_with "Access-Control-Allow-Origin" "*") ~status:`OK ~body () )
  in
  Server.create ~mode:(`TCP (`Port 8000)) (Server.make ~callback ())

(* [update_loop n] is the main loop that infinitely runs, listening for any
   requests, and passing them to the server callback.
   requires: [n] a boolean used to start the loop
   effects: mutates the curr_state and queue object to reflect the updated
   state and the updates to be delivered the client, respectively*)
let rec update_loop n =
  if n then (
    let handle_queue () =
      while (List.length !queue) > 0 do
          let curr = List.hd !queue in
          curr_state := State.update (State.parse curr) !curr_state;
          queue:= List.tl !queue;
      done
in
handle_queue (); Unix.sleepf (1.0/. 60.0); update_loop n)
  else 0
(* [start_server] starts the server by launching the infinite listening loop. *)
let start_server = Lwt_preemptive.detach update_loop true >>= fun (_) -> return(Lwt_main.run server_req)

let () = ignore start_server

(*let start_server port_num = return (testrec true) >|= (fun (_) -> Lwt_main.run server)*)
