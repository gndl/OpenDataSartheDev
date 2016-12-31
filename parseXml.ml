module Ev = Evenement
module EvDtl = EvenementDetails


let typeActivite inputString =
  let i = Xmlm.make_input (`String(0, inputString))
  in
  let parseData data types = (To.doubleSharpSplit data) @ types
  in
  let rec parse isType types =
    if Xmlm.eoi i then types
    else
      match Xmlm.input i with
      | `El_start ((_, tag), _) when tag = "Type" -> parse true types
      | `Data dt when isType -> parse false (parseData dt types)
      | _ -> parse false types
  in
  List.sort_uniq String.compare (parse false [])


let activites inputString =
  let i = Xmlm.make_input (`String(0, inputString)) in

  let rec parseProperties elem ev =
    match Xmlm.input i with
    | `El_start ((_, tag), _) -> parseProperties tag ev
    | `Data dt -> (
        match elem with
        | "SyndicObjectID" -> Ev.setId ev dt |> parseProperties elem
        | "Commune" -> Ev.setCommune ev dt |> parseProperties elem
        | "NomOffre" -> Ev.setNameEvenement ev dt |> parseProperties elem
        | _ -> parseProperties elem ev
      )
    | `El_end -> ev
    | _ -> parseProperties elem ev 
  in
  let rec parse activites =
    if Xmlm.eoi i then activites
    else
      match Xmlm.input i with
      |`El_start ((_, tag), _) when tag = "properties" ->
        parseProperties tag Ev.empty :: activites |> parse
      | _ -> parse activites
  in
  parse []


let evenementDetails inputString idEv =
  let i = Xmlm.make_input (`String(0, inputString)) in

  let rec parseProperties elem ed =
    match Xmlm.input i with
    | `El_start ((_, tag), _) -> parseProperties tag ed |> parseProperties elem
    | `Data dt -> (
        match elem with
        | "SyndicObjectID" ->
          if dt = idEv then EvDtl.setId ed dt |> parseProperties elem else ed
        | "Commune" -> EvDtl.setCommune ed dt |> parseProperties elem
        | "NomOffre" -> EvDtl.setNameEvenement ed dt |> parseProperties elem
        | "SyndicObjectName" -> EvDtl.setEntreprise ed dt |> parseProperties elem
        | "GmapLatitude" -> EvDtl.setLattitude ed dt |> parseProperties elem
        | "GmapLongitude" -> EvDtl.setLongitude ed dt |> parseProperties elem
        | "CommMail" -> EvDtl.setMail ed dt |> parseProperties elem
        | "Tarifs" -> EvDtl.setTarif ed dt |> parseProperties elem
        | "Equipements" -> EvDtl.setEquipement ed dt |> parseProperties elem
        | "Adresse1" -> EvDtl.addToAdresse ed dt |> parseProperties elem
        | "Adresse2" -> EvDtl.addToAdresse ed dt |> parseProperties elem
        | "Adresse3" -> EvDtl.addToAdresse ed dt |> parseProperties elem
        | "Adresse1Suite" -> EvDtl.addToAdresse ed dt |> parseProperties elem
        | "CommWeb" -> EvDtl.setSite ed dt |> parseProperties elem
        | "plateformeURL" -> EvDtl.setReseauSociaux ed dt |> parseProperties elem
        | "Services" -> EvDtl.setServices ed dt |> parseProperties elem
        | "CommTel" -> EvDtl.setTel ed dt |> parseProperties elem
        | "CodePostal" -> EvDtl.setCodePostal ed dt |> parseProperties elem
        | "ModePaiement" -> EvDtl.setModePaiement ed dt |> parseProperties elem
        | "TarifGratuit" -> EvDtl.setTarifGratuit ed dt |> parseProperties elem
        | "Acces" -> EvDtl.setAcces ed dt |> parseProperties elem
        | "OuvertureGranule" -> EvDtl.setOuverture ed dt |> parseProperties elem
        | "VideosUrl" -> EvDtl.setVideoUrl ed dt |> parseProperties elem
        | _ -> parseProperties elem ed
      )
    | `El_end -> ed
    | _ -> parseProperties elem ed 
  in
  let rec parse() =
    if Xmlm.eoi i then EvDtl.empty
    else
      match Xmlm.input i with
      |`El_start ((_, tag), _) when tag = "properties" -> (
          let ed = parseProperties tag EvDtl.empty
          in
          if EvDtl.getId ed = idEv then ed else parse()
        )
      | _ -> parse()
  in
  parse()
