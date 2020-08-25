FMUs = \
HelloWorld \
HelloWorldWithInput \
Lin2DimODE \

.PHONY: all fmutranslate

all:
	@echo
	@echo preparing FMUs...
	@for fmu in $(FMUs) ; do cd $$fmu && zip -r ../$$fmu.fmu * && cd .. ; done


fmutranslate:
	@echo
	@echo preparing FMUs...
	@for fmu in $(FMUs) ; do omc $$fmu.mos ; done
