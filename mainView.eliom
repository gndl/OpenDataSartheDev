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
let make () =
  Eliom_tools.F.html
    ~title:"OPEND@T@"
    ~css:[["css"; "OpenDataSartheDev.css"]; ["css"; "js/jquery-2.2.0.min.js"]]
    (body [
      nav ~a:[a_class["navbar"; "navbar-inverse"; "navbar-fixed-top"]] [
        div ~a:[a_class["container"]] [
          div ~a:[a_class["navbar-header"]] [
            button ~a:[a_class["button"; "navbar-toggle collapsed" (*data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar"*)]]
              [
                pcdata"c'est quoi ce bouton?"
            (*
            span ~a:[a_class["sr-only"](*Toggle navigation*)];
            span ~a:[a_class["icon-bar"]];
            span ~a:[a_class["icon-bar"]];
            span ~a:[a_class["icon-bar"]];
            *)
              ];
          (*
          a ~a:[a_class["navbar-brand"]] []
          *)
          ];
          div ~a:[a_id "navbar"; a_class["collapse"; "navbar-collapse"]] []
        ]
      ];
      div ~a:[a_style "background-color:#aa0000;color:white;padding-left:6px;font-size:14px;height:20px;"] [
        div ~a:[a_id "tagWeightContainer"; a_style "display:none;"] [
          span ~a:[a_id "tagWeight"] []; pcdata "&nbsp;résultats pour&nbsp"; span ~a:[a_id "tagName"] []
        ]
      ];

      div [
        div ~a:[a_id "tagCloud"; a_style "margin-top:36px;border:0px solid black;text-align:left;margin-left:auto;margin-right:auto;"] [pcdata ""];
          div ~a:[a_id "results"; a_style (*display:none;*)"margin-left:36px;"] [
          div ~a:[a_id "selectedTag"] [
            div ~a:[a_style "border-bottom:2px solid grey;"] [
              h3 ~a:[a_id "selectedTagTitle"; a_style "color:#808080"] []
            ];
            table ~a:[a_class["table"]; a_id "resultsTable"] [
(*    thead [ *)
                tr ~a:[a_style "background-color:#aa0000;color:white;border-left:4px solid #800000;"] [
                  th [pcdata "#"];
                  th [pcdata "Nom"]; 
                  th [pcdata "Ville"]; 
                  th ~a:[a_style "width:170px;"] [pcdata "Note"]
               (* ] *)
              ];
  (*            tbody ~a:[a_id "resultsTbody"] []*)
            ]
          ]
        ]
      ];
    ]
    )