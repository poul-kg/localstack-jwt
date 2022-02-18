## Problem with 0.14.0
* `npm install`
* `LOCALSTACK_API_KEY=YOUR_KEY SERVICES=cognito-idp,iam,lambda,cloudformation,s3,s3api,sts DISABLE_CORS_CHECKS=1 localstack start`
* run `./setup.sh`
* script will ask for confirmation code, enter it
* script will output `!!! ERROR: invalid signature`

## Works with 0.11.5
* stop localstack
* `LOCALSTACK_API_KEY=YOUR_KEY SERVICES=cognito-idp,iam,lambda,cloudformation,s3,s3api,sts DISABLE_CORS_CHECKS=1 localstack start`
* run `./setup.sh`
* script will ask for confirmation code, enter it
* script will output `!!! JWT is valid`
