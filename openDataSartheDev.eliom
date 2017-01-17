[%%shared
open Eliom_lib
open Eliom_content
open Eliom_content.Html
open Html.D
]

module OpenDataSartheDev_app =
  Eliom_registration.App (
  struct
    let application_name = "OpenDataSartheDev"
    let global_data_path = None
  end)

let main_service =
  Eliom_service.create
    ~path:(Eliom_service.Path ["od"])
    ~meth:(Eliom_service.Get Eliom_parameter.unit)
    ()

(* Make service available on the client 
let%client main_service = ~%main_service
*)
let%shared title = "OPEND@T@"

let _ =
  OpenDataSartheDev_app.register
    ~service:main_service
    (fun () () ->
       Lwt.return(Eliom_tools.D.html
                    ~title
                    ~css:[["css"; "bootstrap.min.css"];
                          ["css"; "starter-template.css"];
                          ["css"; "jqcloud.css"];
                         ]
                    (MainView.getElement title)
    ))

[%%client
let () =
  Eliom_client.onload(fun () -> MainView.setContent(ActivityView.getElement()))
]
