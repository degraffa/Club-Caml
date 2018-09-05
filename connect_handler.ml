open Csv
open State


(* [find_player lst name] finds the player of name name from the list lst (from
   storage CSV),returning Some player if the player exists, else None.
   * requires: [lst] a list from the storage CSV
               [name] the name to be found*)
let find_player lst name =
  List.fold_left
    (fun acc x-> match acc with
       |Some(x)->Some(x)
       |None-> if (List.nth x 0) = name then Some(x) else None)
    None lst
(* [remove_player lst name] removes the player of name name from list lst.
   * requires: [lst] a list from the storage CSV
               [name] the name to be removed*)
let remove_player lst name =
  List.filter (fun x-> if (List.nth x 0) = name then false else true) lst


(* [get_player players name] finds the player of name name from the list lst (from
   State module),returning Some player if the player exists, else None.
   * requires: [lst] a list of players
               [name] the name to be found *)
let rec get_player players name = match players with
  |[]-> None
  |a::b->if a.name = name then Some(a) else get_player b name

(* [login username password players] handles the login for the players, first
   checking if player of name username (with password password) is the in list
   of players. If not, a new player is created and added to the storage CSV.
   * requires: [username] username of the player
               [password] password of the player
               [players] list of players *)
let login username password players =
  let p = get_player players username in
  match p with
  |Some x -> None
  |None ->
    let data = Csv.load "data.csv" in
    let player_info = find_player data username in
    match player_info with
    |Some(data)-> if List.nth data 1 = password then
        Some((List.nth data 2)) else None
    |_->let new_player = "{\"name\" : " ^ "\"" ^ username ^ "\"," ^
       "\"player_color\" : " ^ (string_of_int (Random.int 16777216)) ^ "," ^
       "\"locationx\": 100,
       \"locationy\": 100,
       \"money\": 0,
         \"orientation\": 0}" in
        Csv.save "data.csv" ([username;password;new_player]::data);
          Some((new_player))

(* [logoff username players] handles the logoff for the players. The latest player
   data is stored in the CSV, for the next time they login.
   * requires: [username] username of the player
               [players] list of the players *)
let logoff username players =
  let data = Csv.load "data.csv" in
  let password = begin match find_player data username with
    |Some(x)-> List.nth x 1
    |None-> ""
    end
  in
  let removed = remove_player data username in
  let loggedoff_player = begin match (get_player players username) with
    |Some(x)-> player_to_json x
    |None->"{\"name\" : " ^ "\"" ^ username ^ "\"," ^
             "\"player_color\" : " ^ (string_of_int (Random.int 16777216))^ ","^
             "\"locationx\": 100,
             \"locationy\": 100,
             \"money\": 0,
               \"orientation\": 0}"
    end
  in
  Csv.save "data.csv" ([username;password;loggedoff_player]::removed)
