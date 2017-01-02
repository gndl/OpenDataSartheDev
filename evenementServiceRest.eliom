open Lwt
<<<<<<< HEAD
open Ocsigen_lib
=======
open To
>>>>>>> 5a2d18849c64ffa7bcfc1627269bd992bed39d27

let path p =
  Eliom_service.Path(To.slashSplit("wsopendatasarthedev/rservice/Evenements/" ^ p))

let toResponse rep = Lwt.return(rep, "application/json")

(* Service getTypeEvenements *)
let getTypeEvenementsService = Eliom_registration.String.create
    ~path:(path "typeEvenements")
    ~meth:(Eliom_service.Get Eliom_parameter.unit)
    (fun () () ->
       let%lwt tes = EvenementCore.getTypeEvenement() in
       tes |> TypeEvenement.listToJson |> toResponse)


(* Service searchEvenements *)
let searchEvenementsService = Eliom_registration.String.create
    ~path:(path "search")
    ~meth:(Eliom_service.Get(Eliom_parameter.(suffix(string "type"))))
    (fun typeEv () ->
       let typeEv = Url.decode typeEv in
       let%lwt es = EvenementCore.searchEvenements typeEv in
       es |> Evenement.listToJson |> toResponse)


(* Service getEvenement *)
let getEvenementService = Eliom_registration.String.create
    ~path:(path "")
    ~meth:(Eliom_service.Get(Eliom_parameter.(suffix(string "id"))))
    (fun id () ->
       let%lwt ed = EvenementCore.getEvenement id in
       ed |> EvenementDetails.toJson |> toResponse)


(* Service saveNote *)
let saveNoteService = Eliom_registration.String.create
    ~path:(path "note")
    ~meth:(Eliom_service.Get Eliom_parameter.(suffix(string "id" ** int "note")))
    (fun  (id, note) () ->
       let%lwt () = EvenementCore.saveNote id note in
       "" |> toResponse)
