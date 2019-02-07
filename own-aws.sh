#!/bin/bash
# Taken from here: https://twitter.com/ustayready/status/1092945968197132288

USER="lols"
GROUP="lolsgroup"
PASSWORD="Doe@deer@femaleDeer123!"
POLICY="lolicy"
ACCOUNTALIAS="alphabetagammadongs"

aws iam create-user --user-name ${USER}
aws iam create-access-key --user-name ${USER}
aws iam create-group --group-name ${GROUP}
aws iam put-group-policy --group-name ${GROUP} --policy-name ${POLICY} --policy-document '{"Version":"2012-10-17", "Statement": [{"Sid": "Stmt1437414476731", "Action": "*", "Effect": "Allow", "Resource": "*" }]}'
aws iam add-user-to-group --group-name ${GROUP} --user-name ${USER}
aws iam create-login-profile --user-name ${USER} --password "${PASSWORD}"
aws iam create-account-alias --account-alias ${ACCOUNTALIAS}


echo "All done."
echo "Login here: https://${ACCOUNTALIAS}.signin.aws.amazon.com/console/"