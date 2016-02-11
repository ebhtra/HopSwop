//
//  BeerEditorVC.swift
//  HopSwop
//
//  Created by Ethan Haley on 2/6/16.
//  Copyright © 2016 Ethan Haley. All rights reserved.
//

import UIKit

protocol WatchlistDelegate {
    func addToWatchlist(_: HalfBeer)
}

class BeerEditorVC: BeerLoginController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate, LocationDelegate {
    
    @IBOutlet weak var searcher: UISearchBar!
    @IBOutlet weak var searchTable: UITableView!
    @IBOutlet weak var beerDateSwitch: UISwitch!
    @IBOutlet weak var beerMonth: UITextField!
    @IBOutlet weak var beerDay: UITextField!
    @IBOutlet weak var beerYear: UITextField!
    @IBOutlet weak var homebrewSwitch: UISwitch!
    @IBOutlet weak var currentBeerDisplay: UITextField!
    @IBOutlet weak var currentBeerBrewer: UITextField!
    @IBOutlet weak var beerLocButton: UIButton!
    @IBOutlet weak var containerPicker: UIPickerView!
    @IBOutlet weak var swopButton: UIButton!
    @IBOutlet weak var watchlistButton: UIButton!
    @IBOutlet weak var beerNotes: UITextView!
    
    var currentBeer: Beer?
    var addBeerDelegate: WatchlistDelegate!
    
    let beernameFieldDefaultText = "Is this a homebrew?   ⌳"
    let brewerFieldDefaultText = "--Brewed By--"
    var isHomeBrew: Bool!
    var drinkBy: Bool!
    var halfBeerResults = [HalfBeer]()
    var searchTask: NSURLSessionDataTask?
    var beerAt: CLLocationCoordinate2D?
    var vessel: String!
    
    let pickerArray = ["Bottles", "Cans", "Crowlers", "Draft"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isHomeBrew = homebrewSwitch.on
        drinkBy = beerDateSwitch.on
    }
   
    @IBAction func beerLocButtonTap(sender: UIButton) {
        let nextVC = storyboard?.instantiateViewControllerWithIdentifier("BeerLocation") as! BeerLocatorVC
        nextVC.locDelegate = self
        presentViewController(nextVC, animated: true, completion: nil)
    }
    
    @IBAction func swopButtonTap(sender: UIButton) {
    }
    
    @IBAction func watchlistButtonTap(sender: UIButton) {
        
    }
    
    @IBAction func beerDateSwitchToggled(sender: UISwitch) {
        drinkBy = !drinkBy
    }
    @IBAction func homebrewSwitchToggled(sender: AnyObject) {
        isHomeBrew = !isHomeBrew
        currentBeerDisplay.enabled = isHomeBrew
        currentBeerBrewer.enabled = isHomeBrew
        currentBeerBrewer.hidden = !isHomeBrew
        currentBeerBrewer.text = isHomeBrew! ? brewerFieldDefaultText : ""
        currentBeerDisplay.text = isHomeBrew! ? "" : beernameFieldDefaultText
        searcher.hidden = isHomeBrew
    }
    
    // MARK: - UITableView delegate methods:
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return halfBeerResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let beerCell = tableView.dequeueReusableCellWithIdentifier("beerCell") as! BeerCell
        
        //let beer = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Beer
        
        let halfBeer = halfBeerResults[indexPath.row]
        beerCell.beerName.text = halfBeer.name
        beerCell.brewery.text = halfBeer.maker
        
        return beerCell
    }
    
    // MARK: - Search Bar Delegate methods:
    
    // -- TableView to be visible only while searchBar is active
    // -- Changing searchBar text cancels old task and starts new
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchTable.hidden = false
        
        // Cancel the last task
        if let task = searchTask {
            task.cancel()
        }
        
        // If the text is empty don't search
        if searchText == "" {
            searchTable.hidden = true
            halfBeerResults = [HalfBeer]()
            searchTable.reloadData()
            objc_sync_exit(self) // I see this in Jason's code but not Jarrod's, and not sure why
            return
        }
        
        // Start a new search task
        searchTask = BreweryDbClient.sharedInstance.halfBeerSearch(searchText) { halfbeerlist, error in
            self.searchTask = nil
            if let result = halfbeerlist {
                self.halfBeerResults = result
                dispatch_async(dispatch_get_main_queue()) {
                    self.searchTable.reloadData()
                }
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
    }
    // dismiss searchBar results when not active
    override func handleTap() {
        super.handleTap() // still want to dismiss keyboards
        searchTable.hidden = true
    }
    
    // MARK: - UIPickerView delegate methods:
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerArray.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerArray[row]
    }
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return CGFloat(16)
    }
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return CGFloat(110)
    }
    
    // MARK: - LocationDelegate method:
    
    func setBeerLoc(site: CLLocationCoordinate2D?) {
        beerAt = site
        if site != nil {
            beerLocButton.setTitle("Change beer location", forState: .Normal)
        }
    }

}
