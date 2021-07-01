include .env

deploy_ec2:
	/bin/bash ./deploy/runner_prod_no_ecr_part1.sh ${remote_ip}
