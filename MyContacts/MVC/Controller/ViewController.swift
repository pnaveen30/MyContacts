//
//  ViewController.swift
//  MyContacts
//
//  Created by Laxmikanth Reddy on 07/10/18.
//  Copyright © 2018 Naveen. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseStorage

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UISearchBarDelegate{

    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var phoneTF: UITextField!
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var countryLbl: UILabel!
    
    
    var countryNameArr = [CName]()
    var filterArr = [CName]()
    var countryTV : UITableView!
    var searchBar:UISearchBar!
    var profileImage = UIImage()
    
    var searchActive = false
    var popOver = Popover()
    var countryView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.countryTV = UITableView(frame: CGRect(x: 0, y: 50, width: self.view.frame.size.width-100, height: self.view.frame.size.height-250), style: .plain)
        self.countryTV.register(UITableViewCell.self, forCellReuseIdentifier: "country")
        self.countryTV.delegate = self
        self.countryTV.dataSource = self
        self.countryView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width-100, height: self.view.frame.size.height-200))
        self.searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.countryView.frame.size.width, height: 48))
        self.countryView.addSubview(searchBar)
        self.countryView.addSubview(countryTV)
        
        self.name.delegate = self
        self.lastName.delegate = self
        self.phoneTF.delegate = self
        
        // for country details service call
        CountryNameService.getCountryDetails(success: { (data) in
            self.countryNameArr = data
            self.countryTV.reloadData()
        }) { (error) in
            print(error)
        }
  
    }

   
@IBAction func saveBtn_tap(_ sender: Any) {
        self.view.endEditing(true)
    if validParams() == false{
        return
    }else{
    if(Connectivity.isConnectedToInternet()){
        ANLoader.showLoading()
        FirebaseServiceCalls.storeUserInformation(firstName: self.name.text!, lastName: self.lastName.text!, email: self.email.text!, country: self.countryTF.text!, phoneNum: self.phoneTF.text!, contactImg: self.imageView.image!, success: { (upload) in
            ANLoader.hide()
            if(upload == true){
                FirebaseServiceCalls.getUserInformation(success: { (person) in
                    
                }, onError: { (error) in
                
                })
                print("succes fully uploaded")
                ANLoader.hide()
                let alert = UIAlertController(title: "Success", message: "Contact Created Successfully", preferredStyle: .alert)
                let action =  UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                       self.navigationController?.popViewController(animated: true)
                })
                alert.addAction(action)
                 self.present(alert, animated: true, completion: nil)
                
            }
        }) { (error) in
            if(error == true){
                self.showAlert(msg: "Data upload failed")
                ANLoader.hide()
            }
        }
        
    }else{
            self.showAlert(msg: "No Network")
        }
    }
}

    func validParams() -> Bool{
        
        let nameString = Validations.nameValidations(textField: self.name)
        let lastNameString = Validations.nameValidations(textField: self.lastName)
        let phoneNumString = Validations.phoneNumValidation(textField: self.phoneTF)
        let emailString = Validations.emailValidation(textField: self.email)
        let imageString = Validations.imageValidation(image: self.imageView)
        if(nameString != "true"){
            showAlert(msg: nameString)
            return false
        }
        if(lastNameString != "true"){
            showAlert(msg: LastName)
            return false
        }
        if(emailString != "true"){
            showAlert(msg: emailString)
            return false
        }
        if(phoneNumString != "true"){
            showAlert(msg: phoneNumString)
            return false
        }
        if(imageString != "true"){
            showAlert(msg: imageString)
            return false
        }
        return true
    }
    
    @IBAction func countryBtn_tap(_ sender: Any) {
        popOver.showAsDialog(self.countryView)
        self.searchBar.delegate = self
    }
    
    func showAlert(msg:String){
        let alert = UIAlertController(title: Error, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func imagePiceBtn_tap(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // MARK :- Image picker Delegate method
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let tempImage:UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
               imageView.image=tempImage
            self.profileImage = tempImage
            self.dismiss(animated: true, completion: nil)
    }
  
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}



extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive == false{
            return self.countryNameArr.count
        }else{
            return self.filterArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.rowHeight = 40
        let cell = tableView.dequeueReusableCell(withIdentifier: "country", for: indexPath)
        cell.textLabel?.textAlignment = .center
        if searchActive == false{
            cell.textLabel?.text = self.countryNameArr[indexPath.row].name
        }else{
            cell.textLabel?.text = self.filterArr[indexPath.row].name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.popOver.dismiss()
        self.searchBar.text = ""
        if searchActive == false{
            self.countryTF.text = self.countryNameArr[indexPath.row].name
            self.countryLbl.text = "+\(self.countryNameArr[indexPath.row].callingCodes[0])"
            self.countryTV.reloadData()
        }else{
            self.countryTF.text = self.filterArr[indexPath.row].name
            self.countryLbl.text = "+\(self.filterArr[indexPath.row].callingCodes[0])"
            searchActive = false
            self.countryTV.reloadData()
        }
        
    }
    
}
extension ViewController{
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = true;
        self.countryTV.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        self.countryTV.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filterArr = countryNameArr.filter({ (text) -> Bool in
            let tmp: NSString = text.name as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if(filterArr.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.countryTV.reloadData()
    }
    
    
}
extension ViewController{
    // MARK: - TextField Delegates.
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.name || textField == self.lastName {
            if(string == " " && textField.text?.count == 0){
                return false;
            }
            let nameStr:NSString = (textField.text! as NSString)
            if(nameStr.length >= 1){
                let code:NSString = nameStr.substring(from: nameStr.length-1) as NSString
                if(code.isEqual(to: " ")){
                    if(string == " "){
                        return false
                    }
                    
                }
                
            }
            let letters = "!~`@#$%^&*-+();:={}[],.<>?\\/\"\'_•¥£€|"
            let cs:CharacterSet = CharacterSet.init(charactersIn: letters)
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            
            return string == filtered
            
        }else if textField == self.phoneTF {
            if(self.phoneTF.text?.count == 0){
                let num = "123456789"
                let checNum = CharacterSet.init(charactersIn: num)
                if (string.rangeOfCharacter(from: checNum) != nil){
                    return true
                }else{
                    return false
                }
                
            }
            
            let currentText = textField.text ?? ""
            
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            return updatedText.containsOnlyCharactersIn(matchCharacters: "0123456789") &&
                updatedText.safelyLimitedTo(length: 10)
            
        }
        
        
        return true
    }
    
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
}
extension String {
    
    // Returns true if the string contains only characters found in matchCharacters.
    func containsOnlyCharactersIn(matchCharacters: String) -> Bool {
        let disallowedCharacterSet =  CharacterSet(charactersIn: matchCharacters).inverted
        return self.rangeOfCharacter(from: disallowedCharacterSet) == nil
    }
    
    
    // Maximum Char
    func safelyLimitedTo(length n: Int)->Bool {
        if (self.count <= n) {
            return true
        }else{
            return false
        }
    }
    
}


