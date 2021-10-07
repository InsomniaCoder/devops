# AWS Useful commands

## Profile

Normally, when you work with AWS, you will likely to be working with multiple AWS accounts.

In order to run the command for each accounts. These are the prerequisites.

### Set up

1. install aws-cli using `Homebrew` or other means
2. configure the profile
   1. You can use `aws configure` to run a prompt for setting up your profile. for example, account, default region, etc
   2. or you can configure them manually

configure profile manually

There are 2 main configuration files

1. `~/.aws/config`
   1. This file is used to store your profile for each account. for example, 

   ```
   [default]
    region=ap-southeast-1
    output=json

    [profile a]
    role_arn = arn:aws:iam::123456789012:role/testing
    source_profile = default

    [profile b]
    role_arn = arn:aws:iam::123456789012:role/admin
    source_profile = default
   
   ```

   or if you use aws sso
    ```
   [default]
    region=ap-southeast-1
    output=json
    
   [profile a]
    sso_start_url = https://x.com/start#/
    sso_region = ap-southeast-1
    sso_account_id = xxxxxxx
    sso_role_name = role
    region = ap-southeast-1

    [profile b]
    sso_start_url = https://x.com/start#/
    sso_region = ap-southeast-2
    sso_account_id = xxxxxxx
    sso_role_name = admin
   ```

2. `~/.aws/credentials`
   This file is used to store your access key
   
   ```
   [default]
    aws_access_key_id=AKIAIOSFODNN7EXAMPLE
    aws_secret_access_key=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY

    [user1]
    aws_access_key_id=AKIAI44QH8DHBEXAMPLE
    aws_secret_access_key=je7MtGbClwBF/2Zp9Utk/h3yCo8nvbEXAMPLEKEY
    ```

#### Make use of the profile

To run the command using profiles set up above
1. add `--profiles <profile>` in your command
2. add `AWS_PROFILE=<profile>` before your command

## AWS SSM

to connect to EC2 using AWS SSM (System's Manager's Session Manager)

1. get your instance id
2. run this command
   ```
   aws ssm start-session --target <instance-id> --profiles <your-profile>
   ```

You should be connected to the EC2 now.


#### Use SCP

You need to configure your `~/.ssh/config` to add

```
# 
host i-* mi-*
    ProxyCommand sh -c "aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p'"
```

then you can run this command to copy the given file from the instance to your machine

`scp -i private-keys.pem ec2-user@i-xxxxxxxxxxxxxxxxx:/var/etc/test-files .`