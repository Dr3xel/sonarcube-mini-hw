# sonarcube-mini-hw
Homework from Mintos

Architecture

![architecture drawio](https://github.com/user-attachments/assets/1c59700b-4eb9-4460-aec5-76be8bf00904)


=====================

Command order:
>chmod +x setup.sh

>bash setup.sh

=====================

Enable port forwarding to check the web UI:

>kubectl port-forward sonarqube-sonarqube-0 9000:9000 -n sonarqube

=====================

Access 127.0.0.1:9000 in your browser

Default username: admin

Default password: admin

After loging you will be forced to change your admin password
