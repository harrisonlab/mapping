#!/usr/bin/perl

use warnings;
use strict;

#Usage ./map_reducer.pl combined_map.txt groups_to keep.txt 
#Usage  ./map_reducer.pl ./rgxha/combined_map.txt ./rgxha/combined_map_groups.txt 
#./map_reducer.pl ./rgxha/combined_map.txt ./rgxha/combined_map_groups.txt >./rgxha/combined_map_filtered.map

my $input_map=shift;
my $collapsed_group=shift;
my @loc_data= read_table(\$input_map); 	
my %hash_of_map=parse_map(\@loc_data);
my @group_data= read_table(\$collapsed_group); 	

my $group_number=scalar(@group_data);
my $loc_number=0;
my @map_output=();

#my %hash_of_group=parse_group(\@group_data);
#my @comp_data= read_table(\$compare_map); 	
#exit;
foreach my $group (@group_data){
	chomp $group;
	$group=~s/\r\n//g;
	#print "Searching for $group \n";
	foreach(keys %hash_of_map){
		#$_=~s/\r\n//g;
		my $search_val=$_;
		$search_val=~s/\r\n//g;
		$search_val=~s/\r//g;
		#chomp $_;
		#print $_."\n";
		if ($group eq $search_val){
			#print $search_val."\n";
			push(@map_output,$_);
			my @lg_array=@{$hash_of_map{$_}};
			#print @lg_array;
			foreach(@lg_array){
			push (@map_output,$_);
			}
			$loc_number=$loc_number+scalar(@lg_array);
			#foreach (@lg_array){
			#	print $_;
			#}
		}
	}
}

print "
; ngrp=$group_number, nloc=$loc_number \n";
foreach( @map_output){
$_=~s/\r\n//;
print $_;
}

#foreach(keys %hash_of_group){
#	print $_."\t";
#	my @group=@{$hash_of_group{$_}};
#	 foreach(@group){
#	 	print $_."\t";
#	 }
#	 print "\n";
#	}
#exit;

#THIS COMPARES THE MAPS LOOKING FOR MATCHING LOCI
#print "Comparing maps \n";
#	foreach(@comp_data){
#		my @marker=split(',',$_);
#		#print "Searching for $marker[1] found on $marker[0] \n";
#		#print "$marker[1] \t";
#			foreach my $group (@group_data){
#				#print $group;
#				my @collapsed_markers= split(';',$group);
#					foreach my $collapsed (@collapsed_markers){
#						#print $collapsed;
#						if ($collapsed=~/$marker[1]/){
#						print "Marker match\n";
#							my $marker_lg=search_map(\@marker,\$collapsed_markers[0],\%hash_of_map);
#						}
#					}
#				}
#	}

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
						print OUT1 "$lgs,$$marker[1],$split_loc[1]\n";
						print OUT2 "$$marker[0],$$marker[1],$$marker[2]";
					}
				}
		}
	close OUT1;
	close OUT2;
}
sub read_table{
    my ($file)=@_;
    
 #   print "Reading in $$file \n ";
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