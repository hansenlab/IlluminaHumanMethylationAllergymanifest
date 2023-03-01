library(minfi)

## Version 1
# manifestFile <- "../../../IlluminaHumanMethylationAllergy_files/Asthma_Allergy_20048910_A1.sesame.csv"
# manifestFile <- "../../../IlluminaHumanMethylationAllergy_files/Chicago-S40.manifest.sesame-base.cpg-sorted.csv_clean"
## I removed the line with cg09324845_BC12 because this Address is not in the IDAT files

## Version 1.2
manifestFile <- "../../../IlluminaHumanMethylationAllergy_files/Asthma_Allergy_v1_2_12x1_20081804_B3.csv"


if(!file.exists(manifestFile)) {
    cat("Missing files, quitting\n")
    q(save = "no")
}

maniTmp <- minfi:::read.manifest.Allergy(manifestFile)

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
## # Version 1
## epic <- readIDAT("../../../IlluminaHumanMethylationAllergy_files/205271030022_R01C01_Grn.idat")
epic <- readIDAT("../../../IlluminaHumanMethylationAllergy_files/TestSamples_KH/Version1.1/206602830002_R01C01_Grn.idat")



address.epic <- as.character(epic$MidBlock)
dropCpGs <- c(anno$IlmnID[!is.na(anno$AddressB) & !anno$AddressB %in% address.epic],
              anno$IlmnID[!is.na(anno$AddressA) & !anno$AddressA %in% address.epic])

dropCpGs <- c(anno$IlmnID[anno$AddressB != "" & !anno$AddressB %in% address.epic],
              anno$IlmnID[anno$AddressA != "" & !anno$AddressA %in% address.epic])

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

## names_short = sub("_.*", "", rownames(anno))
## tmp = table(names_short)
## dupnames = names(tmp)[tmp > 1]
## dupnames_full = rownames(Locations)[names_short %in% dupnames]
## anno <- anno[! rownames(anno) %in% dupnames_full,]


Locations <- anno[, c("CHR", "MAPINFO")]
names(Locations) <- c("chr", "pos")
if(all(!grepl("^chr", Locations$chr)))
    Locations$chr <- paste0("chr", Locations$chr)
Locations$chr[Locations$chr == "chr0"] <- ""
is.na(Locations$chr[Locations$strand == ""]) <- TRUE
is.na(Locations$chr[Locations$pos == ""]) <- TRUE
Locations$pos <- as.integer(Locations$pos)
Locations$strand <- ifelse(anno$Strand_FR == "F", "+", "-")
table(Locations$chr, exclude = NULL)
rownames(Locations) <- anno$Name
Locations <- as(Locations, "DataFrame")

## Investigations





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
             annotation = "ilm12b3",
             genomeBuild = "hg19")
annoNames <- c("Locations", "Manifest", "Other")
for(nam in annoNames) {
    cat(nam, "\n")
    save(list = nam, file = file.path("../../../IlluminaHumanMethylationAllergyanno.ilm12b3.hg19/data", paste(nam, "rda", sep = ".")), compress = "xz")
}
defaults <- c("Locations", "Manifest", "Other")
pkgName <- sprintf("%sanno.%s.%s", annoStr["array"], annoStr["annotation"],
                    annoStr["genomeBuild"])

annoObj <- IlluminaMethylationAnnotation(objectNames = annoNames, annotation = annoStr,
                              defaults = defaults, packageName = pkgName)

assign(pkgName, annoObj)
save(list = pkgName,
     file = file.path("../../../IlluminaHumanMethylationAllergyanno.ilm12b3.hg19/data", "annotation.rda"), compress = "xz")
sessionInfo()
q(save = "no")


## Comparison

manifestFile0 <- "../../../IlluminaHumanMethylationAllergy_files/Asthma_Allergy_v1_2_12x1_20081804_A1.csv"
maniTmp0 <- minfi:::read.manifest.Allergy(manifestFile0)
anno0 <- maniTmp0$manifest
manifestList0 <- maniTmp0$manifestList
rownames(anno) <- anno$Name
rownames(anno0) <- anno0$Ilmn_ID
common <- intersect(anno$Name, anno0$IlmnID)
anno0c <- anno0[common,]
anno1c <- anno[common,]
all.equal(anno0c, anno1c)

