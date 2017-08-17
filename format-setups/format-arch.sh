#!/bin/bash
# Arch version

user="j3r3mias"
homepath="/home/$user"

if (( $EUID != 0 ))
then
    echo " [!] Please, execute as root!"
    exit
fi

echo LANG=pt_BR.UTF-8 > /etc/locale.conf
export LANG=pt_BR.UTF-8

hwclock  --systohc --utc

echo tardis > /etc/hostname

# Manual setup for instance
wifi-menu

pacman -S wireless_tools wpa_supplicant wpa_actiond dialog
pacman -S vim
pacman -S grub
grub-install --target=i386-pc --recheck /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
useradd -m -g users -G wheel -s /bin/bash $user

list=(locate users audio video daemon dbus disk games rfkill lp network optical
power scanner storage vieo video)

for i in ${list[@]}
do
    gpasswd -a $user $i
done

usermod -aG sudo $user

pacman -S acpi acpid
systemctl enable acpid.service

pacman -S openssh
systemctl enable sshd.service


echo " [+] SSH agent"
sshfile='~/.config/systemd/user/ssh-agent.service'

echo '[Unit]' >> $sshfile
echo 'Description=SSH key agent' >> $sshfile
echo '' >> $sshfile
echo '[Service]' >> $sshfile
echo 'Type=simple' >> $sshfile
echo 'Environment=SSH_AUTH_SOCK=%t/ssh-agent.socket' >> $sshfile
echo 'ExecStart=/usr/bin/ssh-agent -D -a $SSH_AUTH_SOCK' >> $sshfile
echo '' >> $sshfile
echo '[Install]' >> $sshfile
echo 'WantedBy=default.target' >> $sshfile
echo '' >> $sshfile
echo 'SSH_AUTH_SOCK   DEFAULT="${XDG_RUNTIME_DIR}/ssh-agent.socket"' >> ~/.pam_environment

pacman -S --needed base-devel git wget yajl
git clone https://aur.archlinux.org/package-query.git
git clone https://aur.archlinux.org/yaourt.git

cd package-query
makepkg -si
cd ..

cd yaourt
makepkg -si
cd ..

rm -dR yaourt/ package-query/

# Package to create the rules based in previous debian usage
# list=(build-essential autoconf libtool pkg-config python-dev python3-dev \
#     python-pip texlive-full terminator vim vim-gtk iptraf audacity vlc \
#     mediainfo unrar wxhexeditor ht bless binwalk wireshark aircrack-ng wifite \
#     nmap hydra zbar-tools g++ g++-6 gcc-6 git curl vinetto skype \
#     pdf-presenter-console libpcap0.8-dev cmake strace ltrace smplayer \
#     alsa-utils network-manager python-software-properties apt-files gimp \
#     inkscape chkconfig htop libgtkmm.3.0-dev libssl-dev gettext \
#     libarchive-devsudo cmake-curses-gui hexchat dcfldd torbrowser-launcher \
#     higan mame xboxdrv lib32stdc++6 mtr-tiny dkms virtualbox cups exiftools \
#     steghide imagemagick lzip apache2 ltrace deluge jd-gui spotify-client \
#     bsdiff wine printer-driver-pxljr xclip xcape okular meld intltool autoconf \
#     automake libglib2.0-dev gawk libgtk-3-dev libxml2-dev libxv-dev \
#     libsdl1.2-dev libpulse-dev libportaudio-ocaml-dev libportaudio2)
# 
# piplist=(hashlib jedi pwn xortool hashid sympy)

cd $homepath

git config --global user.email "j3r3miasmg@gmail.com"
git config --global user.name "Jeremias Moreira Gomes"

### PATHOGEN FOR VIM
echo " [+] Installing pathogen for vim"
mkdir -p $homepath/.vim/autoload $homepath/.vim/bundle
curl -LSso $homepath/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

### CONFIGURATIONS FOR VIM
echo " [+] Creating .vimrc"

cd $homepath
file=.vimrc
echo "execute pathogen#infect()" > $file
echo "    call pathogen#helptags()" >> $file
echo "    filetype plugin indent on" >> $file
echo "    syntax on \"Para utilizar com o tema solarized" >> $file
echo "    set showmatch \"mostra caracteres ( { [ quando fechados" >> $file
echo "    set textwidth=80 \"largura do texto" >> $file
echo "    set nowrap  \"sem wrap (quebra de linha)" >> $file
echo "    set mouse=a \"habilita todas as acoes do mouse" >> $file
echo "    set nu \"numeracao de linhas" >> $file
echo "    set ts=4 \"Seta onde o tab para" >> $file
echo "    set sw=4 \"largura do tab" >> $file
echo "    set et \"espacos em vez de tab" >> $file
echo "    \"set spell spelllang=pt\"" >> $file
echo "    set nospell" >> $file
echo "    set background=light" >> $file
echo "    \"set background=dark" >> $file
echo "    let g:ycm_min_num_of_chars_for_completion = 1" >> $file
echo "    set clipboard=unnamedplus \"Permite copiar direto para o clipboard" >> $file
echo "    set laststatus=2" >> $file
echo "    set t_Co=256" >> $file
echo "    let g:airline_powerline_fonts=1" >> $file
echo "    set relativenumber" >> $file
echo "    highlight OverLength ctermbg=red ctermfg=white guibg=#592929" >> $file
echo "    match OverLength /\%81v.*/" >> $file

cd $homepath/.vim/
git init
git submodule add https://github.com/scrooloose/syntastic.git bundle/syntastic
git submodule add https://github.com/ajh17/VimCompletesMe.git bundle/vim-completes-me
git submodule add https://github.com/jiangmiao/auto-pairs.git bundle/auto-pairs
git submodule add https://github.com/vim-scripts/The-NERD-tree.git bundle/nerdtree
git submodule add https://github.com/bling/vim-airline.git bundle/vim-airline
git submodule add https://github.com/altercation/vim-colors-solarized.git bundle/vim-colors-solarized
git submodule add http://github.com/tpope/vim-fugitive.git bundle/fugitive
vim -u NONE -c "helptags vim-fugitive/doc" -c q
git submodule add https://github.com/davidhalter/jedi-vim.git bundle/jedi-vim
git submodule init
git submodule update
git submodule foreach git submodule init
git submodule foreach git submodule update

cd $homepath

## TELEGRAM
echo " [+] Installing Telegram (desktop)."
telegram=telegram.tar.xz
cd /opt/
curl -LSso $telegram https://telegram.org/dl/desktop/linux
tar xvf $telegram
rm -rf $telegram
cd Telegram
mv Telegram /usr/bin
cd /opt/
rm -rf Telegram/

### PEDA
echo " [+] Downloading and installing peda."
cd /opt/
git clone https://github.com/longld/peda.git peda
echo “source peda/peda.py” > $homepath/.gdbinit

### WIFI-PUMPKIN 
echo " [+] Downloading and installing Wifi-Pumpkin."
cd /opt/
git clone https://github.com/P0cL4bs/WiFi-Pumpkin.git
cd WiFi-Pumpkin
chmod +x installer.sh
./installer.sh --install

### Installing Grub-Customizer
echo " [+] Downloading and installing Grub-Customizer."
cd /opt/
wget https://launchpadlibrarian.net/172968333/grub-customizer_4.0.6.tar.gz
tar xvf grub-customi*
cd grub-customi*
cmake . && make -j3
make install

# echo " [+] Cloning git repositories."
# cd $homepath/Documents
# git clone git@bitbucket.org:jeremiasmg/papers.git
# mv $homepath/papers $homepath/jeremias-papers
# git clone git@bitbucket.org:gteodoro/papers.git
# mv $homepath/papers $homepath/george-papers
# 
# mkdir -p $homepath/Development
# chown $user.$user $homepath/Development
# cd $homepath/Development
# git clone git@bitbucket.org:jeremiasmg/cryptopals.git
# git clone git@github.com:j3r3mias/random.git
# git clone git@github.com:j3r3mias/ctf.git
# git clone git@github.com:j3r3mias/competitive-programming.git
# git clone git@github.com:j3r3mias/teleHaF.git

echo " [+] Creating alias." echo '' >> $homepath/.bashrc 
echo '# Telegram alias' >> $homepath/.bashrc 
echo "alias telegram='cd ~; nohup Telegram &'" >> $homepath/.bashrc 
echo "alias Telegram='cd ~; nohup Telegram &'" >> $homepath/.bashrc 
echo "alias random='cd $homepath/Development/random'" >> $homepath/.bashrc 
echo "alias ctf='cd $homepath/Development/ctf'" >> $homepath/.bashrc 
echo "alias uri='cd $homepath/Development/competitive-programming/uri'" >> $homepath/.bashrc 
echo "alias daily='cd $homepath/Development/competititve-programming/dailyprogrammer'" >> $homepath/.bashrc 
echo '' >> $homepath/.bashrc

echo " [+] History setup."

echo " # History setaup." >> $homepath/.bashrc
echo 'HISTSIZE=1100000' >> $homepath/.bashrc
echo 'HISTFILESIZE=1200000'   >> $homepath/.bashrc 

echo " [+] ROT13."
echo '# ROT13' >> $homepath/.bashrc 
echo "alias rot13=\"tr '[A-Za-z]' '[N-ZA-Mn-za-m]'\"" >> $homepath/.bashrc
echo '' >> $homepath/.bashrc 

echo ""
echo " [!] All done."
