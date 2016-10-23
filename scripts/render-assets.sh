#! /bin/bash

INKSCAPE="/usr/bin/inkscape"
OPTIPNG="/usr/bin/optipng"

SRC_FILE="../src/assets/all-assets.svg"
ASSETS_DIR="../src/assets"
INDEX="../src/assets/all-assets.txt"

for i in `cat $INDEX`
do 
	if [[ -f $ASSETS_DIR/$i.png ]]; then
		rm $ASSETS_DIR/$i.png
	fi

	echo
	echo Rendering $ASSETS_DIR/$i.png
	$INKSCAPE \
		--export-id=$i \
		--export-id-only \
		--export-png=$ASSETS_DIR/$i.png \
		$SRC_FILE >/dev/null

	if [[ -f $ASSETS_DIR/$i@2.png ]]; then
		rm $ASSETS_DIR/$i@2.png
	fi

	echo
	echo Rendering $ASSETS_DIR/$i@2.png
	$INKSCAPE \
		--export-id=$i \
		--export-dpi=180 \
		--export-id-only \
		--export-png=$ASSETS_DIR/$i@2.png \
		$SRC_FILE >/dev/null
done

exit 0
