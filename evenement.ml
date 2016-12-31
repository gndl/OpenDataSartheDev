type t = {id : string; nameEvenement : string; commune : string; note : int} [@@deriving yojson]

let toJson ev = Yojson.Safe.to_string(to_yojson ev)

type t_list = t list [@@deriving yojson]

let listToJson es = Yojson.Safe.to_string(t_list_to_yojson es)


let make id nameEvenement commune = {id; nameEvenement; commune; note = 0}

let empty = make "" "" ""

let isOk ev = ev.id <> ""

let getId ev = ev.id
let setId ev id = {ev with id}

let getNameEvenement ev = ev.nameEvenement
let setNameEvenement ev nameEvenement = {ev with nameEvenement}

let getCommune ev = ev.commune
let setCommune ev commune = {ev with commune}

let getNote ev = ev.note
let setNote ev note = {ev with note}

