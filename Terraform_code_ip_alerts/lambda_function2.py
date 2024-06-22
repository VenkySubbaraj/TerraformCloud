import boto3
import os
import ipaddress

# Set the threshold for IP usage percentage
IP_USAGE_THRESHOLD = 0.6

def lambda_handler(event, context):
    ec2_client = boto3.client('ec2')
    sns_client = boto3.client('sns')
    cloudwatch_client = boto3.client('cloudwatch')

    try:
        vpc_id = os.environ['vpc_id']
        sns_topic_arn = os.environ['sns_topic_arn']
    except KeyError as e:
        print(f"Missing environment variable: {str(e)}")
        return {
            'statusCode': 500,
            'body': f"Missing environment variable: {str(e)}"
        }

    alerts = []
    region = ec2_client.meta.region_name  # Retrieve the current AWS region

    # Fetch the subnets for the specified VPC
    subnets = ec2_client.describe_subnets(Filters=[{'Name': 'vpc-id', 'Values': [vpc_id]}])['Subnets']

    for subnet in subnets:
        subnet_id = subnet['SubnetId']
        cidr_block = subnet['CidrBlock']
        available_ips = subnet['AvailableIpAddressCount']
        total_ips = ipaddress.IPv4Network(cidr_block).num_addresses
        used_ips = total_ips - available_ips
        ip_usage_percentage = (used_ips / total_ips) * 100

        print(f"Subnet ID: {subnet_id}")
        print(f"CIDR Block: {cidr_block}")
        print(f"Total IP Addresses: {total_ips}")
        print(f"Used IP Addresses: {used_ips}")
        print(f"Available IP Addresses: {available_ips}")
        print(f"IP Usage Percentage: {ip_usage_percentage:.2f}%")

        # Publish custom metrics to CloudWatch
        cloudwatch_client.put_metric_data(
            Namespace='SubnetIPUsage2',
            MetricData=[
                {
                    'MetricName': 'IPUsagePercentage1',
                    'Dimensions': [
                        {
                            'Name': 'SubnetId',
                            'Value': subnet_id
                        },
                        {
                            'Name': 'CidrBlock',
                            'Value': cidr_block
                        }
                    ],
                    'Value': ip_usage_percentage,
                    'Unit': 'Percent'
                }
            ]
        )

        # Check the IP usage percentage and update the alarm state accordingly
        alarm_name = f"IPUsageAlarm-{subnet_id}"

        if ip_usage_percentage > IP_USAGE_THRESHOLD:
            cluster_name = subnet['AvailabilityZone']  # Retrieve the Availability Zone (cluster) for the subnet
            alert_message = f"Alert: IP usage percentage for Subnet {subnet_id} in Region {region} is {ip_usage_percentage:.2f}%, which is higher than the threshold of {IP_USAGE_THRESHOLD}%."
            alerts.append(alert_message)

            cloudwatch_client.set_alarm_state(
                AlarmName=alarm_name,
                StateValue='ALARM',
                StateReason='IP usage percentage exceeded the threshold'
            )
        else:
            cloudwatch_client.set_alarm_state(
                AlarmName=alarm_name,
                StateValue='OK',
                StateReason='IP usage percentage is below the threshold'
            )

        print("-" * 80)  # Separator for better readability


    return {
        'statusCode': 200,
        'body': 'IP address check completed'
    }