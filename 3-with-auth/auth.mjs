export const handler = async (event) => {
  console.log(`event:${JSON.stringify(event)}`)

  const token = event['authorizationToken']

  console.log(`token:${JSON.stringify(token)}`)

  let permission = 'Deny'
  if (token === 'my-secret-token') {
    permission = 'Allow'
  }

  const response = {
    principalId: 'abc123',
    policyDocument: {
      Version: '2012-10-17',
      Statement: [
        {
          Action: 'execute-api:Invoke',
          Resource: [
            'arn:aws:execute-api:eu-west-2:503447358475:*/*/*/*',
            // 'arn:aws:execute-api:YOUR_AWS_REGION:YOURACCOUNTNUMBER:YOUR_API_IDENTIFIER/STAGEING_ENV/VERB/RESOURCE',
          ],
          Effect: `${permission}`,
        },
      ],
    },
  }
  return response
}
