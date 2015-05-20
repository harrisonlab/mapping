#!/usr/bin/perl

use warnings;
use strict;

#Usage ./map_sorter.pl ./em_fe/exf_processed.map  ./em_fe/exf_sorted.map 
# your map, probe set mapping, map to compare with


my $input_map=shift;
my $output_map=shift;
my @map_data= read_table(\$input_map); 	
my @ordered_map=();
my $count=0;
my %map=parse_map(\@map_data,\@ordered_map,\$count);

open(OUT1,">$output_map");

foreach( @ordered_map){
	#print "Linkage ".$_."\n";
	my @lg_array=@{$map{$_}};
	my @sorted_lg=sort_lg(\@lg_array);
		foreach (@sorted_lg){
			print OUT1 $_."\n";
		}
	}

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
	my($map,$order,$count)=@_;
	my %HoA=();
	my $key=();
	my @array=();
	my $flag=0;
	print "ARRAY LENGTH ".scalar(@$map)." \n";
	
	for(my $i=0;$i<scalar(@$map);$i++){
		@$map[$i]=~s/\n//g;
		my @split=split(',',@$map[$i]);
		#print $split[0]."\n";
		
		if ($i==0){
	#		print "FIRST LINE\n";
			$flag=$split[0];
			push (@$order,$flag);
			#push (@array,@$map[$i]);
			$$count=$$count+1;
		}
		if ($i==(scalar(@$map)-1)){
		#	print "LAST LINE\n";
			$flag=$split[0];
			push (@array,@$map[$i]);
			$$count=$$count+1;
			my @tmp=@array;
			$HoA{$flag}=\@tmp;
		}
		elsif($split[0] eq $flag){
			#print "NORMAL \n";
			$$count=$$count+1;
			push (@array,@$map[$i]);
		}
		elsif($split[0] ne $flag){
			#print "CHANGING LG from $flag to $split[0] \n";
			
			my @tmp=@array;
			$HoA{$flag}=\@tmp;
			@array=();
			$flag=$split[0];
			$$count=$$count+1;
			push (@$order,$flag);
			push (@array,@$map[$i]);
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