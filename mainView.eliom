[%%shared
open Eliom_lib
open Eliom_content
open Eliom_content.Html
open Eliom_content.Html.F
open Tyxml
open Usual
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

let%shared container_id = "main_view_content_container_id"


let%shared getElement title =
  body [
    nav ~a:[a_class["navbar"; "navbar-inverse"; "navbar-fixed-top"]] [
      div ~a:[a_class["container"]] [
        div ~a:[a_class["navbar-header"]] [
          div ~a:[a_class["navbar-brand"]] [pcdata title]
        ];
        div ~a:[a_id "navbar"; a_class["collapse"; "navbar-collapse"]] [];
      ]
    ];
    div ~a:[a_id container_id] []
  ]

let%client setContent content =
  Dom.appendChild(Dom_html.getElementById container_id) (To_dom.of_element content)
