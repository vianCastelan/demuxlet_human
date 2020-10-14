#!/usr/bin/R

##########################
# Species classification #
##########################

# This script assses cells belonging to different species in a mixed library

output = "/mnt/BioAdHoc/Groups/vd-vijay/vcastelan/genotyping/2trial/run_pipeline/2.Clean_plink_file/results/demuxlet_human/mixedcells_annotation.RData"
fnames <- list.files("/mnt/BioAdHoc/Groups/vd-vijay/cramirez/hayley/raw/NV016/10x_014/COUNTSmixed", full.names = TRUE)
fnames <- paste0(fnames, "/outs/filtered_feature_bc_matrix")
fnames <- fnames[file.exists(fnames)]
library(Seurat)
mdata_list = lapply(X = fnames, FUN = function(fname){
  libname <- basename(dirname(dirname(fname)))
  cat(libname, "\n")
  mixedcells <- Read10X(fname)
  mixedcells <- as.matrix(mixedcells)
  tvar <- sapply(c('^mm10', '^hg19'), function(x){
    sgenes <- grepl(x, rownames(mixedcells))
    # print(head(sgenes))
    colSums(mixedcells[sgenes, ] > 0) / sum(sgenes) * 100 # % of expressed genes
  })
  decide <- apply(tvar[abs(tvar[, 1] - tvar[, 2]) > 0, ], 1, which.max)
  head(tvar); table(decide); cat(length(decide), "classified\n\n")

  data.frame(
    cell_name = colnames(mixedcells),
    library_name = libname,
    species = ifelse(decide == 1, 'mouse', 'human'),
    stringsAsFactors = FALSE,
    row.names = NULL
  )
})
gc()
annot = data.table::rbindlist(mdata_list)
annot
table(annot$species)
table(annot$library_name, annot$species)
save(annot, file = output)
