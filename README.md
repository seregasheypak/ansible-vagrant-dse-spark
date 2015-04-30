# Vagrant+Ansible+Cassandra DSE + Spark 1.2

## What is does
On top of ubuntu/trusty64
* Installs 
    *  oracle java 7
    * DSE 4.6.*
    * OpsCenter 5.1.*
    * Spark 1.2 (with History server)
    * JobServer
    * influxdb 0.8.8             
    * grafana

* Tweaks
    * updates your local /etc/hosts using vagrant-hostsupdater plugin
    * Caches installed packages to reuse them using vagrant-cachier plugin

## Installed services location
| Node name      | IP              |spark-master  |spark-worker  | dse  | opscenter|HistoryServer|JobServer    |
|:---------------|:----------------|:-------------|:-------------|:-----|:---------|:------------|:------------|
| dsenode01      | 192.168.56.10   | +            | +            |  +   |          |             |             |
| dsenode02      | 192.168.56.20   |              | +            |  +   |          | +           | +           |
| dsenode03      | 192.168.56.30   |              | +            |  +   |          |             |             |
| dsenode04      | 192.168.56.40   |              |              |      | +        |             |             |

## UI access
|Service name| 
|:-----------| 
| [opscenter](http://dsenode04:8888/)|
| [spark-master](http://dsenode01:18080/)|
| [history-server](http://dsenode02:18080/)|
| [job-server](http://dsenode02:8090/)|
| [influxdb](http://dsenode03:8083) root:root |
| [grafana](http://dsenode03:3000) admin:admin|

## Reqirements
* [virtualbox](https://www.virtualbox.org/) 4.3.10 or greater.
* [Vagrant](https://www.vagrantup.com/) 1.6 or greater.
    * vagrant plugin install vagrant-hostsupdater to update your /etc/hosts
    * vagrant plugin install vagrant-cachier to speedup apt_cache for all instances sharing it
* [Ansible](http://docs.ansible.com/intro_installation.html#latest-releases-via-homebrew-mac-osx)  
    * [ansible-galaxy install debops.monit](https://github.com/debops/ansible-monit) to use services wrapped in monit
    * [ansible-galaxy install briancoca.oracle_java7](https://galaxy.ansible.com/list#/roles/628) to install java7 without bicycle square wheels [link](https://groups.google.com/forum/#!msg/ansible-project/G84khLtAuQo/5shDJMPOjYYJ)

## Run vagrant to provision 3VMs
```shell
# goto project root
vagrant up
```
### Access VMs
You can access them using ip 192.168.56.(10,20,30,40) or names dsenode0(1,2,3,4) (check your /etc/hosts file before).
* you can do: ```shell vagrant ssh dsenode01``` from project root
* ssh ```shellvagrant@192.168.56.10``` using password "vagrant"
* private key for each VM stored here: ```vagrant/machines/dsenode01/virtualbox/private_key``` each VM has it's own private key due to Vagrant 1.7 changes. It was sharing key previously.

### Add DSE nodes to OpsCenter
**Next time I'll provision nodes with dse-agent packages, we can automate this part**
* Add existing cluster using top right button 
![Add existing clsuter](https://github.com/seregasheypak/ansible-vagrant-dse-spark/tree/spark-cloudera/.wiki_resources/01_new_cluster.png)
* Choose manage exsiting
![Manage existing](https://github.com/seregasheypak/ansible-vagrant-dse-spark/tree/spark-cloudera/.wiki_resources/02_manage_existing.png)
* Enter any DSE node ip address
![DSE node address](https://github.com/seregasheypak/ansible-vagrant-dse-spark/tree/spark-cloudera/.wiki_resources/03_add_cluster.png)
* OpsCenter would ask you for credientials to install. Type ```vagrant``` as user and ```vagrant``` as password. Wait a little and you get agents on each nodes installed using user vagrant which has passwordless sudo.

### Create influxdb database for spark metrics
goto influxdb UI using root:root
![influxdb UI](https://github.com/seregasheypak/ansible-vagrant-dse-spark/tree/spark-cloudera/.wiki_resources/influx_01_login.png)

create database
![influxdb UI](https://github.com/seregasheypak/ansible-vagrant-dse-spark/tree/spark-cloudera/.wiki_resources/influx_02_create_db.png)

### create datasource in Grafana
![Datasource in Grafana](https://github.com/seregasheypak/ansible-vagrant-dse-spark/tree/spark-cloudera/.wiki_resources/grafana_01_create_db.png)

### Grafana and Influxdb
#### Simple dashboard
import grafana-dashboards/spark-simple-example/spark-metrics-1430407766101.json and see how it works

#### List metrics
* login to http://192.168.56.30:8083
* pick database
* execute `select * from /.*/ limit 1`
