

if [ -e target_test_genome_seq.fasta.gz ] && ! [ -e target_test_genome_seq.fasta ]
then
	gunzip target_test_genome_seq.fasta.gz
fi

../transposonPSI.pl target_test_genome_seq.fasta nuc

