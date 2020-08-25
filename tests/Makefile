.PHONY: all test difftool resources partest

# Exclude `resources` for the moment
all: difftool test

test: python.log

# TODO add partest as in OMSimulator?
# partest: difftool resources
# 	cd partest && time ./runtests.pl -nocolour -with-xml

difftool:
	@$(MAKE) -C difftool

resources:
	@$(MAKE) -C resources

python.log: difftool
	@$(MAKE) -C python -f Makefile test > $@
	@grep == python.log
