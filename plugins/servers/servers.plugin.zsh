#!/usr/bin/env zsh

alias server_py='python2 -m SimpleHTTPSewrver 8000'
alias server_py3='python3 -m http.server 8000'
alias server_tw='twistd -n web -p 8000 --path .'
alias server_rb="ruby -rwebrick -e'WEBrick::HTTPServer.new(:Port => 8000, :DocumentRoot => Dir.pwd).start'"
alias server_rb1.9="ruby -run -ehttpd . -p8000"
alias server_perl="perl -MHTTP::Server::Brick -e '$s=HTTP::Server::Brick->new(port=>8000); $s->mount("/"=>{path=>"."}); $s->start'"
alias server_php='php -S localhost:8000'
alias server_js='static -p 8000' 
alias server_httpd='busybox httpd -f -p 8000'  
