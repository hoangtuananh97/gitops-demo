"""This script stop and start aws resources."""
import os
from distutils.util import strtobool

from ecs_handler import EcsScheduler
from instance_handler import InstanceScheduler
from rds_handler import RdsScheduler


def lambda_handler(event, context):
    """Main function entrypoint for lambda.

    Stop and start AWS resources:
    - rds instances
    - rds aurora clusters
    - instance ec2
    - ecs services

    Terminate spot instances (spot instance cannot be stopped by a user)
    """
    # Retrieve variables from aws lambda ENVIRONMENT
    schedule_action = event.get("schedule_action")
    aws_regions = event.get("aws_regions", "").replace(" ", "").split(",")
    tags_web_instance = event.get("tags_web_instance")
    tags_rds = event.get("tags_rds")
    tags_ecs = event.get("tags_ecs")

    _strategy = {
        InstanceScheduler: tags_web_instance,
        EcsScheduler: tags_ecs,
        RdsScheduler: tags_rds,
    }

    for service, tags in _strategy.items():
        if tags:
            key, val = tags.popitem()
            format_tags = [{"Key": key, "Values": [val]}]
            for aws_region in aws_regions:
                strategy = service(aws_region)
                getattr(strategy, schedule_action)(aws_tags=format_tags)
