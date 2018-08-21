//
//  ViewController.swift
//  NewsreaderApp
//
//  Created by Globallogic on 29/01/18.
//  Copyright © 2018 Globallogic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let CellIdentifier = "NewsCell"
    private let segueIdentifier = "Show News Details"
    
    private var newsList = [NewsObject]()
    private var isMenuDisplayed = false
    private let menuTableViewHelper = MenuTableViewHelper()

    @IBOutlet weak var menuTableViewLeadingConstarint: NSLayoutConstraint!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        menuTableViewLeadingConstarint.constant = -20 - menuTableView.frame.width
        isMenuDisplayed = false
        if let indexPath = newsTableView.indexPathForSelectedRow {
            newsTableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

//MARK: - Table View Data Source
extension ViewController : UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath) as? NewsTableViewCell else {
            fatalError("Unexpected indexPath")
        }
        
        let news = newsList[indexPath.row]
        cell.configureCell(news: news)
        cell.newsImageView.layoutSubviews()
        
        return cell
    }
}

//MARK: - Menu Table View Delegate
extension ViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let source = menuTableView.cellForRow(at: indexPath)?.textLabel?.text {
            print(source)
            switch source {
            case "Logout" :
                navigationController?.popToRootViewController(animated: true)
                
            default:
                tableView.deselectRow(at: indexPath, animated: true)
                loadNews(source: source )
                newsTableView.reloadData()
                showMenu()
            }
        } else {
            createAlert(title: NSLocalizedString(Values.error.rawValue, comment: ""), message: "Source not found!", hasCancelAction: false)
        }
    }
}


// MARK: - Navigation
extension ViewController{
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let cell = sender as? NewsTableViewCell else {
            return
        }
        let identifier = segue.identifier ?? ""
        switch identifier{
        case segueIdentifier:
            guard let destinationViewController = segue.destination as? NewsViewController else{
                print("Invalid destination")
                return
            }
            if let indexPath = newsTableView.indexPath(for: cell){
                destinationViewController.news = newsList[indexPath.row]
            }
        default:
            print("default segue")
        }
    }
}

//MARK: - @IBAction Methods
extension ViewController {
    @IBAction func onMenuIconTapped(_ sender: UIBarButtonItem) {
       showMenu()
    }
}

//MARK: - Custom methods
extension ViewController {
    
    /// handler is used for parsing the data received from the URL
    ///
    /// - Parameters:
    ///   - response: json response from the server
    ///   - error: any error that occured due to the device
    @objc func handler(response: [String : Any]?,error:  Error?) {
        if let error = error {
            print(error)
            createAlert(title: NSLocalizedString(Values.error.rawValue, comment: "") , message: error.localizedDescription, hasCancelAction: false)
            return
        }
        if let response = response{
            guard let newsArticles = response[JsonKeys.articles.rawValue] as? [[String:Any]] else {
                print(response)
                createAlert(title: NSLocalizedString(Values.error.rawValue, comment: "") , message: String(describing : response), hasCancelAction: false)
                updateViews()
                return
            }
            newsList = [NewsObject]()
            for newsDetails in newsArticles {
                if let news = NewsObject(json : newsDetails){
                    self.newsList.append(news)
                    updateViews()
                }
            }
        } else {
             createAlert(title: NSLocalizedString(Values.error.rawValue, comment: "") , message: NSLocalizedString(Values.invalidData.rawValue, comment: ""), hasCancelAction: false)
            return
        }
    }
    
    private func updateViews(){
        DispatchQueue.main.async {
            self.newsTableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
    
    /// Method for loading the news from Web
    private func loadNews(source : String){
        activityIndicator.startAnimating()
        NetworkManager.sharedInstance.sendRequest(source: source, completion: self.handler(response:error:))
        
    }
    
    private func showMenu(){
        if isMenuDisplayed {
            menuTableViewLeadingConstarint.constant = -20 - menuTableView.frame.width
        } else {
            view.bringSubview(toFront: menuTableView)
            menuTableViewLeadingConstarint.constant = 0
        }
        UIView.animate(withDuration: 0.3, animations:{
            self.view.layoutIfNeeded()
        } )
        isMenuDisplayed = !isMenuDisplayed
    }
    
    private func setupView(){
        loadNews(source: Source.CNN.rawValue)
        newsTableView.dataSource = self
        menuTableView.delegate = self
        menuTableView.dataSource = menuTableViewHelper
        menuTableView.layer.shadowOffset = CGSize(width: 5, height: view.frame.height)
        let headerView = menuTableView.headerView(forSection: 1)
        headerView?.backgroundColor = UIColor.orange
        view.bringSubview(toFront: activityIndicator)
        view.bringSubview(toFront: menuTableView)
        
    }
}
