all:
	beautysh --indent-size 2 --force-function-style fnpar zpm.zsh
	beautysh --indent-size 2 --force-function-style fnpar lib/init.zsh
	beautysh --indent-size 2 --force-function-style fnpar lib/zpm.zsh
	beautysh --indent-size 2 --force-function-style fnpar lib/imperative.zsh

	beautysh --indent-size 2 --force-function-style fnpar bin/_ZPM-plugin-helper
	
	beautysh --indent-size 2 --force-function-style fnpar functions/_zpm
	beautysh --indent-size 2 --force-function-style fnpar functions/@zpm-addpath
	beautysh --indent-size 2 --force-function-style fnpar functions/@zpm-addpath
	beautysh --indent-size 2 --force-function-style fnpar functions/@zpm-background-initialization
	beautysh --indent-size 2 --force-function-style fnpar functions/@zpm-clean
	beautysh --indent-size 2 --force-function-style fnpar functions/@zpm-get-plugin-basename
	beautysh --indent-size 2 --force-function-style fnpar functions/@zpm-get-plugin-file-path
	beautysh --indent-size 2 --force-function-style fnpar functions/@zpm-get-plugin-link
	beautysh --indent-size 2 --force-function-style fnpar functions/@zpm-get-plugin-hyperlink
	beautysh --indent-size 2 --force-function-style fnpar functions/@zpm-get-plugin-name
	beautysh --indent-size 2 --force-function-style fnpar functions/@zpm-get-plugin-path
	beautysh --indent-size 2 --force-function-style fnpar functions/@zpm-get-git-work-tree
	beautysh --indent-size 2 --force-function-style fnpar functions/@zpm-get-plugin-type
	beautysh --indent-size 2 --force-function-style fnpar functions/@zpm-initialize-plugins
	beautysh --indent-size 2 --force-function-style fnpar functions/@zpm-load-plugin
	beautysh --indent-size 2 --force-function-style fnpar functions/@zpm-log
	beautysh --indent-size 2 --force-function-style fnpar functions/@zpm-upgrade
	beautysh --indent-size 2 --force-function-style fnpar functions/@zpm-compile

test:
	zsh tests/base.test.zsh

.PHONY: all test
