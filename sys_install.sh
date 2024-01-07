#!/bin/bash

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

echo "${green}...:::|-| Crash Angel Arts |-|:::..${reset}"
#for code in {0..255}; do echo -e "\e[38;05;${code}m $code: Test"; done

function SystemUpdate()
{
	echo "" && echo "${green}...:::|-|> System Update ${reset}"
	apt update -y
	apt upgrade
}

function Apps()
{
	echo "" && echo "${green}...:::|-|> Apps ${reset}"
	apt install -y figlet lolcat curl wget nano tmux jq parallel git gh unzip python3 python3-pip python3-fontforge ripgrep
}

function NerdFonts()
{
	echo "" && echo "${green}...:::|-|> NERD Fonts ${reset}"
	cd
	mkdir nerd-fonts && cd nerd-fonts
	curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases \ | jq -r '.[0].assets[] | select(.browser_download_url | endswith(".zip")) | .browser_download_url' \ | parallel --bar -t -- curl -sLOC - {}

	curl -OL https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/install.sh
	chmod +x install.sh

	#./install.sh

	rm -rf patched-fonts && mkdir -p patched-fonts
	ls -1b | parallel -- unzip -o {} \*.\[ot\]tf -d patched-fonts/{.}
	fc-cache -fv
}

function OhMyTmux()
{
	echo "" && echo "${green}...:::|-|> Tmux Oh My ${reset}"
	cd
	git clone https://github.com/gpakosz/.tmux.git
	ln -s -f .tmux/.tmux.conf
	cp .tmux/.tmux.conf.local .
}

function Settings()
{
	echo "" && echo "${green}...:::|-|> Settings ${reset}"
	echo "figlet  "CrashAngel" | lolcat" >> ~/.bashrc
	
	git clone https://github.com/jeremiedecock/iptables-scripts.git

}

function OhMyNeoVim()
{
	apt install -y guix
	nix-env --install neovim
	apt install nix-bin: https://packages.ubuntu.com/jammy/nix-bin

	rm ~/.config/nvim/ -R
	git clone https://github.com/LazyVim/starter ~/.config/nvim

#	git clone https://github.com/hardhackerlabs/oh-my-nvim.git ~/.config/nvim
	rm -rf ~/.config/nvim/.git
}

#SystemUpdate
#Apps
#NerdFonts
#OhMyTmux
#OhMyNeoVim
#Settings


function OhMyNeoVim()
{
	echo "" && echo "${green}...:::|-|> Build NeoVim ${reset}"
	wget https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz
	tar -xzvf nvim-linux64.tar.gz
	#mkdir  ~/.local/
	#mkdir  ~/.local/bin/
	#mkdir  ~/.local/share/
	#mv nvim-linux64 ~/.local/share/nvim-linux64
	#cd ~/.local/bin/
	#ln -sf ~/.local/share/nvim-linux64/bin/nvim nvim
	#cd
	apt install  ninja-build libtool autoconf automake cmake gcc build-essential make  unzip patch gettext curl git
	mkdir lab
	mkdir ~/lab/build
	cd ~/lab/build
	git clone https://github.com/neovim/neovim

	cd ~/lab/build/neovim/
	git checkout stable
	make CMAKE_BUILD_TYPE=RelWithDebInfo
	#make CMAKE_BUILD_TYPE=Release
	make install

	echo "" && echo "${green}...:::|-|> Install Oh My NVim ${reset}"
	git clone https://github.com/hardhackerlabs/oh-my-nvim.git ~/.config/nvim

	cd ~/.local/share/fonts && \
	curl -fLO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
	fc-cache -fv
	git clone https://github.com/ljcooke/vim-fortune.git \
	~/.vim/bundle/vim-fortune

	#Install LSP Server
	#Use command :LspInstall to download and install a server, e.g. :LspInstall rust_analyzer.

	#Install TreeSitter Parser
	#Use command :TSInstall to download and install a parser, e.g. :TSInstall rust.
}

function NerdFonts()
{
	apt install python3-fontforge
	mkdir -p ~/.local/share/fonts
	cd ~/.local/share/fonts && curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/DroidSansMono/DroidSansMNerdFont-Regular.otf

	#git clone https://github.com/ryanoasis/vim-devicons ~/.vim/bundle/vim-devicons
	fc-cache -fv
	#echo "set encoding=utf8" >> ~.vimrc
	#set guifont=DroidSansMono\ Nerd\ Font\ 11
	
	#echo "NeoBundle 'ryanoasis/vim-devicons'" >> ~/.vimrc
}

NerdFonts

#cd ~/.local/share/fonts && curl -fLO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/DroidSansMono.zip
#wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FontPatcher.zip
