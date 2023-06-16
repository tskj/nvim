FNL  = $(wildcard *.fnl)
FNL += $(wildcard ./**/*.fnl)
FNL += $(wildcard ./**/**/*.fnl)

LUA = $(FNL:.fnl=.lua)

$(LUA): %.lua: %.fnl
	fennel \
		--add-package-path ${VIMRUNTIME}/lua \
		--add-package-path ${VIMRUNTIME}/lua/vim/lsp \
		--compile $^ \
		> $@

all: $(LUA)
