//
//  NewsTableViewCell.swift
//  NewsreaderApp
//
//  Created by Globallogic on 29/01/18.
//  Copyright © 2018 Globallogic. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsAuthorLabel: UILabel!
    @IBOutlet weak var newsDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 5
        contentView.layer.borderColor = UIColor.orange.cgColor
        newsImageView.layer.cornerRadius = 5
        newsImageView.layer.borderColor = UIColor.orange.cgColor
        newsImageView.layer.borderWidth = 2
        newsImageView.clipsToBounds = true
        newsAuthorLabel.textColor = UIColor.orange
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsImageView.image = UIImage(named: "defaultPhoto")
    }
    
}

extension NewsTableViewCell {
    /// Method for configuring the table view cell
    ///
    /// - Parameter news: The NewsObject using which the cell will be configured
    func configureCell(news : NewsObject) {
        newsAuthorLabel.text = news.author + " | " + news.publishedAt
        newsDescriptionLabel.text = news.newsDescription
        newsTitleLabel.text = news.title
        if let url = URL(string: news.imageUrl){
            newsImageView.imageFromURL(url: url)
        }
        
    }
}
