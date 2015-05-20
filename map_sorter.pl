#!/usr/bin/perl

use warnings;
use strict;

#Usage ./map_reader.pl combined_map.txt groups.txt hxk_map.txt
# your map, probe set mapping, map to compare with


my $input_map=shift;
my $collapsed_group=shift;
my $compare_map=shift;

my @loc_data= read_table(\$input_map); 	
my %hash_of_map=parse_map(\@loc_data);
my @group_data= read_table(\$collapsed_group); 	
my %hash_of_group=parse_group(\@group_data);
my @comp_data= read_table(\$compare_map); 	

#foreach(keys %hash_of_map){
#	print "Linkage ".$_;
#	my @lg_array=@{$hash_of_map{$_}};
#	print @lg_array;
#	#foreach (@lg_array){
#	#	print $_;
#	#}
#	}

#foreach(keys %hash_of_group){
#	print $_."\t";
#	my @group=@{$hash_of_group{$_}};
#	 foreach(@group){
#	 	print $_."\t";
#	 }
#	 print "\n";
#	}

#THIS COMPARES THE MAPS LOOKING FOR MATCHING LOCI
print "Comparing maps \n";
	foreach(@comp_data){
		my @marker=split('\t',$_);
		#print "Searching for $marker[0] found on $marker[1] \n";
		#print "$marker[1] \t";
			foreach my $group (@group_data){
				my @collapsed_markers= split(' ',$group);
					foreach my $collapsed (@collapsed_markers){
						#print $collapsed;
						if ($collapsed=~/$marker[0]/){
							my $marker_lg=search_map(\@marker,\$collapsed_markers[0],\%hash_of_map);
						}
					}
				}
	}

#ONCE A MATCH HAS BEEN FOUND THIS PRINTS OUT THE POSITION IN THE TWO MAPS BEING COMPARED

sub search_map{
my($marker,$locus,$map)=@_;
#print "Searching for $$locus \n";
open(OUT1,">>emxfe_processed.map");
open(OUT2,">>hxk_processed.map");
 
my %map=%{$map};
#chomp @$marker[2];
#print @$marker[1]."\t".@$marker[2]."\t";
	foreach my $lgs (keys %map){
		my @lg=@{$map{$lgs}};
			foreach my $grp (@lg){
					my @split_loc=split(" ",$grp);
					if ($$locus=~/$split_loc[0]/){
						$lgs=~s/\r\n//;
						#print "$lgs,$$locus,$split_loc[1],";
						#print "$$marker[1],$$marker[0],$$marker[2]\n";
						#print OUT1 "$lgs,$$locus,$split_loc[1]\n";
						print OUT1 "$lgs,$$marker[0],$split_loc[1]\n";
						print OUT2 "$$marker[1],$$marker[0],$$marker[2]";
					}
				}
		}
	close OUT1;
	close OUT2;
}
sub read_table{
    my ($file)=@_;
    
    print "Reading in $$file \n ";
    open(IN,$$file);
    my @array= <IN>;
    close IN;
    return @array;
}
sub parse_map{
	my($file)=@_;
	my %HoA=();
	my $key=();
	my @array=();
	my $flag=0;
	
	foreach(@$file){
		if($_=~/group/ && $flag==0){
			$key=$_;
			$flag=1;
			}
		elsif($_=~/group/ && $flag==1){
			#print "$key \t $_";
			$HoA{$key}=[@array];
			$key=$_;
			@array=();
			}
		elsif($_!~/\S/){
			#print "Whitespace\n";
			next;
			}
		else{
			#print $_;
			push(@array,$_);
			}		
	}
	return %HoA;
}
sub parse_group{
	my($file)=@_;
	my %HoA=();
	my $key=();
	
	foreach(@$file){
		my @array=split(" ",$_);
		my @sub_array=();
				for (my $i=1;$i<scalar(@array);$i++){
					push (@sub_array,$array[$i]);
					}
				$HoA{$array[0]}=\@sub_array;
			}
	return %HoA;
}