//
//  NewsObject.swift
//  NewsreaderApp
//
//  Created by Globallogic on 29/01/18.
//  Copyright © 2018 Globallogic. All rights reserved.
//

import Foundation

class NewsObject : NSObject {
    var title : String
    var newsDescription : String
    var url : String
    var imageUrl : String
    var author : String
    var publishedAt :  String
    var source : (id:String,name:String)
    
    init(title : String, description : String, url : String, imageUrl : String, author : String, publishedAt :  String, source : (id:String , name:String)) {
        self.title = title
        self.newsDescription = description
        self.url = url
        self.imageUrl = imageUrl
        self.author = author
        self.publishedAt = publishedAt
        self.source = source
    }
    
    convenience init?(json : Dictionary<String, Any>) {
        
        guard let title = json[ JsonKeys.title.rawValue] as? String,
            let author = json[ JsonKeys.author.rawValue] as? String,
            let url = json[ JsonKeys.url.rawValue] as? String,
            let imageUrl  = json[ JsonKeys.imageUrl.rawValue] as? String,
            let description = json[ JsonKeys.newsDescription.rawValue] as? String,
            let publishedAt = json[ JsonKeys.publishedAt.rawValue] as? String,
            let sourceDictionary = json[ JsonKeys.source.rawValue] as? Dictionary<String,String>,
            let id  = sourceDictionary[ JsonKeys.sourceId.rawValue],
            let name = sourceDictionary[ JsonKeys.sourceName.rawValue]
            else{
                return nil
        }
        
        self.init(title : title, description : description, url : url, imageUrl : imageUrl, author : author, publishedAt :  publishedAt,source : (id,name))
    }
}
