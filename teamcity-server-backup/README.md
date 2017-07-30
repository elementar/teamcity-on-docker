# TeamCity Server Backup

This image will access your TeamCity instance via the REST API,
perform a backup, and then sync the backup directory with the S3 bucket
you specify.

To use it in a `docker-compose` setup:

```yaml
teamcity-server:
  image: jetbrains/teamcity-server

teamcity-server-backup:
  image: elementar/teamcity-server-backup
  volumes_from:
    - teamcity-server
  environment:
    TEAMCITY_SERVER: http://my-teamcity-server
    TEAMCITY_USERNAME: some_username
    TEAMCITY_PASSWORD: some_password
    S3_BACKUP_LOCATION: s3://some-bucket/some-folder
    # the following are optional when running on EC2 - IAM roles are recommended
    AWS_ACCESS_KEY_ID: ...
    AWS_SECRET_ACCESS_KEY: ...
```
