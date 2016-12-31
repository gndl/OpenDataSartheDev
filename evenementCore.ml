open Lwt
module EvDtl = EvenementDetails

(* Récupère la liste des types d'évènements *)
let getTypeEvenement() =
  let liste1Promise = ClientSourceEvenementielle.getType()  (* Lwt.return []*)
  in
  let liste2Promise = ClientSourceCulturel.getType()
  in
  let%lwt liste1 = liste1Promise in
  let%lwt liste2 = liste2Promise in

  let typeEvenements = Hashtbl.create 100 in

  (* Parcours et comptage des categories d'évenement
     liste 1 *)
  let compteCategories lst = List.iter(fun categorie ->
    let cpt = try Hashtbl.find typeEvenements categorie with Not_found -> 0
    in
    Hashtbl.add typeEvenements categorie (cpt + 1)) lst
  in
  compteCategories liste1;
  compteCategories liste2;

  (* transformation map -> liste finale *)
  Hashtbl.fold(fun text weight tpEvs ->
    (TypeEvenement.make text weight)::tpEvs)
    typeEvenements []
  |> Lwt.return


(* recherche evenements par type. *)
let searchEvenements typeEv =
  (* requete de recherche des events tous les ws par type *)

  (* gestion du caractere a la con *)
  let typeEv = if Str.string_match(Str.regexp "Cale") typeEv 0 then "Cale" else typeEv
  in
  let typeEv = if Str.string_match(Str.regexp "Brocante") typeEv 0 then "Brocantes" else typeEv
  in
  (* ws1 *)
  let listeWs1Promise = ClientSourceEvenementielle.getListeActivite typeEv
  in
  (* ws2 *)
  let listeWs2Promise = ClientSourceCulturel.getListeActivite typeEv
  in
  let%lwt listeWs1 = listeWs1Promise in
  let%lwt listeWs2 = listeWs2Promise in

  (* ajout de la note *)
  Lwt_list.map_s(fun ev ->
    let%lwt note = Notes.getNote(Evenement.getId ev) in
    Evenement.setNote ev note |> Lwt.return
  )
    (listeWs1 @ listeWs2)


(* retourne le detail d'un evenement. *)
let getEvenement id =
  (* requete de tous les ws pour recuperer les infos de l'evenement *)
  (* ws1 *)
  let%lwt ed = ClientSourceEvenementielle.getEvenementDetail id in
  (* ws2 *)
  let%lwt ed = if EvDtl.isOk ed then Lwt.return ed
    else ClientSourceCulturel.getEvenementDetail id
  in
  (* traitement amelioration equipement *)
  let ed = EvDtl.getEquipement ed |> To.noSharp |> EvDtl.setEquipement ed
  in
  (* traitement amelioration modePaiement *) 
  let ed = EvDtl.getModePaiement ed |> To.noSharp |> EvDtl.setModePaiement ed
  in
  (* traitement amelioration acces *)
  let ed = EvDtl.getAcces ed |> To.noSharpPipe |> EvDtl.setAcces ed
  in
  (* traitement amelioration reseauSociaux *)
  let rsx = EvDtl.getReseauSociaux ed
  in
  let ed = if rsx = "" then ed else
      List.fold_left(fun rsx frag -> match To.doublePipeSplit frag with
        | name::url::tl -> rsx ^ (To.htmlLink name url)
        | _ -> rsx ^ frag
      ) "" (To.doubleSharpSplit rsx)
      |> EvDtl.setReseauSociaux ed
  in
  (* traitement amelioration services *)
  let ed = EvDtl.getServices ed |> To.noSharp |> EvDtl.setServices ed
  in
  (* traitement amelioration site *)
  let site = EvDtl.getSite ed
  in
  let ed = if site = "" then ed else To.htmlLink site site |> EvDtl.setSite ed
  in
  (* traitement carte OSM *)
  let ed = EvDtl.makeCarteOsm ed |> EvDtl.setCarteOsm ed
  in
  ed |> Lwt.return


(* enregistrement de la note pour un evenement. *)
let saveNote id note = Notes.setNote id note
