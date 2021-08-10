# IlluminaHumanMethylationAllergymanifest

**Pre-release package for handling the Illumina Allergy and Asthma array**

Annotation packages Github repositories:
- [IlluminaHumanMethylationAllergymanifest](https://github.com/hansenlab/IlluminaHumanMethylationAllergymanifest)
- [IlluminaHumanMethylationAllergyanno.ilm10.hg19](https://github.com/hansenlab/IlluminaHumanMethylationAllergyanno.ilm10.hg19)

A `tar.gz` package tarball can be downloaded from the "release" tab of these github repos.

- [IlluminaHumanMethylationAllergymanifest_0.8.0.tar.gz](https://github.com/hansenlab/IlluminaHumanMethylationAllergymanifest/releases/download/0.8/IlluminaHumanMethylationAllergymanifest_0.8.0.tar.gz)
- [IlluminaHumanMethylationAllergyanno.ilm10.hg19_0.8.0.tar.gz](https://github.com/hansenlab/IlluminaHumanMethylationAllergyanno.ilm10.hg19/releases/download/0.8/IlluminaHumanMethylationAllergyanno.ilm10.hg19_0.8.0.tar.gz)

These packages are designed to work with minfi version 1.39.2. This package is available from Bioconductor and formally requires Bioconductor devel (version 3.14). It can (for now) be manually installed in R 4.1 with Bioconductor 3.13, however all packages should be up to date.

# What works

Assuming minfi 1.39.2 is installed, preprocessing with `preprocessRaw(), preprocessIllumina(), preprocessSWAN(), preprocessNoob()` works (in minfi 1.39.1 `preprocessNoob()` does NOT work). 

The release is based on the manifest file `Chicago-S40.manifest.sesame-base.cpg-sorted.csv`. The package has 
- 38,541 CpGs measured
- 37,882 CpGs with genomic coordinates (for most purposes, these are the useful CpGs)

The manifest contains 53 CpGs which are measured by multiple probe pairs. A decision needs to be made on how to treat this, and in this release (0.8) these CpGs have been deleted.


# Old versions

- [IlluminaHumanMethylationAllergymanifest_0.6.0.tar.gz](https://github.com/hansenlab/IlluminaHumanMethylationAllergymanifest/releases/download/0.6/IlluminaHumanMethylationAllergymanifest_0.6.0.tar.gz)
- [IlluminaHumanMethylationAllergyanno.ilm10.hg19_0.6.0.tar.gz](https://github.com/hansenlab/IlluminaHumanMethylationAllergyanno.ilm10.hg19/releases/download/0.6/IlluminaHumanMethylationAllergyanno.ilm10.hg19_0.6.0.tar.gz)

These packages are designed to work with minfi version 1.39.1. This package is available from Bioconductor and formally requires Bioconductor devel (version 3.14). It can (for now) be manually installed in R 4.1 with Bioconductor 3.13, however all packages should be up to date.

## What works

Example code

```{r}
library(minfi)
meth <- read.metharray(basenames = c("205271030022_R01C01",
                                     "205271030022_R02C01",
                                     "205271030022_R03C01"))
## Works
preprocessRaw(meth)
preprocessIllumina(meth)
preprocessNoob(meth)
```


## Current issues and limitations

1. Reading in IDAT files results in a warning `In readChar(con, nchars = n) : truncating string with embedded nuls`. This warning is benign; I'm working on fixing it.
2. Current there are 1,081 CpG loci with incomplete design information (they are Type I without a color information). This will result in 1,081 missing values in a MethylSet created with `preprocessRaw()` or `preprocessIllumina()`. They will result in 1,750 missing values in a MethylSet created with `preprocessNoob()`.
3. `preprocessSWAN()` results in around 20 missing values per sample. I don't fully understand why and I think it's suspicious.
4. `preprocessFunnorm()` and `preprocessQuantile()` does not work at the moment.
5. Multiple other functions may or may not work; reports are appreciated.

**Disclaimer**: When I say a preprocessing function "works" or "results in", it is purely a statement that the function runs without error. I have not assessed whether the data has been properly normalized.


