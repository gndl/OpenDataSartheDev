[%%shared
open Usual
]

let%client getSelectionResultsFromTagClick tag = ()
(*
  log[tag]
              let%lwt _ =
                Ot_popup.popup
                  ~close_button:[ Os_icons.F.close () ]
                  (fun _ -> Lwt.return @@ p [pcdata tag])
              in
              Lwt.return ()
              *)