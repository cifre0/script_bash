#!/bin/bash

### FUNCTION
function test_module(){
  TEST_MODPROBE=$(modprobe -n -v $1)
  TEST_LSMOD=$(lsmod | grep $1)
  if [[ $TEST_MODPROBE == "install /bin/true" ]] && [[ -z TEST_LSMOD ]] ; then echo "FileSystem disabled"; else return 1; fi
}

function Remediation(){
  if [ -d $PATH_MODPROB ]; then mkdir $PATH_MODPROB; fi;
  test_path_modprobe
  if [ ! -f PATH_MODPROB$1 ]; then 
  touch $PATH_MODPROB$1.conf
  echo "install $i /bin/true" >> $PATH_MODPROB$1.conf
  rmmod cramfs
  fi
}

### VAR
LIST_MODULE=("cramfs" "freevxfs" "jffs2" "hfs" "hfsplus" "squashfs" "udf" "vfat")
#echo ${!module[@]}
PATH_MODPROB="/etc/modprobe.d/"

### MAIN
for i in ${LIST_MODULE[@]}; do 
  test_module $i;
  if [[ $? == 1 ]]; then Remediation $i; 
  echo $i; 
done
