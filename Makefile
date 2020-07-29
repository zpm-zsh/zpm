all:
	@rm -f functions/*.zwc
	@for file in functions/* ; do \
		beautysh --indent-size 2 --force-function-style fnpar $$file ; \
	done

	@rm -f lib/*.zwc
	@for file in lib/* ; do \
		beautysh --indent-size 2 --force-function-style fnpar $$file ; \
	done

	@beautysh --indent-size 2 --force-function-style fnpar zpm.zsh
	@beautysh --indent-size 2 --force-function-style fnpar bin/_ZPM-plugin-helper

test:
	zsh tests/base.test.zsh

.PHONY: all test
