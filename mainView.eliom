[%%shared
open Eliom_lib
open Eliom_content
open Html.F
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
    ~css:[["css"; "bootstrap.min.css"];
          ["css"; "starter-template.css"];
          ["css"; "jqcloud.css"];
         ]
    (body [
       nav ~a:[a_class["navbar"; "navbar-inverse"; "navbar-fixed-top"]] [
         div ~a:[a_class["container"]] [
           div ~a:[a_class["navbar-header"]] [
             div ~a:[a_class["navbar-brand"]] [pcdata title]
           ];
           div ~a:[a_id "navbar"; a_class["collapse"; "navbar-collapse"]] [];
         ]
       ];
       div ~a:[a_id"content"] [content]
     ])
