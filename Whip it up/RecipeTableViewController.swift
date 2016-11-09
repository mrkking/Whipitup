//
//  RecipeTableViewController.swift
//  Whip it up
//
//  Created by Kory E King on 11/7/16.
//  Copyright © 2016 Kory E King. All rights reserved.
//

import UIKit



class RecipeTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    var jsonParser = JSONParser()
    let searchController = UISearchController(searchResultsController: nil)
    var mainlist = [Dictionary<String, String>]()
    var searchString = ""
    var page = 1

    override func viewDidLoad() {
        super.viewDidLoad()
       
        mainlist = jsonParser.parsedInformation
        
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        self.tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.placeholder = "search e.g. eggs"
        searchController.searchBar.delegate = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if mainlist.count != 0{
            return mainlist.count
        }else{
            return 1
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomTBVCell
        if mainlist.count != 0{
            let mDict = mainlist[indexPath.row] as Dictionary<String, String>
            cell.rectitle.text = mDict[mConstants.keys.title]?.stringByReplacingOccurrencesOfString("&amp;", withString: "&")
            loadAsyncImgs(mDict[mConstants.keys.thumbURL]!, imgV: cell.recimage, position: indexPath.row )
        }else{
            cell.rectitle.text = "Sorry we did not find any recipes, please try again :-("
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func loadAsyncImgs(url: String, imgV: UIImageView, position: Int){
        let dlQueue = dispatch_queue_create("com.mrkking.whipitup", nil)
        
        dispatch_async(dlQueue){
            let data = NSData(contentsOfURL: NSURL(string: url)!)
            
            var image: UIImage?
            
            if data != nil{
                image = UIImage(data: data!)
            }else{
                print("image did not load"+self.mainlist[position])
            }
            
            dispatch_async(dispatch_get_main_queue()){
                imgV.image = image
            }
        }
    }
  /*
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let lastrow = mainlist.count-1
        if indexPath.row == lastrow{
            jsonParser.requestJson(searchString, isNewQuery: false, page: page)
            mainlist = jsonParser.parsedInformation
        }
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        jsonParser.requestJson(searchBar.text!)
        print(jsonParser.parsedInformation.count)
        mainlist = jsonParser.parsedInformation
        self.tableView.reloadData()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if searchController.searchBar.text == ""{
            mainlist.removeAll()
        }
        searchString = searchController.searchBar.text!
        self.tableView.reloadData()
    }*/
    

}
