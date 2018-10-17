#!/bin/bash

Usage() {
  echo "Command format: $0 start|restart|stop"
}

if [ $# -lt 1 ]; then
  Usage
  exit 1
fi

binary=iceccd
basedir=$(cd `dirname $0`/..; pwd)
icecream_home=/data/icecream

Release() {
  if [ ! -d ${icecream_home} ]; then mkdir -m 775 ${icecream_home}; fi
  cd ${icecream_home}
  if [ ! -d daemon ]; then mkdir -m 775 daemon; fi
  cd daemon
  if [ ! -d base ]; then mkdir -m 775 base; fi
  if [ ! -d log ]; then mkdir -m 775 log; fi
  local iceccd_home=${icecream_home}/daemon
  cd ${basedir}/sbin
  export LD_LIBRARY_PATH=${basedir}/lib64:$LD_LIBRARY_PATH
  ./${binary} -b ${iceccd_home}/base -d -l ${iceccd_home}/log/${binary}.log \
              -s 10.12.72.76 -u icecc -vvv
}

GetProcNum() {
  proc_num=`ps -ef|grep " \./${binary} "|grep -v grep|wc -l`
}

Stop() {
  echo "${binary} is stopping ..."
  killall -s SIGKILL ${binary}
  sleep 2
  GetProcNum
  if [ $proc_num == 0 ]; then
    echo "${binary} stop successfully."
  else
    echo "${binary} stop failed."
  fi
}

Start() {
  GetProcNum
  if [ $proc_num == 0 ]; then
    echo "${binary} is starting ..."
    Release
    sleep 2
    GetProcNum
    if [ $proc_num == 0 ]; then
      echo "${binary} start failed."
    else
      echo "${binary} start successfully."
    fi
  else
    echo "${binary} is already running now."
  fi
}

if [ "$1" == 'start' ]; then
  Start
elif [ "$1" == 'restart' ]; then
  Stop
  Start
elif [ "$1" == 'stop' ]; then
  Stop
else
  Usage
fi

