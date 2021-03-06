#!/bin/bash
# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

source tests-common.sh

inherit eapi7-ver versionator

cutting() {
	local x
	for x in {1..1000}; do
		ver_cut 1 1.2.3
		ver_cut 1-2 1.2.3
		ver_cut 2- 1.2.3
		ver_cut 1- 1.2.3
		ver_cut 3-4 1.2.3b_alpha4
		ver_cut 5 1.2.3b_alpha4
		ver_cut 1-2 .1.2.3
		ver_cut 0-2 .1.2.3
		ver_cut 2-3 1.2.3.
		ver_cut 2- 1.2.3.
		ver_cut 2-4 1.2.3.
	done >/dev/null
}

cutting_versionator() {
	local x
	for x in {1..100}; do
		get_version_component_range 1 1.2.3
		get_version_component_range 1-2 1.2.3
		get_version_component_range 2- 1.2.3
		get_version_component_range 1- 1.2.3
		get_version_component_range 3-4 1.2.3b_alpha4
		get_version_component_range 5 1.2.3b_alpha4
		get_version_component_range 1-2 .1.2.3
		get_version_component_range 0-2 .1.2.3
		get_version_component_range 2-3 1.2.3.
		get_version_component_range 2- 1.2.3.
		get_version_component_range 2-4 1.2.3.
	done >/dev/null
}

replacing() {
	local x
	for x in {1..1000}; do
		ver_rs 1 - 1.2.3
		ver_rs 2 - 1.2.3
		ver_rs 1-2 - 1.2.3.4
		ver_rs 2- - 1.2.3.4
		ver_rs 2 . 1.2-3
		ver_rs 3 . 1.2.3a
		ver_rs 2-3 - 1.2_alpha4
		#ver_rs 3 - 2 "" 1.2.3b_alpha4
		#ver_rs 3-5 _ 4-6 - a1b2c3d4e5
		ver_rs 1 - .1.2.3
		ver_rs 0 - .1.2.3
	done >/dev/null
}

replacing_versionator() {
	local x
	for x in {1..100}; do
		replace_version_separator 1 - 1.2.3
		replace_version_separator 2 - 1.2.3
		replace_version_separator 1-2 - 1.2.3.4
		replace_version_separator 2- - 1.2.3.4
		replace_version_separator 2 . 1.2-3
		replace_version_separator 3 . 1.2.3a
		replace_version_separator 2-3 - 1.2_alpha4
		#replace_version_separator 3 - 2 "" 1.2.3b_alpha4
		#replace_version_separator 3-5 _ 4-6 - a1b2c3d4e5
		replace_version_separator 1 - .1.2.3
		replace_version_separator 0 - .1.2.3
	done >/dev/null
}

get_times() {
	local factor=${1}; shift
	echo "${*}"
	local real=()
	local user=()

	for x in {1..5}; do
		while read tt tv; do
			case ${tt} in
				real) real+=( $(dc -e "${tv} ${factor} * p") );;
				user) user+=( $(dc -e "${tv} ${factor} * p") );;
			esac
		done < <( ( time -p "${@}" ) 2>&1 )
	done

	[[ ${#real[@]} == 5 ]] || die "Did not get 5 real times"
	[[ ${#user[@]} == 5 ]] || die "Did not get 5 user times"

	local sum
	for v in real user; do
		vr="${v}[*]"
		sum=$(dc -e "${!vr} + + + + 3 k 5 / p")

		vr="${v}[@]"
		printf '%s %4.2f %4.2f %4.2f %4.2f %4.2f => %4.2f avg\n' \
			"${v}" "${!vr}" "${sum}"
	done
}

export LC_ALL=C

get_times 1 cutting
get_times 10 cutting_versionator
get_times 1 replacing
get_times 10 replacing_versionator
