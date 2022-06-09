# Some basic intro level nmap examples

"""A loud port scan which will almost certainly be logged by the target host"""
nmap -sT skillsetlocal.com

# same thing with multiple targets
nmap -sT 10.0.128.123,124
nmap -sT 10.0.128.123 skillsetlocal.com

# ping sweep
nmap -sn 10.0.128.0/18

# scanning an IP range
nmap -sT 10.0.0.50-165

# scanning a specific port
namp -sT skillsetlocal.com -p 6379

# scanning for UDP ports
"""Nmap does this by sending a zero byte UDP packet to each port on the target
machine or device. If it receives an ICMP port unreachable message, it
determines the port is closed. Otherwise it assumes the port is open.

The problem with this technique is that it’s not uncommon for network
equipment to block unreachable messages. This can lead to false positives.
Due to these factors, it can be difficult to determine real open UDP
ports vs. filtered false positive ones. Nmap UDP scan requires root privileges.
"""
sudo nmap -sU skillsetlocal.com

# combining UDP & TCP scan types
sudo nmap -sU -sT skillsetlocal.com

# Grepping the output
nmap -sn 10.0.0.0/24 -oG pingscan.out
cat pingscan.out | grep Up > pingscan.out1
cat pingscan.out1
# getting only the IP addresses
cat pingscan.out1 | cut -f2 -d" " > pingscan.out2

# scan using the modified list
nmap -sT -iL pingscan.out2 -p 80

# protocol scan
sudo nmap -s0 skillsetlocal.com

# OS scanning
sudo nmap -O skillsetlocal.com

# aggressive OS scanning
nmap -T4 -A skillsetlocal.com
