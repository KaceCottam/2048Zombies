export CXXARGS

GCOV=gcov
LCOV=lcov
CXXFLAGS=-std=c++17 -Wall -Wextra -Wpedantic -Werror ${INCLUDES} ${CXXARGS}
GCOVFLAGS=-r -a
LCOVFLAGS=-q --directory ${SRCDIR} --no-external

OUTDIR=bin
OBJDIR=build
SRCDIR=src
INCDIR=include
COVRDIR=coverage
TEMPDIR=temp
TESTDIR=${SRCDIR}/tests

INCLUDES=-I${INCDIR} -I${SRCDIR}

COVRINFO=${COVRDIR}/coverage.info
BROWSER=firefox

define AWKCMD
BEGIN {                                      \
  FS  = ":.*?## ";                           \
  fmt = "%-15s %s\n";                        \
  fmtc = "\33[36m%-15s \33[37m%s \33[0m \n"; \
  printf fmt,"Command","Comment";            \
  printf fmt,"------","-------" }            \
{ printf fmtc,$$1,$$2 }
endef

define CHKDIR
	@if [ ! -d ${1} ] ; \
		then mkdir ${1} & echo "Directory ${1} created."; \
		else echo "Directory ${1} exists."; fi
endef

define COMPILE
	@echo 'Compiling "$@" with params "${CXXFLAGS}"'
	@${CXX} -o ${OUTDIR}/$@ $^ ${CXXFLAGS}
endef

.PHONY: help
help: ## Displays this page.
	@grep -E '^[a-zA-Z_-]+:.*##.*$$' ${MAKEFILE_LIST} | \
	 sort | \
	 awk '${AWKCMD}'

.PHONY: install
install: chkdirs chkdeps game ## Installs the game to the output dir.

game: ${SRCDIR}/main.cpp
	${COMPILE}

.PHONY: add-coverage-flag
add-coverage-flag:
	${eval CXXARGS+= --coverage}

.PHONY: cover
cover: chkcovr add-coverage-flag ${TARGET} ## runs gcov, lcov, and genhtml to show coverage.
	${TARGET}
	@${GCOV} *.gc* ${GCOVFLAGS}
	@${LCOV} -o ${COVRINFO} -c -d . ${LCOVFLAGS}
	@genhtml ${COVRINFO} -o ${COVRDIR}
	@${BROWSER} ${COVRDIR}/index.html &

.PHONY: fetch-catch
fetch-catch: chkinclude
	@if [ ! -f "${INCDIR}/catch.hpp" ]; then\
		echo "Retrieving the latest version of Catch...";\
		git clone https://github.com/catchorg/Catch.git ${TEMPDIR};\
		cp -f ${TEMPDIR}/single_include/catch.hpp ${INCDIR}; \
		rm -fr ${TEMPDIR};\
		echo "...Done";\
	else \
		echo "Catch already exists..."; \
	fi

.PHONY: fetch-json
fetch-json: chkinclude
	@if [ ! -f "${INCDIR}/json.hpp" ]; then\
		echo "Retrieving the latest version of json...";\
		git clone https://github.com/nlohmann/json.git ${TEMPDIR};\
		cp -f ${TEMPDIR}/single_include/nlohmann/json.hpp ${INCDIR};\
		rm -fr ${TEMPDIR};\
		echo "...Done";\
	else \
		echo "json already exists..."; \
	fi

.PHONY: chkdeps
chkdeps: fetch-json

.PHONY: chkout
chkout:
	${call CHKDIR,${OUTDIR}}

.PHONY: chkinclude
chkinclude:
	${call CHKDIR,${INCDIR}}

.PHONY: chkcovr
chkcovr:
	${call CHKDIR,${COVRDIR}}

.PHONY: chkdirs
chkdirs: chkout

.PHONY: clean
clean: ## Cleans the program for a default build state.
	@rm -vrf ${OUTDIR} ${OBJDIR} ${INCDIR} ${COVRDIR} ${TEMPDIR}
	@rm -vf ./*.gc* ./*/*.gc* ./*/*.info ./*.info
