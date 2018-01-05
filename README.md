# GifPicker
An easy Swift library for accessing and using GIFs from the web and the user's library

# Quick Use

To access the Giphy API, you'll need to get a key from Giphy

Once you've gotten your key:

`GifManager.shared.APIKey = "YOUR_API_KEY"`

To get Trending Giphy GIFS:

    GifManager.shared.fetchTrendingGifs { (gifs) in
            //Returns trending Gifs
            //Can also be accessed via GifManager.shared.trendingGifs
    }

To perform a search for GIFS:

    GifManager.shared.searchGifs(search: "yourSearchHere") { (gifs) in
            //Returns GIFs that match the search query from Giphy
            //Results also be accessed via GifManager.shared.searchGifs
    }

Each search is limited to 50 results.  

To get the next page of search results:

    GifManager.shared.searchNextPage { (gifs, exhuasted) in
        //gifs = the next 50 gifs, appended to GifManager.shared.searchGifs            
        //exhausted is a Bool that returns true if there's no more GIFs to fetch for the searchQuery
    }
    
A individual Gif is returned as a `GifAsset` which returns a URL for the original GIF using `URL`, and one to display as a thumbnail under `thumbURL`.  Download the contents into a Data object then display them in a UIImage.

# Coming Soon:

* More flexibility in editing Search options 
* A better way to download the actual GIFs from GifAssets
* Easy access to GIFs in the Users Camera Roll
* A GifPickerViewController that quickly and simply interfaces the entire model

# Contact Me

If you have a personal request for a change, contact me!  hello@robcaraway.com
    
