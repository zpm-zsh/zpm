all:
	beautysh --indent-size 2 --force-function-style fnpar zpm.zsh
	# beautysh --indent-size 2 --force-function-style fnpar lib/completion.zsh
	beautysh --indent-size 2 --force-function-style fnpar lib/functions.zsh
	beautysh --indent-size 2 --force-function-style fnpar lib/imperative.zsh
	
	beautysh --indent-size 2 --force-function-style fnpar autoload/_ZPM_addfpath
	beautysh --indent-size 2 --force-function-style fnpar autoload/_ZPM_addpath
	beautysh --indent-size 2 --force-function-style fnpar autoload/_ZPM_Background_Initialization
	beautysh --indent-size 2 --force-function-style fnpar autoload/_ZPM_clean
	beautysh --indent-size 2 --force-function-style fnpar autoload/_ZPM_get_plugin_basename
	beautysh --indent-size 2 --force-function-style fnpar autoload/_ZPM_get_plugin_file_path
	beautysh --indent-size 2 --force-function-style fnpar autoload/_ZPM_get_plugin_link
	beautysh --indent-size 2 --force-function-style fnpar autoload/_ZPM_get_plugin_name
	beautysh --indent-size 2 --force-function-style fnpar autoload/_ZPM_get_plugin_path
	beautysh --indent-size 2 --force-function-style fnpar autoload/_ZPM_get_plugin_type
	beautysh --indent-size 2 --force-function-style fnpar autoload/_ZPM_initialize_plugin
	beautysh --indent-size 2 --force-function-style fnpar autoload/_ZPM_load_plugin
	beautysh --indent-size 2 --force-function-style fnpar autoload/_ZPM_log
	beautysh --indent-size 2 --force-function-style fnpar autoload/_ZPM_upgrade
	beautysh --indent-size 2 --force-function-style fnpar autoload/_ZPM_compile


test:


.PHONY: all 