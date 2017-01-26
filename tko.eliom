[%%client
module Html = Dom_html

let js = Js.string
let doc = Html.window##.document
(*let doc = Html.document*)
let page = doc##.documentElement


let float_input name value =
  let res = doc##createDocumentFragment in
  Dom.appendChild res (doc##createTextNode(js name));
  let input = Html.createInput ~_type:(js"text") doc in
  input##.value := js(string_of_float !value);
  input##.onchange := Html.handler
      (fun _ ->
         begin try
             value := float_of_string (Js.to_string (input##.value))
           with Invalid_argument _ ->
             ()
         end;
         input##.value := js(string_of_float !value);
         Js._false);
  Dom.appendChild res input;
  res


let button name callback =
  let input = Html.createInput ~_type:(js"submit") doc in
  input##.value := js name;
  input##.onclick := Html.handler callback;
  Eliom_content.Html.Of_dom.of_input input


let div id ?onclick children =
  let div = Html.createDiv doc in
  div##.id := js id;
  List.iter(fun e ->
    Dom.appendChild div (Eliom_content.Html.To_dom.of_element e))
    children;

  ignore(match onclick with
      None -> ()
    | Some f -> div##.onclick := Html.handler f);

  Eliom_content.Html.Of_dom.of_div div



let create_canvas w h =
  let c = Html.createCanvas doc in
  c##.width := w;
  c##.height := h;
  c


]