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
#PBS -l nodes=1:ppn=5
#PBS -l mem=30gb
#PBS -l walltime=10:00:00

cd /mnt/BioAdHoc/Groups/vd-vijay/vcastelan/genotyping/2trial/run_pipeline/2.Clean_plink_file/results/demuxlet_human/results_smp_list/002_10x_014_Shilpi_1_22Jul19

echo "### --- Performing deconvolution of Data --- ###"

/mnt/BioHome/ciro/bin/demuxlet/demuxlet --sam /mnt/BioAdHoc/Groups/vd-vijay/cramirez/hayley/raw/NV016/10x_014/COUNTSh/002_10x_014_Shilpi_1_22Jul19/outs/possorted_genome_bam.bam --tag-group CB --tag-UMI UB --vcf /mnt/BioAdHoc/Groups/vd-vijay/vcastelan/genotyping/2trial/run_pipeline/2.Clean_plink_file/results/vcf_per_library/002_10x_014_Shilpi_1_22Jul19.vcf --field GT --geno-error 0.1 --min-mac 1 --min-callrate 0.50 --sm-list /mnt/BioAdHoc/Groups/vd-vijay/vcastelan/genotyping/2trial/run_pipeline/2.Clean_plink_file/results/vcf_per_library/samples_list_002.txt --out 002_10x_014_Shilpi_1_22Jul19 --alpha 0 --alpha 0.5 --doublet-prior 0.50 --sam-verbose 1000000 --vcf-verbose 10000 --cap-BQ 40 --min-BQ 13 --min-MQ 20  --min-TD 0 --excl-flag 3844 --group-list barcodes.txt --min-total 0 --min-uniq 0 --min-snp 0

echo "Job completed! \n Check for errors if any."
