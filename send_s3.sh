#!/bin/bash


export bucket="XXXXXXXXX"

common_params="--acl public-read --content-encoding gzip --cache-control 'public, max-age=86400'"

function print_aws_env {
  echo -n AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID" " "
}

function aws_sync {
  src=$1
  shift

  print_aws_env
  echo aws s3 sync $common_params \
    --content-type application/vnd.quantized-mesh \
    $* \
    outputs/$src/ s3://$bucket/cli_terrain/$src/

}

function aws_cp_json {
  src=$1
  print_aws_env
  echo aws s3 cp $common_params --content-type application/json \
    outputs/$src/layer.json s3://$bucket/cli_terrain/$src/

}


echo "Run each of the following commands in a different terminal"
aws_sync ch-2m --exclude "16*"
aws_sync ch-2m --exclude "'*'" --include "'16/68*'"
aws_sync ch-2m --exclude "'*'" --include "'16*'" --exclude "'16/68*'"

aws_sync ticino-0.5m --exclude "'18*'"
aws_sync ticino-0.5m --exclude "'*'" --include "'18*'"

echo "Once all the above have finished run this command"
aws_cp_json ch-2m
aws_cp_json ticino-0.5m
