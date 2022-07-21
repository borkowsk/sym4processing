#!/bin/bash
# Use this script when symbolics links to sources
# common for client & server
# did not appear automagically ;-)
ln -sir ./README.md docs/src.java/Readme.md

pushd ./ClientServerGameTemplate/
./link_commons.sh
popd


