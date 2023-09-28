
* Terraform stores the state of the infrastructure it manages in a file called terraform.tfstate by default. This file contains sensitive information such as IP addresses, credentials, and keys, so it is important to avoid uploading it to GitHub or any CI/CD tool. However, this can make it difficult to collaborate with team members on the same Terraform files, since they all need the most up-to-date state file to avoid conflicts.

* One solution to this problem is to use a remote backend. This allows Terraform to control the state file remotely, storing it in a secure location and keeping it up-to-date for all team members. Terraform has its own remote backend platform called Terraform Cloud, but you can also create your own using AWS S3 and DynamoDB.

* We will create a Terraform remote backend to store our state file on cloud. We will create an S3 bucket to store the state file and a DynamoDB table to create a locking mechanism. We will then configure Terraform to use these resources to manage the state of our infrastructure.


*** Create S3 Bucket :**

While creating the S3 bucket we need to select the options as below

*  Block all public access: True
*  Enable bucket versioning: True
*  Enable default encryption: True

  ![image](https://github.com/Vicky2KR/Terraform/assets/115537512/01feefae-6105-4cf6-aed1-706feaca09cc)

  ![image](https://github.com/Vicky2KR/Terraform/assets/115537512/0c69117b-bf23-4020-bd23-be97b33d471e)

  ![image](https://github.com/Vicky2KR/Terraform/assets/115537512/fb94b4ea-fcef-4404-b225-7a4fba3d680e)

  ![image](https://github.com/Vicky2KR/Terraform/assets/115537512/269292ee-0c93-40fc-bb6d-ebb57cb0867b)

* We need to attach a bucket policy to allow Terraform GetObject, Putbject, and ListBucket actions.

* We also have to make sure the bucket cannot be deleted, so we need to deny DeleteBucket actions.

The path where we store the key is /terraform.tfstate.

Go to Permissions -> Bucket Policy -> Edit and create a new policy with the Policy generator.

Copy and  paste the below generated policy in the policy section and save.

```
{
  "Id": "Policy1695922264413",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1695922243120",
      "Action": [
        "s3:DeleteObject",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::bucket-name",
        "arn:aws:s3:::bucket-name/keyname"
      ],
      "Principal": {
        "AWS": [
          "arn:aws:iam::<acc>:user/user"
        ]
      }
    },
    {
      "Sid": "Stmt1695922261616",
      "Action": [
        "s3:DeleteBucket"
      ],
      "Effect": "Deny",
      "Resource": "arn:aws:s3:::bucket-name",
      "Principal": "*"
    }
  ]
}

```

* To avoid multiple resources making changes on the same repo at same time, we can use a DynamoDB table as a locking mechanism, so only one user can make changes to the state file at any given time.

We need to name the Partition key as  “LockID” (It needs to be this exact name)
* Read/Write capacity settings: On-demand
* Deletion protection: True

The name of the table is **tf_state_lock**

  ![image](https://github.com/Vicky2KR/Terraform/assets/115537512/45e929a5-40d6-4dfe-9b00-c2ce2430d4a3)

  ![image](https://github.com/Vicky2KR/Terraform/assets/115537512/dbbc9d1a-3b30-45ab-a6b1-4bd333697851)

  ![image](https://github.com/Vicky2KR/Terraform/assets/115537512/98699fd0-53f5-43e0-a6a4-90500d2f7499)

  ![image](https://github.com/Vicky2KR/Terraform/assets/115537512/fcc170f4-81cd-4482-9cdd-a2cf13ead779)

  ![image](https://github.com/Vicky2KR/Terraform/assets/115537512/0f98ede0-6dea-4ad6-ba3c-d47e490d24c9)


  Add the below code to the main.tf file  to configure the backend.
```
  terraform{
     backend "s3" {
    bucket         = "terra-buc"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf_state_lock"
    encrypt        = true
  }
} 
```
**Lets run terraform init with backend configuration.**

terraform init -backend-config="access_key=<access-key>" -backend config="secret_key=<secret-key-value>" -backend-config="region=us-east-1 "

<img width="509" alt="image" src="https://github.com/Vicky2KR/Terraform/assets/115537512/411e599f-bb76-4c3d-b672-38bddbe35d1d">

Run **terraform apply** to initiate the state and test the backend.

<img width="617" alt="image" src="https://github.com/Vicky2KR/Terraform/assets/115537512/ff03b61f-1022-4fca-bd0a-562b6d0ed24e">

We have successfully configured a remote backend for our Terraform application infrastructure :).

<img width="779" alt="image" src="https://github.com/Vicky2KR/Terraform/assets/115537512/54780629-2ae4-40a8-a156-bd1985ce2ac7">


<img width="725" alt="image" src="https://github.com/Vicky2KR/Terraform/assets/115537512/0e756ac9-9db9-48ac-aee2-c000c58c1ea1">





  







