library(minfi)
# manifestFile <- "../../../IlluminaHumanMethylationAllergy_files/Asthma_Allergy_20048910_A1.sesame.csv"
manifestFile <- "../../../IlluminaHumanMethylationAllergy_files/Chicago-S40.manifest.sesame-base.cpg-sorted.csv_clean"
## I removed the line with cg09324845_BC12 because this Address is not in the IDAT files

if(!file.exists(manifestFile)) {
    cat("Missing files, quitting\n")
    q(save = "no")
}

maniTmp <- minfi:::read.manifest.sesame.Allergy(manifestFile)

## dupNames <- unique(manifest$Name[duplicated(manifest$Name)])
## dups <- manifest[manifest$Name %in% dupNames,]
## dups <- dups[order(dups$Name),]
## dups[dups$Name %in% c("cg08523803", "cg09299252", "cg09305380", "cg09314106"),
##      c("Infinium_Design_Type", "Name", "IlmnID",
##        "AddressA_ID", "AddressB_ID", "AlleleA_ProbeSeq", "AlleleB_ProbeSeq")]

anno <- maniTmp$manifest
manifestList <- maniTmp$manifestList

## Checking
library(illuminaio)
epic <- readIDAT("../../../IlluminaHumanMethylationAllergy_files/205271030022_R01C01_Grn.idat")
address.epic <- as.character(epic$MidBlock)
dropCpGs <- c(anno$IlmnID[!is.na(anno$AddressB) & !anno$AddressB %in% address.epic],
              anno$IlmnID[!is.na(anno$AddressA) & !anno$AddressA %in% address.epic])
table(substr(dropCpGs, 1,2))


## Manifest package
IlluminaHumanMethylationAllergymanifest <- do.call(IlluminaMethylationManifest,
                                                   list(TypeI = manifestList$TypeI,
                                                        TypeII = manifestList$TypeII,
                                                        TypeControl = manifestList$TypeControl,
                                                        TypeSnpI = manifestList$TypeSnpI,
                                                        TypeSnpII = manifestList$TypeSnpII,
                                                        annotation = "IlluminaHumanMethylationAllergy"))
save(IlluminaHumanMethylationAllergymanifest, file = "../../data/IlluminaHumanMethylationAllergymanifest.rda", compress = "xz")

## Annotattion
nam <- names(anno)
names(nam) <- nam
nam[c("IlmnID", "Name", "AddressA_ID", "AddressB_ID", "AlleleA_ProbeSeq", "AlleleB_ProbeSeq",
            "Infinium_Design_Type", "Next_Base", "Color_Channel")] <-  c("Name", "LocusName", "AddressA", "AddressB",
                                                                         "ProbeSeqA", "ProbeSeqB",
                                                                         "Type", "NextBase", "Color")

names(nam) <- NULL
names(anno) <- nam
rownames(anno) <- anno$Name
anno <- anno[getManifestInfo(IlluminaHumanMethylationAllergymanifest, type = "locusNames"),]

Locations <- anno[, c("CHR", "MAPINFO")]
names(Locations) <- c("chr", "pos")
Locations$pos <- as.integer(Locations$pos)
Locations$strand <- ifelse(anno$Strand_FR == "F", "+", "-")
table(Locations$chr, exclude = NULL)
rownames(Locations) <- anno$Name
Locations <- as(Locations, "DataFrame")

Manifest <- anno[, c("Name", "AddressA", "AddressB",
                     "ProbeSeqA", "ProbeSeqB", "Type", "NextBase", "Color")]
Manifest <- as(Manifest, "DataFrame")

## Islands.UCSC <- anno[, c("UCSC_CpG_Islands_Name", "Relation_to_UCSC_CpG_Island")]
## names(Islands.UCSC) <- c("Islands_Name", "Relation_to_Island")
## Islands.UCSC <- as(Islands.UCSC, "DataFrame")
## Islands.UCSC$Relation_to_Island[Islands.UCSC$Relation_to_Island == ""] <- "OpenSea"
## table(Islands.UCSC$Relation_to_Island, exclude = NULL)


usedColumns <- c(names(Manifest), 
                 c("CHR", "MAPINFO", "Strand", "Genome_Build"))
Other <- anno[, setdiff(names(anno), usedColumns)]
nam <- names(Other)
nam <- sub("_NAME", "_Name", nam)
nam
Other <- as(Other, "DataFrame")

## We now use an exisitng grSnp object containing a GRanges of relevant SNPs.
## This is created in a separate script

##
## SNP overlap
##

annoStr <- c(array = "IlluminaHumanMethylationAllergy",
             annotation = "ilm10",
             genomeBuild = "hg19")
annoNames <- c("Locations", "Manifest", "Other")
for(nam in annoNames) {
    cat(nam, "\n")
    save(list = nam, file = file.path("../../../IlluminaHumanMethylationAllergyanno.ilm10.hg19/data", paste(nam, "rda", sep = ".")), compress = "xz")
}
defaults <- c("Locations", "Manifest", "Other")
pkgName <- sprintf("%sanno.%s.%s", annoStr["array"], annoStr["annotation"],
                    annoStr["genomeBuild"])

annoObj <- IlluminaMethylationAnnotation(objectNames = annoNames, annotation = annoStr,
                              defaults = defaults, packageName = pkgName)

assign(pkgName, annoObj)
save(list = pkgName,
     file = file.path("../../../IlluminaHumanMethylationAllergyanno.ilm10.hg19/data/annotation.rda"), compress = "xz")

sessionInfo()
q(save = "no")




