open Lwt
open Ocsigen_lib
module Ev = Evenement
module EvDtl = EvenementDetails

let url_culturel = "http://wcf.tourinsoft.com/Syndication/3.0/cdt72/969e24f9-75a2-4cc6-a46c-db1f6ebbfe97/Objects?"
let url_type = url_culturel ^ Url.encode "format=json&select=Type&orderby=Type"

let url_evenementielle = "http://wcf.tourinsoft.com/Syndication/3.0/cdt72/e9a8e2bf-c933-4831-9ebb-87eec559a21a/Objects"


let printList l = Printf.printf"[\n%!"; List.iter(Printf.printf"\t%s\n%!") l; Printf.printf"]\n%!"; l

let getType() =
  Ocsigen_http_client.get_url url_type >>= To.content
  >>= (fun s -> ParseXml.typeActivite s |> Lwt.return)


let getListeActivite typeActivite =
  let url_activite = url_culturel ^ 
                     Url.encode("format=json&select=NomOffre,Commune,SyndicObjectID&filter=indexof(Type,'"
                                ^ typeActivite ^ "') gt -1 ")
  in
  Ocsigen_http_client.get_url url_activite >>= To.content
  >>= (fun s -> ParseXml.activites s |> Lwt.return)


let getEvenementDetail id =
  let uri_ed = Url.encode(String.concat "" [
    "format=json&select=SyndicObjectID,SyndicObjectName,GmapLatitude,GmapLongitude,CommMail,Commune,Tarifs,";
    "Equipements,Adresse2,CommWeb,NomOffre,plateformeURL,Type,Cedex,Adresse1,Adresse3,Services,CommTel,CodePostal,ModePaiement,";
    " Adresse1Suite,TarifGratuit,Acces,OuvertureGranule,VideosUrl&filter=SyndicObjectID eq '"; id; "'"
  ])
  in
  let url_ed = url_culturel ^ uri_ed
  in
  Ocsigen_http_client.get_url url_ed >>= To.content
  >>= (fun s -> ParseXml.evenementDetails s id |> Lwt.return)

