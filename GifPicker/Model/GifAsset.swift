//
//  GifAsset.swift
//  GifPicker ViewController
//
//  Created by Robert Caraway on 12/21/17.
//  Copyright © 2017 Rob Caraway. All rights reserved.
//


import UIKit

/*
 GifAsset: Holds all relevant data for your GIF
 */
public struct GifAsset {
    
    // Holds Data referencing a thumbnail GIF
    public var thumb: Data?
    
    //Holds GIF data important for displaying a GIF
    //Acceptable as a valid Web Gif URL
    public var gif: Data?
    
    //Quick access to the dimensions of the GIF
    public var size: CGSize?
    
    //URL to access the thumbnail
    public var thumbURL: URL?
    
    //access the main gif from this URL
    public var URL:URL?
    
}




