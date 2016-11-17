#! /bin/bash

INKSCAPE='/usr/bin/inkscape'
OPTIPNG='/usr/bin/optipng'
TYPE="${1:-gtk}"

SRC_FILE="../src/assets/${TYPE}/all-assets.svg"
ASSETS_DIR="../src/assets/${TYPE}"
ASSETS_LIST="../src/assets/${TYPE}/all-assets.txt"

[[ -d "${ASSETS_DIR}/generated" ]] || mkdir -p "${ASSETS_DIR}/generated"

while read asset 
do

	echo
	echo Rendering "${ASSETS_DIR}/generated/${asset}.png"
	"${INKSCAPE}" \
		--export-id="${asset}" \
		--export-id-only \
		--export-png="${ASSETS_DIR}/generated/${asset}.svg" \
		"${SRC_FILE}" >/dev/null

	echo
	echo Rendering "${ASSETS_DIR}/generated/${asset}@2.png"
	"${INKSCAPE}" \
		--export-id="${asset}" \
		--export-dpi=180 \
		--export-id-only \
		--export-png="${ASSETS_DIR}/generated/${asset}@2.png" \
		"${SRC_FILE}" >/dev/null

done < "${ASSETS_LIST}"

exit 0
