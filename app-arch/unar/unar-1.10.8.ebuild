# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 toolchain-funcs

DESCRIPTION="Unpacker for various archiving formats, e.g. rar v3"
HOMEPAGE="https://unarchiver.c3.cx/"
SRC_URI="
	https://github.com/MacPaw/XADMaster/archive/v${PV}/XADMaster-${PV}.tar.gz
	https://github.com/MacPaw/universal-detector/archive/1.1/universal-detector-1.1.tar.gz"
S="${WORKDIR}/XADMaster-${PV}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	app-arch/bzip2:=
	dev-libs/icu:=
	gnustep-base/gnustep-base:=
	media-sound/wavpack
	sys-libs/zlib"
DEPEND="
	${RDEPEND}
	gnustep-base/gnustep-make[native-exceptions]"

PATCHES=( "${FILESDIR}"/${P}-Wint-conversion.patch )

src_prepare() {
	default
	# avoid jobserver warning "make[1]: warning: jobserver unavailable: using -j1"
	sed -i -e 's:make:$(MAKE):g' Makefile.linux || die
	mv "${WORKDIR}/universal-detector-1.1" "${WORKDIR}/UniversalDetector" || die
}

src_compile() {
	emake -f Makefile.linux \
		AR="$(tc-getAR)" \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		OBJCC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		CXXFLAGS="${CXXFLAGS}" \
		OBJCFLAGS="${CFLAGS}" \
		LD="$(tc-getCXX)" \
		LDFLAGS="-Wl,--whole-archive -fexceptions -fgnu-runtime ${LDFLAGS}"
}

src_install() {
	dobin {ls,un}ar
	doman Extra/{ls,un}ar.1
	dobashcomp Extra/{ls,un}ar.bash_completion
}
