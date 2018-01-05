//
//  ViewController.swift
//  GifPicker ViewController
//
//  Created by Robert Caraway on 12/21/17.
//  Copyright © 2017 Rob Caraway. All rights reserved.
//

import UIKit

/*
 GifPickerViewControllerDelegate: use to respond to important events triggered within the GifPickerViewController
 */
protocol GifPickerViewControllerDelegate: class {
    
    //whenever a GIF is selected, it will be first converted to a GIFAsset from its original type
    func didSelectGif(gifAsset:GifAsset)
}


/*
 IndicatorView: Make your custom UIActicityIndicatorViews or other loaders inherit this protocol to use in place of the UIActicityIndicatorView used within the GifPickerViewController.
 */
public protocol IndicatorView {
    
    //Starts the loading animation of your view
    func beginLoading()
    
    //Ends the loading animation of your view
    func stopLoading()
    
    //Makes sure your loading is visible
    func show()
    
    //Makes sure your loading is hidden
    func hide()
    
}


/*
 Extension for UIActivityIndicatorView: forces UIActivityIndicatorView to conform to IndicatorView. The purpose is so that other types of loaders can replace this when needed.
 */
extension UIActivityIndicatorView:IndicatorView {
    public func beginLoading(){ startAnimating() }
    public func stopLoading(){ stopAnimating() }
    public func show(){ alpha = 1.0; isHidden = false}
    public func hide(){ alpha = 0.0; isHidden = true }
}


@IBDesignable class GifPickerViewController: UIViewController {

    //adopt to respond to important actions
    weak var delegate:GifPickerViewControllerDelegate?
    
    public var indicatorView: IndicatorView = { () -> UIActivityIndicatorView in
        let indicator:UIActivityIndicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        return indicator
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(red: 0.9229, green: 0.9229, blue: 0.9229, alpha: 1.0)
        GifManager.sharedManager.fetchTrendingGifs { (gifs) in
            print(gifs)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

