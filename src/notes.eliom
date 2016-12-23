let%lwt note_table = Ocsipersist.open_table "notes"

let getNote id =
  try%lwt
    Ocsipersist.find note_table id
  with
    Not_found -> Lwt.return (-1)

let setNote id note = Ocsipersist.add note_table id note

let insertNote id note = Ocsipersist.add note_table id note

let updateNote id note = Ocsipersist.add note_table id note
(*
let () = Eliom_registration.Action.register
  ~service:create_account_service
  (fun () (name, pwd) -> Ocsipersist.add user_table name pwd)

let () = Eliom_registration.Action.register
  ~service:connection_service
  (fun () (name, password) ->
    match%lwt check_pwd name password with
      | true -> Eliom_reference.set username (Some name)
      | false -> Lwt.return ())
      *)