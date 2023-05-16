# MySQL Master Master Replication with Docker

MySQL replication is a process that allows data to be copied/replicated from one server to the other at the same time. It is mainly done to increase the availability of data. A Master - Master replication means that we are going to use two servers at the same time, both synchronized with each other.


First pull the repository and run the below command to complete the installation:
!! Be sure that you copy the `.env.example` file to`.env` and change based on your local configuration !!
```
chmod +x ./install.sh && ./install.sh
```
Congratulations :). You have done it. We also have a helpful bash script for your daily use.

```
# To down and up all container
./server.sh boot

# To start all container
./server.sh start

# To restart all container
./server.sh restart

# To stop all container
./server.sh stop

# To SSH into master-01 server and open mysql shell with default user
./server.sh master01

# To SSH into master-01 server and open mysql shell with root user
./server.sh master01 --root

# To SSH into master-02 server and open mysql shell with default user
./server.sh master02

# To SSH into master-02 server and open mysql shell with root user
./server.sh master02 --root
```

```SQL
# SETUP MASTER-01 SQL COMMANDS
CREATE USER IF NOT EXISTS 'replication'@'%' IDENTIFIED BY "secret";
GRANT REPLICATION SLAVE ON *.* TO replication@'%';
FLUSH PRIVILEGES;
SHOW MASTER STATUS\G
*************************** 1. row ***************************
             File: 1.000003
         Position: 808
     Binlog_Do_DB: replica_db
 Binlog_Ignore_DB:
Executed_Gtid_Set:
```

```SQL
# SETUP MASTER-02 SERVER AS A SLAVE OF MASTER-01 SERVER
CREATE USER IF NOT EXISTS 'replication'@'%' IDENTIFIED BY "secret";
GRANT REPLICATION SLAVE ON *.* TO replication@'%';
FLUSH PRIVILEGES;

STOP SLAVE;
CHANGE MASTER TO MASTER_HOST = 'master01', MASTER_USER = 'replication', MASTER_PASSWORD = 'secret', MASTER_LOG_FILE = '1.000003', MASTER_LOG_POS = 808;
START SLAVE;
SHOW SLAVE STATUS \G
*************************** 1. row ***************************
               Slave_IO_State: Waiting for source to send event
                  Master_Host: master01
                  Master_User: replication
                  Master_Port: 3306
                Connect_Retry: 60
              Master_Log_File: 1.000003
          Read_Master_Log_Pos: 808
               Relay_Log_File: ccd217ed61ea-relay-bin.000002
                Relay_Log_Pos: 318
        Relay_Master_Log_File: 1.000003
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes
              Replicate_Do_DB:
          Replicate_Ignore_DB:
           Replicate_Do_Table:
       Replicate_Ignore_Table:
      Replicate_Wild_Do_Table:
  Replicate_Wild_Ignore_Table:
                   Last_Errno: 0
                   Last_Error:
                 Skip_Counter: 0
          Exec_Master_Log_Pos: 157
              Relay_Log_Space: 1186
              Until_Condition: None
               Until_Log_File:
                Until_Log_Pos: 0
           Master_SSL_Allowed: No
           Master_SSL_CA_File:
           Master_SSL_CA_Path:
              Master_SSL_Cert:
            Master_SSL_Cipher:
               Master_SSL_Key:
        Seconds_Behind_Master: 1
Master_SSL_Verify_Server_Cert: No
                Last_IO_Errno: 0
                Last_IO_Error:
               Last_SQL_Errno: 0
               Last_SQL_Error:
  Replicate_Ignore_Server_Ids:
             Master_Server_Id: 1
                  Master_UUID: 0abf38e1-f3f0-11ed-a16b-0242ac1d0002
             Master_Info_File: mysql.slave_master_info
                    SQL_Delay: 0
          SQL_Remaining_Delay: NULL
      Slave_SQL_Running_State: Replica has read all relay log; waiting for more updates
           Master_Retry_Count: 86400
                  Master_Bind:
      Last_IO_Error_Timestamp:
     Last_SQL_Error_Timestamp:
               Master_SSL_Crl:
           Master_SSL_Crlpath:
           Retrieved_Gtid_Set:
            Executed_Gtid_Set:
                Auto_Position: 0
         Replicate_Rewrite_DB:
                 Channel_Name:
           Master_TLS_Version:
       Master_public_key_path:
        Get_master_public_key: 0
            Network_Namespace:
SHOW MASTER STATUS\G
*************************** 1. row ***************************
             File: 1.000003
         Position: 808
     Binlog_Do_DB: replica_db
 Binlog_Ignore_DB:
Executed_Gtid_Set:
```

```SQL
# SETUP MASTER-01 SERVER AS A SLAVE OF MASTER-02 SERVER
STOP SLAVE;
CHANGE MASTER TO MASTER_HOST = 'master02', MASTER_USER = 'replication', MASTER_PASSWORD = 'secret', MASTER_LOG_FILE = '1.000003', MASTER_LOG_POS = 808;
START SLAVE;
SHOW SLAVE STATUS \G

*************************** 1. row ***************************
               Slave_IO_State: Waiting for source to send event
                  Master_Host: master02
                  Master_User: replication
                  Master_Port: 3306
                Connect_Retry: 60
              Master_Log_File: 1.000003
          Read_Master_Log_Pos: 808
               Relay_Log_File: f7c3efef4eaa-relay-bin.000002
                Relay_Log_Pos: 318
        Relay_Master_Log_File: 1.000003
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes
              Replicate_Do_DB:
          Replicate_Ignore_DB:
           Replicate_Do_Table:
       Replicate_Ignore_Table:
      Replicate_Wild_Do_Table:
  Replicate_Wild_Ignore_Table:
                   Last_Errno: 0
                   Last_Error:
                 Skip_Counter: 0
          Exec_Master_Log_Pos: 157
              Relay_Log_Space: 1186
              Until_Condition: None
               Until_Log_File:
                Until_Log_Pos: 0
           Master_SSL_Allowed: No
           Master_SSL_CA_File:
           Master_SSL_CA_Path:
              Master_SSL_Cert:
            Master_SSL_Cipher:
               Master_SSL_Key:
        Seconds_Behind_Master: 1
Master_SSL_Verify_Server_Cert: No
                Last_IO_Errno: 0
                Last_IO_Error:
               Last_SQL_Errno: 0
               Last_SQL_Error:
  Replicate_Ignore_Server_Ids:
             Master_Server_Id: 2
                  Master_UUID: 0abf3ae8-f3f0-11ed-a4d3-0242ac1d0003
             Master_Info_File: mysql.slave_master_info
                    SQL_Delay: 0
          SQL_Remaining_Delay: NULL
      Slave_SQL_Running_State: Replica has read all relay log; waiting for more updates
           Master_Retry_Count: 86400
                  Master_Bind:
      Last_IO_Error_Timestamp:
     Last_SQL_Error_Timestamp:
               Master_SSL_Crl:
           Master_SSL_Crlpath:
           Retrieved_Gtid_Set:
            Executed_Gtid_Set:
                Auto_Position: 0
         Replicate_Rewrite_DB:
                 Channel_Name:
           Master_TLS_Version:
       Master_public_key_path:
        Get_master_public_key: 0
            Network_Namespace:
```