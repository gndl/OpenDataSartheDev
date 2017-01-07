[%%shared
open Eliom_lib
open Eliom_content
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
    ~path:(Eliom_service.Path [])
    ~meth:(Eliom_service.Get Eliom_parameter.unit)
    ()

let () =
  OpenDataSartheDev_app.register
    ~service:main_service
    (fun () () -> Lwt.return(MainView.make ())
);

  Lwt.async EvenementCore.getEvenements;
;;