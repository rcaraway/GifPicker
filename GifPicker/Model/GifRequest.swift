//
//  GifRequest.swift
//  GifPicker ViewController
//
//  Created by Robert Caraway on 12/22/17.
//  Copyright © 2017 Rob Caraway. All rights reserved.
//

import UIKit


// Adds easy URL encoding for a web string
extension String {
    func URLEncoded() -> String{
        guard let escapedString = self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {fatalError("URL encoding of string failed")}
        return escapedString
    }
}



public struct GifRequest {
    
    //The amount of GIFs per request
    public var limit:Int = 50
    
    //The amount of GIFs to skip over during the request
    public var offset:Int = 0
    
    
    public private(set) var apiKey:String
    
    public private(set) var sourceType:GifSourceType
   
    public var searchQuery:String = ""
    

    fileprivate let giphySource: String = "https://api.giphy.com/v1/gifs/"

    /* queryString() - Constructs a web-safe query string based on the parameters set. Calls to the Giphy API for searches and trending gifs
     */
    public func queryString() -> String{
        var queryString: String = giphySource
        queryString += queryType()
        queryString += searchString()
        queryString += apiString()
        queryString += limitString()
        queryString += offsetString()
        return queryString
    }
    
    
    public init (key:String, type:GifSourceType){
        assert(key.count > 0, "GifRequests require valid Giphy keys")
        apiKey = key
        sourceType = type
    }
    
    private func queryType() -> String {
        if sourceType == .trending {
            return "trending?"
        }
        if sourceType == .search {
            return "search?q="
        }
        return ""
    }
    
    private func searchString() -> String {
        if (sourceType != .search){
            return ""
        }
        let string:String = searchQuery.URLEncoded() + "&"
        return string
    }
    
    private func apiString() -> String {
        var apiString:String = "api_key="
        apiString.append(apiKey)
        return apiString
    }
    
    private func limitString() -> String {
        return "&limit=" + String(limit)
    }
    
    private func offsetString() -> String {
        return "&offset=" + String(offset)
    }
}
