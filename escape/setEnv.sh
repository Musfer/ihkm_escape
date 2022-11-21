#!/bin/bash

export USER=$(whoami)
if [ -f /cvmfs/alice.cern.ch/etc/login.sh ] ; then
   . /cvmfs/alice.cern.ch/etc/login.sh
else
   echo "ERROR: /cvmfs/alice.cern.ch/etc/login.sh not found !!!"
   exit 99
fi

latest="$(alienv q | grep -x VO_ALICE@AliPhysics::vAN-[0-9]*-1 | tail -1)"
#latest="$(alienv q | grep  VO_ALICE@AliPhysics::vAN | tail -1)"
latest=VO_ALICE@ROOT::v5-34-30-alice-12
echo $latest

eval `alienv printenv $latest`

