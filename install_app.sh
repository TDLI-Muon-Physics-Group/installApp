#!/bin/bash

CWD=`pwd`
WORKSPACE=$(echo $CWD | awk -F '/' '{print $NF}')

# GEANT4
GEANT4="siewyanhoh/musim:geant4-10.7.3"
# crySIM
CRYSIM="siewyanhoh/musim:crySim-1.1"
# ROOT
ROOT="siewyanhoh/musim:root-6.28.12"

#
if [[ $WORKSPACE != "installApp" ]]; then
    echo 'Error: please run the install script in the installApp folder' >&2
    exit
fi

function addbashrc {
    TEST=$(grep -q "$@" ${HOME}/.bashrc; echo $?)
    if [[ "$TEST" -eq "1" ]]; then
	echo "" >> ~/.bashrc
        echo "$@" >> ~/.bashrc
    fi
}

function banner {

    clear

    cat <<\EOF
  __  __                     _____  _               _             _____      _ _______ _    _ 
 |  \/  |                   |  __ \| |             (_)           / ____|    | |__   __| |  | |
 | \  / |_   _  ___  _ __   | |__) | |__  _   _ ___ _  ___ ___  | (___      | |  | |  | |  | |
 | |\/| | | | |/ _ \| '_ \  |  ___/| '_ \| | | / __| |/ __/ __|  \___ \ _   | |  | |  | |  | |
 | |  | | |_| | (_) | | | | | |    | | | | |_| \__ \ | (__\__ \  ____) | |__| |  | |  | |__| |
 |_|  |_|\__,_|\___/|_| |_| |_|    |_| |_|\__, |___/_|\___|___/ |_____/ \____/   |_|   \____/ 
  _____           _        _ _       _   _ __/ |                       _       _              
 |_   _|         | |      | | |     | | (_)___/                       (_)     | |             
   | |  _ __  ___| |_ __ _| | | __ _| |_ _  ___  _ __    ___  ___ _ __ _ _ __ | |_            
   | | | '_ \/ __| __/ _` | | |/ _` | __| |/ _ \| '_ \  / __|/ __| '__| | '_ \| __|           
  _| |_| | | \__ \ || (_| | | | (_| | |_| | (_) | | | | \__ \ (__| |  | | |_) | |_            
 |_____|_| |_|___/\__\__,_|_|_|\__,_|\__|_|\___/|_| |_| |___/\___|_|  |_| .__/ \__|           
                                                                        | |                   
                                                                        |_|                   
EOF
    printf "%s\n\n" "(c) Simulation/software ..."

    return 0
}



#
function makeApp {    
    mkdir -p ${CWD}/app
    cat <<EOF > ${CWD}/app/${1}
#/bin/bash
docker run -it --rm -v \`pwd\`:/root --user \$(id -u) ${2} \$@
EOF
    chmod +x ${CWD}/app/${1}
    addbashrc "export PATH=${CWD}/app/:\$PATH"
    echo app ${1} is installed at ${CWD}/app/${1}
}

function makeVM {

    mkdir -p ${CWD}/app
    cat <<EOF > ${CWD}/app/${1}
#/bin/bash
docker run -it --rm -v \`pwd\`:/root --user \$(id -u) ${2} /bin/bash
EOF
    chmod +x ${CWD}/app/${1}
    addbashrc "export PATH=${CWD}/app/:\$PATH"
    echo app ${1} is installed at ${CWD}/app/${1}
}

#
if ! [ -x "$(command -v docker)" ]; then
    echo 'Error: docker is not installed.' >&2
    exit
else
    echo Docker found! , `docker --version` >&2
    echo
    banner $*
    echo
    echo "Please choose an option:"
    echo "1. Install root"
    echo "2. Install Geant4 + root"
    echo "3. Install muCrySim"

    # Read user input
read -p "Enter your choice (1, 2, or 3): " choice

# Execute action based on the choice
case $choice in
    1)
	echo "Installing ROOT $(echo $ROOT | awk -F ":" '{print $NF}')"
	docker pull $ROOT
	makeApp rootu $ROOT
        ;;
    2)
	echo "Installing Geant4 + root"
	docker pull $GEANT4
	makeVM useG4 $GEANT4
	;;
    3)
	echo "Installing crySim"
	docker pull $GEANT4
	makeApp muCrySim $CRYSIM
        ;;
    *)
        echo "Invalid choice! Please run the script again and select a valid option."
        ;;
esac
fi

echo restart terminal to refresh PATH...
