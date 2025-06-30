FNL  = $(wildcard *.fnl)
FNL += $(wildcard ./**/*.fnl)
FNL += $(wildcard ./**/**/*.fnl)

# exclude fnl/macros directory
FNL := $(filter-out ./fnl/macros/%, $(FNL))

# only used as a dependency to trigger a rebuild
MACROS = $(wildcard ./fnl/macros/*.fnl)

# Use .SECONDEXPANSION to allow dynamic prerequisites
.SECONDEXPANSION:

LUA = $(shell echo "$(FNL)" | tr ' ' '\n' | sed 's|\(.*\)/\([^/]*\)\.fnl|\1/.\2.lua|; s|^\./\([^/]*\)\.fnl$$|./.\1.lua|' | tr '\n' ' ')

all: $(LUA)
	@if [ -f ./.init.lua ]; then mv ./.init.lua ./init.lua; fi

clean:
	find . -name "*.lua" -not -name "compiled-loader.lua" -not -name "list-element-text-objects.lua" -delete

.PHONY: clean all

.%.lua: %.fnl $$(MACROS)
	fennel \
		--add-package-path ${VIMRUNTIME}/lua \
		--add-package-path ${VIMRUNTIME}/lua/vim/lsp \
		--add-macro-path ${VIMRUNTIME}/fnl/macros \
		--compile $< \
		> $@
