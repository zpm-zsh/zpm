clean:
	@rm -f functions/*.zwc
	@rm -f lib/*.zwc

all: clean
	@for file in functions/* ; do \
		beautysh --indent-size 2 --force-function-style fnpar $$file ; \
	done

	@for file in lib/* ; do \
		beautysh --indent-size 2 --force-function-style fnpar $$file ; \
	done

	@beautysh --indent-size 2 --force-function-style fnpar zpm.zsh
	@beautysh --indent-size 2 --force-function-style fnpar bin/@zpm-plugin-helper

test:
	zsh tests/base.test.zsh

.PHONY: all clean test
