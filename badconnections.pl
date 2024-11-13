#!/usr/bin/perl


#NO GUARANTEE THIS PROGRAM DOES ANYTHING USEFUL. USE AT OWN RISK.

#Program to show suspected hacker connections.This is not 100% accurate but is useful.This program will produce both false positives and false negatives but they will
#hopefully be in the minority.I have used this technique to succesfully remove hackers from my computer but there is no guarantee that it will work for anyone else.

#Author - Peter Wolf
#Date - 12-11-2024
#dougalite@gmail.com


sub isblocked
{
my $ip=shift(@_);
($ip,$port)=split(":",$ip);
@ipparts=split(".".$ip);
foreach (@_){
    ($bip,$bits)=split("/",$_);
    @bipparts=split(".".$bip);
    $blocked=1;
    for(my $i = 0; $i <= 3-$bits/8; $i++){
        if($ipparts[i]!=$bipparts[i]){
            $blocked=0;
        }

    }
    if($blocked=1){
        return(1);
    }
    }
    return(0);
}
print "Finding bad connections.Please wait ,this can take a few minutes in some cases.\n";
$info=`ss -rt`;
open my $handle, '<', "ipstoblock";
chomp(my @blockedips = <$handle>);
close $handle;

#print $connections;
#print @blockedips;

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
        $bad=$_;
        print $bad;
        if(isblocked($bad,@blockedips)){
            print("    Blocked\n");
        }
        else{
            print("\n");
        }
    }

}
else{
    print "No bad connectiosn detected.\n";
}


