# Dice Service

> This repository includes an example of a service that rolls a dice written in
> [Winglang](https://winglang.io).

## Development

### Setup

1. Install [Wing](https://www.winglang.io/docs/start-here/installation).
1. Install [Wing VSCode Extension](https://marketplace.visualstudio.com/items?itemName=Monada.vscode-wing).
1. Clone the repo

### Run

Open the Wing Console:

```sh
wing it main.w
```

You should see the service:

![](./images/map.png)

Now, you can interact with the API through the interaction panel:

![](./images/api.png)

### Test

Tests are all under the `tests.w` file:

> Currently they can't be in the same file as the main app

Run tests from terminal:

```sh
wing test tests.w
...
 
Tests 6 passed (6)
Test Files 1 passed (1)
Duration 0m2.44s
```

Run tests on AWS (you'll need AWS credentials on your machine):

```sh
wing test -t tf-aws tests.w
```

![](./images/cloud-test.png)

Run tests from the Wing Console UI:

```sh
wing it tests.w
```

And click "Run all":

![](./images/tests.png)

### Deploy

Compile to Terraform/AWS:

```sh
wing compile -t tf-aws main.w
```

You'll need AWS credentials on your machine and then:

```sh
cd target/main.tfaws
terraform init
terraform apply
```

## Instructions

Build a backend micro-service that rolls a die and returns the result. 

### Initial requirements:
- [x] The application must have an REST API that accepts an HTTP POST only. The request must have a
  required parameter called name that has to be between 2 and 30 characters long.
- [x] The dice have 6 sides and is rolled fairly. The service will return the value in diceRoll, along
  with a 200 http status request. The function must log the dice roll.
- [x] The function must have an environment variable called chanceOfFailure, with a value from 0 to 100.
  The function must throw an error for this percentage of invocations. In this case, it returns an
  error code in the http response and does not return a dice roll. The function must log the error.
- [x] You can choose to work in any runtime.
- [ ] Connect Amazon CodeWhisperer to your IDE.

### Testing:
- [x] Use Postman to test your endpoint. It must support 20 requests per second for 60 seconds.
- [ ] Use the console to show the successful and failed invocations.
- [ ] Use CloudWatch Insights to query the results of your test.

### Do & Don'ts
- [ ] Use CodeWhisperer, but not ChatGPT or Copilot
- [ ] Check out Serverless Land, Stack Overflow, re:Post and other resources
- [ ] Be prepared to commit your code to a Git repository at the end of the session
- [x] Use the IDE of your choice (e.g., VS Code, JetBrains, IntelliJ)

### Additional requirements:
- [ ] Save the microservice to a code repository expressed using your preferred IaC framework (e.g.,
      SAM, CDK, Serverless Framework, Terraform).
- [ ] Store every result in DynamoDB, including both the name and the dice roll value.
- [ ] Create a GET API endpoint that takes name and rolls as query parameters and returns most recent
      number of dice rolls.
- [ ] Convert the API Gateway endpoint from a REST API to an HTTP API.
- [ ] Redeploy the micro-service to a second region and run the same test above.
- [ ] Replace your RNG with a secure random number generator package in your runtime. Create a
      Lambda layer with this package and have your function use the layer. Make the layer publicly
      accessible.
- [ ] Make the service idempotent (the caller will provide the idempotency ID).
- [ ] Write the output of each function to a file in an EFS mount.

## License

Apache 2.0