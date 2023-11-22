import { LightningElement, api } from 'lwc';
import searchKeyResults from '@salesforce/apex/YoutubeDataAPIController.searchKeyResults';

export default class YoutubeDataAPIComponent extends LightningElement {
    columns = [
        {
            label: 'Thumbnail',
            fieldName: 'thumbnail',
            type: 'image',
            cellAttributes: {
                alignment: 'center'
            }
        },
        {
            label: 'Video Title',
            fieldName: 'urlLink',
            type: 'url',
            typeAttributes: {
                label: {
                    fieldName: 'videoTitle'
                },
                target: '_blank'
            },
            wrapText: true
        },
        {
            label: 'Video Description',
            fieldName: 'videoDescription',
            type: 'text',
            wrapText: true
        }
    ]

    get orderOptions() {
        return [
            { label: 'Date', value: 'date' },
            { label: 'Rating', value: 'rating' },
            { label: 'Relevance', value: 'relevance' },
            { label: 'Title', value: 'title' },
            { label: 'Video Count', value: 'videoCount' },
            { label: 'View Count', value: 'viewCount' }
        ]
    }

    searchResults = [];
    searchString;
    channelId;
    maxResults;
    order;
    tableData;

    connectedCallback(){
        document.title = 'Youtube Data API Integration Project'
        this.channelId = ''
    }

    getSearchKeyResults() {
        Promise.resolve().then(() => {
            this.searchResults = [];
            return searchKeyResults({
                searchString: this.searchString,
                channelId: this.channelId,
                maxResults: this.maxResults,
                order: this.order
            })
        }).then((result) => {
            console.log('SearchResource results : ', JSON.parse(JSON.stringify(result)));
            this.tableData = JSON.parse(JSON.stringify(result)).map(video => {
                return {
                    thumbnail: video.snippet.thumbnails.high.url,
                    urlLink: "https://www.youtube.com/watch?v=" + video.id.videoId,
                    videoTitle: video.snippet.title,
                    videoDescription: video.snippet.description
                }
            })
            console.log('tableData: ',JSON.parse(JSON.stringify(this.tableData)));
        }).catch((error) => {
            console.log('error : ',JSON.parse(JSON.stringify(error)));
        })
    }

    handleChannelIdChange(event){
        this.channelId = event.detail.value;
        console.log('channelId : ',this.channelId);
    }

    handleMaxResultsChange(event){
        this.maxResults = event.detail.value;
        console.log('maxResults : ',this.maxResults);
    }

    handleSearchStringChange(event){
        this.searchString = event.detail.value;
        console.log('searchString : ',this.searchString);
    }
    
    handleOrderChange(event){
        this.order = event.detail.value;
        console.log('order : ',this.order);
    }
}