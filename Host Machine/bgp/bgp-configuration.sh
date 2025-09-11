# 모든 호스트에서 실행
sudo dnf install -y frr

# 모든 호스트에서 실행
sudo systemctl enable --now frr
sudo systemctl status frr

# BGP 피어링 상태 요약. State가 'Established'가 되어야 성공
vtysh -c "show ip bgp summary"

# BGP를 통해 학습한 라우팅 경로 확인
# '*'와 '>' 표시가 붙은 경로가 현재 활성화된 경로
vtysh -c "show ip route bgp"

[root@openstack-host ~]# vtysh -c "show running-config"
Building configuration...

Current configuration:
!
frr version 8.5.3
frr defaults traditional
hostname openstack-host
log syslog informational
no ipv6 forwarding
!
router bgp 65001
 bgp router-id 10.10.10.1
 neighbor 10.10.10.2 remote-as 65002
 neighbor 10.10.10.2 update-source enp7s0
 neighbor 10.10.10.3 remote-as 65003
 neighbor 10.10.10.3 update-source enp7s0
 !
 address-family ipv4 unicast
  network 192.168.100.0/24
  neighbor 10.10.10.2 route-map ALLOW_ALL in
  neighbor 10.10.10.3 route-map ALLOW_ALL in
 exit-address-family
exit
!
ip prefix-list ALLOW_ALL_PREFIXES seq 5 permit 0.0.0.0/0 le 32
!
route-map ALLOW_ALL permit 10
 match ip address prefix-list ALLOW_ALL_PREFIXES
exit
!
end

[root@openstack-host ~]# vtysh -c "show ip bgp summary"

IPv4 Unicast Summary (VRF default):
BGP router identifier 10.10.10.1, local AS number 65000 vrf-id 0
BGP table version 10
RIB entries 15, using 2880 bytes of memory
Peers 2, using 1449 KiB of memory

Neighbor        V         AS   MsgRcvd   MsgSent   TblVer  InQ OutQ  Up/Down State/PfxRcd   PfxSnt Desc
10.10.10.2      4      65000         7         9        0    0    0 00:00:47            3        4 N/A
10.10.10.3      4      65000         9        13        0    0    0 00:00:45            3        4 N/A

Total number of neighbors 2

[root@openstack-host ~]# vtysh -c "show ip route bgp"
Codes: K - kernel route, C - connected, S - static, R - RIP,
       O - OSPF, I - IS-IS, B - BGP, E - EIGRP, N - NHRP,
       T - Table, v - VNC, V - VNC-Direct, F - PBR,
       f - OpenFabric,
       > - selected route, * - FIB route, q - queued, r - rejected, b - backup
       t - trapped, o - offload failure

B>* 14.xxxxx.0/24 [200/0] via 10.10.10.3, enp7s0, weight 1, 00:01:41
B>* 45.120.120.0/24 [200/0] via 10.10.10.3, enp7s0, weight 1, 00:01:41
B>* 121.xxxxx.0/24 [200/0] via 10.10.10.2, enp7s0, weight 1, 00:01:44
B>* 172.20.112.0/24 [200/0] via 10.10.10.2, enp7s0, weight 1, 00:01:44

[root@openstack-host ~]# ping 172.20.112.101
PING 172.20.112.101 (172.20.112.101) 56(84) bytes of data.
64 bytes from 172.20.112.101: icmp_seq=1 ttl=63 time=1.62 ms
64 bytes from 172.20.112.101: icmp_seq=2 ttl=63 time=1.68 ms

[root@kubernetes-host ~]# ping 192.168.100.101
PING 192.168.100.101 (192.168.100.101) 56(84) bytes of data.
64 bytes from 192.168.100.101: icmp_seq=1 ttl=63 time=1.83 ms
64 bytes from 192.168.100.101: icmp_seq=2 ttl=63 time=1.42 ms

# 1. 10.10.10.x 대역에서 Compute2의 가상 네트워크(45.120.120.x)로 들어오는 트래픽 허용
sudo iptables -I LIBVIRT_FWI 1 -s 10.10.10.0/24 -d 45.120.120.0/24 -j ACCEPT

# 2. Compute2의 가상 네트워크(45.120.120.x)에서 10.10.10.x 대역으로 나가는 트래픽 허용
sudo iptables -I LIBVIRT_FWO 1 -s 45.120.120.0/24 -d 10.10.10.0/24 -j ACCEPT

[root@openstack-host ~]# ping 45.120.120.101
PING 45.120.120.101 (45.120.120.101) 56(84) bytes of data.
64 bytes from 45.120.120.101: icmp_seq=1 ttl=63 time=1.68 ms
64 bytes from 45.120.120.101: icmp_seq=2 ttl=63 time=1.76 ms

[root@kubernetes-host ~]# ping 45.120.120.101
PING 45.120.120.101 (45.120.120.101) 56(84) bytes of data.
64 bytes from 45.120.120.101: icmp_seq=1 ttl=63 time=1.97 ms
64 bytes from 45.120.120.101: icmp_seq=2 ttl=63 time=2.35 ms