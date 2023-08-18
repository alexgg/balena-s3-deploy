#!/usr/bin/env bash

set -e
set -x

pushd "${GITHUB_WORKSPACE}" || ( echo "Error accessing ${GITHUB_WORKSPACE}" && exit 1 )

if [ -n "${INPUT_AWS_ENDPOINT}" ]; then
  ENDPOINT_APPEND="--endpoint-url ${INPUT_AWS_ENDPOINT}"
fi

S3CMD="s4cmd --access-key=${INPUT_AWS_ACCESS_KEY} --secret-key=${INPUT_AWS_SECRET_KEY} ${ENDPOINT_APPEND}"
_tmpdir=$(mkdir -d)
if [ -z "$($S3CMD ls s3://${INPUT_AWS_BUCKET}/${INPUT_AWS_PATH})" ] ||
   [ -n "$($S3CMD ls s3://${INPUT_AWS_BUCKET}/${INPUT_AWS_PATH}/IGNORE)" ]; then
    $S3CMD del -rf "s3://${INPUT_AWS_BUCKET}/${INPUT_AWS_PATH}"
    touch "${_tmpdir}/IGNORE"
    $S3CMD put "${_tmpdir}/IGNORE" "s3://${INPUT_AWS_BUCKET}/${INPUT_AWS_PATH}"
    $S3CMD --recursive --API-ACL="${INPUT_AWS_POLICY}" dsync "${INPUT_SOURCE_PATH}/" "s3://${INPUT_AWS_BUCKET}/${INPUT_AWS_PATH}"
    if [ -f "${INPUT_SOURCE_PATH}/latest" ]; then
      $S3CMD put "${INPUT_SOURCE_PATH}/latest" "s3://${INPUT_AWS_BUCKET}/${INPUT_AWS_PATH}/" --API-ACL="${INPUT_AWS_POLICY}" -f
    fi
    $S3CMD del "s3://${INPUT_AWS_BUCKET}/${INPUT_AWS_PATH}/IGNORE"
else
  echo "[balena-s3-deploy] WARNING: ${INPUT_AWS_BUCKET}/${INPUT_AWS_PATH} already exists or IGNORE file exists."
fi
rmdir "${_tmpdir}"
