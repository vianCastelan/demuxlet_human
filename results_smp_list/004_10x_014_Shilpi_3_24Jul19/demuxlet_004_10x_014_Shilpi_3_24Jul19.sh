#!/bin/bash

#####################################
# demuxlet DECONVOLUTION of SC data #
#####################################

#PBS -N demuxlet_004_10x_014_Shilpi_3_24Jul19
#PBS -o /mnt/BioAdHoc/Groups/vd-vijay/vcastelan/genotyping/2trial/run_pipeline/2.Clean_plink_file/results/demuxlet_human/results_smp_list/004_10x_014_Shilpi_3_24Jul19/demuxlet_004_10x_014_Shilpi_3_24Jul19_out.txt
#PBS -e /mnt/BioAdHoc/Groups/vd-vijay/vcastelan/genotyping/2trial/run_pipeline/2.Clean_plink_file/results/demuxlet_human/results_smp_list/004_10x_014_Shilpi_3_24Jul19/demuxlet_004_10x_014_Shilpi_3_24Jul19_err.txt
#PBS -m abe
#PBS -M vcastelan@lji.org
#PBS -q default
#PBS -l nodes=1:ppn=10
#PBS -l mem=40gb
#PBS -l walltime=12:00:00

cd /mnt/BioAdHoc/Groups/vd-vijay/vcastelan/genotyping/2trial/run_pipeline/2.Clean_plink_file/results/demuxlet_human/results_smp_list/004_10x_014_Shilpi_3_24Jul19

echo "### --- Performing deconvolution of Data --- ###"

/mnt/BioHome/ciro/bin/demuxlet/demuxlet --sam /mnt/BioAdHoc/Groups/vd-vijay/cramirez/hayley/raw/NV016/10x_014/COUNTSh/004_10x_014_Shilpi_3_24Jul19/outs/possorted_genome_bam.bam --tag-group CB --tag-UMI UB --vcf /mnt/BioAdHoc/Groups/vd-vijay/vcastelan/genotyping/2trial/run_pipeline/2.Clean_plink_file/results/genotypes.norm.filter.snps.hd.sorted.vcf --field GT --geno-error 0.1 --sm-list /mnt/BioAdHoc/Groups/vd-vijay/vcastelan/genotyping/2trial/run_pipeline/2.Clean_plink_file/results/vcf_per_library/samples_list_004.txt --out 004_10x_014_Shilpi_3_24Jul19 --group-list barcodes.txt

#Minimum number of SNPs with coverage for a droplet/cell to be considered*
#*All flags commented with * were set as default


echo "Job completed! \n Check for errors if any."
