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
 GifManager: manages the reference & memory storage of all GIF assets
 and their data.  Class required to manage references.
 */
open class GifManager: NSObject {

    
    //GIFs that represent the current trending GIFs from the Giphy API
    public private(set) var trendingGifs:[GifAsset] = []
    
    //The current GIFS fetched from the latest search
    public private(set) var searchGifs:[GifAsset] = []
    
    //GIFs fetched from the users Photos Library
    public private(set) var libraryGifs:[GifAsset] = []
    
    //Giphy API Key: REQUIRED TO USE THIS API
    public var APIKey:String = "10OaYHtqe2eojm"
    
    
    public private(set) var searchSession:GifSearchSession?
    
    
    
    /* Only one instance of GifManager is allowed to exist to enforce
      strict reference type management */
    static let sharedManager:GifManager = GifManager()
    private override init() {}
    
    
    //MARK: trending
    public func fetchTrendingGifs(completion:@escaping ()->Void) {
        DispatchQueue.global().async {
            let request:GifRequest = GifRequest(key: self.APIKey, type: .trending)
            let gifTask:GifSessionTask = GifSessionTask(request: request)
            gifTask.executeRequest(completion: { (gifs) in
                self.trendingGifs = gifs
                DispatchQueue.main.async {
                    completion()
                }
            })
        }
    }
    
    
    //MARK: search
    public func searchGifs(search:String, completion:@escaping ()->Void) {
        DispatchQueue.global().async {
            var request:GifRequest = GifRequest(key: self.APIKey, type: .search)
            request.searchQuery = search
            let gifTask:GifSessionTask = GifSessionTask(request: request)
            self.resetGifSession(task: gifTask)
            self.searchSession!.runTask(completion: { (gifs) in
                self.searchGifs.append(contentsOf: gifs)
                completion()
            })
        }
    }
    
    public func searchNextPage(completion:@escaping ()-> Void) {
        if (searchSession == nil){fatalError("Search Session must exist to search next page")}
        searchSession?.nextPage()
        self.searchSession!.runTask(completion: { (gifs) in
            self.searchGifs.append(contentsOf: gifs)
            completion()
        })
    }
    
    
    //Helper Function to reset the GifSearchSession on the main thread
    private func resetGifSession(task:GifSessionTask){
        DispatchQueue.main.async {
            self.searchGifs.removeAll()
            self.searchSession = GifSearchSession(task: task)
            if (self.searchSession == nil){fatalError("Search Session must be initialized")}
        }
    }
    
    
    //MARK: library
    public func fetchLibraryGifs() {
        
    }
    
    
}
