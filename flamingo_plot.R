#!/bin/Rscript

library(optparse)
library(FLAMINGOrLite)
library(plotly)
library(htmlwidgets)

option_list <- list(
	make_option(c('-i', '--input'), action='store', type='character', default='input.txt', help='.hic file to use as input'),
        make_option(c('-o', '--output'), action='store', type='character', default='output', help='output file name prefix')
)
opt <- parse_args(OptionParser(option_list = option_list))

datafile <- opt$input
out=opt$output

df <- read.delim(datafile)

fig <- plot_ly(df, x = ~x, y = ~y, z = ~z, type = 'scatter3d', mode = 'lines+markers',
        line = list(width = 1, color = ~start, colorscale = 'Viridis',
                    colorbar = list(title = 'Start Value')),
        marker = list(size = 0.5, color = ~start, colorscale = 'Viridis',
                      colorbar = list(title = 'Start Value'))) 
fig <- plotly::ggplotly(fig)
htmlwidgets::saveWidget(fig, paste0(out, ".html"))

