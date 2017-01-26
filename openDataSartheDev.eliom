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

let%shared title = "OPEND@T@"

let _ =
  OpenDataSartheDev_app.register
    ~service:main_service
    (fun () () ->
       let _ = [%client (
         MainView.setContent(ActivityView.getElement())
         : unit)
       ] in
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
  Eliom_client.onload(fun () -> 
    (*  Dom_html.window##alert(Js.string "Eliom_client.onload");
        MainView.setContent(ActivityView.getElement())
    *)
    () )
]
