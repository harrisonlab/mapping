# mapping

##Tools

The gap_inserter.pl script takes as its input a concatonated loc file which can be produced using the following commands assuming that you are using affy data:

```
for f in *.loc; do tail +7 $f |  tail -r | tail +183 |tail -r ; done >merged.locus
perl -ne '/AX/ && print' merged.locus | wc -l
./gap_inserter.pl merged.loc em_fe_numbers.txt 

```


The loc_formatter.pl script takes a set of loc files 

The map_reader.pl script

The map_formatter.pl script


