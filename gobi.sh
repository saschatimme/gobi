#!/bin/sh -e

IOSCAMLVER=4.04.0 # OCaml compiler
SDK=10.3 # iOS SDK
MIN_VER=8.0 # Minimal supported iOS Version

REASON=true # support reason syntax
BIT_32=false # Build for 32 bit architechture

SRC=src # source directory
LIB_NAME=gobi # name of the generated library, has to coincide with the jbuild target 
LIB_OUTPUT=CrossIOSTest/ # output of the final generated library

# The name of the created switches
DEV_32="${IOSCAMLVER}+ios+arm32"
SIM_32="$IOSCAMLVER+ios+x86"
DEV_64="${IOSCAMLVER}+ios+arm64"
SIM_64="${IOSCAMLVER}+ios+amd64"

# On this switch JBuilder and Merlin will be installed
WORKING_SWITCH="$SIM_64"

gobi_working_switch() {
  opam switch -y --no-warning $WORKING_SWITCH
  eval $(opam config env --switch=$WORKING_SWITCH)
}

gobi_create_switches() {
  if [ "$BIT_32" = true ] ; then
    echo "Generate switch ${DEV_32} alias of ${IOSCAMLVER}+32bit"
    opam switch -y ${DEV_32} --alias-of ${IOSCAMLVER}+32bit --no-warning
    echo "Generate switch ${SIM_32} (iOS Simulator) alias of ${IOSCAMLVER}+32bit"
    opam switch -y ${SIM_32} --alias-of ${IOSCAMLVER}+32bit --no-warning
  fi
  echo "Generate switch ${DEV_64} alias of ${IOSCAMLVER}"
  opam switch -y ${DEV_64} --alias-of ${IOSCAMLVER} --no-warning
  echo "Generate switch4${SIM_64}+ios+amd64 (iOS Simulator) alias of ${IOSCAMLVER}"
  opam switch -y ${SIM_64} --alias-of ${IOSCAMLVER} --no-warning

  gobi_working_switch
}

gobi_foreach() {
  if [ "$BIT_32" = true ] ; then
    for i in ${DEV_32} ${SIM_32}; do
      echo "Switch to ${i}"
      opam switch -y --no-warning $i
      eval $(opam config env --switch=$i)
      if ! OPAMYES=1 $*; then return 1; fi
    done
  fi
  for i in ${DEV_64} ${SIM_64}; do
    echo "Switch to ${i}"
    opam switch -y --no-warning $i
    eval $(opam config env --switch=$i)
    if ! OPAMYES=1 $*; then return 1; fi
  done
  echo "Done."
  echo "Done. Switch back to ${WORKING_SWITCH}"
  gobi_working_switch
}

_gobi_configure_switch() {
  echo "Setup conf-ios"
  case $(opam switch show) in
  ${DEV_32})
    ARCH=arm SUBARCH=armv7 PLATFORM=iPhoneOS \
      opam reinstall -y conf-ios
    ;;
  ${DEV_64})
    ARCH=arm64 SUBARCH=arm64 PLATFORM=iPhoneOS \
      opam reinstall -y conf-ios
    ;;
  ${SIM_32})
    ARCH=i386 SUBARCH=i386 PLATFORM=iPhoneSimulator \
      opam reinstall -y conf-ios
    ;;
  ${SIM_64})
    ARCH=amd64 SUBARCH=x86_64 PLATFORM=iPhoneSimulator \
      opam reinstall -y conf-ios
    ;;
  esac
}

gobi_configure_switches() {
  gobi_foreach _gobi_configure_switch
}

gobi_install() {
  gobi_foreach opam install $*
}

gobi_remove() {
  gobi_foreach opam remove $*
}


gobi_setup() {
  opam update
  opam repository add ios git://github.com/whitequark/opam-cross-ios
  echo "Gobi will now setup the enviroment."
  echo "First we create some new switches. This will take some time."
  gobi_create_switches
  echo "Configure switches properly..."
  gobi_configure_switches
  echo "Install Ocamlbuild and OCamlfind"
  gobi_install ocamlbuild ocamlfind

  if [ "$REASON" = true ] ; then
    echo "Install support for Reason."
    gobi_install reason
  fi

  echo "Install dev dependencies on ${WORKING_SWITCH}"
  opam switch -y --no-warning $WORKING_SWITCH
  eval $(opam config env --switch=$WORKING_SWITCH)
  opam pin add jbuilder git://github.com/saschatimme/jbuilder.git#output-obj+cross
  opam install jbuilder merlin
}

gobi_create_library() {
  jbuilder build ${SRC}/lib${LIB_NAME}.a
  if [ "$BIT_32" = false ] ; then
    lipo -create \
      _build/${SIM_64}/${SRC}/lib${LIB_NAME}.a \
      _build/${DEV_64}/${SRC}/lib${LIB_NAME}.a \
      -o ${LIB_OUTPUT}/lib${LIB_NAME}.a
  fi
  if [ "$BIT_32" = true ] ; then
    lipo -create \
      _build/${SIM_32}/${SRC}/lib${LIB_NAME}.a \
      _build/${DEV_32}/${SRC}/lib${LIB_NAME}.a \
      _build/${SIM_64}/${SRC}/lib${LIB_NAME}.a \
      _build/${DEV_64}/${SRC}/lib${LIB_NAME}.a \
      -o ${LIB_OUTPUT}/lib${LIB_NAME}.a
  fi
}