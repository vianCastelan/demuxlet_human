#!/bin/bash

######################
# Assign species job #
######################

PROJECTNAME=assign_species
WORKDIR=/mnt/BioAdHoc/Groups/vd-vijay/vcastelan/genotyping/2trial/run_pipeline/2.Clean_plink_file/results/demuxlet_human/
USER=vcastelan

cat <<EOT > ${PROJECTNAME}.sh
#PBS -N assign_species
#PBS -o ${PROJECTNAME}_out.txt 
#PBS -e ${PROJECTNAME}_err.txt
#PBS -m abe
#PBS -M ${USER}@lji.org
#PBS -q default
#PBS -l nodes=1:ppn=5
#PBS -l mem=15gb
#PBS -l walltime=12:00:00

cd ${WORKDIR}

echo "### --- Performing the assignment of species --- ###"

/share/apps/R/3.6.1/bin/Rscript ${WORKDIR}/assign_species.R


#Create job dir and move job.sh, err.txt and out.txt into it
mkdir job_${PROJECTNAME}
mv ${PROJECTNAME}_out.txt job_${PROJECTNAME}
mv ${PROJECTNAME}_err.txt job_${PROJECTNAME}
mv ${PROJECTNAME}.sh job_${PROJECTNAME}
echo -e "Job completed! \n Check for errors if any."
EOT

