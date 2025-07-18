# FLAMINGOrLite
Lite version of FLAMINGO, high-resolution 3D chromosome structures reconstruction based on Hi-C.

Now only support `.hic` and `.mcool`.

## Dependencies
The implementation of the algorithm is based on R. It depends on 3 basic R packages: `strawr`, `parallel`, `prodlim` and `Matrix`.

## Installation of the FLAMINGOrLite package
```
install.packages("devtools")
library(devtools)
install_github('JiaxinYangJX/FLAMINGOrLite',ref='HEAD')
```

## Differences between FLAMINGOrLite and FLAMINGOr
1. FLAMINGOrLite doesn't support iFLAMINGO
2. FLAMINGOrLite is faster and more memory-efficient
3. FLAMINGOrLite is more user-friendly and fixed bugs in FLAMINGOr

## Reconstruct the 3D genome structure with FLAMINGOrLite
*Example*:

Using 20 threads to reconstruct 5kb-resolution (*frag_res*) 3D structure of chr21.

The resolution of skeleton (*domain_res*) is set to be 1Mb, which means one domain contains 200 fragments (*frag_res / domain_res*).

```
library(FLAMINGOrLite)
res = flamingo_main(hic_data='4DNFI1UEG1HD.hic',
                    file_format='hic',
                    domain_res=1e6,
                    frag_res=5e3,
                    chr_name='chr21',
                    normalization='KR',
                    nThread=20)
```

## Key functions
If the genome comprises over 200 fragments, we strongly recommend users employ `flamingo_main` rather than `flamingo_basic` for hierarchical structure reconstruction. Users should carefully choose appropriate values for *domain_res* and *frag_res* to **strike a balance between the number of domains in the skeleton (genome size / domain_res) and the number of fragments within each domain (domain_res / frag_res)**.

---
### `flamingo_main`
Main function of FLAMINGO, hieractically reconstruct 3D genome structure.

This function can be used to efficiently predict the structure of high-resolution whole chromosome structures.

It takes three steps:
1. Reconstruct low-resolution (*domain_res*) genome skeleton based on `flamingo_basic`
2. Reconstruct high-resolution (*frag_res*) intra-domain structures based on `flamingo_basic` in parallel
3. Assembly the high-resolution domains into the genome skeleton

Output:

|col| abbrev | Description |
|---|-----|-----------|
| 1 | chr | chromosome ID  |
| 2 | start | genomic location of the start point |
| 3 | end | genomic location of the end point |
| 4 | x | x coordinate |
| 5 | y | y coordinate |
| 6 | z | z coordinate |


Type `?flamingo_main` for detailed explanations of each argument.

---
### `flamingo_basic`
Core function of FLAMINGO, 3D genome structure reconstruction using low-rank matrix completion.

It only takes interaction frequecy matrix as the input.

This function can be used to predict the structure within 200 fragments.

```
res = flamingo_basic(input_if)
```

Output:

A flamingo_prediction object containing the fragment id and 3D coordinates

Type `?flamingo_basic` for detailed explanations of each argument.

## visualize the 3D genome structure using ParaView
ParaView is an open-source, multi-platform data analysis and visualization application. To visualize the 3D genome structure using FLAMINGO, the user needs to convert the 3D coordinates into a .vtk file and use the ParaView software to visualize the structure. In the `FLAMINGOrLite` package, a `write.vtk` function is provided.

```
write.vtk(points,lookup_table,name,opt_path)
```

Arguments:

`points`: 3D coordinates predicted by FLAMINGO in the x,y,z format. 3 by N matrix.

`lookup_table`: The annotation of each point, could be labels or scores, i.e. the compartment PC scores. N-dimensional vector

`name`: output file name annotated within the file. String.

`opt_path`: output file path including the file name. String.

Output:

A `.vtk` file stored at `opt_path` for ParaView visualization.

Type `?write.vtk` for detailed explanations of each argument.



## Running Command Line Version
```
Rscript run_flamingo.R -i inter_30.hic -r chr19 -t 12 -o mydata_
Rscript flamingo_plot.R -i mydata_chr19.txt -o mydata_chr19
```

Example output from the command line version are present in the `example/` directory.

