# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="set of tiny portable unix utilities"
HOMEPAGE="http://www.skarnet.org/software/s6-portable-utils/"
SRC_URI="http://www.skarnet.org/software/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static"

DEPEND=">=sys-devel/make-3.81
	static? (
		>=dev-libs/skalibs-2.4.0.0[static-libs]
	)
	!static? (
		>=dev-libs/skalibs-2.4.0.0
	)
"
RDEPEND="
	!static? (
		>=dev-libs/skalibs-2.4.0.0:=
	)
"

HTML_DOCS="doc/*"

src_prepare() {
	default

	# Remove QA warning about LDFLAGS addition
	sed -i "s/tryldflag LDFLAGS_AUTO -Wl,--hash-style=both/:/" "${S}/configure" || die
}

src_configure() {
	econf \
		--bindir=/bin \
		--dynlibdir=/$(get_libdir) \
		--libdir=/usr/$(get_libdir)/${PN} \
		--with-dynlib=/$(get_libdir) \
		--with-lib=/usr/$(get_libdir)/skalibs \
		--with-sysdeps=/usr/$(get_libdir)/skalibs \
		$(use_enable static allstatic) \
		$(use_enable static static-libc)
}
