project=default
sa_name=cluster-sleeper-sa

oc create sa $sa_name -n $project
oc adm policy add-cluster-role-to-user cluster-admin system:serviceaccount:$project:$sa_name -n $project
oc create token cluster-sleeper-sa --duration=$((90*24))h > /home/dshirley/Documents/dshirley1ipi/cluster-sleeper-sa-auth.json