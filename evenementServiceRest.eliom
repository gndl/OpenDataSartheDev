open Lwt
open Ocsigen_lib

let path p =
  Eliom_service.Path(To.slashSplit("wsopendatasarthedev/rservice/Evenements/" ^ p))

let toResponse rep = Lwt.return(rep, "application/json")

(* Service getTypeEvenements *)
let getTypeEvenements = Eliom_registration.String.create
    ~path:(path "typeEvenements")
    ~meth:(Eliom_service.Get Eliom_parameter.unit)
    (fun () () ->
       let%lwt tes = EvenementCore.getTypeEvenement() in
       tes |> TypeEvenement.listToJson |> toResponse)


(* Service searchEvenements *)
let searchEvenements = Eliom_registration.String.create
    ~path:(path "search")
    ~meth:(Eliom_service.Get(Eliom_parameter.(suffix(string "type"))))
    (fun typeEv () ->
       let typeEv = Url.decode typeEv in
       let%lwt es = EvenementCore.searchEvenements typeEv in
       es |> Evenement.listToJson |> toResponse)


(* Service getEvenement *)
let getEvenement = Eliom_registration.String.create
    ~path:(path "")
    ~meth:(Eliom_service.Get(Eliom_parameter.(suffix(string "id"))))
    (fun id () ->
       let%lwt ed = EvenementCore.getEvenement id in
       ed |> EvenementDetails.toJson |> toResponse)


(* Service saveNote *)
let saveNote = Eliom_registration.String.create
    ~path:(path "note")
    ~meth:(Eliom_service.Get Eliom_parameter.(suffix(string "id" ** int "note")))
    (fun  (id, note) () ->
       let%lwt () = EvenementCore.saveNote id note in
       "" |> toResponse)


let () = Lwt.async EvenementCore.getEvenements
