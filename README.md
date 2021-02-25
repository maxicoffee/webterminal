# mcterminal bastion server


 Fork of Webterminal implemented by django.
This project focus on DevOps and Continuous Delivery.
For now it support almost 90% remote management protocol such as vnc, ssh,rdp,telnet,sftp... It support a possiblity to monitor and recorded user action when user use this project to manage their server!You can also replay the user action such as like a video.
Hope you enjoy it.

Fork is for cleaning codebase.


# Run with docker

```sh
docker pull webterminal/webterminal
docker run -itd -p 80:80 -p 2100:2100 webterminal/webterminal
Login user & password
username: admin
password: password!23456
```
# License

[GPL V3 License](LICENSE)

