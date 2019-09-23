SRC_DIR    := src
INC_DIR    := include
LIB_DIR    := libs
OBJ_DIR    := build
OUT_DIR    := bin
DOC_DIR    := docs

LIBS       := -lstdc++fs
LIBS       += -lfmt
INCLUDES   := -I${INC_DIR}

SRCS       := ${SRC_DIR}/main.cpp
SRCS       += ${SRC_DIR}/load_map.cpp
OBJS       := ${SRCS:${SRC_DIR}/%.cpp=${OBJ_DIR}/%.o}
DOC_OBJS   := ${DOC_DIR}/map_template.pdf
DOCS       := ${DOC_OBJS:.md=.pdf}

EXEC       := game

MAP_FOLDER := maps

CXX        := g++
CXX_FLAGS  := -std=c++17 -O2 ${INCLUDES} ${ARGS}


.PHONY:  clean default help

default: help

all: ${OUT_DIR}/${EXEC} docs ## builds all targets

${OBJ_DIR}/%.o: ${SRC_DIR}/%.cpp ${INC_DIR}/nlohmann/json.hpp
	@mkdir -pv ${OBJ_DIR}
	${CXX} ${CXX_FLAGS} -c $< -o $@ ${CARGS}

${OUT_DIR}/${EXEC}: ${OBJS}
	@mkdir -pv ${OUT_DIR}
	${CXX} ${CXX_FLAGS} $^ ${LIBS} -o $@ ${LARGS}

${INC_DIR}/nlohmann/json.hpp:
	@echo "Installing json.hpp..."
	@mkdir -pv ${INC_DIR}/nlohmann
	@curl -s -o $@ "https://raw.githubusercontent.com/nlohmann/json/release/3.7.0/single_include/nlohmann/json.hpp" > /dev/null
	@echo "...Done"

docs: ${DOCS} ## Compiles the documentation for the program

${DOC_DIR}/%.pdf: ${DOC_DIR}/_%.md
	pandoc -o $@ $<

help: ## Prints usage instructions
	@echo "usage: make [target] [<optional argument>=<value> ...]"
	@grep -E '^[a-zA-Z_-]+:.*?##.*$$' $(MAKEFILE_LIST) | \
	sort | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "\t%-30s%s\n", $$1, $$2}'
	@echo "optional arguments:"
	@echo "\tARGS  - Args that apply to both compiling and linking"
	@echo "\tCARGS - Args that apply to just compiling"
	@echo "\tLARGS - Args that apply to just linking"

deep-clean: clean ## Cleans all build and output files in addition to removing library directories and includes.
	@echo "This will set the project structure up to a clean state."
	@read -p "Are you sure? [Y/N]: " input; \
	if [ "$$input" = "Y" ]; then \
		rm -rf ${LIB_DIR} ${INC_DIR} ${OUT_DIR} ${OBJ_DIR}; \
		echo "Done."; \
	else echo "Aborting..."; \
	fi;

clean: ## Cleans all build and output files
	@find . -name "*.o" -delete
	@find . -name "*.pdf" -delete
	@find . -name "${EXEC}" -delete

