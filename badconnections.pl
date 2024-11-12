#!/usr/bin/perl


#NO GUARANTEE THIS PROGRAM DOES ANYTHING USEFUL. USE AT OWN RISK.

#Program to show suspected hacker connections.This is not 100% accurate but is useful.This program will produce both false positives and false negatives but they will
#hopefully be in the minority.I have used this technique to succesfully remove hackers from my computer but there is no guarantee that it will work for anyone else.

#Author - Peter Wolf
#Date - 12-11-2024
#dougalite@gmail.com

$info=`ss -rt`;
open my $handle, '<', "ipstoblock";
chomp(my @blockedips = <$handle>);
close $handle;

#print $connections;
#print @blockedips;

print "Finding bad connections.Please wait ,this can take a few minutes in some cases.\n";
@badconnections=();

@connections=split(" ",$info);
foreach (@connections){
	$con=$_;
#	print "$con\n";
	if ($con=~/(\d+\.\d+\.\d+\.\d+\:)/){
		push(@badconnections,$con);
		}
	}
if (@badconnections>0){
    foreach (@badconnections){
        print"$_+\n";
    }
}
else{
    print "No bad connectiosn detected.\n";
}

