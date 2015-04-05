# Vagrant+Ansible+Cassandra DSE + Spark 1.2

## Installed services location
| Node name      | IP |spark-master|spark-worker  | dse  | opscenter|
| :------------- |:----------------| :|   :|  :|   :|
| dsenode01      | 192.168.56.10| + | + | + |    |
| dsenode02      | 192.168.56.20|   | + | + |    |
| dsenode03      | 192.168.56.30|   | + | + |    |
| dsenode04      | 192.168.56.30|   |   |   |   +|

## UI access
|Service name|url|
|:-----------|:--|
|opscenter| http://dsenode04:8888/|
|spark-master| http://dsenode01:8080/|

## Reqirements
* [virtualbox](https://www.virtualbox.org/) 4.3.10 or greater.
* [Vagrant](https://www.vagrantup.com/) 1.6 or greater.
    * vagrant plugin install vagrant-hostsupdater to update your /etc/hosts
    * vagrant plugin install vagrant-cachier to speedup apt_cache for all instances sharing it
    * vagrant plugin install vagrant-host-shell to run shell lines on remote host
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
Run ansible with spark tags in order to start spark services in proper order
ANSIBLE_ARGS='--tags=start-spark-master' vagrant provision
ANSIBLE_ARGS='--tags=start-spark-worker' vagrant provision
