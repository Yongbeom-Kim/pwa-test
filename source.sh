#!/bin/bash

TERRAFORM_DIR="infra/envs/prod"
ENV=prod

tofu() {
    command tofu -chdir=$TERRAFORM_DIR "$@"
}
