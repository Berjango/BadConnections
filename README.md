USE AT OWN RISK. NO GUARANTEES THAT THESS PROGRAMS WORK.

Contains 2 programs

1.experimentalfirewall.py experimental firewall - A badly written firewall based on ufw.Has been very useful for me but no guarantees.Tries to find bad connections and automatically blocks them.

to run type "perl experimentalfirewall.py"

2.badconnections.pl
This program is designed to show bad tcp connections to your computer.
It is not 100% accurate and will produce false positives and false negatives which hopefully will be the minority.
This program has proved to be extremely useful for me but may not be for anyone else.

requires the ufw firewall program to be installed,can still be of limited use without it.

To run ,type the following line in a terminal

"perl badconnections.pl"


Currently only ipv4 but will be ipv6 compatible in the future.
