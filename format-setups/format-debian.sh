#!/bin/bash
# Debian version

list=(build-essential autoconf libtool pkg-config python-dev python3-dev \
python-pip texlive-full terminator vim vim-gtk iptraf audacity vlc mediainfo \
unrar wxhexeditor ht bless binwalk wireshark aircrack-ng wifite nmap hydra \
zbar-tools g++ g++-6 gcc-6 git curl vinetto skype pdf-presenter-console \
libpcap0.8-dev cmake strace ltrace smplayer alsa-utils network-manager \
python-software-properties apt-files gimp inkscape chkconfig htop \
libgtkmm.3.0-dev libssl-dev gettext libarchive-dev)

piplist=(hashlib jedi pwn)

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
    echo -n "" > /etc/apt/sources.list
    echo "deb http://http.kali.org/kali kali-rolling main contrib non-free" >> /etc/apt/sources.list
    echo "deb http://old.kali.org/kali sana main non-free contrib" >> /etc/apt/sources.list
    echo "deb http://old.kali.org/kali moto main non-free contrib" >> /etc/apt/sources.list
    echo "deb http://archive.canonical.com/ $(lsb_release -sc) partner" >> /etc/apt-sources.list
    echo "deb http://kali.cs.nctu.edu.tw/ /kali main contrib non-free" >> /etc/apt/sources.list
    echo "deb http://kali.cs.nctu.edu.tw/ /wheezy main contrib non-free" >> /etc/apt/sources.list
    echo "deb http://kali.cs.nctu.edu.tw/kali kali-dev main contrib non-free" >> /etc/apt/sources.list
    echo "deb http://kali.cs.nctu.edu.tw/kali kali-dev main/debian-installer" >> /etc/apt/sources.list
    echo "deb-src http://kali.cs.nctu.edu.tw/kali kali-dev main contrib non-free" >> /etc/apt/sources.list
    echo "deb http://kali.cs.nctu.edu.tw/kali kali main contrib non-free" >> /etc/apt/sources.list
    echo "deb http://kali.cs.nctu.edu.tw/kali kali main/debian-installer" >> /etc/apt/sources.list
    echo "deb-src http://kali.cs.nctu.edu.tw/kali kali main contrib non-free" >> /etc/apt/sources.list
    echo "deb http://kali.cs.nctu.edu.tw/kali-security kali/updates main contrib non-free" >> /etc/apt/sources.list
    echo "deb-src http://kali.cs.nctu.edu.tw/kali-security kali/updates main contrib non-free" >> /etc/apt/sources.list
    echo "deb http://kali.cs.nctu.edu.tw/kali kali-bleeding-edge main" >> /etc/apt/sources.list

else
    echo " [+] Unknow system."
fi

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
file=script-macchanger
echo "#!/bin/bash" > $file
echo "" >> $file
echo "ifconfig eth0 down" >> $file
echo "ifconfig wlan0 down" >> $file
echo "macchanger -r eth0" >> $file
echo "macchanger -r wlan0" >> $file
echo "ifconfig eth0 up" >> $file
echo "ifconfig wlan0 up" >> $file
chmod +x $file
mv $file /usr/bin/
cd ~

### PATHOGEN FOR VIM
mkdir -p ~/.vim/autoload ~/.vim/bundle
wget https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim
mv pathogen.vim ~/.vim/autoload/

cd ~

### CONFIGURATIONS FOR VIM
file=.vimrc
echo "execute pathogen#infect()" > $file
echo "    call pathogen#helptags()" >> $file
echo "    filetype plugin indent on" >> $file
echo "    syntax on \"Para utilizar com o tema solarized" >> $file
echo "    set showmatch \"mostra caracteres ( { [ quando fechados" >> $file
echo "    set textwidth=79 \"largura do texto" >> $file
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

### COWPATTY
echo " [+] Checking cowpatty: "
exec 2> /dev/null
status=$(apt list --installed | grep 'installed' | grep cowpatty | \
       tail -n 1 | awk -F/ '{print $1}')
if [[ ! -z $status ]]
then
    echo -n "found."
else
    echo " [!] Installing cowpatty (in opt): "
    cd /opt/
    wget http://www.willhackforsushi.com/code/cowpatty/4.6/cowpatty-4.6.tgz
    tar xvf cowpatty-4.6.tgz
    rm -rf cowpatty-4.6.tgz
    cd cowpatty-4.6
    make
    cp cowpatty /usr/bin/
    echo -n "done!"
fi

### TELEGRAM
echo " [+] Installing Telegram (desktop)."
cd /opt/
wget https://updates.tdesktop.com/tlinux/tsetup.0.10.11.tar.xz
tar xvf tsetup.0.10.11.tar.xz
rm -rf tsetup.0.10.11.tar.xz
cd 
make

### PULSEAUDIO
echo " [+] Fixing pulseaudio."
killall -9 pulseaudio
systemctl --user enable pulseaudio && systemctl --user start pulseaudio

### PEDA
echo " [+] Downloading and installing peda."
cd /opt/
git clone https://github.com/longld/peda.git peda
echo “source peda/peda.py” >> ~/.gdbinit

### Installing Grub-Customizer
echo " [+] Downloading and installing Grub-Customizer."
cd /opt/
wget https://launchpadlibrarian.net/172968333/grub-customizer_4.0.6.tar.gz
tar xvf grub-customi*
cd grub-customi*
cmake . && make -j3
make install

### Terminator configs
echo " [+] Changing terminator configs."

file=~/.config/terminator/config

echo "\[global_config\]" >> $file
echo "\[keybindings\]" >> $file
echo "\[profiles\]" >> $file
echo "  \[\[default\]\]" >> $file
echo "    background_image = None" >> $file
echo "    font = Monospace 11" >> $file
echo "    background_color = \"\#fdf6e3\"" >> $file
echo "    foreground_color = \"\#657b83\"" >> $file
echo "\[layouts\]" >> $file
echo "  \[\[default\]\]" >> $file
echo "    \[\[\[child1\]\]\]" >> $file
echo "      type = Terminal" >> $file
echo "      parent = window0" >> $file
echo "      profile = default" >> $file
echo "    \[\[\[window0\]\]\]" >> $file
echo "      type = Window" >> $file
echo "      parent = \"\"" >> $file
echo "\[plugins\]" >> $file

echo " [+] All configurations done."
