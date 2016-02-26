(* TyXML
 * http://www.ocsigen.org/tyxml
 * Copyright (C) 2016 Anton Bachin
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

(** Element child argument assemblers. These are almost parsers, except they
    only tell how to pass already-parsed children to element functions. *)



type assembler =
  string -> Location.t -> string -> Parsetree.expression list ->
    (Asttypes.label * Parsetree.expression) list
(** Assemblers satisfy: [assembler implementation loc name children] evaluates
    to a list of optionally-labeled parse trees for passing [children] to the
    the element function for element [name]. For example, for a table element

{[
<table>
  <thead>
    <tr><th>A</th><th>B</th></tr>
  </thead>
  <tbody>
  </tbody>
</table>
]}

    The assembler [table], when called with the parsed children, will evaluate
    to parse trees representing

{[
~thead:(* the thead element *) [(* the tbody element *)]
]}

    This satisfies the child arguments in the signature of
    [Html5_sigs.T.tablex]. The [~table] label is represented by the string
    ["table"], and the unlabeled list argument is paired with the empty string.

    The argument [implementation] is the name of the module providing the
    run-time implementation of the element function that will be applied to the
    children. It is either [Html5] or [Svg], and is based on the element's
    namespace. It is used for wrapping child elements, and for scoping child
    [pcdata] elements.

    The [name] argument is used for error reporting. *)



(** {2 Generic} *)

val nullary : assembler
val unary : assembler
val star : assembler



(** {2 Special-cased} *)

val html : assembler
val head : assembler
val figure : assembler
val object_ : assembler
val audio_video : assembler
val table : assembler
val fieldset : assembler
val datalist : assembler
val details : assembler
val menu : assembler
