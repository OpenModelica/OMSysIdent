.PHONY: all test difftool resources partest

# Exclude `resources` for the moment
all: difftool test

test: python.log

# Exclude `resources` for the moment
partest: difftool
	cd partest && time ./runtests.pl -nocolour -with-xml

difftool:
	@$(MAKE) -C difftool

resources:
	@$(MAKE) -C resources

python.log: difftool
	@$(MAKE) -C python -f Makefile test > $@
	@grep == python.log
