#!/bin/bash
# Debian version

list=(build-essential autoconf libtool pkg-config python-dev network-manger \
python-pip texlive-full terminator vim vim-gtk iptraf audacity vlc mediainfo \
unrar wxhexeditor ht bless binwalk wireshark aircrack-ng wifite nmap hydra \
zbar-tools g++ g++-6 gcc-6 git curl vinetto skype pdf-presenter-console \
libpcap0.8-dev cmake)

piplist=(hashlib jedi)

function check()
{
    name=$1
    exec 2> /dev/null
    status=$(apt list --installed | grep 'installed' | grep $name | \
            tail -n 1 | awk -F/ '{print $1}')
    
    if [[ ! -z $status ]]
    then
        return 1
    else
        echo " [-] Package $name not found."
        echo -n " [+] Trying to install: "
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
    echo " [-] Please, execute as root!"
    exit
fi

# Skype repository
add-apt-repository "deb http://archive.canonical.com/ $(lsb_release -sc) partner"

sudo apt-get update
updatedb

list=(build-essential)

    for current in ${list[@]}
do
    echo " [+] Checking $current"
    check $current
done

for current in ${piplist[@]}
do
    echo " [+] Checking $current"
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
mv $file /etc/init.d/
cd /etc/init.d/
chmod +x $file
update-rc.d $file defaults
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
cd ~
wget http://www.willhackforsushi.com/code/cowpatty/4.6/cowpatty-4.6.tgz
tar xvf cowpatty-4.6.tgz
cd cowpatty-4.6
make
cp cowpatty /usr/bin/
rm -rf cowpatty-4.6.tgz
