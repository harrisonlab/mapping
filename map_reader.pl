#!/usr/bin/perl

use warnings;
use strict;

#Usage ./map_reader.pl combined_map.txt groups.txt hxk_map.txt
# your map, probe set mapping, map to compare with


my $input_map=shift;
my $collapsed_group=shift;
my $compare_map=shift;

my @loc_data= read_table(\$input_map); 	
my %hash_of_map=parse_map(\@locå_data);
my @group_data= read_table(\$collapsed_group); 	
my %hash_of_group=parse_group(\@group_data);
my @comp_data= read_table(\$compare_map); 
	
open(OUT1,">query_processed.map");
open(OUT2,">reference_processed.map");
close OUT1;
close OUT2;
#foreach(keys %hash_of_map){
#	print "Linkage ".$_;
#	my @lg_array=@{$hash_of_map{$_}};
#	#print @lg_array;
#	#foreach (@lg_array){
#	#	print $_;
#	#}
#	}

#foreach(keys %hash_of_group){
#	print $_."\t";
#	my @group=@{$hash_of_group{$_}};
#	 foreach(@group){
#	print $_." next\t";
#	 }
#	 print "\n";
#	}
#exit;

#THIS COMPARES THE MAPS LOOKING FOR MATCHING LOCI
print "Comparing maps \n";
	foreach(@comp_data){
		my @marker=split(',',$_);
		#print "Searching for $marker[1] found on $marker[0] \n";
		#print "$marker[1] \t";
			foreach my $group (@group_data){
#				#print $group;
				my @collapsed_markers= split(' ',$group);
					foreach my $collapsed (@collapsed_markers){
						#print $collapsed;
						if ($collapsed=~/$marker[1]/){
						#print "Marker match\n";
						#print "Searching with $collapsed_markers[0]";
							my $marker_lg=search_map(\@marker,\$collapsed_markers[0],\%hash_of_map);
						}
					}
				}
	#exit;
	}

#ONCE A MATCH HAS BEEN FOUND THIS PRINTS OUT THE POSITION IN THE TWO MAPS BEING COMPARED

sub search_map{
my($marker,$locus,$map)=@_;
#print "Searching for $$locus \n";
open(OUT1,">>query_processed.map");
open(OUT2,">>reference_processed.map");

#print "MAP SEARCH \n"; 
my %map=%{$map};
#chomp @$marker[2];
#print @$marker[1]."\t".@$marker[2]."\t";
	foreach my $lgs (keys %map){
		my @lg=@{$map{$lgs}};
			foreach my $grp (@lg){
					#print $grp;
					my @split_loc=split(" ",$grp);
					#print $split_loc[0]."\t";
					#print $$locus;
					#$split_loc[0]=~s/\r\n//;
					#$split_loc[0]=~s/\r//;
					#$$locus=~s/\r\n//;
					#$$locus=~s/\r//;
					#if ($split_loc[0]=~/$$locus/){
					if ($$locus=~/$split_loc[0]/){
						my $lgr=$lgs;
						$lgr=~s/\r\n/\t/; 
						print "$lgr,$$locus,$split_loc[1],";
						print "$$marker[1],$$marker[0],$$marker[2]";
						#exit;
						print OUT1 "$lgr,$$locus,$split_loc[1],";
						print OUT2 "$$marker[1],$$marker[0],$$marker[2]";
						#print OUT2 "$$marker[0],$$marker[1],$$marker[2]";
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