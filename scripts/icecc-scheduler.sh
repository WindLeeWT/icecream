#!/bin/bash

Usage() {
  echo "Command format: $0 start|restart|stop"
}

if [ $# -lt 1 ]; then
  Usage
  exit 1
fi

binary=icecc-scheduler
basedir=$(cd `dirname $0`/..; pwd)
icecream_home=/data/icecream

Release() {
  if [ ! -d ${icecream_home} ]; then mkdir -m 775 ${icecream_home}; fi
  cd ${icecream_home}
  if [ ! -d scheduler ]; then mkdir -m 775 scheduler; fi
  cd scheduler
  if [ ! -d log ]; then mkdir -m 775 log; fi
  local icecc_scheduler_home=${icecream_home}/scheduler
  cd $basedir/scheduler
  export LD_LIBRARY_PATH=${basedir}/lib64:$LD_LIBRARY_PATH
  ./${binary} -d -r -l ${icecc_scheduler_home}/log/${binary}.log -u icecc -vvv
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

