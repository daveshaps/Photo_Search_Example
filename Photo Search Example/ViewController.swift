//
//  ViewController.swift
//  Photo Search Example
//
//  Created by Wish Carr on 12/2/16.
//  Copyright © 2016 David Shapiro. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchFlickrBy("dogs")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func searchFlickrBy(_ searchString: String) {
        //calling Flickr API
        let manager = AFHTTPSessionManager()
        //question: how would you know what to put in the search parameters?
        let searchParameters:[String:Any] = ["method": "flickr.photos.search",
                                             "api_key": "0696cc4c5e0284868ecd458b00747345",
                                             "format": "json",
                                             "nojsoncallback": 1,
                                             "text": searchString,
                                             "extras": "url_m",
                                             "per_page": 5]
        //this part is the same as in the web service example
        manager.get("https://api.flickr.com/services/rest/",
                    parameters: searchParameters,
                    progress: nil,
                    success: { (operation: URLSessionDataTask, responseObject:Any?) in
                        if let responseObject = responseObject as? [String: AnyObject] {
                            print("Response: " + (responseObject as AnyObject).description)
                            
                            if let photos = responseObject["photos"] as? [String: AnyObject] {
                                if let photoArray = photos["photo"] as? [[String: AnyObject]] {
                                    
                                    let imageWidth = self.view.frame.width
                                    //set size of scrollView
                                    self.scrollView.contentSize = CGSize(width: imageWidth, height: imageWidth * CGFloat(photoArray.count))
                                    
                                    //loop through phoroArray to extract photos
                                    for (i,photoDictionary) in photoArray.enumerated() {
                                        if let imageURLString = photoDictionary["url_m"] as? String {
                                            
                                            let imageView = UIImageView(frame: CGRect(x:0, y:imageWidth*CGFloat(i), width:imageWidth, height:imageWidth)) //created empty imageView
                                            if let url = URL(string: imageURLString) {
                                                imageView.setImageWith(url) //setImageWith() is from UIKit+AFNet and is an asynchronous method to download images in the background
                                                self.scrollView.addSubview(imageView)
                                            }
                                        }
                                    }
                                }
                                
                            }
                        }
        }) { (operation:URLSessionDataTask?, error:Error) in
            print("Error: " + error.localizedDescription)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        for subview in self.scrollView.subviews {
            subview.removeFromSuperview()
        }
        searchBar.resignFirstResponder()
        if let searchText = searchBar.text {
            searchFlickrBy(String(searchText))
        }
        
    }
    
    
}

