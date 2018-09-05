open Yojson.Basic.Util
open Pervasives

type player =
{
  name : string;
  player_color: int; (*RGB hex*)
  locationx: int;
  locationy: int;
  money: int;
  orientation: int; (*from 0 to 7, where each number represents 45 degrees of
                      rotation*)
}

type message =
{
  player_name : string; (*player who sent the message*)
  color: int; (*RGB hex, corresponds to player color*)
  message: string; (*the actual message*)
  time : float; (*used from Unix.gettimeofday *)
}

type state =
{
  players : player list;
  messages : message list;
}


(* [parse_player updatePlayer] parses the JSON for a player update, and
   returns a player object.
 * requires: [updatePlayer] a JSON file representing the player updates.*)
let parse_player updatePlayer =
{
  name = updatePlayer |> member "name" |> to_string;
  player_color = updatePlayer |> member "player_color" |> to_int;
  locationx = updatePlayer |> member "locationx" |> to_int;
  locationy = updatePlayer |> member "locationy" |> to_int;
  money = updatePlayer |> member "money" |> to_int ;
  orientation = updatePlayer |> member "orientation" |> to_int;
}

(* [parse_message updateMessage] parses the JSON for a new message, and
   returns a message object.
 * requires: [updatePlayer] a JSON file representing a new message.*)
let parse_message updateMessage  =
  {
    player_name = updateMessage |> member "player_name" |> to_string;
    color = updateMessage |> member "color" |> to_int;
    message = updateMessage |> member "message" |> to_string;
    time = Unix.gettimeofday ();
  }

(* [parse update] parses the client JSON for a new message and player update, and
   returns Some pair, if the JSON is valid, and None if the JSON is invalid.
 * requires: [update] a JSON file representing a client request.*)
let parse update =
  try Some((parse_player update, parse_message update)) with
  |_ -> print_string "dawdawdawd";let x = {
    player_name = "test5";
    color = 5000000;
    message ="";
    time = Unix.gettimeofday ();
  } in Some((parse_player update, x))

(* [update_message_helper msg_list msg acc flag] adds the message if the player
   has not sent a message, or updates the message text such that each player has
   at most 1 message
 * requires: [msg_list] list of messages to update
             [msg] the new message
             [acc] an internal accumulator
            [flag] used to check if a player has a messge.*)
let rec update_message_helper msg_list msg acc flag =
  match msg_list with
  |[] -> if flag then acc else msg::acc
  |h::t -> if (h.player_name = msg.player_name) then update_message_helper t msg
        ({h with message =  msg.message; time= msg.time}::acc) true else
      update_message_helper t msg (h::acc) false

(* [update_message update old_state] adds the new message to old_state, returning
   a new state object.
 * requires: [update] a message object
             [old_state] the state prior to the new message.*)
let update_message (update:message) old_state : state =
  if update.message <> "" then
    {old_state with
     messages = (update_message_helper old_state.messages update [] false)}
  else old_state


(* [update_player update old_state] updates old_state with the details of the
   player from update.
 * requires: [update] a player object
             [old_state] the state prior to the player update.*)
let update_player (update:player) old_state : state =
  {old_state with players =
    update::List.fold_left (fun x y-> if (update.name = y.name) then x else y::x)
  [] old_state.players}

(* [update update_state old_state] updates old_state with the updates from
   update_state.
 * requires: [update_state] a message, player option, containing a valid player
              and message object or none
             [old_state] the state prior to the update.*)
let update update_state old_state =
match update_state with
|Some (p_update, m_update)-> update_message m_update old_state |> update_player p_update
|None -> old_state

(* [clean_messages old_state] clears all messages that are over 300 seconds old.
 * requires: [old_state] the state prior to cleansing.*)
let clean_messages old_state =
  {old_state with messages =
  List.fold_left (fun x y-> if (Unix.gettimeofday () -. y.time > 300.0) then x else y::x)
    [] old_state.messages}

(* [dc_player old_state playername] disconnects players that have logged out
   by deleting the player with name username from old_state
 * requires: [old_state] the state prior deleting the player.
 *           [playername] the name of the player that is logging out*)
let dc_player old_state playername =
  {old_state with players = List.filter (fun x-> x.name <> playername) old_state.players}


(* [stringify convert lst acc] converts a list into a string, formatted as a
   JSON array.
 * requires: [convert] a conversion function, which converts each object of the
              list to an appropriate JSON formatted string
             [lst] the list to be converted.
             [acc] the accumulator (should be empty on first call)*)
let rec stringify convert lst acc = match lst with
  |[]-> if String.length acc < 1 then "[]"
    else "["^(String.sub acc 0 (String.length acc-1))^"]"
  |a::b-> stringify convert b (convert a)^","^acc

(* [player_to_json player] converts a player object to a JSON formatted string.
   * requires: [player] a valid player object *)
let player_to_json player =
  {|{"name":|}^"\""^player.name^"\""^
  {|,"player_color":|}^(string_of_int player.player_color)^
  {|,"locationx":|}^(string_of_int player.locationx)^
  {|,"locationy":|}^(string_of_int player.locationy)^
  {|,"money":|}^(string_of_int player.money)^
  {|,"orientation":|}^(string_of_int player.orientation)^"}"

(* [players_to_json plist acc] converts a player list to a JSON formatted array
   of players.
   * requires: [plist] a valid player list
               [acc] an accumulator (should be blank on first call)*)
let rec players_to_json plist acc = match plist with
  |[]->acc
  |a::[]-> (players_to_json [] acc^(player_to_json a))
  |a::b-> (players_to_json b acc^","^(player_to_json a))

(* [message_to_json message] converts a message object to a JSON formatted string.
   * requires: [message] a valid message object *)
let message_to_json message =
  {|{"player_name":|}^"\""^message.player_name^"\""^
  {|,"color":|}^(string_of_int message.color)^
  {|,"message":|}^"\""^message.message^"\""^
  {|,"time":|}^(string_of_float message.time)^"0}"

(* [messages_to_json mlist acc] converts a message list to a JSON formatted array
   of messages.
   * requires: [mlist] a valid message list
               [acc] an accumulator (should be blank on first call)*)
let rec messages_to_json mlist acc = match mlist with
  |[]->acc
  |a::[]-> (messages_to_json [] acc^(message_to_json a))
  |a::b-> (messages_to_json b acc^","^(message_to_json a))

(* [to_json old_state] converts a state object to a JSON formatted string.
   * requires: [old_state] a valid state object *)
let to_json old_state =
  "{"^
  {|"players":[|}^(players_to_json old_state.players "") ^ "],"^
  {|"messages":[|}^(messages_to_json old_state.messages "")^"]"^
"}"

let new_state () = {players = []; messages = [];}
