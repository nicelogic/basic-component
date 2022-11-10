
# mongodb

## cmd

kubectl config set-context $(kubectl config current-context) --namespace=mongodb

## community


kubectl create secret generic base-mongodb-user-password -n mongodb --from-literal="password=ccccc123"



<!-- mongo "mongodb://warmth-mongo.luojm.com:27017/?replicaSet=base-mongodb" --username logic --password ccccc123 --authenticationDatabase warmth -->
<!-- mongo "mongodb://base-mongodb-svc.mongodb.svc.cluster.local:27017/?replicaSet=base-mongodb" --username logic --password ccccc123 --authenticationDatabase warmth -->
<!-- mongo "mongodb://admin:ccccc123@warmth-mongo.luojm.com:27017/warmth?readPreference=primary&directConnection=true&ssl=true" -->
mongo "mongodb://logic:ccccc123@warmth-mongo.luojm.com:27017/warmth?readPreference=secondaryPreferred&directConnection=true&ssl=true"

rs.initiate();
//可以显示当前的状态
rs.status(); 

db.createUser({user:"test",pwd:"ccccc123",roles:["clusterAdmin","readWriteAnyDatabase","dbAdminAnyDatabase","userAdminAnyDatabase"]})

db.getFreeMonitoringStatus


mongo "mongodb://<service-object-name>.<my-namespace>.svc.cluster.local:27017/?replicaSet=<replica-set-name>" --username <username> --password <password> --authenticationDatabase <authentication-database>

mongodb://luojm:ccccc123@mongodb-0.mongodb-svc.mongodb.svc.cluster.local:27017,mongodb-1.mongodb-svc.mongodb.svc.cluster.local:27017,mongodb-2.mongodb-svc.mongodb.svc.cluster.local:27017/admin?replicaSet=mongodb&ssl=false

mongodb+srv://luojm:ccccc123@mongodb-svc.mongodb.svc.cluster.local/admin?replicaSet=mongodb&ssl=false
