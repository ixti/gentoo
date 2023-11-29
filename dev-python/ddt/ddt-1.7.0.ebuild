# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1

DESCRIPTION="Data-Driven/Decorated Tests"
HOMEPAGE="
	https://pypi.org/project/ddt/
	https://github.com/datadriventests/ddt/
"
SRC_URI="
	https://github.com/datadriventests/ddt/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 arm arm64 ~hppa ~riscv ~sparc ~x86"

BDEPEND="
	test? (
		dev-python/aiounittest[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
