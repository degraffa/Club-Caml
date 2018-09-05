open Lwt
open Cohttp
open Cohttp_lwt_unix

let body =

  let body_str = {|{
                   "name":"lord help us",
                   "player_color":69,
                   "locationx":420,
                   "locationy":666,
                   "money":42069,
                   "orientation":3,
                   "player_name":"hehehe69",
                   "color":69,
                   "message":"xd"
                   }|} in

  Client.post ~body:(Cohttp_lwt__Body.of_string body_str) (Uri.of_string "http://localhost:8000") >>= fun (resp, body) ->
  let code = resp |> Response.status |> Code.code_of_status in
  Printf.printf "Response code: %d\n" code;
  Printf.printf "Headers: %s\n" (resp |> Response.headers |> Header.to_string);
  body |> Cohttp_lwt.Body.to_string >|= fun body ->
  Printf.printf "Body of length: %d\n" (String.length body);
  body

let () =
  let body = Lwt_main.run body in
  print_endline ("Received body\n" ^ body)
