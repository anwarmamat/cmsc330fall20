OCAML_VERSION=$(ocaml --version | rev | cut -d' ' -f 1 | rev)
if [ $OCAML_VERSION = '4.11.0' ] ; then
    export OCAMLPATH=dep
else
    echo 'You must have OCaml version 4.11.0 for this project.'
    echo $OCAML_VERSION ' is not valid.'
fi
