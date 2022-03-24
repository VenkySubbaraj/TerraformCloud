aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/e3n8w8r2
docker tag publicrepo:latest public.ecr.aws/e3n8w8r2/publicrepo:latest
docker push public.ecr.aws/e3n8w8r2/publicrepo:latest
