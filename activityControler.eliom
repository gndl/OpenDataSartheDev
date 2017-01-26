[%%client
open Usual

let tagUrl = "http://localhost:8080/wsopendatasarthedev/rservice/Evenements/typeEvenements"
let tagClickedUrl = "http://localhost:8080/wsopendatasarthedev/rservice/Evenements/search/"
let selectionNoteUrl = "http://localhost:8080/wsopendatasarthedev/rservice/Evenements/note/"
let selectionDetailUrl = "http://localhost:8080/wsopendatasarthedev/rservice/Evenements/"

let getCloud () =
  
  let%lwt r = XmlHttpRequest.get tagUrl
  in
  let msg = r.XmlHttpRequest.content in
  Lwt.return msg

let getSelectionResultsFromTagClick tag =

  (log[tag])
]
