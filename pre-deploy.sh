#!/bin/bash
set -e

. ./source.sh "$1"

aws() {
    AWS_PAGER="" command aws "$@"
}

tofu apply -target=module.base -var="lambda_image_uri=placeholder" -auto-approve