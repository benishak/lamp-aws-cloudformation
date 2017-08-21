# AWS Cloudformation template for fully programmable automated LAMP Stack Deployment

This is a Cloudformation template to deploy *any* any LAMP Stack to AWS with high availability and scalability! You can deploy any PHP Software with this template like WordPress, MyBB, phpBB, ... etc or your custom application.

## Stack

This is LAMP Stack
- Amazon Linux 2017.03
- Apache 2
- MySQL 5.6
- PHP 7.0

## Architecture

Highly availabile and scalable secure architecture includes

- VPC on 2 Availability Zones with 2 public subnets and 2 private subnets
- 2 NATGateways (1 Gateway per availability zone)
- Multi-AZ RDS MySQL Cluster GP2 EBS deployed into private subnets
- Cross-Zone internet-facing Application ELB deployed into public subnets
- EC2 AutoScaling Group deployed into private subnets
- Security Group allowing HTTP Traffics from Internet to ELB only
- Security Group allowing HTTP Traffics between ELB and EC2 only
- Security Group allowing traffics between EC2 and RDS MySQL Cluster only
- SNS Notification for scaling events

Read more in the example/mybb_1812/Design.pdf

[<img src="https://s3.amazonaws.com/cloudformation-examples/cloudformation-launch-stack.png">](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/new?stackName=lamp-stack&templateURL=https://s3.eu-central-1.amazonaws.com/mybb-cx/lamp.cf.template.json)


## Parameters

You need to specify
- The Application source code (.tar.gz): make sure the source code is not in nested directories
- The Application sql dump file (.sql): if your application requires installation and database population
- The Application config files (.tar.gz) : if your application have config files
- Beforeinstall Script : a bash script to execute before installation (check below)
- Afterinstall Script : a bash script to execute after installation (check below)

The Application config compressed file should be in this form

```
config.tar.gz/
  /dir1
    subdir1/
    subdir2/
    file1
    file2
    ...
```

**WARNING:** *all files are required if your application doesn't require any of these files, make sure to use empty **valid** files!*

## Deployment Hooks

Beforeinstall -> MySQL Dump Restore -> Afterinstall

### Beforeinstall

You can specify an URL for a shell script to be executed before installation, such downloading and installing extra resources or packages or modifying MySQL Dump file. YOU MUST Use an empty file if you don't want to execute anything.

### Afterinstall

You can specify an URL for a shell script to be executed after installation, such changing files and directory permissions or updating config files. YOU MUST Use an empty file if you don't want to execute anything.

### Environment Variables

Here is a list of the available Environment Variables that you can use in your beforeinstall and afterinstall script.

| Variable           | Description                                                               | Hooks                       |
| -----------------: | ------------------------------------------------------------------------: | --------------------------: |
| X_MYSQL_DUMP       | The location of the SQL Dump file                                         | beforeinstall, afterinstall |
| X_WORK_DIR         | The location where files are downloaded                                   | afterinstall                |
| X_WWW_PATH         | The location of apache www/html folder                                    | afterinstall                |
| X_DATABASE_NAME    | The database name you configured at stack creation                        | afterinstall                |
| X_DATABASE_USER    | The database username you configured at stack creation                    | afterinstall                |
| X_DATABASE_PASS    | The database password you configured at stack creation                    | afterinstall                |
| X_DATABASE_URI     | The database endpoint of your RDS MySQL Cluster created by Cloudformation | afterinstall                |
| X_APPLICATION_NAME | The Application name you configured at stack creation                     | afterinstall                |
| X_ELB_HOSTNAME     | The ELB Endpoint created by Cloudformation                                | afterinstall                |
| X_ADMIN_EMAIL      | The Admin Email you configured at stack creation                          | afterinstall                |
| X_ADMIN_USERNAME   | The Admin username you configured at stack creation (if any)              | afterinstall                |
| X_ADMIN_PASSWORD   | The Admin password you configured at stack creation (if any)              | afterinstall                |

check example/mybb_1812/afterinstall.sh

```bash
#!/bin/bash
# afterinstall script example of MyBB
# make language files writable
cd /var/www/html && chmod 666 inc/languages/english/*.php inc/languages/english/admin/*.php

# make public folders writable
cd /var/www/html && chmod 777 cache/ cache/themes/ uploads/ uploads/avatars/ admin/backups/

# delete installation directory
rm -rf /var/www/html/install

# Set config variables
sed -i -e 's/DATABASE/'"$X_DATABASE_NAME"'/g' /var/www/html/inc/config.php
sed -i -e 's/HOSTNAME/'"$X_DATABASE_URI"'/g' /var/www/html/inc/config.php
sed -i -e 's/USERNAME/'"$X_DATABASE_USER"'/g' /var/www/html/inc/config.php
sed -i -e 's/PASSWORD/'"$X_DATABASE_PASS"'/g' /var/www/html/inc/config.php
sed -i -e 's/BB_NAME/'"$X_APPLICATION_NAME"'/g' /var/www/html/inc/settings.php
sed -i -e 's/BB_URL/'"$X_ELB_HOSTNAME"'/g' /var/www/html/inc/settings.php
```

## Examples

- MyBB example/mybb_1812

feel free to contribute and share your examples with beforeinstall & afterinstall scripts!



