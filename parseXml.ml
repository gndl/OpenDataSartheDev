module Ev = Evenement
module EvDtl = EvenementDetails


let typeActivite inputString typePath =
  let typePath = typePath |> To.slashSplit |> List.rev
  in
  let i = Xmlm.make_input (`String(0, inputString))
  in
  let rec parseEv path types =
    match Xmlm.input i with
    | `El_start ((_, tag), _) -> parseEv(tag::path) types |> parseEv path
    | `Data dt when path = typePath -> (To.doubleSharpSplit dt) @ types |> parseEv path
    | `El_end -> types
    | _ -> parseEv path types
  in
  let rec parse lst =
    if Xmlm.eoi i then lst
    else
      match Xmlm.input i with
      |`El_start ((_, tag), _) when tag = "properties" -> parseEv [] lst |> parse
      | _ -> parse lst
  in
  List.sort String.compare (parse [])


let activites inputString =
  let i = Xmlm.make_input (`String(0, inputString))
  in
  let rec parseProperties elem ev =
    match Xmlm.input i with
    | `El_start ((_, tag), _) -> parseProperties tag ev |> parseProperties elem
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


let evenements inputString typePath =
  let typePath = typePath |> To.slashSplit |> List.rev
  in
  let i = Xmlm.make_input (`String(0, inputString)) in

  let rec parseEv path elem ed =
    match Xmlm.input i with
    | `El_start ((_, tag), _) -> parseEv (tag::path) tag ed |> parseEv path elem
    | `Data dt -> (
        match elem with
        | "SyndicObjectID" -> EvDtl.setId ed dt |> parseEv path elem
        | "Commune" -> EvDtl.setCommune ed dt |> parseEv path elem
        | "NomOffre" -> EvDtl.setNameEvenement ed dt |> parseEv path elem
        | "SyndicObjectName" -> EvDtl.setEntreprise ed dt |> parseEv path elem
        | "GmapLatitude" -> EvDtl.setLattitude ed dt |> parseEv path elem
        | "GmapLongitude" -> EvDtl.setLongitude ed dt |> parseEv path elem
        | "CommMail" -> EvDtl.setMail ed dt |> parseEv path elem
        | "Tarifs" -> EvDtl.setTarif ed dt |> parseEv path elem
        | "Equipements" -> EvDtl.setEquipement ed dt |> parseEv path elem
        | "Adresse1" -> EvDtl.addToAdresse ed dt |> parseEv path elem
        | "Adresse2" -> EvDtl.addToAdresse ed dt |> parseEv path elem
        | "Adresse3" -> EvDtl.addToAdresse ed dt |> parseEv path elem
        | "Adresse1Suite" -> EvDtl.addToAdresse ed dt |> parseEv path elem 
        | "CommWeb" -> EvDtl.setSite ed dt |> parseEv path elem
        | "plateformeURL" -> EvDtl.setReseauSociaux ed dt |> parseEv path elem
        | "Services" -> EvDtl.setServices ed dt |> parseEv path elem
        | "CommTel" -> EvDtl.setTel ed dt |> parseEv path elem
        | "CodePostal" -> EvDtl.setCodePostal ed dt |> parseEv path elem
        | "ModePaiement" -> EvDtl.setModePaiement ed dt |> parseEv path elem
        | "TarifGratuit" -> EvDtl.setTarifGratuit ed dt |> parseEv path elem
        | "Acces" -> EvDtl.setAcces ed dt |> parseEv path elem
        | "OuvertureGranule" -> EvDtl.setOuverture ed dt |> parseEv path elem
        | "VideosUrl" -> EvDtl.setVideoUrl ed dt |> parseEv path elem
        | _ -> if path = typePath then EvDtl.setTypeEvenement ed dt else ed
               |> parseEv path elem
      )
    | `El_end -> ed
    | _ -> parseEv path elem ed 
  in
  let rec parse lst =
    if Xmlm.eoi i then lst
    else
      match Xmlm.input i with
      |`El_start ((_, tag), _) when tag = "properties" ->
        (parseEv [] tag EvDtl.empty) :: lst |> parse
      | _ -> parse lst
  in
  parse []
