//
//  Constants.swift
//  NewsreaderApp
//
//  Created by Globallogic on 29/01/18.
//  Copyright © 2018 Globallogic. All rights reserved.
//

import Foundation

enum JsonKeys : String {
    case articles = "articles"
    case title = "title"
    case newsDescription = "description"
    case url = "url"
    case imageUrl = "urlToImage"
    case author = "author"
    case publishedAt = "publishedAt"
    case source = "source"
    case sourceId = "id"
    case sourceName = "name"
    case apiKey = "apiKey"
    case sourcesKey = "sources"
}

let CategoryList = [ "Political",
                     "Sports",
                     "Technology",
                     "Logout"
                    ]

enum URLString : String {
    case techcrunch = "TechCrunch"
    case cnn = "CNN"
    case dailyMail = "DailyMail"
}

enum Source : String {
    case TechCrunch = "techcrunch"
    case DailyMail = "daily-mail"
    case CNN = "cnn"
}

enum APIData : String {
    case APIKey = "6f1f9812f9994150b521dd734c4662b2"
    case APISource = "https://newsapi.org/v2/top-headlines"
}

enum Values : String {
    case error = "error"
    case invalidData = "invalid_data_received"
}

enum Entity : String {
    case user = "User"
    case comment = "Comment"
    case like = "Like"
}

enum UserEntity : String {
    case email = "emailId"
    case name = "name"
    case password = "password"
}

enum CommentEntity : String {
    case comment = "comment"
    case commentedAt = "commentedAt"
    case commentOn = "commentOn"
    case commentedBy = "commentedBy"
}

enum LikeEntity : String {
    case newsLink = "newsLink"
    case like = "like"
    case likedBy = "likedBy"
    case comments = "comments"
}
