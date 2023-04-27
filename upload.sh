#!/usr/bin/env bash

UPLOADED_FILENAME=$(date +%Y%m%d)-backup.sql.dump.bz2
mv /tmp/backup.sql.dump.bz2 /tmp/$UPLOADED_FILENAME

/aws/dist/aws s3 cp /tmp/$UPLOADED_FILENAME s3://$AWS_BUCKET_NAME$BACKUP_PATH
