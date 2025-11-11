#!/bin/bash
set -e

. ./source.sh "$1"

aws() {
    AWS_PAGER="" command aws "$@"
}

printf "\033[33;1mDeploying to $ENV...\033[0m\n"

tofu refresh -var="lambda_image_uri=placeholder"

printf "\033[1;37mAuthenticating with ECR...\033[0m\n"
ecr_repository_url=$(tofu output -raw ecr_repository_url)
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${ecr_repository_url}

printf "\033[1;37mBuilding Docker image...\033[0m\n"
docker build \
    --build-arg VITE_PUBLIC_POSTHOG_KEY="${VITE_PUBLIC_POSTHOG_KEY}" \
    --build-arg VITE_PUBLIC_POSTHOG_HOST="${VITE_PUBLIC_POSTHOG_HOST}" \
    -t personal-blog-server .  
docker tag personal-blog-server:latest ${ecr_repository_url}:latest
docker push ${ecr_repository_url}:latest

ecr_repository_name=$(tofu output -raw ecr_repository_name)
image_digest=$(aws ecr describe-images --repository-name ${ecr_repository_name} --image-ids '[{"imageTag":"latest"}]' --query 'imageDetails[0].imageDigest' --output text)
printf "\033[1;37mImage digest: \033[0m\033[33;1m${image_digest}\033[0m\n"

tofu apply \
    -var="lambda_image_uri=${ecr_repository_url}@${image_digest}" \
    -auto-approve

cloudfront_dist_id=$(tofu output -raw cloudfront_distribution_id)
printf "\033[1;37mCloudFront distribution ID: \033[0m\033[33;1m${cloudfront_dist_id}\033[0m\n"
printf "\033[1;37mInvalidating CloudFront cache...\033[0m\n"
aws cloudfront create-invalidation --distribution-id ${cloudfront_dist_id} --paths "/*" 

printf "\033[32;1mDeployment completed successfully!\033[0m\n"