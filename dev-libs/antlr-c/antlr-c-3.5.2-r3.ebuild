# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

MY_PN="${PN%-c}"
DESCRIPTION="The ANTLR3 C Runtime"
HOMEPAGE="https://www.antlr3.org/"
SRC_URI="https://github.com/${MY_PN}/${MY_PN}3/archive/${PV}.tar.gz -> ${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}3-${PV}/runtime/C"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug doc"

BDEPEND="doc? ( app-doc/doxygen[dot] )"

PATCHES=(
	"${FILESDIR}/3.5-cflags.patch"
	"${FILESDIR}/3.5-autoconf.patch"
)

src_prepare() {
	default

	sed -i '/^QUIET/s/NO/YES/' doxyfile || die
	eautoreconf
}

src_configure() {
	local econfargs=(
		$(use_enable debug antlrdebug)
	)

	case "$(tc-get-ptr-size)" in
		8) econfargs+=( --enable-64bit ) ;;
		4) econfargs+=( --disable-64bit ) ;;
	esac

	CONFIG_SHELL="${BROOT}"/bin/bash econf "${econfargs[@]}"
}

src_compile() {
	default

	if use doc ; then
		einfo "Generating API documentation ..."
		doxygen -u doxyfile || die
		doxygen doxyfile || die

		HTML_DOCS=( "${S}"/api/ )
	fi
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
