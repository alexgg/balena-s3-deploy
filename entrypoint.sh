#!/bin/bash

set -e

if [ -z "$LOCAL_PATH" ]; then
	echo "LOCAL_PATH is required."
	exit 1
fi

if [ -z "$AWS_S3_BUCKET" ]; then
	echo "AWS_S3_BUCKET is required."
	exit 1
fi

if [ -z "$AWS_S3_PATH" ]; then
  echo "[balena-s3-deploy]: WARNING: No AWS_S3_PATH provided, deploying at root."
fi

if [ -z "${AWS_S3_ACCESS_KEY}" ]; then
	echo "AWS_S3_ACCESS_KEY is required."
	exit 1
fi

if [ -z "${AWS_S3_SECRET_KEY}" ]; then
	echo "AWS_S3_SECRET_KEY is required."
	exit 1
fi

if [ -z "$AWS_REGION" ]; then
	AWS_REGION="us-east-1"
fi

AWS_S3_POLICY="private"
if [ -z "$AWS_S3_PUBLIC" ]; then
	AWS_S3_POLICY="public-read"
fi

if [ -n "$AWS_S3_ENDPOINT" ]; then
  ENDPOINT_APPEND="--endpoint-url $AWS_S3_ENDPOINT"
fi

S3CMD="s4cmd --access-key=${AWS_S3_ACCESS_KEY} --secret-key=${AWS_S3_SECRET_KEY} ${ENDPOINT_APPEND}"
_tmpdir=$(mkdir -d)
if [ -z "$($S3CMD ls s3://${AWS_S3_BUCKET}/${AWS_S3_PATH}/)" ] ||
   [ -n "$($S3CMD ls s3://${AWS_S3_BUCKET}/${AWS_S3_PATH}/IGNORE)" ]; then
    $S3CMD del -rf "s3://${S3_BUCKET}/${AWS_S3_PATH}/"
    touch "${_tmpdir}/IGNORE"
    $S3CMD put "${_tmpdir}/IGNORE" "s3://${S3_BUCKET}/${AWS_S3_PATH}/"
    $S3CMD --recursive --API-ACL="${AWS_S3_POLICY}" dsync "${LOCAL_PATH}/" "s3://${AWS_S3_BUCKET}/${AWS_S3_PATH}/"
    $S3CMD put /host/images/${SLUG}/latest s3://${S3_BUCKET}/${SLUG}/ --API-ACL=public-read -f
    $S3CMD del s3://${S3_BUCKET}/${SLUG}/${BUILD_VERSION}/IGNORE
else
  echo "[balena-s3-deploy] WARNING: ${AWS_S3_BUCKET}/${AWS_S3_PATH} already exists or IGNORE file exists."
fi
rmdir "${_tmpdir}"
