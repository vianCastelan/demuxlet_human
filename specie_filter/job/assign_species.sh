#!/bin/bash

######################
# Assign species job #
######################

#PBS -N assign_species
#PBS -o /mnt/BioAdHoc/Groups/vd-vijay/vcastelan/genotyping/2trial/run_pipeline/2.Clean_plink_file/results/demuxlet_human/assign_species_out.txt
#PBS -e /mnt/BioAdHoc/Groups/vd-vijay/vcastelan/genotyping/2trial/run_pipeline/2.Clean_plink_file/results/demuxlet_human/assign_species_err.txt
#PBS -m abe
#PBS -M vcastelan@lji.org
#PBS -q default
#PBS -l nodes=1:ppn=10
#PBS -l mem=15gb
#PBS -l walltime=2:00:00

cd /mnt/BioAdHoc/Groups/vd-vijay/vcastelan/genotyping/2trial/run_pipeline/2.Clean_plink_file/results/demuxlet_human/

echo "### --- Performing the assignment of species --- ###"

/share/apps/R/3.6.1/bin/Rscript assign_species.R

#Create job dir and move job.sh, job err.txt and out.txt into it
mkdir job
mv assign_species_out.txt job
mv assign_species_err.txt job
mv job_assign_species.sh job
echo -e "Job completed! \n Check for errors if any."

