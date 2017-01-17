[%%shared
open Eliom_content.Html
open Eliom_content.Html.D
]

let%client onTagCloudClick ev _ =
(*
  let%lwt _ =

  in
  log[Format.sprintf "Mouse down %d %d" ev##clientX ev##clientY];
  Js.Optdef.iter ev##relatedTarget (fun eltOpt ->
    Js.Opt.iter eltOpt (fun elt ->
      if elt##classList##contains "tag" then (
        let tag = elt##textContent
        in
        ActivityControler.getSelectionResultsFromTagClick tag)
      else ()
    ));
    *)
  Lwt.return (Usual.log["onTagCloudClick"])


let%client getElement() =
  let tagCloudElement = div ~a:[a_id "tagCloud"; a_style "margin-top:36px;border:0px solid black;text-align:left;margin-left:auto;margin-right:auto;"] [
    span ~a:[a_class["tag"]] [pcdata "Concert"];
    span ~a:[a_class["tag"]] [pcdata "Spectacle"];
    span ~a:[a_class["tag"]] [pcdata "Cinéma"];
  ]
  in
  Lwt.async (fun () ->
    Lwt_js_events.clicks (To_dom.of_element tagCloudElement) onTagCloudClick
  );

  let button = Form.input ~a:[a_class ["button"]] ~input_type:`Submit
      ~value:"Click for a message in the log!" Form.string
  in
  Lwt.async (fun () ->
    Lwt_js_events.clicks(To_dom.of_element button)
      (fun _ _ ->
         Lwt.return (Usual.log["Aïe dont!"])
      )
  );
  div [
    div ~a:[a_style "background-color:#aa0000;color:white;padding-left:6px;font-size:14px;height:20px;"] [
      div ~a:[a_id "tagWeightContainer"; a_style "display:none;"] [
        span ~a:[a_id "tagWeight"] []; pcdata " résultats pour "; span ~a:[a_id "tagName"] []
      ];
    ];
    div [
      p [button];
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
