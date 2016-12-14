open Lwt

let url_culturel = "http://wcf.tourinsoft.com/Syndication/3.0/cdt72/969e24f9-75a2-4cc6-a46c-db1f6ebbfe97/Objects"
let url_evenementielle = "http://wcf.tourinsoft.com/Syndication/3.0/cdt72/e9a8e2bf-c933-4831-9ebb-87eec559a21a/Objects"

(* a simple function to access the content of the response *)
let content = function
  | { Ocsigen_http_frame.frame_content = Some v } ->
      Ocsigen_stream.string_of_stream 100000 (Ocsigen_stream.get v)
  | _ -> return ""

let launch () = 
(* launch both requests in parallel *)
Lwt_list.map_p Ocsigen_http_client.get_url
  [ url_culturel; url_evenementielle ]
>>= Lwt_list.map_p content (* maps the result through the content function *)
