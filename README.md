# Youtube Data API v3 Integration Simple Project

![Showcase](README_Materials/YoutubeAPIIntegration.gif)

ChannelId is optional - if to search within a specific youtube channel

- In Google Cloud Console, create a new project or use a existing one
- In API and Services -> Credentials -> CREATE CREDENTIALS -> API Key<br/>
![](README_Materials\API_key_generation.PNG)
- Edit API Key and restrict API Key to Youtube Data API v3<br/>
![](README_Materials\api_key_restriction.PNG)

- Create a new custom metadata type `API Key` and create a new record labelling it `Youtube Data API Key`.
![](README_Materials\Youtube_Data_API_Key.PNG)

- In `Remote Site Settings` in Setup, add `https://www.googleapis.com` to the list of websites allowed to be invoked from your org
![](README_Materials\remote_site_details.PNG)

- Create Apex class and LWC to make calls to API and display the data.

In this project - we are only making a call to `https://www.googleapis.com/youtube/v3/search`<br/>
[Reference](https://developers.google.com/youtube/v3/docs/search)