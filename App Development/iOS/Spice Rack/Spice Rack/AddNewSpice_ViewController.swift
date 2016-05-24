//
//  AddNewSpice_ViewController.swift
//  Spice Rack
//
//  Created by Matt Dickey on 3/1/16.
//  Copyright © 2016 Matt Dickey. All rights reserved.
//

import UIKit
import RealmSwift


class AddNewSpice_ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate{
    
    // MARK: - Global Variables
    let database = try! Realm()
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var spiceNameTextField: UITextField!
    @IBOutlet weak var volumePurchasedTextField: UITextField!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var percentageLabel: UILabel!
    let numbers = ["",0,1,2,3,4,5,6,7,8,9]
    let units = ["g", "oz"]
    var currentSliderValue = 100
    var selectedPickerValues = ["","","",".","","g"]
    var fullVolumeString = String()
    var userUnit = String()
    var userVolume = Double()
    var volumePicker = UIPickerView(frame: CGRectMake(0, 50, 100, 200))
    
    
    lazy var overlayView: OverlayView = {
        let overlayView = OverlayView()
        return overlayView
    }()
    
    
    // Mark: - Optional properties
    @IBOutlet weak var brandTextField: UITextField!
    
    
    
    // MARK: - @IBActions
    @IBAction func sliderValueChanged(sender: UISlider) {
        currentSliderValue = Int(sender.value)
        percentageLabel.text = String(currentSliderValue) + "%"
        
    }
    @IBAction func showMoreOptions(sender: AnyObject) {
        volumePicker.hidden = true
        brandTextField.hidden = false
    }
    @IBAction func doneButton(sender: UIBarButtonItem) {
        
        
        let userSpiceName = spiceNameTextField.text
        let newSpice = Spice()
        
        if (spiceNameTextField.text!.isEmpty || userVolume == 0.0){
            let alertController = UIAlertController(title: "Can't Save", message:
                "Please enter a name and Net Weight", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            // Required Fields
            newSpice.name = userSpiceName!
            newSpice.unit = userUnit
            newSpice.netWt = userVolume
            newSpice.volumeRemaining = Double(Float(userVolume) * volumeSlider.value/100)
            newSpice.calculatePercentage()
            
            overlayView.displayView(view)
            
            //Optional Fields
            
            if let definiteBrand = brandTextField.text {
                newSpice.brand = definiteBrand
            }

                
                //Handle Spice Image
                switch newSpice.name.lowercaseString {
                    case "basil", "basil, ground", "basil, dried", "dried basil", "ground basil", "marjoram":
                        newSpice.imageName = "basil"
                    
                case "bay leaves", "bay leaf":
                    newSpice.imageName = "bay-leaves"
                    
                case "beige", "mustard, ground", "french fry seasoning", "ginger, ground", "ginger", "cardamom, ground", "cardamom":
                    newSpice.imageName = "beige-powder"
                    
                case "brown sugar":
                    newSpice.imageName = "brown-sugar"
                    
                case "pumpkin pie spice", "nutmeg, ground", "nutmeg":
                    newSpice.imageName = "burnt-orange-powder"
                    
                case "cajun", "cajun seasoning", "crushed red pepper", "red pepper", "cajun creole seasoning", "rub seasoning":
                    newSpice.imageName = "cajun"
                    
                case "cinnamon sticks":
                    newSpice.imageName = "cinnamon-sticks"
                    
                case "coffee", "cloves", "cloves, ground", "cloves, crushed":
                    newSpice.imageName = "dark-brown-powder"
                    
                case "peppercorns", "black peppercorns","whole cardamom seeds", "cardamom seeds, whole":
                    newSpice.imageName = "dark-peppercorns"
                    
                case "red", "ancho chili pepper", "chili powder" :
                    newSpice.imageName = "dark-red-powder"
                    
                case "italian blend", "italian seasoning", "zesty seasoning blend", "zesty seasoning":
                    newSpice.imageName = "dead-leafy"
                
                case "dill", "dill weed":
                    newSpice.imageName = "dillweed"
                    
                case "fennel seed", "fennel":
                    newSpice.imageName = "fennel-seed"
                    
                case "oregano", "dill weed", "parsley", "parsley flakes", "thyme", "thyme leaves":
                    newSpice.imageName = "green-leafy"
                    
                case "cinnamon", "cinnamon, ground", "allspice", "garam masala":
                    newSpice.imageName = "light-brown-powder"
                    
                case "garlic", "garlic powder", "garlic bread sprinkle":
                    newSpice.imageName = "offwhite-powder"
                    
                case "curry", "curry powder", "cayenne":
                    newSpice.imageName = "orange-powder"
                    
                case "paprika", "smoked paprika", "paprika, smoked", "chipotle chile pepper":
                    newSpice.imageName = "red-powder"
                    
                case "rosemary", "rosemary leaves":
                    newSpice.imageName = "rosemary"
                    
                case "pepper", "black ground pepper", "pepper, ground, black", "pepper, black, ground":
                    newSpice.imageName = "pepper"
                    
                case "saffron":
                    newSpice.imageName = "saffron"
                    
                case "salt", "granulated onion", "onion, granulated":
                    newSpice.imageName = "white-crystal"
                
                case "star anise", "anise":
                    newSpice.imageName = "star-anise"
                    
                case "sugar", "garlic salt", "cream of tartar", "ranch powder":
                    newSpice.imageName = "white-powder"
                    
                case "whole cloves", "cloves, whole":
                    newSpice.imageName = "whole-cloves"
                    
                case "coriander", "poultry seasoning", "ground sage","sage, ground", "ground coriander","coriander, ground", "ground coriander seed", "coriander seed, ground", "coriander seed":
                    newSpice.imageName = "yellow-green"
                    
                case "mustard", "cumin", "tumeric":
                    newSpice.imageName = "yellow-powder"
                    
                default:
                    newSpice.imageName = "_"

                }
            
    
            try! database.write({database.add(newSpice)})
            spiceNameTextField.text = nil
            volumePurchasedTextField = nil
            
            
            //performSegueWithIdentifier("doneSegue", sender: nil)
            
        }
        
    }
    @IBAction func exitTap(sender: UITapGestureRecognizer) {
        spiceNameTextField.resignFirstResponder()
        volumePicker.hidden = true
    }
    
    
    // Mark: - My functions
    
    func buildInputView(){
                
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor.customGreenColor()
        toolBar.sizeToFit()
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AddNewSpice_ViewController.dismissPicker))
        
        toolBar.setItems([spaceButton,doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        volumePurchasedTextField.inputView = volumePicker
        volumePurchasedTextField.inputAccessoryView = toolBar
    }
    func dismissPicker(){
        volumePurchasedTextField.resignFirstResponder()
    }
    func convertToGrams (ounces: Double) -> [String]{
        //1oz = 28.35g
        let g = ounces * 28.35
        let limitedg = g.roundToPlaces(1)
        let gString = String(limitedg)
        let separatedComponents = Array(gString.characters)
        var finalComponents = [String]()
        
        for char in separatedComponents{
            let new = String(char)
            finalComponents.append(new)
        }
        
        finalComponents.append("g")
        
        return finalComponents
    }
    func convertToOunces (grams: Double) -> [String]{
        // 1g = .035oz
        let oz = grams * 0.035
        let limitedOz = oz.roundToPlaces(1)
        let ozString = String(limitedOz)
        let separatedComponents = Array(ozString.characters)
        var finalComponents = [String]()
        
        for char in separatedComponents{
            let new = String(char)
            finalComponents.append(new)
        }
        
        finalComponents.append("oz")
        
        return finalComponents
    }


    
    // MARK: - Included
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spiceNameTextField.delegate = self
        self.volumePurchasedTextField.delegate = self
        self.brandTextField.delegate = self
        brandTextField.hidden = true

        self.volumePicker.dataSource = self
        self.volumePicker.delegate = self
        
        buildInputView()
        
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    // MARK: - PickerView
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 6
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 5 {
            return units.count
        }else if component == 3{
            return 1
        }
        else{
            return numbers.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var titleForRow = String()
        
        if component == 3 {
            titleForRow = "."
        } else if component == 5{
            titleForRow = units[row]
        }else{
            titleForRow = String(numbers[row])
        }
        
        return titleForRow
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        fullVolumeString = ""
        volumePurchasedTextField.text = ""
        var rawValueAsString = String()
        
        
        switch component {
        case 0:
            selectedPickerValues[component] = String(numbers[row])
        case 1:
            selectedPickerValues[component] = String(numbers[row])
        case 2:
            selectedPickerValues[component] = String(numbers[row])
        case 3:
            selectedPickerValues[component] = "."
        case 4:
            selectedPickerValues[component] = String(numbers[row])
        case 5:
            selectedPickerValues[component] = units[row]
        default:
            break
        }
        
        //Set the combination of picker values to the textField
        for value in selectedPickerValues {
            fullVolumeString += String(value)
            volumePurchasedTextField.text = fullVolumeString
        }
        
        //Update the data model for the new object
        userUnit = selectedPickerValues[5]
        
        for number in selectedPickerValues[0...4]{
            rawValueAsString += number
        }
        if rawValueAsString != "."{
            userVolume = Double(rawValueAsString)!
        }
    }
    

    
}//End of Class


