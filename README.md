# Vagrant+Ansible+Cassandra DSE + Spark 1.2

## What is does
* Installs 
    * DSE 4.6
    * OpsCenter 5.1
    * Spark 1.2 (with History server)
    * JobServer
    * Graphite
* Tweaks
    * updates your local /etc/hosts using vagrant-hostsupdater plugin
    * Caches installed packages to reuse them using vagrant-cachier plugin

## Installed services location
| Node name      | IP              |spark-master  |spark-worker  | dse  | opscenter|HistoryServer|JobServer    |
|:---------------|:----------------|:-------------|:-------------|:-----|:---------|:------------|:------------|
| dsenode01      | 192.168.56.10   | +            | +            |  +   |          | +           |             |
| dsenode02      | 192.168.56.20   |              | +            |  +   |          |             | +           |
| dsenode03      | 192.168.56.30   |              | +            |  +   |          |             |             |
| dsenode04      | 192.168.56.30   |              |              |      | +        |             |             |

## UI access
|Service name| 
|:-----------| 
| [opscenter](http://dsenode04:8888/)|
| [spark-master](http://dsenode01:8080/)|
| [history-server](http://dsenode01:18080/)|
| [job-server](http://dsenode02:8090/)|
| [graphite](http://dsenode03) admin:admin

## Reqirements
* [virtualbox](https://www.virtualbox.org/) 4.3.10 or greater.
* [Vagrant](https://www.vagrantup.com/) 1.6 or greater.
    * vagrant plugin install vagrant-hostsupdater to update your /etc/hosts
    * vagrant plugin install vagrant-cachier to speedup apt_cache for all instances sharing it
* [Ansible](http://docs.ansible.com/intro_installation.html#latest-releases-via-homebrew-mac-osx)  

## Run Spark downloader
```shell
# go to project root
chmod +x download_spark_distro.sh
./download_spark_distro.sh
```
Run script to download Apache Spark locally. Then Ansible is going to upload binary to VMs. We are trying to save some time for dowloading 200MB distro several times.

**NB**: If link to distro changes, just fix it in download shell script **download_spark_distro.sh** and spark-configuration role
```
/Users/ssa/devel/appdata/ansible-vagrant-dse-spark/roles/spark_configuration/tasks/main.yml
```

## Run vagrant to provision 3VMs
```shell
# go to project root
vagrant up
```
## start spark
Run Ansible with spark related tags in order to start spark services in proper order. Vagrant and Ansible have weird ad-hoc integration, 
hope it would be easier to run adhoc Ansible for vagrant later. I prepared two agly scripts for u.
```shell
#restart spark-master 
chmod +x start-spark-master.sh
./start-spark-master.sh

#restart spark-workers 
chmod +x start-spark-master.sh
./start-spark-master.sh
```
Feel free to suggest how-to fix this nighmare

### Access VMs
You can access them using ip 192.168.56.(10,20,30,40) or names dsenode0(1,2,3,4) (check your /etc/hosts file before).
* you can do: ```shell vagrant ssh dsenode01``` from project root
* ssh ```shellvagrant@192.168.56.10``` using password "vagrant"
* private key for each VM stored here: ```vagrant/machines/dsenode01/virtualbox/private_key``` each VM has it's own private key due to Vagrant 1.7 changes. It was sharing key previously.

### Add DSE nodes to OpsCenter
**Next time I'll provision nodes with dse-agent packages, we can automate this part**
* Add existing cluster using top right button 
![Add existing clsuter](https://github.com/seregasheypak/ansible-vagrant-dse-spark/blob/master/.wiki_resources/01_new_cluster.png)
* Choose manage exsiting
![Manage existing](https://github.com/seregasheypak/ansible-vagrant-dse-spark/blob/master/.wiki_resources/02_manage_existing.png)
* Enter any DSE node ip address
![DSE node address](https://github.com/seregasheypak/ansible-vagrant-dse-spark/blob/master/.wiki_resources/03_add_cluster.png)
* OpsCenter would ask you for credientials to install. Type ```vagrant``` as user and ```vagrant``` as password. Wait a little and you get agents on each nodes installed using user vagrant which has passwordless sudo.
