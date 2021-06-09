# terraform AWS - EC2 with Nginx - go-web

# Before install
    1 - You need install terraform, please follow official documentation: https://learn.hashicorp.com/terraform/getting-started/install.html

    2 - You need install "aws cli" and credentials configured in you enviremonts, please follow official documentation: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html

    3 - You need have ec2-key-pair to have ssh access in webserver, please follow official documentation: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html


# Run the project

    1 - Check plan project:
        terrform plan

    2 - Do deploy project:
        terraform apply

# Destroy the project
    terraform destroy