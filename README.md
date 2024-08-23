# DevOps-af-xtern-pod-a-June2024-SHALI-Terraform

Welcome to this GitHub repository. Follow the instructions below to set up your environment.

### <br>Prerequisites<br/>

Before you begin, ensure you have the following installed:

**i.** [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

**ii.** [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

### <br>Clone the Repository<br/>

In your terminal, clone the **`DevOps-af-xtern-pod-a-June2024-SHALI-Terraform`** 

**`$ git clone DevOps-af-xtern-pod-a-June2024-SHALI-Terraform`**

Navigate to the cloned repository:

**`$ cd DevOps-af-xtern-pod-a-June2024-SHALI-Terraform`**

## GitHub Actions Workflow for Terraform

### Overview
This repository includes a GitHub Actions workflow to manage Terraform deployments across different environments.

### Triggering the Workflow
The workflow is triggered on the following events:
- Push to `main` or feature branches and for any changes in any of the path of the environment.
- Pull requests targeting `main` or feature branches and for any changes in any of the path of the environment.

### Managing the Pipeline

#### Feature Branches
For feature branches:
- Terraform only plans changes to the "prod" and "staging" environments.
- Terraform plans and applies changes to the "sandbox" environment.

#### Main Branch
For the `main` branch:
- Terraform plans changes for production environment.
- Manual approval is required to apply changes to production environments.

### Secure Storage
AWS credentials and other sensitive information are stored securely using GitHub Secrets and properly referenced in the workflow.

### Manual Approval
Changes to production require manual approval.

### <br>Additional Notes<br/>

To deploy your resources, create your feature branch and start working on only the sandbox environment. After your configuration, push your changes to the remote repo. This will trigger the workflow to deploy your configurations to the sandbox environment. If the workflow is successful and your resources are deployed you are good to go.

To promote to staging, copy your configuration from the sandbox environment to the staging environment and push to the remote repo. This will trigger the workflow to deploy to staging environment and if the workflow is successful and your resources deployed, you are good to go.

To promote to production, copy your configuration from the staging environment to the production environment and push to the remote repo and create a pull request. This will trigger the workflow to deploy to production environment and if the pull request is approved and merged and a manual approval is approved, the workflow will deploy your resources to the production environment.

### <br>Troubleshooting<br/>

**i.** Ensure that your Terraform configuration files (**`.tf`** files) are correctly configured for your specific infrastructure needs.

**ii.** Review and understand the Terraform documentation related to the providers and resources you are using in your configuration.

**iii.** If you encounter any errors during initialization or planning, check the error messages for guidance.

**iv.** Ensure that your environment variables and configuration files are correctly set up.

## Terraform Backend Configuration with S3 and DynamoDB

### Overview

This document provides instructions on setting up and configuring Terraform's remote backend using AWS S3 for state file storage and DynamoDB for state locking. This setup ensures centralized management, consistency, and prevents concurrent modifications of the Terraform state file, improving collaboration and reliability in our infrastructure as code processes.

### Step 1: Create an S3 Bucket for Terraform State Files and DynamoDB Table for State Locking

1. **Create the S3 Bucket and DynamoDB Table for State Locking:**
  Three S3 buckets and DynamoDB were created . This is done on a seperate [repo](https://github.com/xterns/DevOps-af-xterns-pod-a-June2024-SHALI-s3-dynamodb.git) using Github actions workflow so as to seperate the backend resources frfom the company's infrastructure for security purposes and will also advise that access to that repo should be authorized by the CTO before anyone can access the backend resourses.

2. **Enable Versioning:**
   Enable versioning on the S3 bucket to keep a history of the state file changes.
   
3. **Set Permissions:**
   Ensure that the S3 bucket and DynamoDB has appropriate permissions to allow Terraform to read and write state files and to create and manage locks respectively. Created an IAM policy having permissions on the bucket and DynamoDB which is attached to a role that will be assumed by terraform to ensure secure access to the S3 bucket and DynamoDB.


### Step 2: Configure Terraform Backend

1. **Update the `backend-providers.tf` in each environment with the below file File:**
   Create or update the `backend.tf` file in your Terraform configuration to use the S3 bucket and DynamoDB table.
   
   ```yaml
        # for providers configurations
      terraform {
        required_providers {
          aws = {
            source  = "hashicorp/aws"
            version = "~> 5.0"
          }
        }
      }

      # Configure the AWS Provider
      provider "aws" {
        region = var.region

        # for assuming a role
        assume_role {
          role_arn = "arn:aws:iam::938106001005:role/afxternpod_a_s3_dynamodb_access"
        }
      }


      # Configure S3 Backend
      terraform {
        backend "s3" {}
      }
   ```
2. **Initialize Terraform:**
   Run `terraform init` to initialize the backend configuration in each environment.

  ```yaml  
        - name: Initialize Terraform
        working-directory: ./Environments/prod
        env:
          TF_VAR_BUCKET: ${{ secrets.TF_VAR_BUCKET_PROD }}
          TF_VAR_KEY: ${{ secrets.TF_VAR_KEY }}
          TF_VAR_REGION: ${{ secrets.TF_VAR_REGION }}
          TF_VAR_DYNAMODB_TABLE: ${{ secrets.TF_VAR_DYNAMODB_TABLE_PROD }}
          TF_VAR_ENCRYPT: ${{ secrets.TF_VAR_ENCRYPT }}
        run: terraform init -backend-config="bucket=${TF_VAR_BUCKET}" -backend-config="key=${TF_VAR_KEY}" -backend-config="region=${TF_VAR_REGION}" -backend-config="dynamodb_table=${TF_VAR_DYNAMODB_TABLE}" -backend-config="encrypt=${TF_VAR_ENCRYPT}"
  ```
  
### Troubleshooting

1. **State Locking Issues:**
   - If Terraform fails to acquire or release a state lock, check the DynamoDB table for any stale locks and remove them if necessary.

2. **Permission Denied Errors:**
   - Ensure that the IAM role or user running the Terraform commands has the necessary permissions to access the S3 bucket and DynamoDB table.
   - Use AWS CLI commands below to verify the identity of the user/role and check the associated policies.
```sh
aws sts get-caller-identity
aws iam simulate-principal-policy --policy-source-arn arn:aws:iam::938106001005:role/afxternpod_a_s3_dynamodb_access --action-names ec2:DescribeVpcAttribute
```

3. **Backend Configuration Errors:**
   - If you encounter issues during `terraform init`, ensure that the S3 bucket and DynamoDB table exist and that the region and credentials are correctly configured.

## Maintaining the CHANGELOG
The CHANGELOG.md file is an essential document that tracks all notable changes made to the project. It helps team members and users understand what has been added, changed, fixed, or removed in each release.

### How to Update the CHANGELOG

1. Before Merging Pull Requests:

- Ensure that the CHANGELOG.md is updated to reflect any relevant changes introduced by your pull request.
- Add new entries under the [Unreleased] section, including the date when the change was made.

2. Sections to Update:

- Added: For new features or functionalities.
- Changed: For changes in existing features or functionalities.
- Deprecated: For features or functionalities that are no longer recommended for use.
- Removed: For features or functionalities that have been removed from the project.
- Fixed: For any bugs or issues that have been resolved.
- Security: For security-related improvements or fixes.

3. Format:

- Use bullet points for each item.
- Be concise but informative; describe what was done and why if necessary.

4. Example:

- Added: Implemented a new feature to automate AMI builds using Packer.
- Fixed: Resolved an issue where SSH configuration did not correctly disable root login.

5. Versioning:

- Once the changes are released, move the [Unreleased] section to a new versioned section, e.g., [1.0.0] - YYYY-MM-DD, and start a new [Unreleased] section.


### Instructions to Implement Slack Notifications for GitHub Actions (Failures Notifications Only)


**1. Create a new slack channel:**

- On the slack workspace, Click on the **`+`** button and create a channel.
- Use the naming convention of the existing POD A and just add a suffix of CI/CD.

**2. Obtain a Webhook URL:**

- Visit the [slack api website](https://api.slack.com/)
- Click on **Your Apps** and click on **create an app**.
- In the dialogue box, select the option that creates the app from scratch.
- Name the app and select the relevant workspace
- On the slack api page, click on incoming webhooks and set it up for the newly created channel.
- Copy the webhook URL

**3. Add the Slack Webhook URL to Github Secrets:**

- Go to your repository settings on GitHub.
- Navigate to Settings > Secrets and variables > Actions.
- Click on **Add a new secret**
- Enter the Secret Name: **`SLACK_WEBHOOK_URL`** and paste the Slack Webhook URL.

**4. Update the Terraform Pipeline:**

- Add steps in the pipeline to notify the team via Slack when a failure occurs on the main branch.
- The **`Notify Slack on Failure`** step is added at the end of both the  **`terraform`** and **`deploy-to-prod`** jobs. It checks if the pipeline has failed and triggers a slack notification.
- The Slack Webhook URL is securely stored in GitHub Secrets and is passed into the environment variables.

**5. Usecase for Step:**

```yaml
#  This step checks if the pipeline has failed and triggers a slack notification.  
      - name: Notify Slack on Failure
        if: failure()  # Ensures the step runs only if previous steps failed
        uses: slackapi/slack-github-action@v1.26.0
        with:
          payload: |
            {
              "text": "❌ Terraform Pipeline failed in repository ${{ github.repository }} on branch ${{ github.ref_name }} (commit: ${{ github.sha }}). View details: ${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}"
            }
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
```

**i.** **Condition to Run Step:**
   -  **`if: failure()`** This condition ensures that this step will only execute if any of the previous steps in the job have failed. If all previous steps succeed, this step will be skipped.

**ii.** **Slack Notification Action:**
   - This line specifies the action to use for sending a Slack notification. The **`slackapi/slack-github-action@v1.26.0`** is a GitHub Action that integrates with Slack's API to send messages to a specified Slack channel.

**iii.** **Slack Message Payload:**

```yaml
with:
  payload: |
    {
      "text": "❌ Terraform Pipeline failed in repository ${{ github.repository }} on branch ${{ github.ref_name }} (commit: ${{ github.sha }}). View details: ${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}"
    }
```

This section defines the content of the Slack message that will be sent if the pipeline fails:
- ${{ github.repository }}: Replaced by the repository name.
- ${{ github.ref_name }}: Replaced by the name of the branch where the failure occurred.
- ${{ github.sha }}: Replaced by the commit SHA that triggered the pipeline.
- ${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}: This generates a URL that links directly to the failed GitHub Actions run, allowing easy access to view details.

**iv.** **Environment Variables**

```yaml
env:
  SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
```

- The **`SLACK_WEBHOOK_URL`** environment variable is needed for the Slack action to send the message to the correct Slack channel.
- **`${{ secrets.SLACK_WEBHOOK_URL }}`**: This is a secret stored in the GitHub repository settings. It contains the URL to the Slack webhook, ensuring that the webhook URL is kept secure and is not exposed in the code.

### TFSEC USE-CASE

Objective:
Ensure that Terraform configurations are secure and compliant with best practices before being deployed to any environment. By integrating TFSec into the CI/CD pipeline, you can automatically scan your Terraform code for vulnerabilities and misconfigurations, categorize issues by severity, and enforce security policies that prevent high-risk changes from being deployed.

In the pipeline, you will see the TFsec Job:
- Automatically scans Terraform code using TFSec.
- Fails the build if any critical or high-severity issues are detected.
- Allows the pipeline to continue but logs and displays medium and low-severity issues.
- Provides a full report of the TFSec scan for further review.

```yaml
   - name: Scan Terraform with TFSec
      run: |
        # Run full TFSec scan and output to JSON file
        tfsec --format=json --out=tfsec-output.json
        
        # Run scan specifically for high and critical issues
        # Fail the pipeline if any are found
        tfsec --severity=high,critical --out=tfsec-severe.json || exit 1
        
        # Run scan for medium and low issues and log them
        tfsec --severity=medium,low --out=tfsec-warnings.json
```
# How to Use It:
Once the the pipeline is Triggered on every push to main  or feature branch

# TFSec Security Scan:
The pipeline checks out the Terraform code and runs TFSec to scan for security issues.
Step 1: A full TFSec scan is performed, and the results are saved to tfsec-output.json.
Step 2: A focused scan checks for high and critical issues. If any are found, the pipeline fails, preventing the merge.
Step 3: A separate scan logs medium and low-severity issues, allowing the pipeline to continue, but ensuring these warnings are visible.
Reviewing the Output:

The complete TFSec scan results are displayed in the pipeline logs (tfsec-output.json).
Critical and high-severity issues are highlighted separately (tfsec-severe.json), ensuring they receive immediate attention.
Developers and security teams can review the output to understand the issues and take necessary action before proceeding with the deployment.


- Ignoring tfsec checks
Let’s pretend that the problem highlighted by tfsec is not that important to us and that it would be okay to ignore it. We can inform it to tfsec by adding a comment at the top of the resource block where this problem exists.

#tfsec:ignore:<check-id>

# OUTPUT_FOR_THE_TF_SCAN
Passed – This is the number of checks that were passed by tfsec, and no action is required to close these gaps.
Ignored – tfsec ignores some checks due to several reasons. It is possible to skip a certain check explicitly, which we will cover in the next section.
Critical, high, medium, low – each tfsec check is associated with a level of severity or impact. Any failed check is counted against the respective severity. In our example, we have encountered a medium severity check.

# How to fix the error
- you will see the resolution result and click on the link provided to see what should work.


## AWS VIRTUAL PRIVATE CLOUD (VPC) RESOURCES

To create the full VPC network recources from local system, cd into each environment (sandbox, staging and prod) to run:

terraform init
terraform plan
terraform apply


**Note: For the github workflow you will not need to do all this, github action will automate that for you.**

Running the above each environment will create vpc resources in sandbox, staging, and prod.

# Terraform Module for AWS VPC

This Terraform module creates a VPC along with subnets, DNS settings, and more in an AWS environment.

## Inputs

| Name                                 | Description                                                                  | Type     | Default | Required |
| -------------------------------      | --------------------------------------------------------------------         | -------- | ------- | -------- |
| `region`                             | AWS region where resources are created.                                      | `string` | n/a     | yes      |
| `vpc_cidr`                           | CIDR block for the VPC. This will depend on the environment chosen.          | `string` | n/a     | yes      |
| `enable_dns_support`                 | Enables DNS support in the VPC.                                              | `bool`   | n/a     | no       |
| `enable_dns_hostnames`               | Enables DNS hostname support in the VPC.                                     | `bool`   | n/a     | no       |
| `access_ip`                          | Represents an IP address or range of IP addresses allowed to access the VPC. | `string` | n/a     | yes      |
| `preferred_number_of_public_subnets` | Number of public subnets to be created in the VPC.                           | `number` | n/a     | yes      |
| `preferred_number_of_private_subnets`| Number of private subnets to be created in the VPC.                          | `number` | n/a     | no       |
| `name`                        | Name to be attached to the resources.                                               | `string` | n/a     | no       |
| `environment`                 | Infrastructure environment (e.g., sandbox, development, production, staging).       | `string` | n/a     | yes      |

## Outputs

# Terraform Module Outputs

This section describes the outputs provided by this Terraform module. These outputs are used to reference the IDs and other attributes of the resources created by the module.

## Outputs

| Name                                      | Description                                                 |
| ----------------------------------------- | ----------------------------------------------------------- |
| `vpc_id`                                  | VPC CIDR needed by other resources.                         |
| `public_subnet-1`                         | The ID of the first public subnet.                          |
| `public_subnet-2`                         | The ID of the second public subnet.                         |
| `private_subnet-1`                        | The ID of the first private subnet.                         |
| `private_subnet-2`                        | The ID of the second private subnet.                        |
| `public_subnet_ids`                       | The IDs of all public subnets.                              |
| `private_subnet_ids`                      | The IDs of all private subnets.                             |
| `internet_gateway_id`                     | The ID of the Internet Gateway.                             |
| `nat_eip_id`                              | The ID of the Elastic IP for the NAT Gateway.               |
| `nat_gateway_id`                          | The ID of the NAT Gateway.                                  |
| `private_route_table_id`                  | The ID of the private route table.                          |
| `public_route_table_id`                   | The ID of the public route table.                           |
| `public_route_table_association_ids`      | The IDs of the public route table associations.             |
| `private_route_table_association_ids`     | The IDs of the private route table associations.            |
| `availability_zones`                      | The availability zones used for the subnets.                |
| `aws_security_group-id`                   | The ID of the default security group.                       |

Enough output have been created in vpc/outputs for your reference

###  References
- terraform setup - https://github.com/marketplace/actions/hashicorp-setup-terraform
- Consult the [Terraform documentation](https://developer.hashicorp.com/terraform/docs) for additional help and resources.
- For [manual approval](https://github.com/trstringer/manual-approval)
- [Workflow syntax for GitHub Actions](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_idenvironment)
- [GitHub Actions documentation](https://docs.github.com/en/actions)
- https://developer.hashicorp.com/terraform/cli/commands/init
- https://www.youtube.com/watch?v=YcfWKy8YiLo
- slack notification https://www.youtube.com/watch?v=hzIub2noFw8
- slack notification https://github.com/marketplace/actions/slack-send
- slack notification https://api.slack.com/apps
- slack notification https://api.slack.com/apps/A07GG5DKYPM/incoming-webhooks?success=1
