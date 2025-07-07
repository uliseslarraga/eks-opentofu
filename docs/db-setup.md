## RDS Setup
To load the sample data into the RDS sql, you should log in into bastion host with cmd psql client, you need to install psql client on ec2 with this command

```shell
$ sudo yum install postgresql15
```

Create a file with your favorite text editor (vim, nano, etc.) copy the content of the file db/db.sql and paste it into a file called db.sql

```shell
$ vim db.sql
$ psql -h <your-rds-endpoint> -p 5432 --dbname=products --username=java_app -a -f db.sql
```
The above command will promp a password input, you should be able to log in with the password set on your tofu script for the database module.