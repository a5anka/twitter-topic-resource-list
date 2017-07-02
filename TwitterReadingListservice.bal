import ballerina.net.http;
import org.wso2.ballerina.connectors.oauth2;
import ballerina.lang.messages;
import ballerina.lang.jsons;
import ballerina.net.uri;

const string BEARER_TOKEN = "Enter your bearer token here";

@http:config { basePath: "/twitter-reading-list"}
service<http> TwitterReadingListService {

    oauth2:ClientConnector tweeterEP = create oauth2:ClientConnector("https://api.twitter.com",
                                                                     BEARER_TOKEN,
                                                                     "null","null","null","null");
    @http:GET {}
    @http:Path {value:"/"}
    resource myEchoResource (message m, @http:QueryParam {value:"q"} string query) {

        string tweetSearchPath = "/1.1/search/tweets.json?count=50&&q=" + uri:encode(query);
        message request = {};

        message searchResponse = oauth2:ClientConnector.get(tweeterEP, tweetSearchPath, request);

        json jsonSearchResponse = messages:getJsonPayload(searchResponse);

        int resultCount = jsons:getInt(jsonSearchResponse, "$.statuses.length()");
        UrlResult[] results = [];
        int i = 0;
        int k = 0;
        while (i < resultCount) {
            int retweetCount = jsons:getInt(jsonSearchResponse.statuses[i], "$.retweet_count");
            int urlCount = jsons:getInt(jsonSearchResponse.statuses[i], "$.entities.urls.length()");

            int j = 0;
            json urls = jsonSearchResponse.statuses[i].entities.urls;
            while (j < urlCount) {
                json url = urls[j].expanded_url;
                results[k] = {};
                results[k].url = jsons:getString(urls[j],"$.expanded_url");
                results[k].score = retweetCount;
                j = j + 1;
                k = k +1;
            }

            i = i + 1;
        }

        json responseJson = [];

        createResponse(k, responseJson, results);

        message response = {};
        messages:setJsonPayload(response, responseJson);

        messages:setHeader(response, "Access-Control-Allow-Origin","*");
        reply response;
    }
}

function createResponse(int resultCount, json responseJson, UrlResult[] results) {
    int i = 0;
    while (i < resultCount) {
        json j5 = {url:results[i].url,score:results[i].score};
        jsons:addToArray(responseJson, "$", j5);
        i = i + 1;
    }
}

struct UrlResult {
    int score;
    string url;
}

