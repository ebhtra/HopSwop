//
//  BeerEditorVC.swift
//  HopSwop
//
//  Created by Ethan Haley on 2/6/16.
//  Copyright © 2016 Ethan Haley. All rights reserved.
//

import UIKit
import CoreData

class BeerEditorVC: BeerLoginController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate, LocationDelegate, UISearchBarDelegate, UITextViewDelegate {
    
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
    
    var editingBeer = false  // default setting is that a new beer is being created
    var currentBeer: Beer?  // in case this VC is used later for editing existing Beers
    var currentHalfBeer: HalfBeer?  // since searchBar is returning results in this form
    
    var isHomeBrew: Bool!
    var drinkBy: Bool!
    var halfBeerResults = [HalfBeer]()
    var searchTask: NSURLSessionDataTask?
    var beerAt: CLLocationCoordinate2D?
    var vesselType = 0
    var wasEdited = false // did user tap in the notes field yet?
    
    let pickerArray = ["😧 none", "Bottles", "Cans", "Crowlers", "Draft"]
    
    let sharedContext = CoreDataStackManager.sharedInstance().managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showBackgroundBeer()
        
        if let beer = currentBeer {
            fillBeer(beer)
        }
        
        if editingBeer {
            searcher.hidden = true
            watchlistButton.hidden = true
            homebrewSwitch.enabled = false
            currentBeerBrewer.hidden = false
            currentBeerDisplay.hidden = false
        }
        
        isHomeBrew = homebrewSwitch.on
        drinkBy = beerDateSwitch.on
        
        tapRecognizer!.cancelsTouchesInView = false  // otherwise tableView taps don't work
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func fillBeer(oldBeer: Beer) {
        homebrewSwitch.setOn(oldBeer.dbID == "", animated: true)
        currentBeerBrewer.text = oldBeer.brewer
        currentBeerDisplay.text = oldBeer.beerName
        beerDateSwitch.setOn(!oldBeer.bornOn, animated: true)
        let date = oldBeer.freshDate.componentsSeparatedByString("-")
        beerMonth.text = date[0]
        beerDay.text = date[1]
        beerYear.text = date[2]
        beerNotes.text = oldBeer.descrip
        wasEdited = true
        beerAt = CLLocationCoordinate2DMake(oldBeer.latitude, oldBeer.longitude)
        beerLocButton.setTitle("Change location", forState: .Normal)
        vesselType = pickerArray.indexOf(oldBeer.vessel) ?? 0
        containerPicker.selectRow(vesselType, inComponent: 0, animated: true)
        
    }

    @IBAction func beerLocButtonTap(sender: UIButton) {
        // Modally present a map for user to drop a pin on.
        //   Send any currently stored pin over to display on map.
        //   Set this VC as delegate to receive new coordinate back from map.
        let nextVC = storyboard?.instantiateViewControllerWithIdentifier("BeerLocation") as! BeerLocatorVC
        nextVC.locDelegate = self
        if let coord = beerAt {
            nextVC.oldCoord = coord
        }
        presentViewController(nextVC, animated: true, completion: nil)
    }
    
    @IBAction func swopButtonTap(sender: UIButton) {
        
        if validateSwopFields() {
            
            var swopDict = [String: AnyObject]()
            
            swopDict[Beer.Keys.Lat] = beerAt!.latitude
            swopDict[Beer.Keys.Lon] = beerAt!.longitude
            swopDict[Beer.Keys.Name] = currentBeerDisplay.text!
            swopDict[Beer.Keys.Brewer] = currentBeerBrewer.text!
            swopDict[Beer.Keys.Vessel] = pickerArray[vesselType]
            swopDict[Beer.Keys.BornOn] = !beerDateSwitch.on
            swopDict[Beer.Keys.DrinkDate] = tryForDate()
            swopDict[Beer.Keys.Descrip] = tryForNotes()
            swopDict[Beer.Keys.BrewDBID] = currentBeer?.dbID ?? currentHalfBeer?.id ?? "New Beer"
            
            swopDict[Beer.Keys.ParseOwner] = PFUser.currentUser()!.objectId!
            
            if !editingBeer {  // so this is a new beer listing
            
                ParseClient.sharedInstance.postBeer(swopDict) { success, error in
                    if success {
                        print("yessir")
                        
                    } else {
                    
                        print("bigtime error-- \(error)")
                    }
                }
            } else {  // so this is an existing listing that needs to be updated on parse
            
                swopDict[Beer.Keys.ParseID] = currentBeer?.dbID
                
                ParseClient.sharedInstance.updateSwop(swopDict) { success, error in
                    if success {
                        self.displayGenericAlert("Success--", message: "Your beer details were updated.")
                        // save coredate here or at end of client call
                    } else {
                        self.displayGenericAlert("Error--", message: error!)
                    }
                }
            }
            navigationController!.popViewControllerAnimated(true)
        }
    }
    
    @IBAction func watchlistButtonTap(sender: UIButton) {
        
        if currentBeerDisplay.text! == "" || currentBeerBrewer.text! == "" {
            displayGenericAlert("Please enter a beer name and brewer.", message: "")
        } else {
            var watchDict = [String: AnyObject]()
            watchDict[Beer.Keys.Lat] = 50.0
            watchDict[Beer.Keys.Lon] = 50.0
            watchDict[Beer.Keys.Name] = currentBeerDisplay.text!
            watchDict[Beer.Keys.Brewer] = currentBeerBrewer.text!
            watchDict[Beer.Keys.Vessel] = ""
            watchDict[Beer.Keys.BornOn] = false
            watchDict[Beer.Keys.DrinkDate] = ""
            watchDict[Beer.Keys.Descrip] = getWatcherNotes()
            watchDict[Beer.Keys.BrewDBID] = currentHalfBeer?.id ?? ""
            watchDict[Beer.Keys.ParseID] = ""
            
            sharedContext.performBlockAndWait() {
                let newBeer = Beer(dict: watchDict, context: self.sharedContext)
                newBeer.watcher = User.thisUser
            
                CoreDataStackManager.sharedInstance().saveContext()
            }
            
            navigationController!.popViewControllerAnimated(true)
        }
    }
    
    @IBAction func beerDateSwitchToggled(sender: UISwitch) {
        drinkBy = !drinkBy
    }
    
    @IBAction func homebrewSwitchToggled(sender: AnyObject) {
        isHomeBrew = !isHomeBrew
        currentBeerBrewer.hidden = !isHomeBrew
        currentBeerDisplay.hidden = !isHomeBrew
        currentBeerBrewer.text = ""
        currentBeerDisplay.text = ""
        currentHalfBeer = nil
        searcher.hidden = isHomeBrew
    }
    // MARK: - UITextView delegate methods:
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView == beerNotes {
            if !wasEdited {
                textView.text = ""
                wasEdited = true
            }
        }
    }
    
    // MARK: - UITextField delegate methods:
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if textField == beerMonth || textField == beerDay || textField == beerYear {
            //store the unedited contents of textfield
            var entered: NSString = textField.text!
            
            //Allow edit to happen only if new text will be fewer than 3 numbers long
            if (entered.length - range.length + (string as NSString).length) < 3 {
                entered = entered.stringByReplacingCharactersInRange(range, withString: string)
                return true
            }
            return false
        }
        return true
    }
    
    // MARK: - UITableView delegate methods:
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return halfBeerResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let beerCell = tableView.dequeueReusableCellWithIdentifier("beerCell") as! BeerCell
        
        let halfBeer = halfBeerResults[indexPath.row]
        beerCell.beerName.text = halfBeer.name
        beerCell.brewery.text = halfBeer.maker
        
        return beerCell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        currentBeerBrewer.hidden = false
        currentBeerDisplay.hidden = false
        
        currentHalfBeer = halfBeerResults[indexPath.row]
        currentBeerDisplay.text = currentHalfBeer!.name
        currentBeerBrewer.text = currentHalfBeer!.maker
        
        tableView.hidden = true
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
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        vesselType = row
    }
    
    // MARK: - LocationDelegate method:
    
    func setBeerLoc(site: CLLocationCoordinate2D?) {
        beerAt = site
        if site != nil {
            beerLocButton.setTitle("Change location", forState: .Normal)
        }
    }
    
    // MARK: - Helpers
    
    func validateSwopFields() -> Bool {
        if currentBeerDisplay.text! == "" || currentBeerBrewer.text! == "" || vesselType == 0 || beerAt == nil {
            displayGenericAlert("Please enter more info to swop your beer--", message: "At the least, you must enter the beer's name, brewer, location, and container.  If you can, add a freshness date and some notes.")
            return false
        }
        return true
    }
    
    func tryForDate() -> String {
        if let month = beerMonth.text, day = beerDay.text, year = beerYear.text {
            if Int(month) < 13 && Int(day) < 32 {
                return "\(month)-\(day)-\(year)"
            }
        }
        return "No Date"
    }
    func tryForNotes() -> String {
        if homebrewSwitch.on {
            return !wasEdited ? "" : beerNotes.text
        }
        return !wasEdited ? currentHalfBeer!.notes : beerNotes.text
        
    }
    func getWatcherNotes() -> String {
        if wasEdited {
            return beerNotes.text!
        }
        return currentHalfBeer?.notes ?? ""
    }
}
