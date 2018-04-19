#!/bin/bash
# Debian version

user="j3r3mias"
homepath="/home/$user"

list=(build-essential autoconf libtool pkg-config python-dev python3-dev \
    python-pip texlive-full terminator gvim vim vim-gtk iptraf audacity vlc \
    mediainfo unrar wxhexeditor ht bless binwalk wireshark aircrack-ng wifite \
    nmap hydra zbar-tools g++ g++-6 gcc-6 git curl vinetto \
    pdf-presenter-console libpcap0.8-dev cmake strace ltrace smplayer \
    alsa-utils network-manager python-software-properties apt-files gimp \
    inkscape chkconfig htop libgtkmm.3.0-dev libssl-dev gettext \
    libarchive-devsudo cmake-curses-gui hexchat dcfldd torbrowser-launcher \
    higan mame xboxdrv lib32stdc++6 mtr-tiny dkms virtualbox cups libimage-exiftool-perl \
    steghide imagemagick lzip apache2 ltrace deluge jd-gui spotify-client \
    bsdiff wine printer-driver-pxljr xclip xcape okular meld intltool autoconf \
    automake libglib2.0-dev gawk libgtk-3-dev libxml2-dev libxv-dev zsnes \
    libsdl1.2-dev libpulse-dev libportaudio-ocaml-dev libportaudio2 \
    sublime openvpn python-qt4 metasploit hplip mixxx radare2 haguichi \
    anthy ibus-anthy openmpi-bin openmpi-common openmpi-doc libopenmpi2 \
    libopenmpi-dev gnome-tweak-tool sl)

piplist=(hashlib jedi pwn xortool hashid sympy colorama Crypto pycrypto)

function check()
{
    name=$1
    exec 2> /dev/null
    status=$(apt list --installed | grep 'installed' | grep $name | \
            tail -n 1 | awk -F/ '{print $1}')
    
    if [[ ! -z $status ]]
    then
        echo " [+] Package $name found!"
        return 1
    else
        echo " [-] Package $name not found."
        echo -n " [!] Trying to install: "
        apt-get install -y $name
        status=$(apt list --installed | grep 'installed' | grep $name | \
            tail -n 1 | awk -F/ '{print $1}')
        if [[ ! -z $status* ]]
        then
            echo "OK"
            return 1
        else
            echo "FAIL"
            return 0
        fi
    fi
}

function pipcheck()
{
    name=$1
    status=$(pip list | grep 'installed' | grep $name | \
            tail -n 1 | awk -F/ '{print $1}')
    if [[ ! -z $status ]]
    then
        return 1
    else
        echo " [-] Package $name not found."
        echo -n " [+] Trying to install: "
        pip install $name
        status=$(pip list | grep 'installed' | grep $name | \
            tail -n 1 | awk -F/ '{print $1}')
        if [[ ! -z $status* ]]
        then
            echo "OK"
            return 1
        else
            echo "FAIL"
            return 0
        fi
    fi
}

if (( $EUID != 0 ))
then
    echo " [!] Please, execute as root!"
    exit
fi

echo "Let's go!"
version=$(uname -a)

if [[ $version == *Ubuntu* ]]
then 
    echo " [+] Ubuntu system. No need to add repositories."
elif [[ $version == *kali* ]]
then
    echo " [+] Kali system. Adding some repositories."
    aptpath="/etc/apt/sources.list"
    echo -n "" > $aptpath
    echo "deb http://kali.cs.nctu.edu.tw/kali kali-dev main contrib non-free" >> $aptpath
    echo "deb http://kali.cs.nctu.edu.tw/kali kali-dev main/debian-installer" >> $aptpath
    echo "deb-src http://kali.cs.nctu.edu.tw/kali kali-dev main contrib non-free" >> $aptpath
    echo "deb http://kali.cs.nctu.edu.tw/kali kali main contrib non-free" >> $aptpath
    echo "deb http://kali.cs.nctu.edu.tw/kali kali main/debian-installer" >> $aptpath
    echo "deb-src http://kali.cs.nctu.edu.tw/kali kali main contrib non-free" >> $aptpath
    echo "deb http://kali.cs.nctu.edu.tw/kali-security kali/updates main contrib non-free" >> $aptpath
    echo "deb-src http://kali.cs.nctu.edu.tw/kali-security kali/updates main contrib non-free" >> $aptpath
    echo "deb http://kali.cs.nctu.edu.tw/kali kali-bleeding-edge main" >> $aptpath
    echo "deb http://repository.spotify.com stable non-free" >> $aptpath
else
    echo " [+] Unknow system."
fi
echo " [+] Adding repositories."
sudo add-apt-repository ppa:webupd8team/haguichi
echo " [+] Updating repositories."
apt-get update
echo " [+] Upgrading repositories."
apt-get upgrade -y
echo " [+] Updating repositories."
apt-get update
updatedb



for current in ${list[@]}
do
    echo " [+] Checking $current."
    check $current
done

for current in ${piplist[@]}
do
    echo " [+] Checking $current."
    pipcheck $current
done


### Automatic MACCHANGER
echo " [+] Generating MAC changer script for every boot."
file=script-macchanger
echo "#!/bin/bash" > $file
echo "" >> $file
echo "ifconfig eth0 down" >> $file
echo "ifconfig wlan0 down" >> $file
echo "macchanger -r eth0" >> $file
echo "macchanger -r wlan0" >> $file
echo "ifconfig eth0 up" >> $file
echo "ifconfig wlan0 up" >> $file
chmod +755 $file
mv $file /usr/bin/
sed -i "s/exit 0/$file\n\nexit 0/" /etc/rc.local

cd $homepath

git config --global user.email 'j3r3miasmg@gmail.com'
git config --global user.name 'Jeremias Moreira Gomes'

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

### PULSEAUDIO
echo " [+] Fixing pulseaudio."
killall -9 pulseaudio
systemctl --user enable pulseaudio && systemctl --user start pulseaudio

### PEDA
echo " [+] Downloading and installing peda."
cd /opt/
git clone https://github.com/longld/peda.git peda
echo “source peda/peda.py” > $homepath/.gdbinit

### Installing Grub-Customizer
echo " [+] Downloading and installing Grub-Customizer."
cd /opt/
wget https://launchpadlibrarian.net/172968333/grub-customizer_4.0.6.tar.gz
tar xvf grub-customi*
cd grub-customi*
cmake . && make -j3
make install

### Installing snes9x
echo " [+] Downloading and installing snes9x."
cd /opt/
git clone https://github.com/snes9xgit/snes9x.git
cd snes9x/unix
autoconf
./configure --enable-netplay
make
cp snes9x /usr/bin/
wget http://maxolasersquad.com/snes9x.png -O /usr/share/pixmaps/snes9x.png
cd ../gtk
./autogen.sh
./configure --with-gtk3
make
cp snes9x-gtk /usr/bin/
deskFile='/usr/share/applications/snes9x.desktop'
echo -n '' > $deskFile
echo '[Desktop Entry]' >> $deskFile
echo 'Version=1.0' >> $deskFile
echo 'Name=Snes9x GTK' >> $deskFile
echo 'Comment=A portable, freeware Super Nintendo Entertainment System (SNES)' >> $deskFile
echo 'emulator.' >> $deskFile
echo 'GenericName=Snes9x GTK' >> $deskFile
echo 'Keywords=Games' >> $deskFile
echo 'Exec=snes9x-gtk' >> $deskFile
echo 'Terminal=false' >> $deskFile
echo 'X-MultipleArgs=false' >> $deskFile
echo 'Type=Application' >> $deskFile
echo 'Icon=/usr/share/pixmaps/snes9x.png' >> $deskFile
echo 'Categories=Game' >> $deskFile
echo 'StartupWMClass=Snes9x' >> $deskFile
echo 'StartupNotify=true' >> $deskFile

# # echo " [+] Cloning git repositories."
# # cd $homepath/Documents
# # git clone git@bitbucket.org:jeremiasmg/papers.git
# # mv $homepath/papers $homepath/jeremias-papers
# # git clone git@bitbucket.org:gteodoro/papers.git
# # mv $homepath/papers $homepath/george-papers
# 
# # mkdir -p $homepath/Development
# # chown $user.$user $homepath/Development
# # cd $homepath/Development
# # git clone git@bitbucket.org:jeremiasmg/cryptopals.git
# # git clone git@github.com:j3r3mias/random.git
# # git clone git@github.com:j3r3mias/ctf.git
# # git clone git@github.com:j3r3mias/competitive-programming.git
# # git clone git@github.com:j3r3mias/teleHaF.git
# 
echo "[+] Creating alias."
echo '' >> $homepath/.bashrc 
echo '# Telegram alias' >> $homepath/.bashrc 
echo "alias telegram='cd ~; nohup Telegram &'" >> $homepath/.bashrc 
echo "alias Telegram='cd ~; nohup Telegram &'" >> $homepath/.bashrc 
echo "alias random='cd $homepath/Development/random'" >> $homepath/.bashrc 
echo "alias ctf='cd $homepath/Development/ctf'" >> $homepath/.bashrc 
echo "alias CTF='cd $homepath/Development/ctf'" >> $homepath/.bashrc 
echo "alias uri='cd $homepath/Development/competitive-programming/uri'" >> $homepath/.bashrc 
echo "alias daily='cd $homepath/Development/competititve-programming/dailyprogrammer'" >> $homepath/.bashrc 

echo " [+] Creating new directory path view."
echo '' >> $homepath/.bashrc 
echo '' >> $homepath/.bashrc 
echo '' >> $homepath/.bashrc 

echo " [+] Increasing history size."
sed -i 's/\(HISTSIZE=\).*/\1100000/;s/\(HISTFILESIZE=\).*/\1200000/' $homepath/.bashrc

echo " [+] ROT13."
echo '# ROT13' >> $homepath/.bashrc 
echo "alias rot13=\"tr \'[A-Za-z]\' \'[N-ZA-Mn-za-m]\'\"" $homepath/.bashrc
echo '' >> $homepath/.bashrc 

updatedb
echo "     OK"
echo ""
echo " [!] All done."
