all:
	beautysh --indent-size 2 --force-function-style fnpar zpm.zsh
	beautysh --indent-size 2 --force-function-style fnpar lib/init.zsh
	beautysh --indent-size 2 --force-function-style fnpar lib/zpm.zsh
	beautysh --indent-size 2 --force-function-style fnpar lib/imperative.zsh

	beautysh --indent-size 2 --force-function-style fnpar bin/_ZPM-plugin-helper
	
	beautysh --indent-size 2 --force-function-style fnpar functions/_zpm
	beautysh --indent-size 2 --force-function-style fnpar functions/_ZPM_addfpath
	beautysh --indent-size 2 --force-function-style fnpar functions/_ZPM_addpath
	beautysh --indent-size 2 --force-function-style fnpar functions/_ZPM_Background_Initialization
	beautysh --indent-size 2 --force-function-style fnpar functions/_ZPM_clean
	beautysh --indent-size 2 --force-function-style fnpar functions/_ZPM_get_plugin_basename
	beautysh --indent-size 2 --force-function-style fnpar functions/_ZPM_get_plugin_file_path
	beautysh --indent-size 2 --force-function-style fnpar functions/_ZPM_get_plugin_link
	beautysh --indent-size 2 --force-function-style fnpar functions/_ZPM_get_plugin_hyperlink
	beautysh --indent-size 2 --force-function-style fnpar functions/_ZPM_get_plugin_name
	beautysh --indent-size 2 --force-function-style fnpar functions/_ZPM_get_plugin_path
	beautysh --indent-size 2 --force-function-style fnpar functions/_ZPM_get_plugin_root_git_dir
	beautysh --indent-size 2 --force-function-style fnpar functions/_ZPM_get_plugin_type
	beautysh --indent-size 2 --force-function-style fnpar functions/_ZPM_initialize_plugins
	beautysh --indent-size 2 --force-function-style fnpar functions/_ZPM_load_plugin
	beautysh --indent-size 2 --force-function-style fnpar functions/_ZPM_log
	beautysh --indent-size 2 --force-function-style fnpar functions/_ZPM_upgrade
	beautysh --indent-size 2 --force-function-style fnpar functions/_ZPM_compile
	beautysh --indent-size 2 --force-function-style fnpar functions/_ZPM_readme


test:
	zsh tests/base.test.zsh


.PHONY: all test