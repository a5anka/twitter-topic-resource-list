## Running the Application

1. Open the TwitterReadingListservice.bal file and change `BEARER_TOKEN` 
constant to mach the bearer token you have. If You don't have a beared 
token, you can read the twitter api reference on 
(Application-only authentication)[https://dev.twitter.com/oauth/application-only] 
to get a bearer token.

2. Use the follwoing command to run the backend service
 
```
$ ballerina run service TwitterReadingListservice.bal
```

3. Open the `index.html` file on a web browser to generate resource list for a topic.
