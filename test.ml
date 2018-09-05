open OUnit2
open State
open Yojson

(*The following objects are example player, message, and state objects to be
  used in the unit tests. The are used to compare the json files we parsed
  (found in /test_resources) and to test state updates.*)
let player1 = {
  name="test1";
  player_color = 1000000;
  locationx = 0;
  locationy = 0;
  money = 100;
  orientation = 1;}

let player2 = {
  name="test2";
  player_color = 2000000;
  locationx = 100;
  locationy = 100;
  money = 200;
  orientation = 2;}

let player3 = {
  name="test3";
  player_color = 3000000;
  locationx = 150;
  locationy = 150;
  money = 300;
  orientation = 3;}

let player4 = {
  name="test4";
  player_color = 4000000;
  locationx = 200;
  locationy = 200;
  money = 400;
  orientation = 4;}

let player5 = {
  name="test5";
  player_color = 5000000;
  locationx = 250;
  locationy = 250;
  money = 500;
  orientation = 5;}

let msg1 = {
  player_name = "test1";
  color = 1000000;
  message ="msg1";
  time = Unix.gettimeofday ();
}

let msg2 = {
  player_name = "test2";
  color = 2000000;
  message ="msg2";
  time = Unix.gettimeofday ();
}
let msg3 = {
  player_name = "test3";
  color = 3000000;
  message ="msg3";
  time = Unix.gettimeofday ();
}
let msg4 = {
  player_name = "test4";
  color = 4000000;
  message ="msg4";
  time = Unix.gettimeofday ();

}
let msg5 = {
  player_name = "test5";
  color = 5000000;
  message ="msg5";
  time = Unix.gettimeofday ();

}
let blank_msg = {
  player_name = "test5";
  color = 5000000;
  message ="";
  time = Unix.gettimeofday ();
}

let state1 = {
  players =[player1];
  messages = [msg1;msg2;msg3];
}
let state1_2 = {
  players =[player1;player2];
  messages = [msg1;msg2;msg3];
}
let state1_3 = {
  players =[player1;player2];
  messages = [msg4;msg1;msg2;msg3];
}

let state2 = {
  players =[player1;player2];
  messages = [];
}

let state2_1 = {
  players =[player1;player2];
  messages = [msg1];
}

let state2_2 = {
  players =[player1;player2];
  messages = [msg2;msg1];
}

let state2_3 = {
  players =[player1;player2];
  messages = [msg3;msg2;msg1];
}
let state3 = {
  players =[player1;player2;player3];
  messages = [];
}
let state3_1 = {
  players =[player1;player2;player3];
  messages = [];
}
let state3_2 = {
  players =[player1;player2;player3];
  messages = [msg3;msg2;msg1];
}
let state4 = {
  players =[player1;player2;player3];
  messages = [msg3];
}
let state5 = {
  players =[];
  messages = [msg1;msg2;msg3];
}

let json1 = Yojson.Basic.from_file "test_resources/test1.txt"
let json2 = Yojson.Basic.from_file "test_resources/test2.txt"
let json3 = Yojson.Basic.from_file "test_resources/test3.txt"
let json4 = Yojson.Basic.from_file "test_resources/test4.txt"
let json5 = Yojson.Basic.from_file "test_resources/test5.txt"
let json_blank () = Yojson.Basic.from_file "test_resources/test_blank.txt"
let json_e1 () = Yojson.Basic.from_file "test_resources/test_error1.txt"
let json_e2 ()= Yojson.Basic.from_file "test_resources/test_error2.txt"
let json_e3 () = Yojson.Basic.from_file "test_resources/test_error3.txt"

(* let state1_json = "{\"players\":[{\"name\":\"test1\",\"player_color\":1000000,\"locationx\":0,\"locationy\":0,\"money\":100,\"orientation\":1}],\"messages\":[{\"player_name\":\"test3\",\"color\":3000000,\"message\":\"msg3\",\"time\":1526346856.76},{\"player_name\":\"test2\",\"color\":2000000,\"message\":\"msg2\",\"time\":1526346856.76},{\"player_name\":\"test1\",\"color\":1000000,\"message\":"msg1","time":1526346856.76}]}" *)
let state1_json = "{\"players\":[{\"name\":\"test1\",\"player_color\":1000000,\"locationx\":0,\"locationy\":0,\"money\":100,\"orientation\":1}],\"messages\":[{\"player_name\":\"test3\",\"color\":3000000,\"message\":\"msg3\",\"time\":1526346856.76},{\"player_name\":\"test2\",\"color\":2000000,\"message\":\"msg2\",\"time\":1526346856.76},{\"player_name\":\"test1\",\"color\":1000000,\"message\":\"msg1\",\"time\":1526346856.76}]}"
let state2_json = "{\"players\":[{\"name\":\"test2\",\"player_color\":2000000,\"locationx\":100,\"locationy\":100,\"money\":200,\"orientation\":2},{\"name\":\"test1\",\"player_color\":1000000,\"locationx\":0,\"locationy\":0,\"money\":100,\"orientation\":1}],\"messages\":[]}"
let state3_json = "{\"players\":[{\"name\":\"test3\",\"player_color\":3000000,\"locationx\":150,\"locationy\":150,\"money\":300,\"orientation\":3},{\"name\":\"test2\",\"player_color\":2000000,\"locationx\":100,\"locationy\":100,\"money\":200,\"orientation\":2},{\"name\":\"test1\",\"player_color\":1000000,\"locationx\":0,\"locationy\":0,\"money\":100,\"orientation\":1}],\"messages\":[]}"
let state4_json = "{\"players\":[{\"name\":\"test3\",\"player_color\":3000000,\"locationx\":150,\"locationy\":150,\"money\":300,\"orientation\":3},{\"name\":\"test2\",\"player_color\":2000000,\"locationx\":100,\"locationy\":100,\"money\":200,\"orientation\":2},{\"name\":\"test1\",\"player_color\":1000000,\"locationx\":0,\"locationy\":0,\"money\":100,\"orientation\":1}],\"messages\":[{\"player_name\":\"test3\",\"color\":3000000,\"message\":\"msg3\",\"time\":1526346856.76}]}"
let state5_json = "{\"players\":[],\"messages\":[{\"player_name\":\"test3\",\"color\":3000000,\"message\":\"msg3\",\"time\":1526346856.76},{\"player_name\":\"test2\",\"color\":2000000,\"message\":\"msg2\",\"time\":1526346856.76},{\"player_name\":\"test1\",\"color\":1000000,\"message\":\"msg1\",\"time\":1526346856.76}]}"

(*This function tests equality between two messages. It is required due to the
fact messages have an automatic time stamp, which makes direct equality difficult.*)
let message_eq m1 m2 =
  if (m1.player_name = m2.player_name) && (m1.color = m2.color) && (m1.message = m2.message)
  then true else false

(*This function tests equality between the results of parse and a state. It mainly
exists due to the fact parse returns an option pair.*)
let match_json (p1,m1) j2 =
  match j2 with
  |None -> false
  |Some (p2,m2) -> (p1 = p2) && (message_eq m1 m2)

(*This function tests equality between two lists of players. This is required as
  players may be in different orders, which does not affect the player object.*)
let player_eq p1 p2 =
  List.for_all (fun a -> List.mem a p2) p1

  (*This function tests equality between two lists of message. This is required as
    players may be in different orders, which does not affect the player object.*)
  let rec msg_eq m1 m2 =
    match m1 with
    |[] -> true
    |h::t -> if (List.exists (fun a -> message_eq h a) m2) then msg_eq t m2 else false


(*This function tests equality between two states using the earlier player and
  message list equality functions.*)
let match_state s1 s2 =
  try
    ((player_eq s1.players s2.players && (List.for_all2 (fun a b -> message_eq a b) s1.messages s2.messages))||
     (player_eq s1.players s2.players && (msg_eq s1.messages s2.messages)))
  with |_ -> false

(*These tests test whether or not the parse function accurately converts json to
  an appropriate state object. Additionally, there are tests on inccorect json files
in order to check whether they are deemed as incorrect.*)
let json_parse_tests =
  [
    "json_parse1" >:: (fun _ -> assert_equal true ((match_json (player1, msg1)) (parse json1)));
    "json_parse2" >:: (fun _ -> assert_equal true ((match_json (player2, msg2)) (parse json2)));
    "json_parse3" >:: (fun _ -> assert_equal true ((match_json (player3, msg3)) (parse json3)));
    "json_parse4" >:: (fun _ -> assert_equal true ((match_json (player4, msg4)) (parse json4)));
    "json_parse5" >:: (fun _ -> assert_equal true ((match_json (player5, msg5)) (parse json5)));
    "json_parse_blank" >:: (fun _ -> assert_equal false ((match_json (player2, msg2)) (parse (json_blank ()))));
    "json_parse_e1" >:: (fun _ -> assert_equal false ((match_json (player2, msg2)) (parse (json_e1 ()))));
    "json_parse_e2" >:: (fun _ -> assert_equal false ((match_json (player2, msg2)) (parse (json_e2 ()))));
    "json_parse_e2" >:: (fun _ -> assert_equal false ((match_json (player2, msg2)) (parse (json_e3 ()))));
  ]

let to_json_tests =[
  "to_json1" >:: (fun _ -> assert_equal (parse (Yojson.Basic.from_string (state1_json))) (parse (Yojson.Basic.from_string (to_json state1))));
  "to_json2" >:: (fun _ -> assert_equal (parse (Yojson.Basic.from_string (state2_json))) (parse (Yojson.Basic.from_string (to_json state2))));
  "to_json3" >:: (fun _ -> assert_equal (parse (Yojson.Basic.from_string (state3_json))) (parse (Yojson.Basic.from_string (to_json state3))));
  "to_json4" >:: (fun _ -> assert_equal (parse (Yojson.Basic.from_string (state4_json))) (parse (Yojson.Basic.from_string (to_json state4))));
  "to_json5" >:: (fun _ -> assert_equal (parse (Yojson.Basic.from_string (state5_json))) (parse (Yojson.Basic.from_string (to_json state5))));
  "to_json_fail1" >:: (fun _ -> assert_equal (parse (Yojson.Basic.from_string (state1_json))) (parse (Yojson.Basic.from_string (to_json state2))));
  "to_json_fail2" >:: (fun _ -> assert_equal (parse (Yojson.Basic.from_string (state2_json))) (parse (Yojson.Basic.from_string (to_json state3))));
  "to_json_fail3" >:: (fun _ -> assert_equal (parse (Yojson.Basic.from_string (state3_json))) (parse (Yojson.Basic.from_string (to_json state1))));
  "to_json_fail4" >:: (fun _ -> assert_equal (parse (Yojson.Basic.from_string (state2_json))) (parse (Yojson.Basic.from_string (to_json state1))));
]


(*These tests test whether or not the update and disconnect functions work correctly.
  They cover a great variety of scenarios. First, individual message and player update
  functions are tested. This includes corner cases such as adding blank messages
  (which should not be stored) or updating with the same player object (no change
  should happen to the state). Then the overall update function is tested, using
  option pairs. This is essentially combining the above two tests and making sure
  the state reacts appropriately. Finally, there are some tests which test disconnect
  player functions, to make sure the right thing happens.*)
let update_state_tests = [
  "state_blank_msg1" >:: (fun _ -> assert_equal true (match_state state1 (update_message blank_msg state1)));
  "state_blank_msg2" >:: (fun _ -> assert_equal true (match_state state2 (update_message blank_msg state2)));
  "state_blank_msg3" >:: (fun _ -> assert_equal true (match_state state5 (update_message blank_msg state5)));
  "state_add_player1" >:: (fun _ -> assert_equal true (match_state state1_2 (update_player player2 state1)));
  "state_add_player2" >:: (fun _ -> assert_equal true (match_state state1 (update_player player1 state5)));
  "state_add_player3" >:: (fun _ -> assert_equal true (match_state state3 (update_player player3 state2)));
  "state_add_player4" >:: (fun _ -> assert_equal false (match_state state2 (update_player player2 state1)));
  "state_add_msg1" >:: (fun _ -> assert_equal true (match_state state2_1 (update_message msg1 state2)));
  "state_add_msg2" >:: (fun _ -> assert_equal true (match_state state2_2 (update_message msg2 state2_1)));
  "state_add_msg3" >:: (fun _ -> assert_equal true (match_state state2_3 (update_message msg3 state2_2)));
  "state_add_msg4" >:: (fun _ -> assert_equal false (match_state state4 (update_message msg3 state2_3)));
  "state_add_msg5" >:: (fun _ -> assert_equal false (match_state state1 (update_message msg3 state4)));
  "state_update1" >:: (fun _ -> assert_equal true (match_state state4 (update (Some (player3,msg3)) state2)));
  "state_update2" >:: (fun _ -> assert_equal true (match_state state1 (update (Some (player1,blank_msg)) state5)));
  "state_update3" >:: (fun _ -> assert_equal true (match_state state1_3 (update (Some (player2,msg4)) state1_2)));
  "state_update4" >:: (fun _ -> assert_equal true (match_state state3 (update (Some (player2,blank_msg)) state3)));
  "state_update5" >:: (fun _ -> assert_equal true (match_state state3_1 (update (Some (player1,blank_msg)) state3)));
  "state_update6" >:: (fun _ -> assert_equal false (match_state state4 (update (Some (player2,msg4)) state1_3)));
  "state_update7" >:: (fun _ -> assert_equal false (match_state state5 (update (Some (player1,msg2)) state4)));
  "state_update7" >:: (fun _ -> assert_equal false (match_state state1 (update (Some (player4,msg5)) state4)));
  "state_update8" >:: (fun _ -> assert_equal false (match_state state1 (update None state4)));
  "state_update9" >:: (fun _ -> assert_equal true (match_state state4 (update None state4)));
  "state_update9" >:: (fun _ -> assert_equal false (match_state state2 (update None state1_3)));
  "state_disconnect1" >:: (fun _ -> assert_equal true (match_state state1 (dc_player state1_2 "player1")));
  "state_disconnect2" >:: (fun _ -> assert_equal true (match_state state2_3 (dc_player state3_2 "player1")));
  "state_disconnect3" >:: (fun _ -> assert_equal false (match_state state2 (dc_player state4 "player1")));
  "state_disconnect4" >:: (fun _ -> assert_equal false (match_state state1 (dc_player state5 "player1")));
]


let suite =
  "State Tests"
  >:::List.flatten [
    json_parse_tests;
    to_json_tests;
    update_state_tests;
    ]

let _ = run_test_tt_main suite
