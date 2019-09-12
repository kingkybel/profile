#!/bin/ksh

       function prompt
        {
                if [ "X$BASH_VERSION" = "X" ] ; then
                        XX=dummy
                else
                        local BLUE="\[\033[0;34m\]"
                        local CYAN="\[\033[0;36m\]"
                        local DARK_BLUE="\[\033[1;34m\]"
                        local RED="\[\033[0;31m\]"
                        local DARK_RED="\[\033[1;31m\]"
                        local NO_COLOR="\[\033[0m\]"
                        PS1="\u@\h [\t]> "
                        PS1="${TITLEBAR}$BLUE\u@\h $RED[$CYAN\w $RED]>$NO_COLOR "
                        PS2='continue-> '
                        PS4='$0.$LINENO+ '
                fi
        }
	prompt

stty erase ^H
stty -istrip

function addPath
{
	PATHS=`echo ${PATH} | tr ':' '\ '`
	DONT_ADD=FALSE
	for i in ${PATHS} nomore ; do
		if [ ${i} = nomore ]; then
			break;
		fi;
		if [ "${i}" = "${1}" ]; then
			DONT_ADD=TRUE
		fi;
	done
	if [ "${DONT_ADD}" = "FALSE" ] ; then
		export PATH="${PATH}:${1}"
	fi;
}

function addLDPath
{
	PATHS=`echo ${LD_LIBRARY_PATH} | tr [:] [\ ]`
	DONT_ADD=FALSE
	for i in ${PATHS} nomore ; do
		if [ ${i} = nomore ]; then
			break;
		fi;
		if [ "${i}" = "${1}" ]; then
			DONT_ADD=TRUE
		fi;
	done
	if [ "${DONT_ADD}" = "FALSE" ] ; then
		export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${1}"

	fi;
}


IS_LINUX=`uname`
echo "OS is '$IS_LINUX'"
export MY_HOST=`hostname`
export ATRIAHOME=/usr/atria
export CLEARTOOL=${ATRIAHOME}/bin/cleartool

if [ "X$IS_LINUX" = "XLinux" ] ; then
	export MY_BINDIR=/bin
	export GREP="$MY_BINDIR/egrep"
	export GREP_OPTIONS="-H -n -s --colour=tty"
	export GREP_OPTIONS="--colour=tty"
	alias ct=${CLEARTOOL}

	export EDITOR=vim
	function boldmsg
	{
		echo -e "\e[1m$*\e[0m"
	}

	function greenmsg
	{
		echo -e "\e[32m$*\e[0m"
	}

	function redmsg
	{
		echo -e "\e[31m$*\e[0m"
	}

	function yellowmsg
	{
		echo -e "\e[33m$*\e[0m"
	}

	function bluemsg
	{
		echo -e "\e[34m$*\e[0m"
	}

	function magentamsg
	{
		echo -e "\e[35m$*\e[0m"
	}

	function lightbluemsg
	{
		echo -e "\e[36m$*\e[0m"
	}
	alias l="$MY_BINDIR/ls --color=tty -Fax"
	alias ll="$MY_BINDIR/ls --color=tty -Fartsl"
	alias rmcores="rm /local/0/cores/*`id | cut -f2 -d= | cut -f1 -d\(`*"
	alias mywho="who | cut -f1 -d' ' | sort -u | xargs -I:  ldapsearch -LLL -x -h ldap -F= -b o=nomura.com uid=: uid cn | grep -v dn: | xargs -L 2 | cut -f2,4,5 -d' '"
	function which                                                                   
	{                                                                           
		(alias; declare -f) | /usr/bin/which --tty-only --read-alias --read-functions --show-tilde --show-dot $@                                                          
	}                                                                           
	export which                                                             
 

else
		export MY_BINDIR=/data/tecindev/tools/mot/4.6.1/local/bin
		export GREP="$MY_BINDIR/grep --color=tty"
		alias ct=${CLEARTOOL}

		export EDITOR=/apps/forte/sun4/SunOS5/6u2.full.n3/SUNWspro/bin/nedit
		export PATH=${PATH}:/apps/cvs/sun4/SunOS5.8/1.11.11/bin/
		export CVSROOT=/apps/cvs/sun4/SunOS5.8/1.11.11/bin/
		export MANPATH=${MANPATH}:/apps/cvs/sun4/SunOS5.8/1.11.11/man
		alias l="${MY_BINDIR}/ls --color=tty -Fax"
		alias ll="${MY_BINDIR}/ls --color=tty -Fartsl"
		alias doxygen="/data/tecindev/tools/mot/4.6.1/local/bin/doxygen"
#		export MY_BINDIR=/usr/bin
#		export GREP=/usr/bin/grep
#		alias l="${MY_BINDIR}/ls -Fax"
#		alias ll="${MY_BINDIR}/ls -Fartsl"
	alias top=prstat
	alias mywho="who | cut -f1 -d' ' | sort -u | xargs -I:  ldapsearch -h ldap -F= -b o=nomura.com uid=: uid cn | grep -v UID | grep -v , | cut -f2 -d= | paste -d, - -"

fi

function top10
{
	OPTIND=1
	USAGE1="totalSize [-p <path>] [-h]"
	CHECK_PATH=$1
	DO_EXECUTE=1
	while getopts "p:h" OPTION; do
            case ${OPTION} in
                p) CHECK_PATH=${OPTARG} ;;
                h) echo "${USAGE1}" 
		   DO_EXECUTE=0 ;;
                *) echo "${USAGE1}" 
		   DO_EXECUTE=0 ;;
            esac
	done
	if [ "X$DO_EXECUTE" = "X1" ] ; then
		du -s -k $CHECK_PATH
	fi
	if [ "X$DO_EXECUTE" = "X1" ] ; then
		du -a -k $CHECK_PATH | sort -r -n | head -n 10
	fi
}

function totalSize
{
	OPTIND=1
	USAGE1="totalSize [[-p] <path>] [-h]"
	CHECK_PATH=$1
	DO_EXECUTE=1
	while getopts "p:h" OPTION; do
            case ${OPTION} in
                p) CHECK_PATH=${OPTARG} ;;
                h) echo "${USAGE1}" 
		   DO_EXECUTE=0 ;;
                *) echo "${USAGE1}" 
		   DO_EXECUTE=0 ;;
            esac
	done
	if [ "X$DO_EXECUTE" = "X1" ] ; then
		SZ=`du -s -k $CHECK_PATH | awk '{s+=$1} END {printf "%.0f", s*1024 }'`
		echo -e "size of \e[1m$CHECK_PATH\e[0m in bytes: \e[31m$SZ\e[0m"
	fi
}

function vw
{
	${CLEARTOOL} setview `whoami`_${1}
}

function vwdiff
{
        OPTIND=1
	if [ "X$IS_LINUX" = "XLinux" ] ; then
		GRA=
	else
		GRA="-gra"
	fi
	if [ "X$1" = "X" ] ; then
		CHECK_DIR=`pwd`
	else
		CHECK_DIR="$1"
	fi
	cd ${CHECK_DIR}
	${CLEARTOOL} lsco -r -cvi -fmt "diff -options \"-hea\" -pred \"%n\"\n" ${CHECK_DIR} | ${CLEARTOOL} | grep ">>>" | cut -f2 -d:  | xargs -I _ ${CLEARTOOL} diff -pre ${GRA} _
#
#	${CLEARTOOL} lsco -cview -rec ${CHECK_DIR} | cut -f2 -d\" | xargs -I _ ${CLEARTOOL} diff -pre ${GRA} _
}

function vwlsco
{
        OPTIND=1
	if [ "X$IS_LINUX" = "XLinux" ] ; then
		GRA=
	else
		GRA="-gra"
	fi
	if [ "X$1" = "X" ] ; then
		CHECK_DIR=`pwd`
	else
		CHECK_DIR="$1"
	fi
	cd ${CHECK_DIR}
	${CLEARTOOL} lsco -cview -rec ${CHECK_DIR} | grep "/vobs/" | cut -f2 -d\"
}

function checkinvw
{
        OPTIND=1
	USAGE1="checkinvw [-p <path>] [-c <comment>]"
	HAS_COMMENT="NO"
	COMMENT=""
	CHECK_DIR=`pwd`
	while getopts "p:c:h" OPTION; do
            case ${OPTION} in
                p) ROOT_PATH=${OPTARG} ;;
                c) HAS_COMMENT="YES"
                   COMMENT=${OPTARG} ;;
                h) echo "${USAGE1}" ;;
                *) echo "${USAGE1}" ;;
            esac
	done

	if [ "X$HAS_COMMENT" = "XYES" ] ; then
		${CLEARTOOL} lsco -cview -rec ${CHECK_DIR} | grep "/vobs/" | cut -f2 -d\"  | xargs -I _ ${CLEARTOOL} ci -c "${COMMENT}" _
	else
		${CLEARTOOL} lsco -cview -rec ${CHECK_DIR} | grep "/vobs/" | cut -f2 -d\"  | xargs -I _ ${CLEARTOOL} ci -c -nc _
	fi
}

function lbldiff
{
        OPTIND=1
	USAGE1="lbldiff -1 label1 -2 label2 [-p <path>]"
	CHECK_DIR=`pwd`
	LBL1=
	LBL1=
	while getopts "1:2:p:" OPTION; do
            case ${OPTION} in
                1) LBL1=${OPTARG} ;;
                2) LBL2=${OPTARG} ;;
                p) CHECK_DIR=${OPTARG} ;;
                h) echo "${USAGE1}" ;;
                *) echo "${USAGE1}" ;;
            esac
	done
	if [ "X$IS_LINUX" = "XLinux" ] ; then
		GRA=
	else
		GRA="-gra"
	fi

	if [ "X$LBL1" = "X" ] ; then
		echo "${USAGE1}"
	else
		 if [ "X$LBL2" = "X" ] ; then
			 echo "${USAGE1}"
		 else
			 ${CLEARTOOL} find ${CHECK_DIR} -all \
  				 -element "{lbtype_sub(${LBL1}) && lbtype_sub(${LBL2})}" \
  				 -version "{(lbtype(${LBL1}) && ! lbtype(${LBL2})) || \
  				 (lbtype(${LBL2}) && !lbtype(${LBL1}))}" -print | \
				 xargs -I_ ${CLEARTOOL} describe -fmt "[%Nd] [%u] [%Xn]\t %Nc\n" _
		 fi
	fi

}

function findModified
{
        OPTIND=1
	USAGE1="findModified [-b <branch>] [-u <user>] [-s <since>] [-p <path>] [-c]"
	USAGE2="         -b : branch e.g. infra_lx_int"
	USAGE3="         -u : user, default `whoami`"
	USAGE4="         -s : since e.g. 10-Dec-2012.13:21 or today.00:00 or Friday or..."
	USAGE5="         -p : path any clearcase-path"
	USAGE6="         -c : include comment [0/1], default 1"
	USAGE7="         -i : checked in elements     (mutual exclusive with option -o: last one wins)"
	USAGE8="         -o : checked *OUT* elements  (mutual exclusive with option -i: last one wins)"

	CHECK_USER=""
	CHECK_SINCE=""
	CHECK_DIR=/vobs/NGBInfra
	INCLUDE_COMMENT=0
	DO_EXECUTE=1
	CHECK_IN_OUT=""

	while getopts "b:u:s:p:chio" OPTION; do
            case ${OPTION} in
                b) ON_BRANCH="-branch brtype(${OPTARG})" ;;
                u) CHECK_USER="created_by(${OPTARG})" ;;
                s) CHECK_SINCE="created_since(${OPTARG})" ;;
                c) INCLUDE_COMMENT=1 ;;
                p) CHECK_DIR=$OPTARG ;;
                i) CHECK_IN_OUT=" grep -v CHECKEDOUT";;
                o) CHECK_IN_OUT=" grep  CHECKEDOUT" ;;
                h) echo "${USAGE1}"
                   echo "${USAGE2}"
                   echo "${USAGE3}"
                   echo "${USAGE4}"
                   echo "${USAGE5}"
                   echo "${USAGE6}"
                   echo "${USAGE7}"
                   echo "${USAGE8}"
                   DO_EXECUTE=0 ;;
                *) echo "${USAGE1}"
                   echo "${USAGE2}"
                   echo "${USAGE3}"
                   echo "${USAGE4}"
                   echo "${USAGE5}"
                   echo "${USAGE6}"
                   echo "${USAGE7}"
                   echo "${USAGE8}"
                   DO_EXECUTE=0 ;;
            esac
	done
	if [ "X$CHECK_SINCE" = "X" ] ; then
		if [ "X$CHECK_USER" = "X" ] ; then
			CHECK_SINCE="created_since(01-Jan-2010)"
		else
			CHECK_SINCE="created_since(01-Jan-2010) && "
		fi
	else
		if [ "X$CHECK_USER" = "X" ] ; then
			CHECK_SINCE=$CHECK_SINCE
		else
			CHECK_SINCE="$CHECK_SINCE && "
		fi
	fi
	if [ "X$DO_EXECUTE" = "X1" ] ; then
  	      if [ "X$CHECK_IN_OUT" = "X" ] ; then
                  ${CLEARTOOL} find ${CHECK_DIR} ${ON_BRANCH} \
                  -version "{${CHECK_SINCE} ${CHECK_USER}}" \
                  -print | xargs -I_ ${CLEARTOOL} describe -fmt "[%Nd] [%u] [%Xn]\t %Nc\n" _
	      else
                  ${CLEARTOOL} find ${CHECK_DIR} ${ON_BRANCH} \
                  -version "{${CHECK_SINCE} ${CHECK_USER}}" \
                  -print | xargs -I_ ${CLEARTOOL} describe -fmt "[%Nd] [%u] [%Xn]\t %Nc\n" _ | ${CHECK_IN_OUT}
	      fi
	fi
}

function findLabelledFiles
{
        OPTIND=1
	USAGE1="findLabelledFiles  [-p <path>] -l <label>"
	LABEL=$1
	ROOT_PATH="."
	while getopts "p:l:h" OPTION; do
            case ${OPTION} in
                p) ROOT_PATH=${OPTARG} ;;
                l) LABEL=${OPTARG} ;;
                h) echo "${USAGE1}" ;;
                *) echo "${USAGE1}" ;;
            esac
	done
	if [ "X$LABEL" = "X" ] ; then
		echo "Need to specify label to look for: usage: $FIND_CI_USAGE1"
	else
		${CLEARTOOL} find $ROOT_PATH -version "lbtype($LABEL)" -print
	fi
}

function removeZeroVersions
{
        OPTIND=1
	FIND_RM0_USAGE1="removeZeroVersions  [-p <path>] -b <branch>"
	ROOT_PATH=`pwd`
	while getopts "p:b:h" OPTION; do
            case ${OPTION} in
                p) ROOT_PATH=${OPTARG} ;;
                b) BRANCH=${OPTARG} ;;
                h) echo "${FIND_RM0_USAGE1}" ;;
                *) echo "${FIND_RM0_USAGE1}" ;;
            esac
	done
	if [ "X$BRANCH" = "X" ] ; then
		echo "Need to specify branch from which  to remove versions 0: usage: ${FIND_RM0_USAGE1}"
	else
		${CLEARTOOL} find /vobs/NGBInfra -type f \
			-version "version(/main/${BRANCH}/LATEST)&&version(.../${BRANCH}/0)" \
			-print | xargs -I_ dirname _ | xargs -I_ ${CLEARTOOL} rmbranch -force _
	fi
}

function setGroupPermissions
{
	if [ "X$1" = "X" ] ; then
		CHECK_DIR=`pwd`
	else
		CHECK_DIR=$1
	fi
	find ${CHECK_DIR} -user `whoami` -type d -a -perm 0770 -exec ${CLEARTOOL} protect -chmod 775 {} \;
}

function findByModDate
{
        OPTIND=1
	USAGE1="findByModDate [-d <dir>] [-l <minLength>] [-f <filenamePattern>] [-h]"
	USAGE2="         -d : root directory from where to start, default: ${PWD}"
	USAGE3="         -l : minimal length of line, default: 1024"
	USAGE4="         -f : filter files by pattern, default: all files. note: escape wildcards!"
	USAGE5="         -h : this help message"

	FIND_DIR=${PWD}
	MIN_LENGTH=1024
	FILE_PATTERN=
	DO_EXECUTE=1

	while getopts "d:l:f:h" OPTION; do
            case ${OPTION} in
                d) FIND_DIR=${OPTARG} ;;
                l) MIN_LENGTH=${OPTARG} ;;
                f) FILE_PATTERN="${OPTARG}" ;;
                h) echo "${USAGE1}"
                   echo "${USAGE2}"
                   echo "${USAGE3}"
                   echo "${USAGE4}"
                   echo "${USAGE5}"
                   DO_EXECUTE=0 ;;
                *) echo "${USAGE1}"
                   echo "${USAGE2}"
                   echo "${USAGE3}"
                   echo "${USAGE4}"
                   echo "${USAGE5}"
                  DO_EXECUTE=0 ;;
            esac
	done
	find ${FIND_DIR} -type f -printf '%TY-%Tm-%Td %TT %p\n' | sort
}

function findLongLines
{
        OPTIND=1
	USAGE1="findLongLines [-d <dir>] [-f <filenamePattern>] [-h]"
	USAGE2="         -d : root directory from where to start, default: ${PWD}"
	USAGE3="         -l : minimal length of line, default: 1024"
	USAGE4="         -f : filter files by pattern, default: all files. note: escape wildcards!"
	USAGE5="         -h : this help message"

	FIND_DIR=${PWD}
	MIN_LENGTH=1024
	FILE_PATTERN=
	DO_EXECUTE=1

	while getopts "d:l:f:h" OPTION; do
            case ${OPTION} in
                d) FIND_DIR=${OPTARG} ;;
                l) MIN_LENGTH=${OPTARG} ;;
                f) FILE_PATTERN="${OPTARG}" ;;
                h) echo "${USAGE1}"
                   echo "${USAGE2}"
                   echo "${USAGE3}"
                   echo "${USAGE4}"
                   echo "${USAGE5}"
                   DO_EXECUTE=0 ;;
                *) echo "${USAGE1}"
                   echo "${USAGE2}"
                   echo "${USAGE3}"
                   echo "${USAGE4}"
                   echo "${USAGE5}"
                  DO_EXECUTE=0 ;;
            esac
	done
	if [ "X${DO_EXECUTE}" = "X1" ] ; then
		AWK_COMMAND="BEGIN{ FS=\"\n\"; LINE=0; }{ if(length(\$1)>${MIN_LENGTH}) printf(\"%s(%d): length=%d\n\",FILENAME,LINE,length(\$1)); LINE=LINE+1; }"
		if [ "X$FILE_PATTERN" = "X" ] ; then
			find ${FIND_DIR} | xargs -I_ awk "${AWK_COMMAND}" _
		else
			find ${FIND_DIR} -name "${FILE_PATTERN}" | xargs -I_ awk "${AWK_COMMAND}" _
		fi
	fi
}

function processSize
{
        OPTIND=1
	USAGE1="processSize [-p <ppid> ] [ -i <filter IN string>] [ -o <filter OUT string>] [-h]"
	USAGE2="         -p : process id"
	USAGE3="         -i : filter in string"
	USAGE4="         -o : filter out string"
	USAGE5="         -h : this help message"

	FIND_DIR=${PWD}
	DO_EXECUTE=1

	while getopts "p:i:o:h" OPTION; do
            case ${OPTION} in
                p) PPID=${OPTARG} ;;
                i) FILTER_IN="${OPTARG}" ;;
                i) FILTER_OUT="${OPTARG}" ;;
                h) echo "${USAGE1}"
                   echo "${USAGE2}"
                   echo "${USAGE3}"
                   echo "${USAGE4}"
                   echo "${USAGE5}"
                   DO_EXECUTE=0 ;;
                *) echo "${USAGE1}"
                   echo "${USAGE2}"
                   echo "${USAGE3}"
                   echo "${USAGE4}"
                   echo "${USAGE5}"
                  DO_EXECUTE=0 ;;
            esac
	done
	if [ "X$FILTER_IN" = "X1" ] ; then
	    if [ "X$FILTER_OUT" = "X1" ] ; then
		ps -a | egrep -v "egrep" | cut -f7 -d' ' | xargs -I_ cat /proc/_/status | egrep -i "vmsize|pid" | egrep -v "PPid|Tracer"
	    else
		ps -a | egrep -v "${FILTER_OUT}|egrep" | grep Daem | cut -f7 -d' ' | xargs -I_ cat /proc/_/status | egrep -i "vmsize|pid" | egrep -v "PPid|Tracer"
	    fi

	else
	    if [ "X$FILTER_OUT" = "X1" ] ; then
	        ps -a | egrep -v "egrep" | grep ${FILTER_IN} | cut -f7 -d' ' | xargs -I_ cat /proc/_/status | egrep -i "vmsize|pid" | egrep -v "PPid|Tracer"

	    else
	        ps -a | egrep -v "${FILTER_OUT}|egrep" | grep ${FILTER_IN} | cut -f7 -d' ' | xargs -I_ cat /proc/_/status | egrep -i "vmsize|pid" | egrep -v "PPid|Tracer"

	    fi

	fi
}

function VALGRIND
{
        OPTIND=1
	USAGE1="VALGRIND executable [ ... ]"
	LABEL=$1
	ROOT_PATH="."
	EXECUTABLE=$1

	if [ "${EXECUTABLE}" = "X" ] ; then
		echo "No executable defined"
		echo "Usage: ${USAGE1}"
	else
		if [ "X${IS_LINUX}" = "XLinux" ] ; then
			echo "writing log to ./${EXECUTABLE}.valgrindLog"
			/data/tecindev/tools/mot/netbeans/valgrind/bin/valgrind --tool=memcheck  \
        			 --leak-check=full \
        			 --track-origins=yes \
        			 --verbose \
        			 --trace-children=yes \
        			 --vgdb=yes \
        			 --fullpath-after= \
        			 --read-var-info=yes \
        			 --log-file=./${EXECUTABLE}.valgrindLog \
        			 $*

		fi
	fi
}

function userSearch
{
        OPTIND=1
	USAGE1="userSearch [-i <ID> | -f <firstname> | -s <surname> | -l <leaveDate YYYY/MM/DD>]"
	ID=""
	FIRST=""
	SUR=""
	LEAVE=""
	DO_RUN=Y
	while getopts "i:f:s:l:h" OPTION; do
            case ${OPTION} in
                i) ID="uid=${OPTARG}" ;;
                f) FIRST="givenName=${OPTARG}" ;;
                s) SUR="sn=${OPTARG}" ;;
                l) LEAVE="ngbemployeduntil=${OPTARG}" ;;
                h) echo "${USAGE1}"
		   DO_RUN=Y ;;
                *) echo "${USAGE1}"
		   DO_RUN=N ;;
            esac
	done
	if [ "X${DO_RUN}" = "XY" ] ; then
		#ldapsearch -x -h ldap -F= -b o=nomura.com ${ID} ${FIRST} ${SUR} ${LEAVE} | egrep "ngbemaildisplayname|uid=|ngbemployeduntil"
        	ldapsearch -x -h ldap -F= -b o=nomura.com ${ID} ${FIRST} ${SUR} ${LEAVE} givenName sn ngbemployeduntil uid 
	fi
}

function userSearch2
{
        OPTIND=1
	USAGE1="userSearch [-l <leaveDate YYYY/MM/DD>]"
	DO_RUN=Y
	while getopts "l:h" OPTION; do
            case ${OPTION} in
                l) enddate="${OPTARG}" ;;
                h) echo "${USAGE1}"
		   DO_RUN=Y ;;
                *) echo "${USAGE1}"
		   DO_RUN=Y ;;
            esac
	done
	if [ "X${DO_RUN}" = "XY" ] ; then
		d=`date +%Y/%m/%d`
		while [ "$d" != "$enddate" ]; do 
  			d=$(date -d "$d + 1 day" +%Y/%m/%d)
			userSearch -l $d
		done
	fi
}

alias h=history
alias makeview="${CLEARTOOL} mkview -stgloc -auto -tag"
alias myps="ps -eaf | $GREP `id | cut -f2 -d'(' | cut -f1 -d')'`"
alias m="less"
alias cls="clear"
alias cd..="cd .."
alias cd-="cd -"
alias vw1="${CLEARTOOL} setview `whoami`"
alias showvw="${CLEARTOOL} pwv"
alias myviews="${CLEARTOOL} lsview | grep `whoami`"
alias findinfiles="find . -type f -name \"*.cc\" -o -name \"*.h\" -o -name \"*.H\" -o -name \"*.c\" -o -name \"*.hxx\" -o -name \"*.cxx\" -o -name \"*.hh\" -o -name \"*ake*\" -o -name \"*.mk\" | xargs $GREP"
alias grep="$GREP"

#build aliases
alias nohup="nohup "
alias hexdump="od -x -A x"
alias mystat="prstat -s rss -u `whoami`"
alias xdiff="${CLEARTOOL} diff -gra"
alias linux0="ssh -l `whoami` -p 22 lonlx10758"
alias asmerlin="rlogin -l merlin 0"


function myFunctions
{
	alias
	set | grep -v "=" | grep \(\)
	#find /home/`whoami`/bin -perm "/u=x,g=x,o=x" -type f -print
	find /home/`whoami`/bin -type f -print | xargs -I_ test -x _ && echo _
}

