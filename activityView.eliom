open Eliom_content.Html.D

let element =
  div [
    div ~a:[a_style "background-color:#aa0000;color:white;padding-left:6px;font-size:14px;height:20px;"] [
      div ~a:[a_id "tagWeightContainer"; a_style "display:block;"] [
        span ~a:[a_id "tagWeight"] []; pcdata "&nbsp;résultats pour&nbsp"; span ~a:[a_id "tagName"] []
      ]
    ];
    div ~a:[a_id "tagCloud"; a_style "margin-top:36px;border:0px solid black;text-align:left;margin-left:auto;margin-right:auto;"] [
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
    ]
  ]
