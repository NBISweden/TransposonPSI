#TransposonPSI

TransposonPSI involves a PSI-blast search of a protein or nucleotide sequence against a set of profiles of proteins corresponding to major clades/families of transposon Open Reading Frames.

**Note** This repo is created for ease of creating a conda package for TransposonPSI

This is most useful to:
-identify proteins with similarities to known families of transposon ORFs.
-identify (degenerate) regions in genome sequences with homology to known transposon ORFs.

Run like so:

   % ./transposonPSI.pl 

   usage: ./transposonPSI.pl $fastaFile prot|nuc
                                                                                                                                                               
Two output files are created:
     $fastaFile.topHits (for prot searches)
    and
     $fastaFile.allHits (for nuc searches)

The hits are reported in btab format.  See the script 'scripts/BPbtab' for information on the tab-delimited output format.
The .topHits file contains only the single best hit (by blast score).
The .allHits file contains each match scoring above the 1e-5 E-value default.

On 'nuc' searches, gff3 files are automatically generated for all hits and only the best hits per genomic locus.


Installation Requirements:
-you must have NCBI blast installed, including blastall and blastpgp
-bioPerl


Transposon families included by the profiles are:
cacta.chkp  gypsy.chkp  ISa.chkp  isc1316.chkp  ltr_Roo.chkp       mariner.chkp  P_element.chkp
DDE_1.chkp  hAT.chkp    ISb.chkp  line.chkp     mariner_ant1.chkp  MuDR.chkp     TY1_Copia.chkp  

See the transposon_PSI_LIB/ directory for the reference sequences corresponding to the above families.


Questions, comments, etc?

contact: Brian Haas bhaas@broadinstitute.org





