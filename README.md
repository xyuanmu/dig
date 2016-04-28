**特别声明：[checkiptools](https://github.com/xyuanmu/checkiptools) 已经集成dig功能并且支持多线程，建议用该工具进行解析！**

## 软件说明
* 一个简单的使用dig扩展功能获取谷歌IP的工具
* 支持平台：Windows
* 支持网站：[Best DNS](http://www.bestdns.org/), [Ungefiltert surfen](http://www.ungefiltert-surfen.de/)
* 下载地址：[点击下载](https://github.com/xyuanmu/dig/archive/master.zip)

## debug工具使用方法：
1. 方法一：
  1. 到 [Best DNS](http://www.bestdns.org/) 首页 **Where do you need a DNS from?** 下方选一个地区的网址进行复制。
  2. 或者到 [Ungefiltert surfen](http://www.ungefiltert-surfen.de/) 选择 **Öffentliche Nameserver nach Ländern** 下方的地区网址进行复制。
  3. 运行 debug.bat，右键，粘贴网址，按下回车，之后会自动获取网页内的IP并使用dig工具获取返回的IP段。
2. 方法二：
  1. 在 debug.bat 所在目录新建一个 ip.txt，将自己收集IP地址复制进去，一行一个。
  2. 运行 debug.bat 自动使用dig工具获取返回的IP段。
3. 方法三：
  1. 在 debug.bat 所在目录新建一个 url.txt，复制 [Best DNS](http://www.bestdns.org/) 站点的网址进去，一行一个。
  2. 或者新建一个 url2.txt，复制 [Ungefiltert surfen](http://www.ungefiltert-surfen.de/) 站点的网址进去，一行一个。
  3. 运行 debug.bat 自动下载所有网页并使用dig工具获取返回的IP段。
4. 生成 ip_range.txt 后将里面的IP段导入扫描工具如 [checkiptools](https://github.com/xyuanmu/checkiptools) 进行扫描和管理。

## 注意事项：
* 目前支持的地址只有 [Best DNS](http://www.bestdns.org/) 和 [Ungefiltert surfen](http://www.ungefiltert-surfen.de/) ，而且 [Best DNS](http://www.bestdns.org/) 首页格式不同无法获取。
* url.txt 和 url2.txt 两个文件不要弄混，url.txt 输入 [Best DNS](http://www.bestdns.org/) 网址，url2.txt 输入 [Ungefiltert surfen](http://www.ungefiltert-surfen.de/) 网址。
* 为方便以后查看，日志文件 dig.log 默认重命名，有洁癖的可以手动删除。
* 为保证下次启动后不会重新下载 url 文件里的网址，下载成功后会重命名 url 文件，若无用可手动删除。
* 每次结束时会自行整理 ip_range.txt 去掉之前出现过的IP段，若只想获取本次结果可手动删除后再运行 debug.bat。
* **软件需要完整VC++ 2005运行库**，若提示“应用程序无法启动...使用命令行 sxstrace.exe 工具”，请到[这里下载安装](https://www.microsoft.com/zh-CN/download/details.aspx?id=26347)。

## dig工具使用方法：
1. 根据系统选择32位（dig-32bit）或64位（dig-64bit）。
1. 双击运行 check.bat，如果是IPv6用户运行 check-ip6.bat。
2. 到DNS网站找各个地区DNS，输入模拟的IP，按下回车键。
3. 获取 ANSWER SECTION 下方的IP，如果不是谷歌官方IP段，则是GGC，丢进 [checkiptools](https://github.com/xyuanmu/checkiptools) 或 GoGo Tester 里扫描。

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
