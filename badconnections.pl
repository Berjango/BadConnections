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
#print "ip=$ip\n";
($ip,$port)=split(":",$ip);
#print "ip=$ip\n";
my @ipparts=split(/\./,$ip);
#print "ipparts=@ipparts\n";
foreach (@_){
    ($bip,$bits)=split(/\//,$_);
    #print "bip=$bip";
    if($bip=~/:/ or $bip==""){
        $blocked=0;
        #print "non ipv4 detected\n"
    }
    else{
    @bipparts=split(/\./,$bip);
#    print "bipparts=@bipparts\n";
    $blocked=1;
    #print "Checking @bipparts with @ipparts\n";
    for(my $i = 0; $i <= 3-$bits/8; $i++){
        #print "Loop $i $ipparts[$i] $bipparts[$i]\n";

        if($ipparts[$i]!=$bipparts[$i]){
            $blocked=0;
            #print "$blocked=0\n";
            last;
        }

    }
    if($blocked==1){
        return(1);
    }
    }
    }
    return(0);
}
print "Finding bad connections.Please wait ,this can take a few minutes in some cases.\n";
$info=`ss -rt`;
#$info="ESTAB 69.160.152.31:http\nESTAB 211.12.20.34:https";
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
        if(isblocked($bad,@blockedips)==1){
            print("    Blocked\n");
        }
        else{
            print("     Danger,connection not blocked\n");
        }
    }

}
else{
    print "No bad connectiosn detected.\n";
}
0;

