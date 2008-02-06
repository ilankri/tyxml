(* Ocsigen
 * http://www.ocsigen.org
 * Module Eliompredefmod
 * Copyright (C) 2007 Vincent Balat
 * Laboratoire PPS - CNRS Université Paris Diderot
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, with linking exception; 
 * either version 2.1 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *)

(** This modules contains predefined modules for generating forms and
   registering handlers, for several types of pages:
   XHTML pages typed with polymorphic variants,
   untyped (text) pages, actions, redirections, files ...
 *)

open XHTML.M
open Xhtmltypes
open Extensions
open Eliomsessions
open Eliomservices
open Eliomparameters
open Eliommkforms
open Eliommkreg


(** The signature of such modules. *)
module type ELIOMSIG = sig
  include Eliommkreg.ELIOMREGSIG
  include Eliommkforms.ELIOMFORMSIG
end


(** {2 Module for registering Xhtml pages typed with polymorphic variants using {!XHTML.M}} *)

(** {3 Creating links and forms} *)

module type XHTMLFORMSSIG = sig


  open XHTML.M
  open Xhtmltypes

(** {2 Links and forms} *)

  val make_string_uri :
      service:('get, unit, [< get_service_kind ],
               [< suff ], 'gn, unit, 
               [< registrable ]) service ->
                 sp:Eliomsessions.server_params -> 
                   ?fragment:string ->
                     'get -> string
(** Creates the string corresponding to the URL of a service applied to
    its GET parameters.
 *)

  val a :
      ?a:a_attrib attrib list ->
        service:
          ('get, unit, [< get_service_kind ], 
           [< suff ], 'gn, 'pn,
           [< registrable ]) service ->
           sp:Eliomsessions.server_params -> ?fragment:string -> 
             a_content elt list -> 'get -> [> a] XHTML.M.elt
(** [a service sp cont ()] creates a link to [service]. 
   The text of
   the link is [cont]. For example [cont] may be something like
   [[pcdata "click here"]]. 

   The last  parameter is for GET parameters.
   For example [a service sp cont (42,"hello")]

   The [~a] optional parameter is used for extra attributes 
   (see the module XHTML.M).

   The [~fragment] optional parameter is used for the "fragment" part
   of the URL, that is, the part after character "#".
 *)

  val css_link : ?a:(link_attrib attrib list) ->
    uri:uri -> unit ->[> link ] elt
(** Creates a [<link>] tag for a Cascading StyleSheet (CSS). *)

  val js_script : ?a:(script_attrib attrib list) ->
    uri:uri -> unit -> [> script ] elt
(** Creates a [<script>] tag to add a javascript file *)

    val make_uri :
        service:('get, unit, [< get_service_kind ],
         [< suff ], 'gn, unit, 
         [< registrable ]) service ->
          sp:Eliomsessions.server_params -> ?fragment:string -> 'get -> uri
(** Create the text of the service. Like the [a] function, it may take
   extra parameters. *)


    val get_form :
        ?a:form_attrib attrib list ->
          service:('get, unit, [< get_service_kind ],
           [<suff ], 'gn, 'pn, 
           [< registrable ]) service ->
             sp:Eliomsessions.server_params -> ?fragment:string ->
              ('gn -> form_content elt list) -> [>form] elt
(** [get_form service sp formgen] creates a GET form to [service]. 
   The content of
   the form is generated by the function [formgen], that takes the names
   of the service parameters as parameters. *)

    val post_form :
      ?a:form_attrib attrib list ->
      service:('get, 'post, [< post_service_kind ],
               [< suff ], 'gn, 'pn, 
               [< registrable ]) service ->
      sp:Eliomsessions.server_params -> 
      ?fragment:string ->
      ?keep_get_na_params:bool ->
      ('pn -> form_content elt list) -> 'get -> [>form] elt
(** [post_form service sp formgen] creates a POST form to [service]. 
   The last parameter is for GET parameters (as in the function [a]).
 *)

(** {2 Form widgets} *)

  type basic_input_type =
      [
    | `Hidden
    | `Password
    | `Submit
    | `Text ]

  val int_input :
      ?a:input_attrib attrib list -> input_type:[< basic_input_type ] ->
        ?name:[< int setoneopt ] param_name -> 
          ?value:int -> unit -> [> input ] elt
(** Creates an [<input>] tag for an integer *)

  val float_input :
      ?a:input_attrib attrib list -> input_type:[< basic_input_type ] ->
        ?name:[< float setoneopt ] param_name -> 
          ?value:float -> unit -> [> input ] elt
(** Creates an [<input>] tag for a float *)

  val string_input : 
      ?a:input_attrib attrib list -> input_type:[< basic_input_type ] ->
        ?name:[< string setoneopt ] param_name -> 
          ?value:string -> unit -> [> input ] elt
(** Creates an [<input>] tag for a string *)

  val user_type_input : 
      ?a:input_attrib attrib list -> input_type:[< basic_input_type ] ->
        ?name:[< 'a setoneopt ] param_name -> 
          ?value:'a -> ('a -> string) -> [> input ] elt
(** Creates an [<input>] tag for a user type *)

  val raw_input :
      ?a:input_attrib attrib list -> 
        input_type:[< basic_input_type | `Reset | `Button ] ->
        ?name:string -> ?value:string -> unit -> [> input ] elt
(** Creates an untyped [<input>] tag. You may use the name you want
   (for example to use with {!Eliomparameters.any}).
 *)

  val file_input :
      ?a:input_attrib attrib list -> 
        name:[< file_info setoneopt ] param_name -> 
          unit -> [> input ] elt
(** Creates an [<input>] tag for sending a file *)

  val image_input :
      ?a:input_attrib attrib list -> 
        name:[< coordinates oneopt ] param_name -> 
          ?src:uri -> unit -> [> input ] elt
(** Creates an [<input type="image" name="...">] tag that sends the coordinates 
   the user clicked on *)
            
  val int_image_input :
      ?a:input_attrib attrib list -> 
        name:[< (int * coordinates) oneopt ] param_name -> value:int -> 
          ?src:uri -> unit -> [> input ] elt
(** Creates an [<input type="image" name="..." value="...">] tag that sends
   the coordinates the user clicked on and a value of type int *)

  val float_image_input :
      ?a:input_attrib attrib list -> 
        name:[< (float * coordinates) oneopt ] param_name -> value:float -> 
          ?src:uri -> unit -> [> input ] elt
(** Creates an [<input type="image" name="..." value="...">] tag that sends
    the coordinates the user clicked on and a value of type float *)

  val string_image_input :
      ?a:input_attrib attrib list -> 
        name:[< (string * coordinates) oneopt ] param_name -> value:string -> 
          ?src:uri -> unit -> [> input ] elt
(** Creates an [<input type="image" name="..." value="...">] tag that sends
   the coordinates the user clicked on and a value of type string *)

  val user_type_image_input :
      ?a:input_attrib attrib list -> 
        name:[< ('a * coordinates) oneopt ] param_name -> value:'a -> 
          ?src:uri -> ('a -> string) -> [> input ] elt
(** Creates an [<input type="image" name="..." value="...">] tag that sends
   the coordinates the user clicked on and a value of user defined type *)

  val raw_image_input :
      ?a:input_attrib attrib list -> 
        name:string -> value:string -> ?src:uri -> unit -> [> input ] elt
(** Creates an [<input type="image" name="..." value="...">] tag that sends
   the coordinates the user clicked on and an untyped value *)


  val bool_checkbox :
      ?a:input_attrib attrib list -> ?checked:bool -> 
        name:[ `One of bool ] param_name -> unit -> [> input ] elt
(** Creates a checkbox [<input>] tag that will have a boolean value.
   The service must declare a [bool] parameter.
 *)

    val int_checkbox :
        ?a:input_attrib attrib list -> ?checked:bool -> 
          name:[ `Set of int ] param_name -> value:int -> 
            unit -> [> input ] elt
(** Creates a checkbox [<input>] tag that will have an int value.
   Thus you can do several checkboxes with the same name 
   (and different values). 
   The service must declare a parameter of type [set].
 *)

    val float_checkbox :
        ?a:input_attrib attrib list -> ?checked:bool -> 
          name:[ `Set of float ] param_name -> value:float -> 
            unit -> [> input ] elt
(** Creates a checkbox [<input>] tag that will have a float value.
   Thus you can do several checkboxes with the same name 
   (and different values). 
   The service must declare a parameter of type [set].
 *)


    val string_checkbox :
        ?a:input_attrib attrib list -> ?checked:bool -> 
          name:[ `Set of string ] param_name -> value:string -> 
            unit -> [> input ] elt
(** Creates a checkbox [<input>] tag that will have a string value.
   Thus you can do several checkboxes with the same name 
   (and different values). 
   The service must declare a parameter of type [set].
 *)


    val user_type_checkbox :
        ?a:input_attrib attrib list -> ?checked:bool -> 
          name:[ `Set of 'a ] param_name -> value:'a -> 
            ('a -> string) -> [> input ] elt
(** Creates a checkbox [<input>] tag that will have a "user type" value.
   Thus you can do several checkboxes with the same name 
   (and different values). 
   The service must declare a parameter of type [set].
 *)


    val raw_checkbox :
        ?a:input_attrib attrib list -> ?checked:bool -> 
          name:string -> value:string -> unit -> [> input ] elt
(** Creates a checkbox [<input>] tag with untyped content.
   Thus you can do several checkboxes with the same name 
   (and different values). 
   The service must declare a parameter of type [any].
 *)




  val string_radio : ?a:(input_attrib attrib list ) -> ?checked:bool -> 
    name:[ `Opt of string ] param_name -> value:string -> unit -> [> input ] elt
(** Creates a radio [<input>] tag with string content *)

  val int_radio : ?a:(input_attrib attrib list ) -> ?checked:bool -> 
     name:[ `Opt of int ] param_name -> value:int -> unit -> [> input ] elt
(** Creates a radio [<input>] tag with int content *)

  val float_radio : ?a:(input_attrib attrib list ) -> ?checked:bool -> 
     name:[ `Opt of float ] param_name -> value:float -> unit -> [> input ] elt
(** Creates a radio [<input>] tag with float content *)

  val user_type_radio : ?a:(input_attrib attrib list ) -> ?checked:bool ->
    name:[ `Opt of 'a ] param_name -> value:'a -> ('a -> string) -> [> input ] elt
(** Creates a radio [<input>] tag with user_type content *)

  val raw_radio : ?a:(input_attrib attrib list ) -> ?checked:bool -> 
    name:string -> value:string -> unit -> [> input ] elt
(** Creates a radio [<input>] tag with untyped string content (low level) *)


  type button_type =
      [ `Button | `Reset | `Submit ]

  val string_button : ?a:button_attrib attrib list -> 
    name:[< string setone ] param_name -> value:string -> 
      button_content elt list -> [> button ] elt
(** Creates a [<button>] tag with string content *)

  val int_button : ?a:button_attrib attrib list ->
    name:[< int setone ] param_name -> value:int -> 
      button_content elt list -> [> button ] elt
(** Creates a [<button>] tag with int content *)

  val float_button : ?a:button_attrib attrib list ->
    name:[< float setone ] param_name -> value:float -> 
      button_content elt list -> [> button ] elt
(** Creates a [<button>] tag with float content *)

  val user_type_button : ?a:button_attrib attrib list ->
    name:[< 'a setone ] param_name -> value:'a -> ('a -> string) ->
      button_content elt list -> [> button ] elt
(** Creates a [<button>] tag with user_type content *)

  val raw_button : ?a:button_attrib attrib list ->
    button_type:[< button_type ] ->
      name:string -> value:string -> 
        button_content elt list -> [> button ] elt
(** Creates a [<button>] tag with untyped string content *)

  val button : ?a:button_attrib attrib list ->
    button_type:[< button_type ] ->
      button_content elt list -> [> button ] elt
(** Creates a [<button>] tag with no value. No value is sent. *)



  val textarea : 
      ?a:textarea_attrib attrib list ->
        name:[< string setoneopt ] param_name -> 
          ?value:Xhtmltypes.pcdata XHTML.M.elt -> 
            rows:int -> cols:int -> 
              unit -> [> textarea ] elt
(** Creates a [<textarea>] tag *)

  val raw_textarea : 
      ?a:textarea_attrib attrib list ->
        name:string -> 
          ?value:Xhtmltypes.pcdata XHTML.M.elt -> 
            rows:int -> cols:int -> 
              unit -> [> textarea ] elt
(** Creates a [<textarea>] tag for untyped form *)

  type 'a soption =
      Xhtmltypes.option_attrib XHTML.M.attrib list
        * 'a (* Value to send *)
        * pcdata elt option (* Text to display (if different from the latter) *)
        * bool (* selected *)
        
  type 'a select_opt = 
    | Optgroup of 
        [ common | `Disabled ] XHTML.M.attrib list
          * string (* label *)
          * 'a soption
          * 'a soption list
    | Option of 'a soption
          
  (** The type for [<select>] options and groups of options.
     - The field of type 'a in [soption] is the value that will be sent 
     by the form. 
     - If the [pcdata elt option] is not present it is also the
     value displayed.
     - The string in [select_opt] is the label
   *)

  val int_select :
      ?a:select_attrib attrib list ->
        name:[< `One of int ] param_name ->
          int select_opt ->
            int select_opt list ->
              [> select ] elt
(** Creates a [<select>] tag for int values. *)

  val float_select :
      ?a:select_attrib attrib list ->
        name:[< `One of float ] param_name ->
          float select_opt ->
            float select_opt list ->
              [> select ] elt
(** Creates a [<select>] tag for float values. *)

  val string_select :
      ?a:select_attrib attrib list ->
        name:[< `One of string ] param_name ->
          string select_opt ->
            string select_opt list ->
              [> select ] elt
(** Creates a [<select>] tag for string values. *)

  val user_type_select :
      ?a:select_attrib attrib list ->
        name:[< `One of 'a ] param_name ->
          'a select_opt ->
            'a select_opt list ->
              ('a -> string) ->
                [> select ] elt
(** Creates a [<select>] tag for user type values. *)

  val raw_select :
      ?a:select_attrib attrib list ->
        name:string ->
          string select_opt ->
            string select_opt list ->
              [> select ] elt
(** Creates a [<select>] tag for any (untyped) value. *)


  val int_multiple_select :
      ?a:select_attrib attrib list ->
        name:[< `Set of int ] param_name ->
          int select_opt ->
            int select_opt list ->
              [> select ] elt
(** Creates a [<select>] tag for int values. *)

  val float_multiple_select :
      ?a:select_attrib attrib list ->
        name:[< `Set of float ] param_name ->
          float select_opt ->
            float select_opt list ->
              [> select ] elt
(** Creates a [<select>] tag for float values. *)

  val string_multiple_select :
      ?a:select_attrib attrib list ->
        name:[< `Set of string ] param_name ->
          string select_opt ->
            string select_opt list ->
              [> select ] elt
(** Creates a [<select>] tag for string values. *)

  val user_type_multiple_select :
      ?a:select_attrib attrib list ->
        name:[< `Set of 'a ] param_name ->
          'a select_opt ->
            'a select_opt list ->
              ('a -> string) ->
                [> select ] elt
(** Creates a [<select>] tag for user type values. *)

  val raw_multiple_select :
      ?a:select_attrib attrib list ->
        name:string ->
          string select_opt ->
            string select_opt list ->
              [> select ] elt
(** Creates a [<select>] tag for any (untyped) value. *)


end

(** {3 Forms and registration functions} *)

      (** Eliom forms and service registration functions for XHTML *)
module Xhtml : sig

  include Eliommkreg.ELIOMREGSIG with type page = xhtml elt
  include XHTMLFORMSSIG

end

(** {3 Module to register subpages of type [block]} *)

module Blocks : sig

  include Eliommkreg.ELIOMREGSIG with type page = body_content elt list
  include XHTMLFORMSSIG

end
  (** Use this module for example for XMLHttpRequests for block tags (e.g. <div>) *)


(** {3 Functor to create modules to register subpages for other subtypes of XHTML} *)

module SubXhtml : functor (T : sig type content end) ->
  sig
    
    include Eliommkreg.ELIOMREGSIG with type page = T.content elt list
    include XHTMLFORMSSIG
    
  end




(** {2 Untyped pages} *)

(** {3 Module to create forms and register untyped HTML pages} *)
module HtmlText : ELIOMSIG with 
type page = string
and type form_content_elt = string
and type form_content_elt_list = string
and type form_elt = string 
and type a_content_elt = string 
and type a_content_elt_list = string 
and type a_elt = string 
and type a_elt_list = string 
and type div_content_elt = string 
and type div_content_elt_list = string 
and type uri = string 
and type link_elt = string 
and type script_elt = string 
and type textarea_elt = string 
and type select_elt = string 
and type input_elt = string 
and type pcdata_elt = string 
and type a_attrib_t = string 
and type form_attrib_t = string 
and type input_attrib_t = string 
and type textarea_attrib_t = string 
and type select_attrib_t = string 
and type link_attrib_t = string 
and type script_attrib_t = string 
and type input_type_t = string 

(** {3 Module to register untyped CSS pages} *)
module CssText : Eliommkreg.ELIOMREGSIG with type page = string

(** {3 Module to register untyped text pages} *)
module Text : Eliommkreg.ELIOMREGSIG with type page = string * string
(** The first string is the content, the second is the content type,
 for example "text/html" *)

(** {2 Other kinds of services} *)

(** Actions do not generate any page. They do something, 
   then the page is reloaded (if it was a coservice or a service with
   POST parmeters).
   Actions return a list of exceptions. 
   You may use this to give information to the handler that will be called
   to reload the page.
   Use {!Eliomsessions.get_exn} to access these exceptions from this handler.
 *)
module Actions : Eliommkreg.ELIOMREGSIG with 
  type page = exn list

(** Like actions, but the page is not reloaded. Just do something and do
   not generate any page.
 *)
module Unit : Eliommkreg.ELIOMREGSIG with 
  type page = unit

(** Allows to create redirections towards other URLs.
   A 301 code is sent to the browser to ask it to redo the request to
   another URL.
 *)
module Redirections : Eliommkreg.ELIOMREGSIG with 
  type page = string

(** Allows to create temporary redirections towards other URLs.
   A 302 code is sent to the browser to ask it to redo the request to
   another URL.
 *)
module TempRedirections : Eliommkreg.ELIOMREGSIG with 
  type page = string

(** Allows to send files. The content is the name of the file to send. *)
module Files : Eliommkreg.ELIOMREGSIG with 
  type page = string

(** Allows to create services that choose dynamically what they want
   to send. The content is created using one {!Eliommkreg.ELIOMREGSIG1.send}
   function, for ex [Xhtml.send] or [Files.send].
   .
 *)
module Any : Eliommkreg.ELIOMREGSIG with 
  type page = Eliomservices.result_to_send

(** Allows to send raw data using Ocsigen's streams.
    The content is a pair conatining:

    - a list of functions returning a stream and the
    function to close it,
    - the  content type string to send. 

    Streams are opened by calling the functions in the list, and closed
    automatically by a call to the closing function.
    If something goes wrong, the current stream is closed,
    and the following are not opened.
 *)
module Streamlist : Eliommkreg.ELIOMREGSIG with 
  type page = (((unit -> string Ocsistream.t Lwt.t) list) * 
                 string)

