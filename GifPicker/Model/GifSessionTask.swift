//
//  GifSessionTask.swift
//  GifPicker ViewController
//
//  Created by Robert Caraway on 12/21/17.
//  Copyright © 2017 Rob Caraway. All rights reserved.
//

import UIKit

public struct GifSessionTask {
    
    var request:GifRequest
    
    public func executeRequest(completion:([GifAsset]) -> Void){
        let query:String = request.queryString()
        fetchJSON(query: query) { (json) in
            let jsonData:[[String:Any]] = json["data"] as! [[String:Any]]
            let gifs:[GifAsset] = allGifs(json: jsonData)
            completion(gifs)
        }
    }
    
    //MARK: conveniece functions
    private func fetchJSON(query:String, completion:([String:Any])->Void) {
        var json:[String: Any]
        do {
            guard let url:URL = URL(string: query) else {fatalError()}
            let data:Data = try Data(contentsOf: url)
            json = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as! [String : Any]
        } catch {
            fatalError("QUERY FAILED TO LOAD")
        }
        completion(json)
    }
    
    private func allGifs(json:[[String:Any]]) -> [GifAsset]{
        var gifAssets:[GifAsset] = []
        for dictionary:[String:Any] in json {
            let gifAsset:GifAsset = gifAssetFromJSON(jsonDict: dictionary)
            gifAssets.append(gifAsset)
        }
        return gifAssets
    }
    
    private func gifAssetFromJSON(jsonDict:[String:Any]) -> GifAsset {
        let imageInfo:[String:Any] = jsonDict["images"] as! [String:Any]
        let fixedWidth:[String:String] = imageInfo["fixed_width"] as! [String:String]
        let original:[String:String] = imageInfo["original"] as! [String:String]
        guard let originalURL:URL = URL(string: original["url"]!) else {
            fatalError("URL of Original GIF was not valid")
        }
        guard let thumbURL:URL = URL(string: fixedWidth["url"]!) else {
            fatalError("URL of Thumb GIF was not valid")
        }
        var gif: GifAsset = GifAsset()
        gif.thumbURL = thumbURL
        gif.URL = originalURL
        return gif
    }
    
}
