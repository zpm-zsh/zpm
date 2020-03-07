all:
	beautysh --indent-size 2 --force-function-style fnpar zpm.zsh
	# beautysh --indent-size 2 --force-function-style fnpar lib/completion.zsh
	beautysh --indent-size 2 --force-function-style fnpar lib/functions.zsh
	beautysh --indent-size 2 --force-function-style fnpar lib/imperative.zsh

test:


.PHONY: all 