#!/bin/bash
set -e

# TeamCity REST API documentation:
# https://confluence.jetbrains.com/display/TCD10/REST+API#RESTAPI-DataBackup

if [[ ! -d $LOCAL_BACKUP_DIR ]]; then
  echo "$LOCAL_BACKUP_DIR is not a directory"
  echo "Make sure the \$LOCAL_BACKUP_DIR enviroment variable is correctly set"
  exit 1
fi

if [[ $S3_BACKUP_LOCATION != s3://* ]]; then
  echo "$S3_BACKUP_LOCATION is not a valid S3 location"
  echo "Make sure the \$S3_BACKUP_LOCATION enviroment variable is correctly set"
  exit 1
fi

if [[ $TEAMCITY_SERVER != http* ]]; then
  echo "$TEAMCITY_SERVER is not a valid location"
  echo "Make sure the \$TEAMCITY_SERVER enviroment variable is correctly set"
  exit 1
fi

if [[ -z $TEAMCITY_USERNAME ]] || [[ -z $TEAMCITY_PASSWORD ]]; then
  echo "Make sure the \$TEAMCITY_USERNAME and \$TEAMCITY_PASSWORD enviroment variables are correctly set"
  exit 1
fi

function tc_api {
  url="$1"
  shift
  curl -s -u "$TEAMCITY_USERNAME:$TEAMCITY_PASSWORD" "$TEAMCITY_SERVER/$url" "$@"
}

function backup_is_running {
  [ $(tc_api 'app/rest/server/backup') == 'Running' ]
}

function wait_for_idle {
  echo -n "$@" " "
  while backup_is_running; do
    sleep 10
    echo -n "."
  done
  echo "OK!"
}

[ ! backup_is_running ] || wait_for_idle "Waiting for backup service to be idle..."

# starts the backup
echo "Asking TeamCity to start the backup."
echo -n "Response: "
tc_api 'app/rest/server/backup' -X POST -G \
        -d 'includeConfigs=true' \
        -d 'includeDatabase=true' \
        -d 'includeBuildLogs=true' \
        -d 'fileName=TeamCity_Auto_Backup'

echo
echo
wait_for_idle "Waiting for the backup to finish..."

# uploads backups to S3
echo "Syncing backups to S3..."
aws s3 sync "$LOCAL_BACKUP_DIR" "$S3_BACKUP_LOCATION"

echo "Done!"
