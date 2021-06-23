# IlluminaHumanMethylationAllergymanifest

**Pre-release package for handling the Illumina Allergy and Asthma array**

Annotation packages
- [IlluminaHumanMethylationAllergymanifest](https://github.com/hansenlab/IlluminaHumanMethylationAllergymanifest)
- [IlluminaHumanMethylationAllergyanno.ilm10.hg19](https://github.com/hansenlab/IlluminaHumanMethylationAllergyanno.ilm10.hg19)

A `tar.gz` package tarball can be downloaded from the "release" tab of these github repos.

These packages are designed to work with minfi version 1.39.1. This package is available from Bioconductor and formally requires Bioconductor devel (version 3.14). It can (for now) be manually installed in R 4.1 with Bioconductor 3.13, however all packages should be up to date.

## Current issues and limitations

1. Reading in IDAT files results in a warning `In readChar(con, nchars = n) : truncating string with embedded nuls`. This warning is benign; I'm working on fixing it.
2. Current there are 1,081 CpG loci with incomplete design information (they are Type I without a color information). This will result in 1,081 missing values in a MethylSet created with `preprocessRaw()` or `preprocessIllumina()`. They will result in 1,750 missing values in a MethylSet created with `preprocessNoob()`.
3. `preprocessSWAN()` results in around 20 missing values per sample. I don't fully understand why and I think it's suspicious.
4. `preprocessFunnorm()` and `preprocessQuantile()` does not work at the moment.
5. Multiple other functions may or may not work; reports are appreciated.

**Disclaimer**: When I say a preprocessing function "works" or "results in", it is purely a statement that the function runs without error. I have not assessed whether the data has been properly normalized.


