
(* Contains: player name, color, location, money, and direction *)
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

(* Contains: message, player who sent the message, and time of the message *)
type message =
  {
    player_name : string; (*player who sent the message*)
    color: int; (*RGB hex, corresponds to player color*)
    message: string; (*the actual message*)
    time : float; (*used from Unix.gettimeofday *)
  }


(* Contains: list of players, list of recent messages and who said them *)
type state =
  {
    players : player list;
    messages : message list;
  }

(* Returns a new, empty state *)
val new_state : unit -> state

(* Converts state to json that is ready to be outputted by the server *)


(* Given a json object of message updates from the client,
updates the given state and returns a new state object *)
val update_message : message -> state -> state

(* Given a json object of player updates from the client,
   updates the given state and returns a new state object *)
val update_player : player -> state -> state

(*disconnects the player from the state, returning the state without the player*)
val dc_player : state -> string -> state

(*parses the client json request body and returns an appropriate player and
   message object in the form of a pair *)
val parse : Yojson.Basic.json -> (player * message) option

(*updates the state with the new player and message value, if they exist*)
val update : (player * message) option -> state -> state

(*converts the player object, to a json formatted string which can be sent to
  the client *)
val player_to_json : player -> string

(*converts the state object, to a json formatted string which can be sent to
  the client *)
val to_json : state -> string
