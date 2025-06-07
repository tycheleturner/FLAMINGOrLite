#!/bin/Rscript

library(optparse)
library(FLAMINGOrLite)

option_list <- list(
	make_option(c('-i', '--input'), action='store', type='character', default='inter_30.hic', help='.hic file to use as input'),
	make_option(c('-r', '--chromosome'), action='store', type='character', default='chr1', help='Variant file created from the variant directory'),
	make_option(c('-t', '--thread'), action='store', type='numeric', default=1, help='Number of threads that flamingo can use during the run'),
        make_option(c('-o', '--output'), action='store', type='character', default='output', help='output file name')
)
opt <- parse_args(OptionParser(option_list = option_list)) 

datafile <- opt$input
chromosome=opt$chromosome
userthread=opt$thread
out=opt$output

res = flamingo_main(hic_data=datafile, file_format='hic', domain_res=1e6, frag_res=5e3, chr_name=chromosome,normalization='VC',nThread=userthread)
write.table(res, file=paste0(out, opt$chromosome, ".txt", sep=""), sep="\t", quote=F, row.names=F)

