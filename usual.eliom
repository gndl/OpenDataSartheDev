[%%shared
]
module%shared L = ListLabels
module%shared S = String
module%shared A = struct
	include ArrayLabels
	
	let add a e = append a [|e|]
	
	let sup a i =
		let newLen = length a - 1 in
		
		if i = 0 then sub a 1 newLen
		else if i = newLen then sub a 0 newLen
		else append(sub a 0 i) (sub a (i + 1) (newLen - i))
		
end

let%shared default d = function
  | None -> d
  | Some v -> v


let%shared mini (x:int) (y:int) = if x < y then x else y
let%shared maxi (x:int) (y:int) = if x > y then x else y
let%shared minf (x:float) (y:float) = if x < y then x else y
let%shared maxf (x:float) (y:float) = if x > y then x else y

let%shared ini (min:int) (v:int) (max:int) = if v < min then min else if v > max then max else v
let%shared inf (min:float) (v:float) (max:float) = if v < min then min else if v > max then max else v


let%shared soi i = string_of_int i
let%shared ios s = int_of_string s
let%shared sof f = string_of_float f
let%shared fos s = float_of_string s
let%shared sob b = string_of_bool b
let%shared soc c = S.make 1 c
let%shared sol l = S.concat "" l

let%shared foi i = float_of_int i
let%shared iof f = int_of_float f

let%shared coi i = char_of_int i
let%shared ioc c = int_of_char c


let%shared pi = 4.0 *. atan 1.0
let%shared pi2 = 2. *. pi
let%shared piOn2 = pi /. 2.
let%shared mPi = -.pi
let%shared mPiOn2 = -.pi /. 2.

(* Degree of Radian *)
let%shared dor r = (r *. 180.) /. pi

(* Radian of Degree *)
let%shared rod d = (d *. pi) /. 180.

(* Angle of float *)
let%shared aof f = if f < 0. then f +. pi2 else if f > pi2 then f -. pi2 else f

(* standard angle *)
let%shared stdA a = if a <= (-.pi) then a +. pi2 else if a > pi then a -. pi2 else a
let%shared stdAoc x y = stdA(atan2 y x)
let%shared stdRA x y d = stdA((atan2 y x) -. d)
(*
type cartesianCoordinates_t = {x : float; y : float}
let%shared originCartesianCoordinates = {x = 0.; y = 0.}

type cartesianVector_t = {p1 : cartesianCoordinates_t; p2 : cartesianCoordinates_t}
let%shared originCartesianSegment = {p1 = originCartesianCoordinates; p2 = originCartesianCoordinates}


(* distance, angle *)
type polarCoordinates_t = {d:float; a:float}
let%shared originPolarCoordinates = {d = 0.; a = 0.}
 *)

let%client js = Js.string

module%client Html = Dom_html
(*
let%client doc = Dom_html.window##document
*)
type canvas_t = Dom_html.canvasElement Js.t
type canvasContext_t = Dom_html.canvasRenderingContext2D Js.t
(*type webglContext_t = WebGL.renderingContext Js.t Js.opt*)
type webglContext_t = WebGL.renderingContext Js.t

let%client startChrono msg = Firebug.console##time(js msg)
let%client stopChrono msg = Firebug.console##timeEnd(js msg)
let%client log msg = Firebug.console##log(js (sol msg))
(*
let log msg = ()
let startChrono msg = ()
let stopChrono msg = ()
*)

let%client error f = Printf.ksprintf (fun s -> Firebug.console##error (Js.string s); failwith s) f
let%client debug f = Printf.ksprintf (fun s -> Firebug.console##log(Js.string s)) f
let%client alert f = Printf.ksprintf (fun s -> Dom_html.window##alert(Js.string s); failwith s) f
