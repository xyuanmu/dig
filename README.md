
到这里下载：http://git.io/vcT59


## 使用方法：
1. 双击运行 check.bat，如果是IPv6用户运行 check-ip6.bat。
2. 到 http://public-dns.tk/ 找各个地区DNS，输入模拟的IP，按下回车键。
3. 获取 ANSWER SECTION 下方的IP，如果不是谷歌官方IP段，则是GGC，丢进 checkgoogleip 或 GoGo Tester 里扫描。

## 谷歌官方IP段：
```
nslookup -q=TXT _netblocks.google.com 8.8.8.8
64.18.0.0/20
64.233.160.0/19
66.102.0.0/20
66.249.80.0/20
72.14.192.0/18
74.125.0.0/16
173.194.0.0/16
207.126.144.0/20
209.85.128.0/17
216.58.192.0/19
216.239.32.0/19
```


## 方法原理：
利用dig中EDNS扩展中的subnet功能（为了解析到距离更近的主机，这里可以模拟DNS查询的来源IP），查Google的四个权威DNS：
```
ns1.google.com (216.239.32.10)
ns2.google.com (216.239.34.10)
ns3.google.com (216.239.36.10)
ns4.google.com (216.239.38.10)
```


## 使用dig查询：
在cmd里输入：
* 如果你要IPv4地址（大多数人用IPv4）：
 ``` dig +subnet=X.X.X.X @ns1.google.com www.google.com```
* 如果你要IPv6地址：
  ```dig +subnet=2001:db8:1234::1234 @ns1.google.com aaaa www.google.com```
```
X.X.X.X和那个2001:db8开头的地址改成你想模拟的来源IP
最后的www.google.com可以改成其他的Google域名
ns1.google.com可以换成ns2，ns3，ns4，或者干脆用IP地址
来源IP优先选择亚洲的IP，延时小，速度快
因为Google的官方IP被封的差不多了，所以要找Google Global Cache IP (GGC IP)
```
