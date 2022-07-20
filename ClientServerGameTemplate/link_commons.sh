#!/bin/bash
# Use this script when symbolics links to sources
# common for client & server
# did not appear automagically ;-)
ln -sir gameCommon/*.pde gameServer/
ln -sir gameCommon/*.pde gameClient/
ln -sir ./Readme.md docs/src.java/


