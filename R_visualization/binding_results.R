#!/usr/bin/env Rscript

######################
# DEMUXLET MATCHING ##
######################

# This script creates a per-cell meta data table

options(stringsAsFactors = FALSE)
.libPaths('~/R/newer_packs_library/3.5/')
library(optparse)
library(data.table)

## Settting arguments ##
# arg <- commandArgs(TRUE)
optlist <- list(
  make_option(
    opt_str = c("-d", "--bestsdir"), type = "character", default = getwd(),
    help = "Directory where the best files are stored."
  ),
  make_option(
    opt_str = c("-m", "--metadata"), type = "character", default = "library_names.csv",
    help = "Table where per-library descriptions are, or a Seurat object."
  ),
  make_option(
    opt_str = c("-o", "--output"), type = "character",
    help = "By default it's written to 'bestsdir' and using 'metadata' name."
  ),
  make_option(
    opt_str = c("-a", "--aggr10x"), type = "character", default = "nofile.csv",
    help = "Table of the aggregation_csv, which indicates the library order."
  ),
  make_option(
    opt_str = c("-i", "--metadonor"), type = "character", default = 'nofile.csv',
    help = "Per-donor information table."
  ),
  make_option(
    opt_str = c("-l", "--libnames"), type = "character", default = 'origlib',
    help = "Library names column if Seurat object was given."
  ),
  make_option(
    opt_str = c("-f", "--prefix"), type = "character", default = 'orig.',
    help = "Library names column if Seurat object was given."
  ),
  make_option(
    opt_str = c("-p", "--pattern"), type = "character", default = 'X1234',
    help = "Pattern to select the 'best' files from demuxlet."
  )
)

# Getting arguments from command line and setting their values to their respective variable names.
optparse <- OptionParser(option_list = optlist)
opt <- parse_args(optparse)

opt$bestsdir <- "/mnt/BioAdHoc/Groups/vd-vijay/vcastelan/genotyping/2trial/run_pipeline/2.Clean_plink_file/results/demuxlet_human/R_visualization/best_files"
# opt$metadata <- "/mnt/BioAdHoc/Groups/vd-vijay/cramirez/asthma/raw/10X/AS3Esm/AS3Esm_aggr_groups.csv"
opt$metadata <- "/mnt/BioAdHoc/Groups/vd-vijay/vcastelan/genotyping/2trial/run_pipeline/2.Clean_plink_file/results/demuxlet_human/R_visualization/R_seurat_object/Human.all_tissue.20K_cells.res_0.8.PC_18.seurat.object.RData"
#opt$output <- "/mnt/BioAdHoc/Groups/vd-vijay/vcastelan/genotyping/2trial/run_pipeline/2.Clean_plink_file/results/demuxlet/R_visualization/human_NV016_10x_014_deconvolution"
#opt$aggr10x <- "/mnt/BioAdHoc/Groups/vd-vijay/cramirez/hayley/raw/NV016/10x_014/COUNTSh/AGGR/MAIT_mapped/outs/aggregation.csv"
# opt$metadonor <- '/mnt/BioHome/ciro/asthma/info/patients_posteriori.csv'
#opt$libnames<-"/mnt/BioAdHoc/Groups/vd-vijay/vcastelan/genotyping/2trial/run_pipeline/2.Clean_plink_file/results/demuxlet_human/R_visualization/libnames.txt"
#opt$prefix<-"/mnt/BioAdHoc/Groups/vd-vijay/vcastelan/genotyping/2trial/run_pipeline/2.Clean_plink_file/results/demuxlet_human/R_visualization/libnames.txt"

source('/mnt/BioHome/ciro/scripts/functions/handy_functions.R'); rm(.Last)
opt$bestsdir <- dircheck(opt$bestsdir)
if(1){
  cat('\n------------------- DEMUXLET DECONVOLUTION MERGING -------------------\n')
  cat("Path:", opt$bestsdir, "\n")
  cat("Metadata file:", opt$metadata, "\n")
}

## Functions ##
prop_table <- function(x){
  propdf <- data.frame(table(x)); colnames(propdf) <- c('class', 'percent')
  propdf$ncells <- propdf$percent
  propdf$percent <- round(propdf$percent * 100 / length(x), 2)
  propdf
}

setwd(opt$bestsdir)
mybests <- list.files(pattern = "best", full.names = FALSE, recursive = TRUE)
if(opt$pattern != "X1234"){
  opt$pattern <- paste0(opt$pattern, collapse = "|")
  cat("Getting files with pattern:", opt$pattern, "\n")
  mybests <- mybests[grepl(opt$pattern, mybests)]
}
if(length(mybests) == 0) stop("No results in ", getwd())

gems <- "no_gems"
if(file.exists(opt$aggr10x)){
  cat("------------------ Getting GEMs from Cell Ranger file ------------------\n")
  gems <- read.csv(opt$aggr10x, stringsAsFactors = FALSE)[, 1]
  names(gems) <- 1:length(gems)
}

# Now getting the metadata per library
if(file.exists(opt$metadata)){
  cat("----------------- Getting annotation file -----------------\n")
  mylibs <- readfile(opt$metadata, stringsAsFactors = FALSE, v = TRUE)
  if(casefold(class(mylibs)) == "seurat"){
    cat("Seurat file\n"); annot <- mylibs@meta.data; rm(mylibs); gc()
    categorical_names <- c(colnames(annot)[grepl(opt$prefix, colnames(annot))], 'gems')
    categorical_names <- categorical_names[!categorical_names %in% opt$libnames]
    cat("Present categories:", commas(categorical_names), "\n")
    annot$gems <- gsub("[A-Z]+\\-(.*)", "\\1", rownames(annot))
    mylibs <- data.frame(sapply(categorical_names, function(x){
      y <- make_list(x = annot, colname = opt$libnames, col_objects = x)
      sapply(y, unique)
    })); mylibs$Libraries <- rownames(mylibs)
    colnames(mylibs) <- gsub('orig\\.', '', colnames(mylibs))
  }
  if(is.null(mylibs$Summarise)) mylibs$Summarise <- TRUE
  mylibs <- mylibs[mylibs$Summarise, , drop = FALSE] # taking only the ones to summarise
  libname <- colnames(mylibs)[grep("ibrar", colnames(mylibs))] # identify the library name column
  rownames(mylibs) <- mylibs[, libname]
  if(!is.null(mylibs$gems)){
    cat("Creating GEM names and getting order\n")
    gemsnames <- names(gtools::mixedsort(make_list(x = mylibs, colname = 'gems', grouping = TRUE)))
    mylibs <- mylibs[gemsnames, ]
    gems <- mylibs[, libname]
    names(gems) <- mylibs$gems
  }else if(gems[1] != "no_gems"){
    mylibs <- mylibs[gems, ]
  }else{
    warning("Make sure to give the right order in case of aggregation\n")
  }
  mylibs <- mylibs[, !grepl("ibrar|Summarise|gems", colnames(mylibs)), drop = FALSE]
  # if(nrow(mylibs) > 1) mylibs <- mylibs[, sapply(mylibs, function(x) length(unique(x)) ) > 1, drop = FALSE]
  selected_libs <- unique(unlist(lapply(rownames(mylibs), function(x){
    which(grepl(x, mybests))
  })))
  cat("Taking", length(selected_libs), "libraries from", length(mybests), "\n")
  takenlist <- mybests[selected_libs]
  cat("Dropping:", paste0(mybests[!mybests %in% takenlist], collapse = "\n"), "\n\n")
  mybests <- takenlist
}

sampling_patterns <- c("complete.*|cells_|\\.best", paste0(c("_bs", "_vs", "_ge"), "[0-9].*"))
sampling_patterns <- paste0(sampling_patterns, collapse = "|")
cat('------------------- Reading best files -------------------\n')
demdata <- rbindlist(lapply(mybests, function(samp){ # samp <- mybests[1]
  lname <- gsub(sampling_patterns, "", basename(samp))
  cat(lname)
  bests <- try(read.table(samp, row.names = 1, header = 1), silent = TRUE)
  if(class(bests) == "try-error"){ cat(' FAILED!!\n'); next }
  bests$origlib <- lname
  bests$class <- sub("^(...).*", "\\1", as.character(bests$BEST))
  bests$donor <- as.character(bests$SNG.1ST)
  tvar <- names(gems)[which(gems %in% lname)]
  gem <- if(length(tvar) == 1) tvar else 1
  bests$cell_id <- gsub("\\-.*", paste0("-", gem), rownames(bests))
  cat("\n", nrow(bests), "cells with GEM:", gem, "\n")
  bests
}))
demdata <- data.frame(demdata, stringsAsFactors = FALSE, check.names = FALSE)
# str(demdata)

if(exists('mylibs')){
  if(!all(colnames(mylibs) %in% colnames(demdata))){
    cat('---------------- Adding meta data to merged ----------------\n')
    cat("Prefix:", opt$prefix, "\n")
    colnames(mylibs) <- paste0(opt$prefix, casefold(colnames(mylibs)))
    tvar <- grepl("^donor$|^class$", colnames(demdata))
    colnames(demdata)[tvar] <- paste0(opt$prefix, colnames(demdata))[tvar]
    tvar <- mylibs[demdata$origlib, ]; rownames(tvar) <- NULL
    demdata <- cbind(demdata, tvar)
  }
}

opt$metadonor <- unlist(strsplit(opt$metadonor, "~"))
if(file.exists(opt$metadonor[1])){
  print(opt$metadonor)
  pat_info <- read.csv(opt$metadonor[1], stringsAsFactors = F, header = 1)
  dnames <- if(is.na(opt$metadonor[2])) grep('atient|donor$', colnames(pat_info))[1] else opt$metadonor[2]
  dnames <- which(colnames(pat_info) %in% dnames)
  rownames(pat_info) <- pat_info[, dnames]; pat_info <- pat_info[, -dnames]
  if(!is.na(opt$metadonor[3])){
    tvar <- grepl(opt$metadonor[3], colnames(pat_info))
    colnames(pat_info)[tvar] <- paste0(opt$prefix, colnames(pat_info))[tvar]
  }
  if(!all(colnames(pat_info) %in% colnames(demdata))){
    cat('---------------- Adding donor data to merged ----------------\n')
    cat(commas(rownames(pat_info)), "\nFind:"); str(demdata$orig.donor);
    tvar <- pat_info[demdata$orig.donor, ]; rownames(tvar) <- NULL
    demdata <- cbind(demdata, tvar)
  }
}
cat(commas(colnames(demdata)), "\n")
str(demdata[, headtail(colnames(demdata))])
cat('------------------- Writing output file -------------------\n')
if(is.null(opt$output)){
  if(!dir.exists(opt$bestsdir)) opt$bestsdir <- dircheck(dirname(opt$bestsdir))
  opt$output <- paste0(opt$bestsdir, basename(opt$metadata))
}; cat("", opt$output, "\n")
ftype <- paste0(paste0(c('rda', 'rta', 'rdata', 'robj'), '$'), collapse = "|")
rownames(demdata) <- demdata$cell_id
if(grepl(ftype, casefold(opt$output))){
  save(demdata, file = opt$output)
}else{
  write.csv(demdata, file = opt$output)
}
cat('\n------------------- %%%%%%%% %%%%%%%%%%%%% %%%%%%% -------------------\n')
q('no')
