//
//  NewViewModel.swift
//  TestNewsApiApp
//
//  Created by Рустам Т on 9/27/23.
//

import UIKit

struct NewViewModel: Hashable, Equatable, Codable {
    let new: Article
    var isFavourite: Bool = false
    var id = UUID()
    
    var title: String {
        new.title
    }
    
    var description: String {
         new.description ?? ""
    }
    
    var author: String {
        "Published by \(new.author ?? "Free sources")"
    }
    
    var urlImage: String {
        new.urlToImage ?? "http://surl.li/lntpy"
    }
    
    var url: String {
        new.url ?? ""
    }
    
    var date: String {
        guard let dateStr = new.publishedAt else {return "" }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let newDate = dateFormatter.date(from: dateStr) else { return ""}
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "dd.MM.yyyy"
            let formattedDate = outputDateFormatter.string(from: newDate)
            return formattedDate
        
    }
    
    static func == (lhs: NewViewModel, rhs: NewViewModel) -> Bool {
        return lhs.title == rhs.title && lhs.author == rhs.author
       }
}
