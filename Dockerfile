FROM fedora:37

RUN dnf -y --setopt=install_weak_deps=False install findutils which git make opam \
                                                    python3 python3-setuptools python3-pip \
                                                    cairo-devel gmp-devel gtk3-devel gtksourceview3-devel

RUN opam init --bare --disable-sandboxing --yes
RUN opam switch create coq -j4 --packages="ocaml-variants.4.14.1+options,ocaml-option-flambda"
RUN opam install --yes --switch=coq dune ocamlfind zarith lablgtk3-sourceview3
RUN opam switch set coq

COPY requirements.txt /tmp/requirements.txt
RUN pip3 install -r /tmp/requirements.txt

COPY coq_parser.py /store/

ARG COQ_VER=8.17.0

ADD https://github.com/coq/coq/archive/V${COQ_VER}.tar.gz coq.tar.gz
RUN mkdir /coq && tar zxf coq.tar.gz -C /coq --strip-components=1

WORKDIR /coq

RUN eval $(opam env --switch=coq --set-switch) && \
    ./configure -prefix /usr -mandir /usr/share/man -configdir /etc/xdg/coq/
RUN eval $(opam env --switch=coq --set-switch) && \
    make -j4 dunestrap
RUN eval $(opam env --switch=coq --set-switch) && \
    dune build -p coq-core,coq-stdlib,coqide,coqide-server,coq
# Default sphinx theme for coq which is sphinx_rtd_theme, seems no way to disable sidebar, so we use alabaster instead
RUN eval $(opam env --switch=coq --set-switch) && \
    make -j4 SPHINXOPTS="-Dhtml_theme=alabaster -Dhtml_theme_options.nosidebar=true" \
    refman-html stdlib-html apidoc

RUN LANG=C.UTF-8 LC_ALL=C.UTF-8 PYTHONPATH=/store/ doc2dash -n Coq -i ./ide/coqide/coq.png \
         --parser coq_parser.CoqSphinxParser ./doc/sphinx/_build/html
