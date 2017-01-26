[%%client
open Eliom_content.Html
open Eliom_content.Html.D


let onTagCloudClick ev _ =

  Usual.log["onTagCloudClick"];
  (try
     match Dom.eventTarget ev |> Dom_html.CoerceTo.element |> Js.Opt.to_option with
     | None -> Usual.log["Not element"]; ()
     | Some elt ->
       if Js.to_bool (elt##.classList##contains (Js.string "tag")) then (
         match elt##.textContent |> Js.Opt.to_option with
         | None -> Usual.log["Not content"]; ()
         | Some tag ->
           ActivityControler.getSelectionResultsFromTagClick (Js.to_string tag)
       )
       else ()
   with Not_found -> Usual.log["Not_found"]; ())
  |> Lwt.return


let onCloudClick ev =

  Usual.log["onCloudClick"];
  try
     match Dom.eventTarget ev |> Dom_html.CoerceTo.element |> Js.Opt.to_option with
     | None -> Usual.log["Not element"]; Js._true
     | Some elt ->
       if Js.to_bool (elt##.classList##contains (Js.string "tag")) then (
         match elt##.textContent |> Js.Opt.to_option with
         | None -> Usual.log["Not content"]; Js._true
         | Some tag ->
           ActivityControler.getSelectionResultsFromTagClick (Js.to_string tag);
           Js._false
       )
       else Js._true
   with Not_found -> Usual.log["Not_found"]; Js._true


let getElement() =
  let tagCloudElement = div ~a:[a_id "tagCloud"; a_style "margin-top:36px;border:0px solid black;text-align:left;margin-left:auto;margin-right:auto;"] [
    div ~a:[a_class["tag"]] [pcdata "Concert"];
    span ~a:[a_class["tag"]] [pcdata "Spectacle"];
    span ~a:[a_class["tag"]] [pcdata "Cinéma"];
  ]
  in
  Lwt.async (fun () ->
    Lwt_js_events.clicks (To_dom.of_element tagCloudElement) onTagCloudClick
  );

  let cloudElement = Tko.div "cloud"
  ~onclick:onCloudClick [
    div ~a:[a_class["tag"]] [pcdata "Concert"];
    span ~a:[a_class["tag"]] [pcdata "Spectacle"];
    span ~a:[a_class["tag"]] [pcdata "Cinéma"];
  ]
  in
  div [
    div ~a:[a_style "background-color:#aa0000;color:white;padding-left:6px;font-size:14px;height:20px;"] [
      div ~a:[a_id "tagWeightContainer"; a_style "display:none;"] [
        span ~a:[a_id "tagWeight"] []; pcdata " résultats pour "; span ~a:[a_id "tagName"] []
      ];
    ];
    div [
      cloudElement;
      tagCloudElement;
      div ~a:[a_id "results"; a_style "display:none;margin-left:36px;"] [
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

]
