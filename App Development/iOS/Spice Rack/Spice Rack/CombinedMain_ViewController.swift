//
//  CombinedMain_ViewController.swift
//  Spice Rack
//
//  Created by Matt Dickey on 4/5/16.
//  Copyright © 2016 Matt Dickey. All rights reserved.
//

import UIKit
import RealmSwift

//https://www.raywenderlich.com/113772/uisearchcontroller-tutorial
//typeface credit https://fontlibrary.org/en/font/grand-hotel
//https://grokswift.com/custom-fonts/



class CombinedMain_ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    
    let database = try! Realm()
    let reuseIdentifier = "spiceCell"
    var spicetoDetail : Spice?
    var currentRack : Results<Spice>!
    var allSpices = [Spice]()
    var sortedbyRunningLow : Results<Spice>!
    var runningLow = [Spice]()
    var searchResults = [Spice]()
    var sections = [[Spice]]()
    
    //MARK: - Interface
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Views
    @IBOutlet weak var collectionParent: UIView!
    @IBOutlet weak var tableParent: UIView!
    @IBOutlet weak var segmentBar: UISegmentedControl!
    
    // MARK: - IBActions
    @IBAction func unwindSegue(segue: UIStoryboardSegue){
        readAndUpdate()
    }
    @IBAction func doneSegue(segue: UIStoryboardSegue){
    }
    @IBAction func segmentSelectionChanged(sender: AnyObject) {
        let selectedSegment = segmentBar.selectedSegmentIndex
        
        if selectedSegment == 0 {
            collectionParent.hidden = false
            tableParent.hidden = true
            
        }else if selectedSegment == 1{
            collectionParent.hidden = true
            tableParent.hidden = false
            if allSpices.count != 0 {
                tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
            }
        }
        readAndUpdate()
        removeDuplicates()
    }
    
    
    // MARK: - My Functions
    func readAndUpdate(){
        
        //Load Data from Realm
        currentRack = database.objects(Spice)
        
        //Convert to Swift Array
        currentRack = currentRack.sorted("name")
        allSpices = Array(currentRack)
        
        sortedbyRunningLow = database.objects(Spice).filter("percentageRemaining <= 10.0").sorted("name")
        runningLow = Array(sortedbyRunningLow)
        
        //TableView Data Source
        sections = [runningLow, allSpices]
        
        
        removeDuplicates()
        collectionView?.reloadData()
        tableView.reloadData()
    }
    func buildSearchBar(){
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.sizeToFit()
    }
    func setCollectionViewBackground(imageName : String){
        let shelf = UIImage(named: imageName)
        self.collectionView?.backgroundColor = UIColor(patternImage: shelf!)
    }
    func designUI(){
        navigationController?.navigationBar.barTintColor = UIColor.customGreenColor()
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
        navigationController?.navigationBar.titleTextAttributes = [ NSForegroundColorAttributeName: UIColor.peachColor(), NSFontAttributeName: UIFont(name: "GrandHotel-Regular", size: 26)! ]
        
        if runningLow.isEmpty{
            setCollectionViewBackground("darkshelf")
        }else{
            setCollectionViewBackground("newshelf")
        }
        
        
    }
    func removeDuplicates(){
        //remove running low spices from the list of allspices
        for spice in runningLow {
            if let spiceIndex = allSpices.indexOf({$0.name == spice.name}){
                allSpices.removeAtIndex(spiceIndex)
            }
        }
        sections = [runningLow, allSpices]
    }
    
    
    // MARK: CollectionView Requirements
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if runningLow.count != 0 {
            return 2
        }else {
            return 1
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if runningLow.count == 0 {
            return allSpices.count
        }else{
            return sections[section].count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)  as! SpiceJar_CollectionViewCell
        
        var spice : Spice
        
        if runningLow.count != 0 {
            spice = sections[indexPath.section][indexPath.row]
        }else{
            spice = allSpices[indexPath.row]
        }
        
        let spiceName = spice.name.capitalizedString
        let percentageRemaining = spice.percentageRemaining
        let imageOffset = (100 - (1.05 * percentageRemaining))
        
        
        //set the Label to the Spice Name
        cell.spiceNameLabel.text = spiceName
        cell.spiceNameLabel.textColor = UIColor.whiteColor()
        cell.spiceNameLabel.shadowColor = UIColor.blackColor()
        if spice.percentageRemaining <= 10 {
            cell.spiceNameLabel.textColor = UIColor.redColor()
            cell.spiceNameLabel.shadowColor = UIColor.whiteColor()
        }
        
        
        //Get The Appropriate texture based on name
        if let image = spice.imageName{
            cell.spiceTextureImage.image = UIImage(named: image)
        }
        
        //Create and image mask to illustrate quantity
        if let maskImage = UIImage(named: "jarmask-ti.png"){
            cell.spiceTextureImage.maskView = UIImageView(image: maskImage)
        }
        let mask = cell.spiceTextureImage.maskView!
        //modify it's position
        mask.frame.origin = CGPoint(x: 2.0, y: 9.0)
        //modify it's vertical offset and max points.
        mask.frame.offsetInPlace(dx: 0.0, dy: CGFloat(imageOffset))
        mask.frame.size = CGSize(width: 93, height: 134)
        
        //this line is needed for the cell size to initalize correctly on the first load of the thread. IDK why...
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if runningLow.count != 0 {
            spicetoDetail = sections[indexPath.section][indexPath.row]
        } else{
            spicetoDetail = allSpices[indexPath.row]
        }
        performSegueWithIdentifier("showDetails", sender: nil)
    }
    
    
    
    //MARK: - TableView Requirements
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if searchController.active && searchController.searchBar.text != ""{
            return 1
        }
        if runningLow.count != 0 {
            return 2
        }else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != ""{
            return searchResults.count
        }else if runningLow.count == 0 {
            return allSpices.count
        }else{
            return sections[section].count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SpiceTableViewCell
        
        var spice : Spice
        
        
        //search
        if searchController.active && searchController.searchBar.text != "" {
            spice = searchResults[indexPath.row]
        }else if runningLow.count != 0 {
            spice = sections[indexPath.section][indexPath.row]
        }else{
            spice = allSpices[indexPath.row]
        }
        let spiceName = spice.name.capitalizedString
        let percentRemaining = spice.percentageRemaining.roundToPlaces(2)
        
        
        
        //Labels
        cell.customTextLabel?.text = spiceName
        cell.customTextLabel?.textColor = UIColor.whiteColor()
        cell.customDetailTextLabel?.text = "\(Int(percentRemaining))%"
        cell.customDetailTextLabel?.textColor = UIColor.whiteColor()
        
        if spice.percentageRemaining <= 10 {
            cell.customDetailTextLabel?.textColor = UIColor.redColor()
        }
        
        //background image
        if let image = spice.imageName{
            let bgImage = UIImage(named:"\(image)-table")
            let bgImageView = UIImageView(image: bgImage)
            bgImageView.contentMode = UIViewContentMode.ScaleAspectFill
            
            //dark overlay effect
            let darkFilterView = UIView()
            darkFilterView.backgroundColor = UIColor.blackColor()
            darkFilterView.frame = self.view.frame
            darkFilterView.alpha = 0.6
            
            bgImageView.addSubview(darkFilterView)
            cell.backgroundView = bgImageView
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if searchController.active && searchController.searchBar.text != "" {
            spicetoDetail = searchResults[indexPath.row]
        } else if runningLow.count != 0 {
            spicetoDetail = sections[indexPath.section][indexPath.row]
        } else{
            spicetoDetail = allSpices[indexPath.row]
        }
        
        searchResults = [Spice]()
        performSegueWithIdentifier("showDetails", sender: nil)
        
    }
    
    
    
    //MARK: - Search
    func filterContentForSearchText(searchText : String, scope : String = "All"){
        searchResults = Array(allSpices).filter { spice in
            return spice.name.lowercaseString.containsString(searchText.lowercaseString)}
        tableView.reloadData()
    }
    
    
    //MARK: - Included
    override func viewDidLoad() {
        super.viewDidLoad()
        readAndUpdate()
        buildSearchBar()
    }
    
    override func viewWillAppear(animated: Bool) {
        readAndUpdate()
        designUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showDetails" && spicetoDetail != nil) {
            let showDetailsVC = segue.destinationViewController as! SpiceDetails_ViewController
            showDetailsVC.receivedObject = spicetoDetail
        }
    }
    
} // End of Class




