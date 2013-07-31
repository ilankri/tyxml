# TypedXML

TyXML allows you to build XML trees whose validity is ensured by the typechecker.
It's based on a traduction of XML types into polymorphic variants, originally written by Thorsten Ohl.
Currently, the transcription has been done for XHTML 1.0 and 1.1, HTML5 and SVG (partial).

TyXML also provides a generic printer and some low-level (and untyped) iterators over XML trees.
The printer has options for printing XHTML in more browser-friendly way when served as `"text/html"` (instead of `"text/xml"`).
HTML5 is always printed with those options.

All modules provided by TyXML are also provided in functorial interface, where every module is parameterised by the underlying XML representation.

A camlp4 extension, named `Pa_tyxml`, allows to write HTML pages or HTML fragments with the usual syntax.
For creating HTML5-, XHTML-, or SVG-nodes, the syntax extension relies on the presence of a module called Html5, Xhtml, or Svg which keeps the actual implementation, e.g.
```ocaml
let module Html5 = Eliom_content.Html5.F in
<:html5< <div>xyz</div> >>
```

You can find the documentation [here](http://ocsigen.org/tyxml/api/).

## How to

### Installation

tyxml is available in [opam](http://opam.ocamlpro.com) : `opam install tyxml`

You can also use the ocsigen opam repository for the dev version :
`opam repository add opamocsigen http://ocsigen.org/opam`

### Manual build

#### Requirements:
* ocaml and camlp4
* findlib
* ocamlduce (optional)

#### Build instructions:
```
${EDITOR} Makefile.config
make
make install
```

#### API documentation:
```
make doc
${BROWSER} doc/api-html/index.html
```
