//
//  GifSession.swift
//  GifPicker ViewController
//
//  Created by Robert Caraway on 12/21/17.
//  Copyright © 2017 Rob Caraway. All rights reserved.
//


import Foundation

public class GifSearchSession {
    //current page
    public var page:Int = 0 {
        didSet{
            sessionTask.request.offset = sessionTask.request.limit * page
        }
    }
    public private(set) var exhausted:Bool = false
    public private(set) var searchInProgress:Bool = false
    public var sessionTask:GifSessionTask
    
    public init (task:GifSessionTask){
        sessionTask = task
    }
    
    public func nextPage(){
        page += page+1
    }
    
    public func runTask(completion:@escaping ([GifAsset])->Void){
        if exhausted{ completion([]); return }
        
        isSearching(searching: true)
        sessionTask.executeRequest(completion: { (gifs) in
            isSearching(searching: false)
            DispatchQueue.main.async {
                self.evaluateExhaustion(gifCount: gifs.count)
                completion(gifs)
            }
        })
    }
    
    private func evaluateExhaustion(gifCount:Int){
        let boolean:Int = (gifCount / sessionTask.request.limit + 1) % 2
        exhausted = Bool(exactly: NSNumber(integerLiteral: boolean))!
    }
    
    private func isSearching(searching: Bool){
         DispatchQueue.main.async {
            self.searchInProgress = searching
        }
    }
    
    
}


