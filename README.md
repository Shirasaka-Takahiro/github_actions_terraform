README.md
■Set-Up
1. Create S3 for tfstate
2. Generate public and private key

■Resources
<br />
Network
<br />
EC2
<br />
ALb x 1(HTTP Listener)

■Deploy
1. Move to direstory
2. terraform init
3. terraform plan
4. terraform apply

■Properties
1. This is including GitHub Actions
2. terraform plan will be executing when marging dev branch into main one by using GitHub Actions
3. terraform apply will be executing when marging dev branch into main one by using GitHub Actions
4. Run workflow manually on the page of Github Actions