//
//  GifManager.swift
//  GifPicker ViewController
//
//  Created by Robert Caraway on 12/22/17.
//  Copyright © 2017 Rob Caraway. All rights reserved.
//

import Foundation
import Photos


/*
 GifManager: use the singleton of this class to manage and retrieve all of your GIFs.
 Class required to manage references.
 */
open class GifManager: NSObject {

    
    //GIFs that represent the current trending GIFs from the Giphy API
    public private(set) var trendingGifs:[GifAsset] = []
    
    //The current GIFS fetched from the latest search
    public private(set) var searchGifs:[GifAsset] = []
    
    //GIFs fetched from the users Photos Library
    public private(set) var libraryGifs:[GifAsset] = []
    
    //Giphy API Key: REQUIRED TO USE THIS API
    public var APIKey:String = ""
    
    //Serial queue used to safely call all background GIF activities
    private let queue = DispatchQueue(label:"gifQueue")
    
    //Used to manage paging, index, search queries required for searching.
    public private(set) var searchSession:GifSearchSession?
    
    
    /* Only one instance of GifManager is allowed to exist to enforce
      strict reference type management */
    static let shared:GifManager = GifManager()
    private override init() {}
    
    
    //MARK: trending
    
    
    /*
        fetchTrendingGifs
        Access the current most popular Gifs from GIPHYs Library.
        Great to keep your GIF content fresh.
     */
    public func fetchTrendingGifs(completion:@escaping ([GifAsset])->Void) {
        verifyGiphyAPI()
        queue.async {
            let request:GifRequest = GifRequest(key: self.APIKey, type: .trending)
            let gifTask:GifSessionTask = GifSessionTask(request: request)
            gifTask.executeRequest(completion: { (gifs) in
                self.trendingGifs = gifs
                DispatchQueue.main.async {
                    completion(self.trendingGifs)
                }
            })
        }
    }
    
    
    //MARK: search
    
    
    /*
        searchGifs
        Returns every GIF in the Giphy library that is tagged with the search string provided
     */
    public func searchGifs(search:String, completion:@escaping ([GifAsset])->Void) {
       verifyGiphyAPI()
        queue.async {
            var request:GifRequest = GifRequest(key: self.APIKey, type: .search)
            request.searchQuery = search
            let gifTask:GifSessionTask = GifSessionTask(request: request)
            self.resetGifSession(task: gifTask)
            self.searchSession?.runTask(completion: { (gifs) in
                self.searchGifs.append(contentsOf: gifs)
                completion(self.searchGifs)
            })
        }
        searchGifs(search: "blah") { (gifs) in
            
        }
    }
    
    /*
        searchNextPage
        In the case where Searches have large amount of results,
        meaning:  totalSearchResults >  searchSession.sessionTask.request.limit
        the next page of GIFs can be accessed using this method.
     
        Once you've run out of GIFS to fetch, exausted will return true
     */
    public func searchNextPage(completion:@escaping (_ gifs:[GifAsset], _ exausted:Bool)-> Void) {
       verifyGiphyAPI()
        if (searchSession == nil){fatalError("Search Session must exist to search next page")}
        if searchSession?.exhausted == true {completion([], true); return }
        searchSession?.nextPage()
        self.searchSession!.runTask(completion: { (gifs) in
            self.searchGifs.append(contentsOf: gifs)
            completion(gifs, (self.searchSession?.exhausted)!)
        })
    }
    
    
    //Helper Function to reset the GifSearchSession on the main thread
    private func resetGifSession(task:GifSessionTask){
        DispatchQueue.main.sync {
            self.searchGifs.removeAll()
            self.searchSession = GifSearchSession(task: task)
            if (self.searchSession == nil){fatalError("Search Session must be initialized")}
        }
    }
    
    
    //MARK: library
    public func fetchLibraryGifs() {
        
    }
    
    //MARK: convenience
    
    private func verifyGiphyAPI(){
        if (APIKey.count == 0){ fatalError("Giphy API Key required. Contact Giphy for a key")}
    }
    
    
}
