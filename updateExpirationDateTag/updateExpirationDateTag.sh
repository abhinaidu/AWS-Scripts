#!/bin/bash
set -e
# Variables 
PROFILE=default # set the AWS profile name, defaults to default
REGIONS='*' # if set to *, looks up in all region, otherwise provide a comma separated list of regions without space. Eg: us-east-1,eu-west-1
OWNER_NAME=john.doe # please provide your owner name
DAYS_TO_UPDATE=5 # the number of days forward to update the ExpirationDate tag to.
DAYS_TO_EXPIRY=3 # the number of days untill expiry

GREEN='\033[0;32m' #Green color
NC='\033[0m' #  No Color
BLUE='\033[0;34m' #Blue color
RED='\033[0;31m' #Red color
BROWN='\033[0;33m' #Purple color

aws_regions=($(aws ec2 describe-regions --filters "Name=region-name,Values=$REGIONS" | jq -r '.Regions[] .RegionName'))
current_time=$(date +%s) #converting the current date to UNIX epoch format
for region in ${aws_regions[@]}
do
	#Get the Instance id
	instance_ids=($(aws ec2 describe-instances --filter "Name=tag-value,Values=$OWNER_NAME" --region $region --profile $PROFILE | jq -r '.Reservations[] .Instances[] .InstanceId'))
	for instance_id in ${instance_ids[@]}
	do
		#Get the expiration date for the instance in UNIX epoch format
		current_expiration_time=$(date -d $(aws ec2 describe-tags --filters "Name=resource-id, Values=$instance_id" --region $region --profile $PROFILE | jq -r '.Tags[] | select(.Key =="ExpirationDate") .Value') +%s)
		#get the instance name
		instance_name=$(aws ec2 describe-tags --filters "Name=resource-id, Values=$instance_id" --region $region --profile $PROFILE | jq -r '.Tags[] | select(.Key == "Name") .Value')
		#Checking whetehr the date is nearing expiration
		if [ "$(((current_expiration_time-current_time)/86400))" -le "$DAYS_TO_EXPIRY" ]; then
			#Deleting the current ExpirationDate tag
			aws ec2 delete-tags --resource $instance_id --tags Key='ExpirationDate' --region $region --profile $PROFILE
			#Calculating the new expiration date
			new_exp_date=$(date -d @$(($current_time+86400*$DAYS_TO_UPDATE)) +%Y-%m-%d)
			echo -e "Updating the ${BROWN}ExpirationDate${NC} tag of instance with id: ${GREEN}$instance_id${NC}, with name: ${GREEN}$instance_name${NC} in region ${BLUE}$region${NC} to ${RED}$new_exp_date${NC}"
			#Updating the ExpirationDate tag
			aws ec2 create-tags --resource $instance_id --tags Key=ExpirationDate,Value=$new_exp_date --region $region --profile $PROFILE
		fi
	done
done