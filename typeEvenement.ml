type t = {text : string; weight : int} [@@deriving yojson]

let toJson te = Yojson.Safe.to_string(to_yojson te)

type t_list = t list [@@deriving yojson]

let listToJson tes = Yojson.Safe.to_string(t_list_to_yojson tes)


let make text weight = {text; weight}

let empty = make "" 0

let getText te = te.text
let setText te text = {te with text}

let getWeight te = te.weight
let setWeight te weight = {te with weight}
