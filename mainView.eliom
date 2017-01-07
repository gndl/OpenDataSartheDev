[%%shared
open Eliom_lib
open Eliom_content
open Html.D
open Tyxml
]
(*
    (* Bootstrap core JavaScript ------------------------------------------------------------------------- *)
    (* Placed at the end of the document so the pages load faster *)
    script "js/jquery-2.2.0.min.js";
    script ~src "js/bootstrap.min.js";

(* jQCloud ------------------------------------------------------------------------------------------- *)
script ~src "js/jqcloud.js";
link ~rel "stylesheet" ~href "css/jqcloud.css";

(* APPLICATION OPENDATA ------------------------------------------------------------------------------ *)
script ~src "js/opendata.js";
  *)
let title = "OPEND@T@"

let element content =
  Eliom_tools.F.html
    ~title:"OPEND@T@"
    ~css:[["css"; "OpenDataSartheDev.css"]]
    (body [
       div ~a:[a_class["container"]] [
         div ~a:[a_class["headerbar"]] [pcdata title];
         div ~a:[a_id "navbar"; a_class["navbar"]] [];

       div ~a:[a_id"content"] [content];
     ]
    ])