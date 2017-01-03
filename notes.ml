let%lwt note_table = Ocsipersist.open_table "notes"

let getNote id =
  try%lwt
    Ocsipersist.find note_table id
  with
    Not_found -> Lwt.return (-1)

let setNote id note = Ocsipersist.add note_table id note
