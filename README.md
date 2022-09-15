# IlluminaHumanMethylationAllergymanifest

**Pre-release package for handling the Illumina Allergy and Asthma array**

Annotation packages Github repositories:
- [IlluminaHumanMethylationAllergymanifest](https://github.com/hansenlab/IlluminaHumanMethylationAllergymanifest)
- [IlluminaHumanMethylationAllergyanno.ilm10.hg19](https://github.com/hansenlab/IlluminaHumanMethylationAllergyanno.ilm10.hg19)

A `tar.gz` package tarball can be downloaded from the "release" tab of these github repos.

- [IlluminaHumanMethylationAllergymanifest_0.9.0.tar.gz](https://github.com/hansenlab/IlluminaHumanMethylationAllergymanifest/releases/download/0.9/IlluminaHumanMethylationAllergymanifest_0.9.0.tar.gz)
- [IlluminaHumanMethylationAllergyanno.ilm10.hg19_0.9.0.tar.gz](https://github.com/hansenlab/IlluminaHumanMethylationAllergyanno.ilm10.hg19/releases/download/0.9/IlluminaHumanMethylationAllergyanno.ilm10.hg19_0.9.0.tar.gz)

These packages are designed to work with minfi version 1.43.1. This package is available from Bioconductor and formally requires Bioconductor devel (version 3.16). It can (for now) be manually installed in R 4.1 with Bioconductor 3.15, however all packages should be up to date.

# What works

Assuming minfi 1.43.1 is installed, preprocessing with `preprocessRaw(), preprocessIllumina(), preprocessSWAN(), preprocessNoob()` works.

The release is based on the manifest file `Asthma_Allergy_v1_2_12x1_20081804_A1.csv`. The package has 

- 45,899 CpGs measured
- 45,511 CpGs annotated

We have discarded CpGs which are measured by multiple probe-pairs. There is a total of 182 such CpGs. They are discard at least following normalization, where they shouldn't matter.


# Old versions

- [IlluminaHumanMethylationAllergymanifest_0.8.0.tar.gz](https://github.com/hansenlab/IlluminaHumanMethylationAllergymanifest/releases/download/0.8/IlluminaHumanMethylationAllergymanifest_0.8.0.tar.gz)
- [IlluminaHumanMethylationAllergyanno.ilm10.hg19_0.8.0.tar.gz](https://github.com/hansenlab/IlluminaHumanMethylationAllergyanno.ilm10.hg19/releases/download/0.8/IlluminaHumanMethylationAllergyanno.ilm10.hg19_0.8.0.tar.gz)

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


