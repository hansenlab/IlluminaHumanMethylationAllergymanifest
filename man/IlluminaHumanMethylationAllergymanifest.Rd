\name{IlluminaHumanMethylationAllergymanifest}
\alias{IlluminaHumanMethylationAllergymanifest}
\docType{data}
\title{
  Manifest object for the IlluminaHumanMethylationAllergy array
}
\description{
  This object contains the array design for Illumina's Human Methylation
  Allergy microarray. 
}
\usage{data(IlluminaHumanMethylationAllergymanifest)}
\details{
  This package is based on the file
  \sQuote{Asthma_Allergy_20048910_A1.csv}.

  1,081 CpGs have problematic address information and they will result
  in missing values. We are waiting for clarification from Illumina on
  this.
  
  A script for creating the data object in this package is contained in
  \code{scripts/manifest.R}.
}
\format{
  An object of class \code{IlluminaMethylationManifest}
}
\references{
  None.
}
\seealso{
  The description of the class in the minfi package,
  \code{\link[minfi]{IlluminaMethylationManifest-class}}.
}
\examples{
data(IlluminaHumanMethylationAllergymanifest)
}
\keyword{datasets}
