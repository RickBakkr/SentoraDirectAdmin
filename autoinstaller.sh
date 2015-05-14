#!/usr/bin/env bash

THEME_NAME=directadmin
THEME_URL=https://github.com/RickB2000/SentoraDirectAdmin/archive/master.zip
SENTORA_VERSION=( "1.0.0")

echo "$THEME_NAME Theme installer/updater for Sentora."
echo "This autoinstaller is made by Ron-e / Auxio. Thanks!"
echo "###########################################################"
echo "#  THE SCRIPT IS DISTRIBUTED IN THE HOPE THAT IT WILL BE  #" 
echo "# USEFUL, IT IS PROVIDED 'AS IS' AND WITHOUT ANY WARRANTY #"
echo "###########################################################"
	
echo "Checking if the OS is compatible with this installer/updater..."

if [ -f /etc/centos-release ]; then
    OS="CentOs"
    VERFULL=$(sed 's/^.*release //;s/ (Fin.*$//' /etc/centos-release)
    VER=${VERFULL:0:1} # return 6 or 7
elif [ -f /etc/lsb-release ]; then
    OS=$(grep DISTRIB_ID /etc/lsb-release | sed 's/^.*=//')
    VER=$(grep DISTRIB_RELEASE /etc/lsb-release | sed 's/^.*=//')
else
    OS=$(uname -s)
    VER=$(uname -r)
fi

if [[ "$OS" = "CentOs" && ("$VER" = "6" || "$VER" = "7" ) || 
      "$OS" = "Ubuntu" && ("$VER" = "12.04" || "$VER" = "14.04" ) ]] ; then 
    echo "$OS is supported by Sentora and this theme installer/updater."
else
	echo "Sorry, $OS $VERFULL is not supported by Sentora and this theme installer/updater." 
    exit 1
fi

echo "Checking if Sentora is installed and compatible with this installer/updater..."		

function contains() {
    local n=$#
    local value=${!n}
    for ((i=1;i < $#;i++)) {
        if [ "${!i}" == "${value}" ]; then
            echo "y"
            return 0
        fi
    }
    echo "n"
    return 1
}

if [ -d "/etc/sentora/panel" ]; then		
	VERSION_SENTORA=$(setso --show dbversion)		
	if [ $(contains "${SENTORA_VERSION[@]}" "$VERSION_SENTORA") == "y" ]; then
	#if [[ "$VERSION_SENTORA" = "1.0.0" ]]; then		
		echo "Sentora version $VERSION_SENTORA is compatible with this installer/updater."		
	else		
		echo "Sorry, Sentora version $VERSION_SENTORA is not compatible with this installer/updater."	
		exit
	fi
else		
	echo "Sorry, Sentora is not installed on your server."		
	echo "please install Sentora before using this $THEME_NAME installer/updater. (http://docs.sentora.org/?node=7)"		
	exit		
fi

if [ -d "/etc/sentora/panel/etc/styles/$THEME_NAME" ]; then
	THEME_UPDATE=1
	echo "You have the $THEME_NAME theme already installed, theme will be updated."
else
	THEME_UPDATE=0
	echo "You have not jet installed the $THEME_NAME theme, theme will be installed."
fi

cd /etc/sentora/panel/etc/styles/

echo "Downloading the $THEME_NAME theme..."
while true; do
	wget -qO $THEME_NAME.zip $THEME_URL
	if [[ -f $THEME_NAME.zip ]]; then
		break;
	else
		echo "Failed to download the $THEME_NAME theme from Github."
	exit 1
	fi 
done

if [[ "$THEME_UPDATE" = "1" ]]; then
	echo "Updating the $THEME_NAME theme..."
else
	echo "Installing the $THEME_NAME theme..."
fi

unzip -q $THEME_NAME.zip
rm -f $THEME_NAME.zip

if [[ "$THEME_UPDATE" = "1" ]]; then
	rm -rf /etc/sentora/panel/etc/styles/$THEME_NAME
fi

mv -u -f SentoraDirectAdmin-master $THEME_NAME

echo "##########################################################################################"
if [[ "$THEME_UPDATE" = "1" ]]; then
	echo " Congratulations the $THEME_NAME theme for Sentora has now been updated on your server."
else
	echo " Congratulations the $THEME_NAME theme for Sentora has now been installed on your server."
fi
echo "##########################################################################################"
