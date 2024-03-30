FNL  = $(wildcard *.fnl)
FNL += $(wildcard ./**/*.fnl)
FNL += $(wildcard ./**/**/*.fnl)

# exclude fnl/macros directory
FNL := $(filter-out ./fnl/macros/%, $(FNL))

# only used as a dependency to trigger a rebuild
MACROS = $(wildcard ./fnl/macros/*.fnl)

# Use .SECONDEXPANSION to allow dynamic prerequisites
.SECONDEXPANSION:

LUA = $(FNL:.fnl=.lua)

all: $(LUA)

$(LUA): %.lua: %.fnl $$(MACROS)
	fennel \
		--add-package-path ${VIMRUNTIME}/lua \
		--add-package-path ${VIMRUNTIME}/lua/vim/lsp \
		--add-macro-path fnl/macros \
		--compile $< \
		> $@
