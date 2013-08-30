(* TyXML
 * http://www.ocsigen.org/tyxml
 * Copyright (C) 2004 Thorsten Ohl <ohl@physik.uni-wuerzburg.de>
 * Copyright (C) 2011 Pierre Chambart, Grégoire Henry
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
 * Foundation, Inc., 51 Franklin Street, Suite 500, Boston, MA 02111-1307, USA.
 *)


module type Wraper = sig
  type 'a t
  val bind : 'a t -> ('a -> 'b t) -> 'b t
  val return : 'a -> 'a t
end

module NoWrap : Wraper with type 'a t = 'a

module type Wraped = sig

  module W : Wraper

  type uri
  val string_of_uri : uri -> string
  val uri_of_string : string -> uri

  type aname = string
  type event_handler

  type attrib

  val float_attrib : aname -> float W.t -> attrib
  val int_attrib : aname -> int W.t -> attrib
  val string_attrib : aname -> string W.t -> attrib
  val space_sep_attrib : aname -> string list W.t -> attrib
  val comma_sep_attrib : aname -> string list W.t -> attrib
  val event_handler_attrib : aname -> event_handler -> attrib
  val uri_attrib : aname -> uri W.t -> attrib
  val uris_attrib : aname -> uri list W.t -> attrib

  type elt
  type ename = string

  val empty : unit -> elt
  val comment : string -> elt

  val pcdata : string W.t -> elt
  val encodedpcdata : string W.t -> elt
  val entity : string -> elt

  val leaf : ?a:(attrib list) -> ename -> elt
  val node : ?a:(attrib list) -> ename -> elt list W.t -> elt

  val cdata : string -> elt
  val cdata_script : string -> elt
  val cdata_style : string -> elt

end

module type T = Wraped with module W := NoWrap

module type Iterable = sig

  include T

  type separator = Space | Comma

  val aname : attrib -> aname

  type acontent = private
    | AFloat of float
    | AInt of int
    | AStr of string
    | AStrL of separator * string list
  val acontent : attrib -> acontent

  type econtent = private
    | Empty
    | Comment of string
    | EncodedPCDATA of string
    | PCDATA of string
    | Entity of string
    | Leaf of ename * attrib list
    | Node of ename * attrib list * elt list
  val content : elt -> econtent

end

module type Info = sig
  val content_type: string
  val alternative_content_types: string list
  val version: string
  val standard: string
  val namespace: string
  val doctype: string
  val emptytags: string list
end

module type Output = sig
  type out
  type m
  val empty: m
  val concat: m -> m -> m
  val put: string -> m
  val make: m -> out
end

module type Typed_xml = sig

  module Xml : T
  module Info : Info

  type 'a elt
  type doc
  val toelt : 'a elt -> Xml.elt
  val doc_toelt : doc -> Xml.elt

end

module type Iterable_typed_xml = sig

  module Xml : Iterable
  module Info : Info

  type 'a elt
  type doc
  val toelt : 'a elt -> Xml.elt
  val doc_toelt : doc -> Xml.elt

end

module type Printer = sig

  type xml_elt
  type out

  val print_list: ?encode:(string -> string) -> xml_elt list -> out

end

module type Simple_printer = sig

  type xml_elt

  val print_list:
    output:(string -> unit) ->
    ?encode:(string -> string) ->
    xml_elt list -> unit

end

module type Typed_printer = sig

  type 'a elt
  type doc
  type out

  val print_list: ?encode:(string -> string) -> 'a elt list -> out
  val print: ?encode:(string -> string) -> ?advert:string-> doc -> out

end


module type Typed_simple_printer = sig

  type 'a elt
  type doc

  val print_list:
    output:(string -> unit) ->
    ?encode:(string -> string) ->
    'a elt list -> unit

  val print:
    output:(string -> unit) ->
    ?encode:(string -> string) -> ?advert:string->
    doc -> unit

end
