#!/usr/bin/env zsh

rm -rf rootfiles
rm -rf txtfiles
rm -rf logs
rm -rf output
rm -rf paramshydro
rm -rf paramsurqmd
#rm -rf jobfiles
mkdir -p rootfiles
mkdir -p txtfiles
mkdir -p output/logs
mkdir -p paramshydro
mkdir -p paramsurqmd
mkdir -p jobfiles
mkdir  -p output/source
mkdir  -p output/hydro
mkdir  -p output/urqmd
rm -rf zeroline

etas=0.14
tau0=1.2
dtau=0.04
steps=5 # don't change
nsteps=7    #tau_rel = dtausource*nsteps - 0.04 = 0.36
#tauth=2.56
((tauth=$tau0+$nsteps*$dtau*$steps-$dtau))
taurel=1.36    #tau0 + nsteps*(steps*dtau)  - dtau
nmin=0
nmax=10
nurqmd=600
esw=0.5
# EoS 0 - AZHYDRO; 1 - chiral
EoS=1


treeDir=/lustre/nyx/alice/users/sinyukov/musfer/ihkm_full/UrQMD_events/14_5
treemin=0
treemax=1000
mult_min=77  # multiplicity cuts 
mult_max=117
average_over_ev=1 # event by event.
Xmax=10.0
Ymax=10.0
Etamax=3.5
#Taumin=1.2
#dTau=0.04
RX=0.5
RY=0.5
RETA=0.5
NX=100
NY=100
NETA=70

cat > txtfiles/zeroline.txt << END
-9.9    9.9     99   -9.9    9.9     99    -3.45     3.45      69       $tau0     $tauth    $dtau  3
END

. ./setEnv.sh
./scriptcompile.sh
./scriptparams_ic.sh $treeDir $treemin $treemax $mult_min $mult_max $average_over_ev $Xmax $Ymax $Etamax $tau0 $dtau $steps $RX $RY $RETA $NX $NY $NETA 
./scriptjob.sh $nsteps $tau0 $taurel $etas $dtau $nurqmd $esw $nmin $nmax $EoS
# params: num_of_event tau0 taurel etas dtau nurqms
for ((k=$nmin; k<$nmax; k++))
do
sbatch --job-name=ic${k} --partition=long --time=16:00:00  --output="output/logs/${k}.out.log" --error="output/logs/${k}.err.log" --chdir=/lustre/nyx/alice/users/sinyukov/musfer/ihkm_full/ic -- ./job_${k}.sh
done
