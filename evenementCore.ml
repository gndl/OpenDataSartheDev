open Lwt
module EvDtl = EvenementDetails

let cacheTypesEvenement = ref None
let cacheEvenements = ref None
let cacheEvenementsDetails = ref None


let makeCacheTypesEvenement categories =

  let typesWeights = Hashtbl.create 100
  in
  (* Parcours et comptage des categories d'évenement *)
  let compteCategorie categorie =
    let cpt = try Hashtbl.find typesWeights categorie with Not_found -> 0
    in
    Hashtbl.replace typesWeights categorie (cpt + 1)
  in
  List.iter compteCategorie categories;

  (* transformation map -> liste finale *)
  let tes = Hashtbl.fold(fun text weight tes ->
    (TypeEvenement.make text weight)::tes
  )
    typesWeights []
  in
  cacheTypesEvenement := Some tes;
  tes


(* Récupère la liste des types d'évènements *)
let getTypeEvenement() =

  match !cacheTypesEvenement with
  | Some tes -> Lwt.return tes
  | None ->
    let%lwt liste1 = ClientSourceEvenementielle.getType() in
    let%lwt liste2 = ClientSourceCulturel.getType() in

    makeCacheTypesEvenement(liste1 @ liste2) |> Lwt.return


let makeEvenements evs =
  (* ajout de la note *)
  Lwt_list.map_s(fun ev ->
    let%lwt note = Notes.getNote(Evenement.getId ev) in
    Evenement.setNote ev note |> Lwt.return
  ) evs


(* recherche evenements par type. *)
let searchEvenements typeEv =

  match !cacheEvenements with
  | Some evs -> (try Hashtbl.find evs typeEv with Not_found -> []) |> Lwt.return
  | None ->
    (* gestion du caractere a la con *)
    let typeEv = if Str.string_match(Str.regexp "Cale") typeEv 0 then "Cale" else typeEv
    in
    let typeEv = if Str.string_match(Str.regexp "Brocante") typeEv 0 then "Brocantes" else typeEv
    in
    (* requete de recherche des events tous les ws par type *)
    (* ws1 *)
    let listeWs1Promise = ClientSourceEvenementielle.getListeActivite typeEv
    in
    (* ws2 *)
    let listeWs2Promise = ClientSourceCulturel.getListeActivite typeEv
    in
    let%lwt listeWs1 = listeWs1Promise in
    let%lwt listeWs2 = listeWs2Promise in

    makeEvenements(listeWs1 @ listeWs2)


let makeCacheEvenements evenementsDetails =
  let evenements = Hashtbl.create 100
  in
  let%lwt () = Lwt_list.iter_s(fun ed ->

    let id, name, commune, typeEv =
      EvDtl.(getId ed, getNameEvenement ed, getCommune ed, getTypeEvenement ed)
    in
    let%lwt note = Notes.getNote id
    in
    let ev = Evenement.make id name commune note
    in
    let evLst = try Hashtbl.find evenements typeEv with Not_found -> []
    in
    Hashtbl.replace evenements typeEv (ev::evLst);
    Lwt.return()
  )
    evenementsDetails
  in
  cacheEvenements := Some evenements;
  Lwt.return()


let amelioreEvenement ed =
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
  ed


(* retourne le detail d'un evenement. *)
let getEvenement id =
  match !cacheEvenementsDetails with
  | Some eds -> Lwt.return(try Hashtbl.find eds id with Not_found -> EvDtl.empty)
  | None ->
    (* requete de tous les ws pour recuperer les infos de l'evenement *)
    (* ws1 *)
    let%lwt ed = ClientSourceEvenementielle.getEvenementDetail id in
    (* ws2 *)
    let%lwt ed = if EvDtl.isOk ed then Lwt.return ed
      else ClientSourceCulturel.getEvenementDetail id
    in
    ed |> amelioreEvenement |> Lwt.return


let makeCacheEvenementsDetails evenementsDetails =
  let eds = Hashtbl.create 100
  in
  List.iter(fun ed -> Hashtbl.add eds (EvDtl.getId ed) ed)
    evenementsDetails;

  cacheEvenementsDetails := Some eds


(* Récupère la liste des évènements *)
let getEvenements() =

  let listeWs1Promise = ClientSourceEvenementielle.getEvenements() in
  let listeWs2Promise = ClientSourceCulturel.getEvenements()
  in
  let%lwt listeWs1 = listeWs1Promise in
  let%lwt listeWs2 = listeWs2Promise in

  let evenementsDetails = listeWs1 @ listeWs2
  in
  let categories = List.map(fun ed -> EvDtl.getTypeEvenement ed)
      evenementsDetails
  in
  makeCacheTypesEvenement categories |> ignore;

  makeCacheEvenementsDetails evenementsDetails;

  makeCacheEvenements evenementsDetails


(* enregistrement de la note pour un evenement. *)
let saveNote id note = Notes.setNote id note

