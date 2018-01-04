//
//  GifConfig.swift
//  GifPicker ViewController
//
//  Created by Robert Caraway on 12/21/17.
//  Copyright © 2017 Rob Caraway. All rights reserved.
//


public enum GifSourceType {
    case search
    case library
    case trending
}

//Configures Gif Requests to behave in a specific way
public struct GifConfig {
    var sourceType:GifSourceType
    var giphyKey:String
}


