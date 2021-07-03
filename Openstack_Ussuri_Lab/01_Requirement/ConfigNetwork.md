## 1\. Cáu hình Static IP và Hostname cho toàn bộ các Node theo thông tin trong file cấu Environment

## 2\. Cấu hình DNS Local cho toàn bộ các node `/etc/hosts`

```
root@controller:~# cat <<EOT >> /etc/hosts                                                                               
> 10.0.0.2 controller                                                                                                    
> 10.0.0.3 compute1                                                                                                      
> 10.0.0.4 block1                                                                                                        
> EOT

```

```
root@controller:~# cat /etc/hosts
127.0.0.1       localhost
127.0.1.1       controller

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
10.0.0.2 controller
10.0.0.3 compute1
10.0.0.4 block1
```

## 3\. Test connect

```
root@controller:~# ping compute1
PING compute1 (10.0.0.3) 56(84) bytes of data.
64 bytes from compute1 (10.0.0.3): icmp_seq=1 ttl=64 time=0.632 ms
64 bytes from compute1 (10.0.0.3): icmp_seq=2 ttl=64 time=0.325 ms
64 bytes from compute1 (10.0.0.3): icmp_seq=3 ttl=64 time=0.330 ms
^C
--- compute1 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2035ms
rtt min/avg/max/mdev = 0.325/0.429/0.632/0.143 ms
root@controller:~# ping block1
PING block1 (10.0.0.4) 56(84) bytes of data.
64 bytes from block1 (10.0.0.4): icmp_seq=1 ttl=64 time=0.365 ms
64 bytes from block1 (10.0.0.4): icmp_seq=2 ttl=64 time=0.258 ms
^C
--- block1 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1013ms
rtt min/avg/max/mdev = 0.258/0.311/0.365/0.056 ms

```

## Cấu hình tương tự trên các Node còn lại