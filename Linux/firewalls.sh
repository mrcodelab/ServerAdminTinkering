# includes notes

"""Stateless firewalls: packets are examined independently from on another,
meaning that a request and a response are treated as unrelated packets, making
them easy targets for adversaries."""

"""Stateful firewalls: All transmitted packets are monitored from the
initialization of the connection until its termination. This means the firewall
keeps note of packets belonging to the same connection."""

"""Circuit-level gateways are used to establish secure TCP or UDP connections.
The filtering is only applied in the initial phase of the connection setting,
after which the packets flow without inspection."""

"""Proxy firewalls serve as intermediaries between networks for specific
applications, filtering the traffic of layer 7 protocols. The firewall acts
as a gateway by sending requests and receiving data on behalf of the devices
behind it. These firewalls use stateful filtering and deep packet inspection
(DPI) to detect unwanted traffic but can slow network performance since they
actively analyze the data going through them. These types of firewalls are
also known as application-level gateways."""

"""Next-generation firewalls (NGFW) combine packet filtering and stateful
inspection with intrusion detection solutions, encrypted traffic inspection,
and deep packet inspection to detect and stop packets with malicious intentions.
Deep packet inspection is the opposite approach of other firewalls that only
check packet headers to filter connections."""

"""Cloud firewalls are solutions used to filter traffic on cloud services. The
setup is that of proxy firewall implemented on the cloud, and their benefit is
that it can be scaled as needed."""

# Example load firewall rules from file
sudo sh -c 'iptables-restore -v < /iptable-rules.txt | tee /tmp/iptables-out'

# display host routing tables
route | tee ~/route-out.txt """saves host routing table to file"""

# To check the firewall rules, run:
sudo iptable -S | tee ~/iptables-out.txt

# List all the rules in the chain
sudo iptables -L | tee ~/iptables-out.txt

# Add a rule allowing the host to send ICMP packets for ping
sudo iptables -v -A OUTPUT -p icmp -j ACCEPT | tee ~/iptables-out.txt

# Add ALLOW for traceroute tool
sudo iptables -A OUTPUT -m state --state NEW -j ACCEPT
sudo iptables -A OUTPUT -p udp --dport 53 -j ACCEPT

# Add ALLOW of new, related, or established connections
sudo iptables -A INPUT pm state --state RELATED,ESTABLISHED -j ACCEPT
# Add ALLOW for new connections like DNS
sudo iptables -A INPUT -m state --state NEW -j ACCEPT
# Drop all other connections
sudo iptables -P OUTPUT DROP
