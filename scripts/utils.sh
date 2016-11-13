#!/bin/bash

THEME_PARTS=()


_set_theme_parts_array() {
	gtk2=('-r' "${SRC_DIR}/toolkits/gtk-2.0" "${DIST_DIR}")

	metacity=('-r' "${SRC_DIR}/window-managers/metacity" "${DIST_DIR}/metacity-1")

	openbox=('-r' "${SRC_DIR}/window-managers/openbox" "${DIST_DIR}/openbox-3")

	theme_index=("${SRC_DIR_GTK320}/index.theme" "${DIST_DIR_GTK320}")

	theme_thumbnail=("${SRC_DIR_GTK320}/thumbnail.png" "${DIST_DIR_GTK320}")

	xfce_notify=('-r' "${SRC_DIR}/xfce-notify-4.0" "${DIST_DIR}")

	xfwm=('-r' "${SRC_DIR}/window-managers/xfwm" "${DIST_DIR}/xfwm-4")

	THEME_PARTS=("${gtk2[*]}"             "${metacity[*]}"
				 "${openbox[*]}"          "${theme_index[*]}"
				 "${theme_thumbnail[*]}"  "${xfce_notify[*]}"  "${xfwm[*]}")
}


do_install() {
	for cp_command_args in "${THEME_PARTS[@]}"
	do
		cp_command_args=(${cp_command_args})
		cp "${cp_command_args[@]}"
	done

	install -dm755 "${INSTALL_DIR}"/../

	cp -r "${DIST_DIR}" "${INSTALL_DIR}"

	cp "${SRC_DIR}"/{CREDITS,CHANGES,LICENSE,README.md} "${INSTALL_DIR}"

	cd "${INSTALL_DIR}/gtk-3.0" && {
		ln -sr ../gtk-3.20/index.theme
		ln -sr ../gtk-3.20/thumbnail.png
	}
}


output_changes_file_version_marker() {

	line() {
		dashes="$(printf '%0.s-' $(seq 1 13))"
		echo "${dashes}>>>> $1 <<<<${dashes}"
	}

	tag_line="$(line $1)"

	echo "-${tag_line}${tag_line}${tag_line}-"
}


update_changes_file() {
	LAST_STABLE_RELEASE=$(git describe --abbrev=0 --tags $(git rev-list --tags --max-count=1))
	LAST_MAJOR_MINOR="${LAST_STABLE_RELEASE%.*}"

	LAST_MAJOR="${LAST_STABLE_RELEASE%%.*}"
	LAST_MINOR="${LAST_MAJOR_MINOR#*.}"
	LAST_PATCH="${LAST_STABLE_RELEASE##*.}"

	case "${PWD##*/}" in
		Numix)
			NEXT_PATCH=$((LAST_PATCH + 1))

			NEXT_STABLE_RELEASE="${LAST_MAJOR_MINOR}.${NEXT_PATCH}"
		;;

		Numix-Frost)
			LAST_MAJOR=$((LAST_MAJOR + 1))
			NEXT_STABLE_RELEASE="${LAST_MAJOR}.${LAST_MINOR}.${LAST_PATCH}"
			LAST_PATCH=$((LAST_PATCH - 1))

			LAST_STABLE_RELEASE="${LAST_MAJOR}.${LAST_MINOR}.${LAST_PATCH}"
		;;

		*)
			echo 'Unknown directory!' && exit 1
		;;
	esac

	[[ -f CHANGES ]] && mv CHANGES CHANGES.old

	output_changes_file_version_marker "${NEXT_STABLE_RELEASE}" > CHANGES

	{ git log \
		--pretty=format:"[%ai] %<(69,trunc) %s %><(15) %aN {%h}" \
		--cherry-pick "${LAST_STABLE_RELEASE}...HEAD"; } >> CHANGES


	[[ -f CHANGES.old ]] && echo "" >> CHANGES && cat CHANGES.old >> CHANGES && rm CHANGES.old

	git add CHANGES
	git commit -m 'RELEASE PREP :: Update CHANGES file.'
	git push
}



case $1 in
	changes)
		update_changes_file
		exit $?
	;;

	install)
		do_install "$2"
	;;

	*)
		exit 0
	;;
esac
