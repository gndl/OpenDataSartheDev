open Lwt
open Ocsigen_lib

let url_culturel = "http://wcf.tourinsoft.com/Syndication/3.0/cdt72/969e24f9-75a2-4cc6-a46c-db1f6ebbfe97/Objects?"
let url_type = url_culturel ^ Url.encode "format=json&select=Type&orderby=Type"

let url_evenementielle = "http://wcf.tourinsoft.com/Syndication/3.0/cdt72/e9a8e2bf-c933-4831-9ebb-87eec559a21a/Objects"

(* a simple function to access the content of the response *)
let content = function
  | { Ocsigen_http_frame.frame_content = Some v } ->
    Ocsigen_stream.string_of_stream 10000000 (Ocsigen_stream.get v)
  | _ -> Lwt.return "reponse vide"

let write_to filename str =
  let oc = open_out filename in
  output_string oc str;
  close_out oc;
  Lwt.return()

let printList l = Printf.printf"[\n%!"; List.iter(Printf.printf"\t%s\n%!") l; Printf.printf"]\n%!"; l

let launch() =
  let url = url_culturel ^ Url.encode "format=json" in
  print_endline url;
  Ocsigen_http_client.get_url url_culturel >>= content
  >>= (fun s -> print_endline s; Lwt.return())

let getType() =
  print_endline url_type;
  Ocsigen_http_client.get_url url_type >>= content
  >>= (fun s -> TypeActivite.parseXml s |> printList |> Lwt.return)

let getListeActivite typeActivite =
  let url_activite = url_culturel ^ Url.encode("format=json&select=NomOffre,Commune,SyndicObjectID&filter=indexof(Type,'"
                                               ^ typeActivite ^ "') gt -1 ")
  in
  print_endline url_activite;
  Ocsigen_http_client.get_url url_activite >>= content
  >>= (fun s -> print_string s; Lwt.return())

