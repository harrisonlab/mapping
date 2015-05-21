#!/usr/bin/perl

use warnings;
use strict;

#Usage  ./map_namer.pl ./rgxha/combined_map_filtered.map ./rgxha/map_compare.txt ./rgxha/rgxha_renamed.map 28 3933
# your map, name list, output file


my $input_map=shift;
my $map_comparison=shift;
my $output_map=shift;
my $grp=shift;
my $loc=shift;
my @map_data= read_table(\$input_map); 	
my %map=parse_map(\@map_data);
my @lg_compare= read_table(\$map_comparison); 	

open(OUT1,">$output_map");
print OUT1 "; ngrp=".$grp.", nloc=".$loc."\n";
 
foreach (@lg_compare){

my @split=split('\t',$_);
	foreach( keys (%map)){
		my $tmp=$_;
		$tmp=~s/\n//g;
		#print $tmp;
		if ($tmp eq $split[0]){
		print "MATCHED with $split[0] with $tmp and $split[1]"; 
		print OUT1 "group ".$split[1];
		print OUT1 @{$map{$_}};
		}
	}
}
close OUT1;
exit;

#foreach( @lg_compare){
	#print "Linkage ".$_."\n";
#	my @lg_array=@{$map{$_}};
#	my @sorted_lg=sort_lg(\@lg_array);
#		foreach (@sorted_lg){
#			print OUT1 $_."\n";
#		}
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
#print "Comparing maps \n";
#	foreach(@comp_data){
#		my @marker=split('\t',$_);
#		#print "Searching for $marker[0] found on $marker[1] \n";
#		#print "$marker[1] \t";
#			foreach my $group (@group_data){
#				my @collapsed_markers= split(' ',$group);
#					foreach my $collapsed (@collapsed_markers){
#						#print $collapsed;
#						if ($collapsed=~/$marker[0]/){
#							my $marker_lg=search_map(\@marker,\$collapsed_markers[0],\%hash_of_map);
#						}
#					}
#				}
#	}

#ONCE A MATCH HAS BEEN FOUND THIS PRINTS OUT THE POSITION IN THE TWO MAPS BEING COMPARED

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
sub sort_lg{
	my ($file)=@_;
	my %hash_to_sort=();

	foreach(@$file){
		#print $_."\n";
		my @split=split(",",$_);
		$hash_to_sort{$split[2]}=$_;
	}
	
	my @aov=sort { $a <=> $b }(keys %hash_to_sort);
	my @sorted_lg=();

	foreach (@aov){
		push(@sorted_lg, $hash_to_sort{$_});
	}

return @sorted_lg;
}