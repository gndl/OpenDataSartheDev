

let parseXml inputString =
  let reg = Str.regexp"##" in
  let i = Xmlm.make_input (`String(0, inputString)) in

  let parseData data types =
    let rec aux its ots =
      match its with
      | [] -> ots
      | t::ts -> if List.mem t ots then aux ts ots else aux ts (t::ots)
    in 
    aux(Str.split reg data) types
  in
  let rec parseTypeElement types =
    match Xmlm.input i with
    | `Data dt -> (Str.split reg dt)@types
    | `El_end -> types
    | _ -> parseTypeElement types
  in

  let rec parseElement types =
    if Xmlm.eoi i then types
    else
      match Xmlm.input i with
      | `El_start ((_, name), _) when name = "Type" -> parseTypeElement types
      | `El_start ((_, name), _) -> print_endline name; parseElement types
      | _ -> parseElement types
  in
  let rec parse isType types =
    if Xmlm.eoi i then types
    else
      match Xmlm.input i with
      | `El_start ((_, name), _) when name = "Type" -> parse true types
      | `Data dt when isType -> parse false (parseData dt types)
      | _ -> parse false types
  in
  List.sort_uniq String.compare (parse false [])