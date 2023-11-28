public class YoutubeDataAPIController {    
    public static String getAPIKey(){
        String API_Key = [SELECT Label,API_Key__c FROM API_Key__mdt WHERE Label = 'Youtube Data API Key'].API_Key__c;
        return API_Key;
    }
    
    @AuraEnabled
    public static List<YoutubeDataAPIController.SearchResource> searchKeyResults(String searchString,String channelId,Integer maxResults,String order){
        String apiKey = getAPIKey();
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = null;
        String searchURL = 'https://www.googleapis.com/youtube/v3/search';
        String endpointString = searchURL + 
            '?part=snippet' +
            '&channelId=' + channelId + 
            '&maxResults=' + maxResults + 
            '&order=' + order +
            '&q='+ EncodingUtil.urlEncode(searchString,'UTF-8') +
            '&type=video'+
            '&key=' + apiKey;    
        System.debug('API Endpoint : ' + endpointString);
        req.setEndpoint(endpointString);
        req.setMethod('GET');
        res = http.send(req);
        String response = res.getBody();
        System.JSONParser parser = JSON.createParser(response);
        List<SearchResource> resources = new List<SearchResource>();
        Boolean loopContinuation = true;
        while(parser.nextToken() != null && loopContinuation == true){
            if(parser.getText() == 'items'){
                if(parser.nextToken() == JSONToken.START_ARRAY){
                    resources = (List<SearchResource>)parser.readValueAs(List<SearchResource>.class);
                    parser.skipChildren();
                    loopContinuation = false;
                }
            }
        }
        System.debug('SearchResource resources : ' + resources);
        System.debug('HttpResponse response : ' + response);
        return resources;
    }
    
    public class SearchResource{
        @AuraEnabled
        public String kind;
        @AuraEnabled
        public String etag;
        @AuraEnabled
        public YoutubeDataAPIController.VideoIdentity id;
        @AuraEnabled
        public YoutubeDataAPIController.Snippet snippet;
    }

    public class VideoIdentity{
        @AuraEnabled
        public String type;
        @AuraEnabled
        public String videoId;
        
        public VideoIdentity(String type,String videoId){
            this.type = type;
            this.videoId = videoId;
        }
    }

    public class Snippet{
        @AuraEnabled
        public String publishedAt;
        @AuraEnabled
        public String channelId;
        @AuraEnabled
        public String title;
        @AuraEnabled
        public String description;
        @AuraEnabled
        public YoutubeDataAPIController.thumbnails thumbnails;
        public String channelTitle;
    }

    public class thumbnails{
        @AuraEnabled
        public Thumbnail medium;
        @AuraEnabled
        public Thumbnail high;
    }

    public class Thumbnail{
        @AuraEnabled
        public String url;
        @AuraEnabled
        public Integer width;
        @AuraEnabled
        public Integer height;
        
        public Thumbnail(String url,Integer width,Integer height){
            this.url = url;
            this.width = width;
            this.height = height;
        }
    } 
}