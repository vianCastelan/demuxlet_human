#!/bin/bash

#####################################
# demuxlet DECONVOLUTION of SC data #
#####################################

#PBS -N demuxlet_002_10x_014_Shilpi_1_22Jul19
#PBS -o /mnt/BioAdHoc/Groups/vd-vijay/vcastelan/genotyping/2trial/run_pipeline/2.Clean_plink_file/results/demuxlet_human/results_smp_list/002_10x_014_Shilpi_1_22Jul19/demuxlet_002_10x_014_Shilpi_1_22Jul19_out.txt
#PBS -e /mnt/BioAdHoc/Groups/vd-vijay/vcastelan/genotyping/2trial/run_pipeline/2.Clean_plink_file/results/demuxlet_human/results_smp_list/002_10x_014_Shilpi_1_22Jul19/demuxlet_002_10x_014_Shilpi_1_22Jul19_err.txt
#PBS -m abe
#PBS -M vcastelan@lji.org
#PBS -q default
#PBS -l nodes=1:ppn=10
#PBS -l mem=40gb
#PBS -l walltime=12:00:00

cd /mnt/BioAdHoc/Groups/vd-vijay/vcastelan/genotyping/2trial/run_pipeline/2.Clean_plink_file/results/demuxlet_human/results_smp_list/002_10x_014_Shilpi_1_22Jul19

echo "### --- Performing deconvolution of Data --- ###"

/mnt/BioHome/ciro/bin/demuxlet/demuxlet --sam /mnt/BioAdHoc/Groups/vd-vijay/vcastelan/genotyping/2trial/run_pipeline/2.Clean_plink_file/results/COUNTShg19/002_10x_014_Shilpi_1_22Jul19/outs/possorted_genome_bam.bam --tag-group CB --tag-UMI UB --vcf /mnt/BioAdHoc/Groups/vd-vijay/vcastelan/genotyping/2trial/run_pipeline/2.Clean_plink_file/results/vcf_per_library/002_10x_014_Shilpi_1_22Jul19.vcf --field GT --geno-error 0.01 --sm-list /mnt/BioAdHoc/Groups/vd-vijay/vcastelan/genotyping/2trial/run_pipeline/2.Clean_plink_file/results/vcf_per_library/samples_list_002.txt --out 002_10x_014_Shilpi_1_22Jul19 --group-list barcodes.txt --alpha 0 --alpha 0.5

echo "Job completed! \n Check for errors if any."
