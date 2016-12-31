open Lwt
open Ocsigen_lib

(* a simple function to access the content of the response *)
let content = function
  | { Ocsigen_http_frame.frame_content = Some v } ->
    Ocsigen_stream.string_of_stream Sys.max_string_length (Ocsigen_stream.get v)
  | _ -> Lwt.return "reponse vide"

let file filename str =
  let oc = open_out filename in
  output_string oc str;
  close_out oc

let htmlLink name url = String.concat "" ["<a href=\""; url; "\">"; name; "</a>"]

let regSharp = Str.regexp "#"
let noSharp = Str.global_replace regSharp ""

let regSharpPipe = Str.regexp "[#|]"
let noSharpPipe = Str.global_replace regSharpPipe ""

let regDoubleSharp = Str.regexp "##"
let doubleSharpSplit s = Str.split regDoubleSharp s

let regPipe = Str.regexp "|"
let pipeSplit s = Str.split regPipe s

let regDoublePipe = Str.regexp "||"
let doublePipeSplit s = Str.split regDoublePipe s

let regSlash = Str.regexp "/"
let slashSplit s = Str.split regSlash s
