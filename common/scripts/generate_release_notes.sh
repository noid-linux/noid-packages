#!/bin/bash
#
# generate_release_notes.sh

if [ $1 == "main" ]; then
	sed -e "s/@SUBREPO_TITLE_SUFFIX@//" common/scripts/RELEASE_NOTES.md.in
else
	sed -e "s/@SUBREPO_TITLE_SUFFIX@/ [$1]/" common/scripts/RELEASE_NOTES.md.in
fi
