#!/bin/bash

THEME_PARTS=()


_set_theme_parts_array() {
	GTK2=('-r' "${SRC_DIR}/toolkits/gtk-2.0" "${DIST_DIR}")

	METACITY=('-r' "${SRC_DIR}/window-managers/metacity" "${DIST_DIR}/metacity-1")

	OPENBOX=('-r' "${SRC_DIR}/window-managers/openbox" "${DIST_DIR}/openbox-3")

	THEME_INDEX=("${SRC_DIR_GTK320}/index.theme" "${DIST_DIR_GTK320}")

	THEME_THUMBNAIL=("${SRC_DIR_GTK320}/thumbnail.png" "${DIST_DIR_GTK320}")

	XFCE_NOTIFY=('-r' "${SRC_DIR}/xfce-notify-4.0" "${DIST_DIR}")

	XFWM=('-r' "${SRC_DIR}/window-managers/xfwm" "${DIST_DIR}/xfwm-4")

	THEME_PARTS=("${GTK2[*]}"             "${METACITY[*]}"
				 "${OPENBOX[*]}"          "${THEME_INDEX[*]}"
				 "${THEME_THUMBNAIL[*]}"  "${XFCE_NOTIFY[*]}"  "${XFWM[*]}")
}


do_install() {
	# Copy non-compiled files into DIST_DIR
	for cp_command_args in "${THEME_PARTS[@]}"
	do
		cp_command_args=(${cp_command_args})
		cp "${cp_command_args[@]}"
	done

	# Remove previous install if one exists.
	[[ -d "${INSTALL_DIR}" ]] && rm -rf "${INSTALL_DIR}"

	# Create INSTALL_DIR path except for the last directory in path.
	install -dm755 "$(dirname ${INSTALL_DIR})"

	# Copy DIST_DIR as INSTALL_DIR
	cp -r "${DIST_DIR}" "${INSTALL_DIR}"

	# Copy changes, credits, & license to INSTALL_DIR.
	cp "${REPO_ROOT_DIR}"/{CREDITS,CHANGES,LICENSE} "${INSTALL_DIR}"

	# Create symlink for index.theme in INSTALL_DIR/gtk-3.0
	( cd "${INSTALL_DIR}/gtk-3.0" && ln -srf ../gtk-3.20/index.theme )
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
		numix-gtk-theme)
			NEXT_PATCH=$(($LAST_PATCH + 1))

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
		_set_theme_parts_array
		do_install
	;;

	*)
		exit 0
	;;
esac
