# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGO_PN="github.com/${PN}/${PN}"

inherit toolchain-funcs

if [[ ${PV} == *9999 ]]; then
	inherit golang-vcs
else
	MY_PV="${PV/_/-}"
	EGIT_COMMIT="cfb82a876ecc11b5ca0977d1733adbe58599088a"
	SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~ppc64"
	inherit golang-vcs-snapshot
fi

DESCRIPTION="A daemon to control runC"
HOMEPAGE="https://containerd.tools"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="hardened +seccomp"

DEPEND=""
RDEPEND=">=app-emulation/docker-runc-1.0.0_rc3_p20170607
	seccomp? ( sys-libs/libseccomp )"

S=${WORKDIR}/${P}/src/${EGO_PN}

RESTRICT="test"

src_compile() {
	local options=( $(usex seccomp "seccomp" '') )
	export GOPATH="${WORKDIR}/${P}" # ${PWD}/vendor
	LDFLAGS=$(usex hardened '-extldflags -fno-PIC' '') emake GIT_COMMIT="$EGIT_COMMIT" BUILDTAGS="${options[@]}"
}

src_install() {
	dobin bin/containerd* bin/ctr
}
