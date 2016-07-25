# prepare / review common_ubuntu_vm.sh
# prepare / review config.fish
# set base mem
# set network
# create sf_Dropbox
# create sf_Code
# install guest additions (if you seem to have already a pre-installed version you can do: sudo apt-get purge virtualbox*)


HERE_USER=langenha
HERE_MAILADDR=andreas.langenhagen@here.com
USER=barn


function main {

    read -n1 -r -p "Which script stage do you want to enter? (1 or 2): " stage
    echo

    if [ $stage == 1 ]; then
       stage_one
    elif [ $stage == 2 ]; then
        stage_two
    else
       echo "Invalid input. Exiting"
       exit 1
    fi

    echo 'Stage $stage ends.'
    exit 0
}


function stage_one {

    sudo passwd $USER


    sudo apt-get install software-properties-common
    sudo add-apt-repository ppa:george-edison55/cmake-3.x

    sudo apt-get --assume-yes install git cmake ccache ninja-build build-essential doxygen libcurl4-openssl-dev mono-devel
    sudo apt-get --assume-yes install mesa-common-dev libglu1-mesa-dev libicu-dev libexpat1-dev libpng12-dev git-gui gitk
    sudo apt-get --assume-yes install meld ruby ruby-nokogiri libglew-dev
    sudo apt-get --assume-yes install libjogl2-java
    sudo apt-get --assume-yes install libxmlsec1-openssl chrpath libxml2-dev libssl-dev keychain
    sudo apt-get --assume-yes install libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 ant default-jdk
    sudo apt-get --assume-yes install python-dev python-pip curl
    sudo apt-get --assume-yes install vim fish tig
    sudo apt-get --assume-yes install clang-3.5
    sudo apt-get --assume-yes install freeglut3 freeglut3-dev binutils-gold g++ mesa-common-dev build-essential libglew1.5-dev libglm-dev

    sudo apt-get update
    sudo apt-get -y upgrade


    wget http://de.archive.ubuntu.com/ubuntu/pool/universe/s/swig/swig3.0_3.0.2-1ubuntu1_amd64.deb
    sudo dpkg -i swig3.0_3.0.2-1ubuntu1_amd64.deb

    sudo pip install python-dateutil
    sudo pip install web.py testtools autopep8 xmlrunner

    mkdir -p /home/$USER/bin
    PATH=/home/$USER/bin:$PATH
    echo >> /home/$USER/.profile
    echo "export PATH=$PATH:/home/$USER/bin" >> /home/$USER/.profile
    curl https://storage.googleapis.com/git-repo-downloads/repo > /home/$USER/bin/repo
    chmod a+x /home/$USER/bin/repo


    ccache -M 64G


    sudo rm -rf /media/sf_Data 2> /dev/null
    sudo rm -rf /home/$USER/olympia/repo 2> /dev/null

    ssh-keygen -C $HERE_MAILADDR
    echo >> ~/.bashrc
    echo "eval \`keychain --eval ~/.ssh/id_rsa\`" >> /home/$USER/.bashrc


    cmake --version # just for curiosity for info

    echo '

    Register your public ssh key at Gerrit to access CARLO-repository
    Open    https://gerrit.it.here.com
    Sign in
    Click Name on the top-right -> Settings -> SSH Public Keys
    Add Key
    cat ~/.ssh/id_rsa.pub
    Copy output of id_rsa.pub to "Add SSH Public key text box" and then select "Add"

    Sign out (or reboot virtual machine)

    In stage 2, the script will test your Gerrit connection. If some problems occur, you can do that manually:
    ssh -p 29418 $HERE_USER@gerrit.it.here.com

    Try ssh-add if you encounter issues like this:
                 Permission denied (publickey).
                 Agent admitted failure to sign using the key.

     Maybe, now is all a good time to make a first backup
    '
    read -n1 -r -p "Any key to continue..." key
}


function stage_two {

    echo 'Checking gerrit connection:'
    ssh -p 29418 $HERE_USER@gerrit.it.here.com
    read -n1 -r -p "Any key to continue..." key


    mkdir -p /home/$USER/olympia
    mkdir -p /home/$USER/olympia/repo
    mkdir -p /home/$USER/olympia/olymp-vm-build
    mkdir -p /home/$USER/olympia/olymp-prime-build

    ln -sfn /media/sf_Dropbox /home/$USER/Desktop/sf_Dropbox
    ln -sfn /media/sf_code /home/$USER/Desktop/sf_code
    ln -sfn /media/sf_code/scripts /home/$USER/Desktop/sf_scripts
    ln -sfn /home/$USER/olympia/repo /home/$USER/Desktop/olymp-vm-repo
    ln -sfn /home/$USER/olympia/olymp-vm-build /home/$USER/Desktop/olymp-vm-build
    ln -sfn /media/sf_code/olympia-prime /home/$USER/Desktop/olymp-prime-repo
    ln -sfn /home/$USER/olympia/olymp-prime-build /home/$USER/Desktop/olymp-prime-build

    ln -sfn /media/sf_code/scripts/common.sh /home/$USER/common.sh

    mkdir -p /home/$USER/.config/fish
    cp /media/sf_Dropbox/config.fish /home/$USER/.config/fish/config.fish           # <<< actually provide the file that is to be copied
    sudo chsh -s `which fish`                                                       # <<< does not work always! (i.e. doesnt work with Linux Mint)


    sudo chmod u+s /sbin/shutdown       # enables shutdown launcher
    sudo chmod u+s /sbin/reboot         #         reboot launcher


    git config --global review.gerrit.it.here.com.username $HERE_USER
    git config --global core.autocrlf input
    git config --global user.email "$HERE_MAILADDR"
    git config --global user.name $HERE_USER
    git config --global diff.tool meld
    git config --global merge.tool meld
    git config --global core.editor "vim"


    cd /home/$USER/olympia/repo
    repo init -u ssh://$HERE_USER@gerrit.it.here.com:29418/prime/manifest -m olympia.xml
    repo sync -j `cat /proc/cpuinfo | grep -c 'processor'`


    echo '
    Now shutdown
    And make a backup

    If you want,
    Change the disk size on host site:

        VBoxManage modifyhd Olympia_official_dev_v2-disk1.vdi --resize 122880

        Use a   gparted live   cd to modify partition sizes

        Then do in the guest system:

        sudo pvdisplay # look for Free PE
        sudo lvresize --resizefs -l <value of Free PE> /dev/ubuntu-vg/root
        sudo pvdisplay  # for checking

        Do a backup

    - download & install qtc, etc
    - make custom changes

    Do a backup
    '
}





main "$@"
