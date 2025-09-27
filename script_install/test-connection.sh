# All in one diagnostic
echo "=== DNS Diagnostic ===" && \
ping -c1 8.8.8.8 && \
nslookup google.com && \
cat /etc/resolv.conf && \
nmcli dev status
