config:
   cluster_name: 'DSE Cluster'
   seeds: '172.31.4.154'
   listen_address: 172.31.4.154
   rpc_address:  172.31.4.154