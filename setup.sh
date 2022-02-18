#!/bin/bash
echo "Creating User Pool"
USERNAME=user1
PASSWORD=password1
USER_POOL_ID=$( aws --endpoint-url=http://localhost:4566 cognito-idp create-user-pool \
    --pool-name test \
    --cli-input-json file://create-user-pool.json | jq -r '.UserPool.Id' )
echo "User Pool Created: ${USER_POOL_ID}"

echo "Creating User Pool Client"
CLIENT_ID=$( aws --endpoint-url=http://localhost:4566 cognito-idp create-user-pool-client \
--user-pool-id "$USER_POOL_ID" \
--client-name client \
--explicit-auth-flows ALLOW_USER_PASSWORD_AUTH | jq -r '.UserPoolClient.ClientId')
echo "User Pool Created: ${CLIENT_ID}"

echo "Sign Up User: user1/password1"
aws --endpoint-url=http://localhost:4566 cognito-idp sign-up \
    --client-id "$CLIENT_ID" \
    --username "$USERNAME" \
    --password "$PASSWORD" && echo "Sign Up Success" || echo "Failed to Sign Up"

echo "Please enter confirmation code printed in terminal with 'localstack start' and hit Enter:"
read CONFIRMATION_CODE

aws --endpoint-url=http://localhost:4566 cognito-idp confirm-sign-up \
    --client-id "$CLIENT_ID" \
    --username "$USERNAME" \
    --confirmation-code "$CONFIRMATION_CODE" && echo "User Confirmed" || echo "Unable to confirm"

echo "Authenticating User"
ID_TOKEN=$( aws --endpoint-url=http://localhost:4566 cognito-idp initiate-auth \
    --auth-flow USER_PASSWORD_AUTH \
    --client-id "$CLIENT_ID" \
    --auth-parameters USERNAME="$USERNAME",PASSWORD="$PASSWORD" | jq -r '.AuthenticationResult.IdToken' )

echo "Validating ID TOKEN"
node localstack.js "$ID_TOKEN"
