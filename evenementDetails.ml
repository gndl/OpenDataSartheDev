type t = {
  id : string;
  entreprise : string;
  nameEvenement : string;
  typeEvenement : string;
  commune : string;
  lattitude : string;
  longitude : string;
  adresse : string;
  codepotal : string;
  tarif : string;
  tel : string;
  services : string;
  codePostal : string;
  modePaiement : string;
  tarifGratuit : string;
  acces : string;
  ouverture : string;
  mail : string;
  site : string;
  reseauSociaux : string;
  equipement : string;
  videosUrl : string;
  carteOsm : string;
} [@@deriving yojson]

let toJson te = Yojson.Safe.to_string(to_yojson te)

type t_list = t list [@@deriving yojson]

let listToJson eds = Yojson.Safe.to_string(t_list_to_yojson eds)


let empty = {
  id = "";
  entreprise = "";
  nameEvenement = "";
  typeEvenement = "";
  commune = "";
  lattitude = "";
  longitude = "";
  adresse = "";
  codepotal = "";
  tarif = "";
  tel = "";
  services = "";
  codePostal = "";
  modePaiement = "";
  tarifGratuit = "";
  acces = "";
  ouverture = "";
  mail = "";
  site = "";
  reseauSociaux = "";
  equipement = "";
  videosUrl = "";
  carteOsm = "";
}

let make id nameEvenement commune = {empty with id; nameEvenement; commune}

let isOk ed = ed.id <> ""

let getId ed = ed.id
let setId ed id = {ed with id}

let setNameEvenement ed nameEvenement = {ed with nameEvenement}
let getNameEvenement ed = ed.nameEvenement

let setTypeEvenement ed typeEvenement = {ed with typeEvenement}
let getTypeEvenement ed = ed.typeEvenement

let getEquipement ed = ed.equipement
let setEquipement ed equipement = {ed with equipement}

let getLattitude ed = ed.lattitude
let setLattitude ed lattitude = {ed with lattitude}

let getLongitude ed = ed.longitude
let setLongitude ed longitude = {ed with longitude}

let getAdresse ed = ed.adresse
let setAdresse ed adresse = {ed with adresse}
let addToAdresse ed adressePart = {ed with adresse = String.concat " " [ed.adresse; adressePart]}

let getCodepotal ed = ed.codepotal
let setCodepotal ed codepotal = {ed with codepotal}

let getTarif ed = ed.tarif
let setTarif ed tarif = {ed with tarif}

let getTel ed = ed.tel
let setTel ed tel = {ed with tel}

let getServices ed = ed.services
let setServices ed services = {ed with services}

let getCodePostal ed = ed.codePostal
let setCodePostal ed codePostal = {ed with codePostal}

let getModePaiement ed = ed.modePaiement
let setModePaiement ed modePaiement = {ed with modePaiement}

let getTarifGratuit ed = ed.tarifGratuit
let setTarifGratuit ed tarifGratuit = {ed with tarifGratuit}

let getAcces ed = ed.acces
let setAcces ed acces = {ed with acces}

let getOuverture ed = ed.ouverture
let setOuverture ed ouverture = {ed with ouverture}

let getCommune ed = ed.commune
let setCommune ed commune = {ed with commune}

let getMail ed = ed.mail
let setMail ed mail = {ed with mail}

let getSite ed = ed.site
let setSite ed site = {ed with site}

let getReseauSociaux ed = ed.reseauSociaux
let setReseauSociaux ed reseauSociaux = {ed with reseauSociaux}

let getEntreprise ed = ed.entreprise
let setEntreprise ed entreprise = {ed with entreprise}

let getVideosUrl ed = ed.videosUrl
let setVideoUrl ed videosUrl = {ed with videosUrl}

let getCarteOsm ed = ed.carteOsm
let setCarteOsm ed carteOsm = {ed with carteOsm}

let makeCarteOsm ed =
  String.concat "" [
    "<iframe width=\"400\" height=\"350\" frameborder=\"0\" scrolling=\"no\"";
    "marginheight=\"0\" marginwidth=\"0\" src=\"http://cartosm.eu/map?";
    "lon="; ed.longitude;
    "&lat="; ed.lattitude;
    "&zoom=14&width=400&height=350&mark=true&nav=true&pan=true&zb=inout&style=default&icon=down\"></iframe>"
  ]
