#!/bin/sh

unset GREEN RED CLEAR ECH_VRBL SYS_INF NET_INF HARD_INF

# style 
GREEN='\E[32m'
RED='\E[31m'
CLEAR=$(tput sgr0)

# System and Network monitor script 
run_script() {
	ECH_VRBL="Internet: "
	#ping 
	ping -c 1 google.com > /dev/null && echo -e "${ECH_VRBL}${GREEN}Connected" || echo -e "${ECH_VRBL}${RED}Disconnected"
	echo ${CLEAR}

	#OS information
	ECH_VRBL="OS type: " 
	case ${OSTYPE} in
		solaris*) echo "${ECH_VRBL}SOLARIS" ;;
		darwin*)  echo "${ECH_VRBL}OSX" ;;
		linux*)   echo "${ECH_VRBL}LINUX" ;;
		bsd*)     echo "${ECH_VRBL}BSD" ;;
		msys*)    echo "${ECH_VRBL}WINDOWS" ;;
		cygwin*)  echo "${ECH_VRBL}WINDOWS" ;;
		*)        echo "${ECH_VRBL}${OSTYPE}" ;;
	esac
	SYS_INF=`uname -m`
	echo "Architecture: ${SYS_INF}"
	SYS_INF=`awk -F= '/^PRETTY_NAME/{print $2}' /etc/os-release`
	echo "OS name: ${SYS_INF}"
	SYS_INF=`hostnamectl | awk '/Chassis/ { print $2 }'`
	echo "Chassis: ${SYS_INF}"
	echo

	#Network information
	NET_INF=`uname -n`
	echo "hostname: ${NET_INF}"
	NET_INF=`hostname -I`
	echo "ip: ${NET_INF}"
	echo 

	#Hardware information
	echo "Ram usage in mebibytes:"
	free -m -l | head -n 4
	echo -e "\nSwap usage in mebibytes:"
	free -m -l | head -n 1
	free -m -l | tail -n 1
	echo -e "\nCPU usage:"
	top -bn 1 | head -n 3 | tail -n 2
}

# check parametrs 
if [ ${#} -eq 0 ]; then 
	run_script
else
	case ${1} in 
		'-v') echo -e "System and Network Monitor\nv.1\ncreated by Nikolay Malykhin"
			;;
		'-h') echo -e \
			"-v: version"\
			"\n-h: help"
			;;
		*) echo "for help use '-h'"
			;;
	esac
fi
