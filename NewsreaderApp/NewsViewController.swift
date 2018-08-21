//
//  NewsViewController.swift
//  NewsreaderApp
//
//  Created by Globallogic on 29/01/18.
//  Copyright © 2018 Globallogic. All rights reserved.
//

import UIKit
import WebKit
import CoreData

class NewsViewController: UIViewController {
    
    private let reuseIdentifier = "CommentCell"
    
    var news : NewsObject!
    private var isNewsLiked = true
    var like : Like? = nil
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var webActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var newsWebView: WKWebView!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var numberOfLikesLabel: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var headerView: UIView!
    
    
    lazy var fetchedResultsController : NSFetchedResultsController<Comment> = {
        let fetchRequest: NSFetchRequest<Comment> = Comment.fetchRequest()
        
        if let like = DataManager.sharedInstance.fetchLikes(newsLink: news.url)  {
            let predicate = NSPredicate(format: "%K == %@",CommentEntity.commentOn.rawValue, like)
            fetchRequest.predicate = predicate
        }
       
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: CommentEntity.commentedAt.rawValue, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest:fetchRequest,
                                                                  managedObjectContext: DataManager.sharedInstance.managedObjectContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController

    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        commentTableView.sectionHeaderHeight = UITableViewAutomaticDimension
       
        do{
            try fetchedResultsController.performFetch()
            
        }catch {
            let fetchError = error as Error
            print ("Error is : \(fetchError)")
        }
    }
    
}
// MARK :- UITableViewDataSource
extension NewsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections{
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? CommentTableViewCell else {
            fatalError("Cell cannot be initialised!")
        }
        let comment = fetchedResultsController.object(at: indexPath)
        cell.configureCell(comment : comment)
        return cell
    }
}

//MARK: - Table View Delegate
extension NewsViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

// MARK: - Fetched Result Controller Delegate
extension NewsViewController : NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>){
        commentTableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>){
        commentTableView.endUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?){
        
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                commentTableView.insertRows(at: [indexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                commentTableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath{
                guard let cell = commentTableView.cellForRow(at: indexPath) as? CommentTableViewCell else {
                    fatalError("Cell invalid!")
                }
                if let comment = controller.object(at: indexPath) as? Comment{
                    print("update")
                    cell.configureCell(comment : comment)
                }
            }
        case .move:
            break
        }
    }
}

//MARK: - TextView Delegate
extension NewsViewController : UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        //resizeView()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter your comment here..."
            textView.textColor = UIColor.lightGray
        }
    }
}

//MARK: - WKNavigation Delegate
extension NewsViewController : WKNavigationDelegate{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webActivityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        webActivityIndicator.stopAnimating()
    }
}

//MARK: - @IBAction methods
extension NewsViewController{
    @IBAction func onLikeTapped(_ sender: UIButton) {
        like = DataManager.sharedInstance.likeNews(liked: true, newsLink: news.url)
        isNewsLiked = !isNewsLiked
        setUpLike(like: like )
    }
    
    @IBAction func onCommentTapped(_ sender: UIButton) {
        print("onCommentTapped")
        saveComment()
    }
}

//MARK: - Custom Methods
extension NewsViewController {
    private func setupViews(){
        
       // Getting the url for news
        guard let url = URL(string: news.url) else {
            fatalError("Link could not be loaded!")
        }
        let urlRequest = URLRequest(url: url)
        newsWebView.load(urlRequest)
        newsWebView.navigationDelegate = self
        newsWebView.addSubview(webActivityIndicator)
        webActivityIndicator.startAnimating()
        
        like = DataManager.sharedInstance.fetchLikes(newsLink: news.url)
        isNewsLiked = DataManager.sharedInstance.getLike(like:like)
        
        setUpLike(like: like )
        
        commentTextView.layer.borderWidth = 2
        
    }
    
    private func setUpLike(like : Like?){
        if let like = like {
            numberOfLikesLabel.text = String(like.like) + " likes"
        } else {
            numberOfLikesLabel.text = "No likes yet!"
        }
        
        if isNewsLiked {
            likeButton.setTitle("Unlike", for: .normal)
            likeButton.tintColor = UIColor.blue
        } else {
            likeButton.setTitle("Like", for: .normal)
            likeButton.tintColor = UIColor.black
        }
    }
    
    private func saveComment(){
        guard let comment = commentTextView.text ,
            comment.count > 0 else {
                createAlert(title: "Comment", message: "Comment field is empty!", hasCancelAction: false)
                return
        }
        
        commentTextView.text = ""
        let date = NSDate()
        self.like = DataManager.sharedInstance.likeNews(liked: false, newsLink: news.url)
        if let like = like,
            let user = DataManager.sharedInstance.user {
            let valueDictionary : [String:Any] = [CommentEntity.comment.rawValue : comment,
                                                  CommentEntity.commentedAt.rawValue : date,
                                                  CommentEntity.commentOn.rawValue : like,
                                                  CommentEntity.commentedBy.rawValue : user
                                                ]
            DataManager.sharedInstance.saveComment(valueDictionary: valueDictionary)
        }
    }
}
