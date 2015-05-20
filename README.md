# mapping

##Tools


The loc_formatter.pl script takes a loc file that is formatted to 80 char lines and converts it to single line data

```
./loc_formatter.pl your_loc_file.loc
```

The gap_inserter.pl script takes as its input a concatonated loc file which can be produced using the following commands assuming that you are using affy data:

```
for f in *.loc; do tail +7 $f |  tail -r | tail +183 |tail -r ; done >merged.locus
perl -ne '/AX/ && print' merged.locus | wc -l
./gap_inserter.pl merged.loc em_fe_numbers.txt 
```

Note that at present there is hard coded stuff in this script, which contains the header information required to produce a joinmap compatible file.

The map_reader.pl script takes your map, a probe set mapping (needed for collapsed markers) and the map to compare with and outputs the comparison

```
./map_reader.pl combined_map.txt groups.txt hxk_map.txt
```

The map_sorter.pl tool will take a disordered map and sort it into ascending cM order for each linkage group. This is necessary if the map_reader.pl tool has been used.

```
./map_sorter.pl map_to_sort.map  map_sorted.map 
```
eg:
```
./map_sorter.pl ./em_fe/exf_processed.map  ./em_fe/exf_sorted.map 

```


The map_formatter.pl script takes a non-standard map file, such as those generated by map_reader.pl and convers is into joinmap format:

```
./map_formatter.pl maptoformat.txt name_of_map_to_output.map
```
```
eg:
./map_formatter.pl ./em_fe/exf_sorted.map ./em_fe/exf_joinmap.map

```



