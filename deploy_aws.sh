export ORG_GRADLE_PROJECT_ARCHIVECLASSIFIER="aws"
./gradlew clean
./gradlew build
aws iam create-role \
    --role-name function-sample-aws-role-01 \
    --assume-role-policy-document file://aws/assume_role_policy_document.json \
    > aws/log-create-role.json
aws iam put-role-policy \
    --role-name function-sample-aws-role-01 \
    --policy-name function-sample-aws-policy-01 \
    --policy-document file://aws/lambda_execute_policy.json \
    > aws/log-put-role-policy.json
sleep 30
aws lambda create-function \
    --function-name function-sample-aws-lambda-01 \
    --runtime java17 \
    --role "arn:aws:iam::${AWS_ACCOUNT_ID}:role/function-sample-aws-role-01" \
    --handler "org.springframework.cloud.function.adapter.aws.FunctionInvoker::handleRequest" \
    --zip-file fileb://build/libs/demo-function-0.0.1-SNAPSHOT-aws.jar \
    --timeout 30 \
    --memory-size 512 \
    > aws/log-create-function.json