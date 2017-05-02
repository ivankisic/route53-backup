#!/bin/bash

date=$(date)
zone_path=/your/path/file.zone

for i in $(aws route53 list-hosted-zones | grep Id | awk '{print $2}' | cut -d\/ -f3 | cut -d\" -f1); do aws route53 list-resource-record-sets --hosted-zone-id $i; done > $zone_path

# setup git before running

git add $zone_path
git commit -m "$date - AWS route53 all zones backup" > /dev/null 2>&1
git push > /dev/null 2>&1
	if [[ $? -ne 0 ]]; then
		echo AWS route53 backup on $HOSTNAME failed, nothing was pushed to git. Try pushing it manually from $zone_path | mail -s "AWS route53 git push failed" name@example.com
		exit 1
	fi
exit 0
