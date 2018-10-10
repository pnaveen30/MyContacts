//
//  DisplayContactsVC.swift
//  MyContacts
//
//  Created by Laxmikanth Reddy on 09/10/18.
//  Copyright © 2018 Naveen. All rights reserved.
//

import UIKit

class DisplayContactsVC: UIViewController,UISearchBarDelegate {
   
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var contactsTV : UITableView!
    var personDetArr = [Person]()
    var filterArr = [Person]()
    var searchActive = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.contactsTV.delegate = self
        self.contactsTV.dataSource = self
        
    }

    override func viewWillAppear(_ animated: Bool) {
        if(Connectivity.isConnectedToInternet()){
            DispatchQueue.main.async {
                self.contactsFromFirebase()
            }
        }else{
            self.showAlert(msg: "No Networl")
        }
    }
    
    @objc func contactsFromFirebase(){
        
            self.personDetArr.removeAll()
            FirebaseServiceCalls.getUserInformation(success: { (success) in
                print(success[0].email)
                self.personDetArr.append(success[0])
              let ascendOrder = self.personDetArr.sorted(by: { (item1, item2) -> Bool in
                    return item1.fName.compare(item2.fName) == ComparisonResult.orderedAscending
                })
                self.personDetArr = ascendOrder
                DispatchQueue.main.async {
                    self.contactsTV.reloadData()
                }
                
            }) { (fail) in
            }
        
    }
    
    func showAlert(msg:String){
        let alert = UIAlertController(title: Error, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func contactAddBtn(_ sender: Any) {
        var contactObj = ViewController()
        contactObj = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.pushViewController(contactObj, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension DisplayContactsVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive == false{
            return personDetArr.count
        }else{
            return filterArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.rowHeight = 80
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsTVCell", for: indexPath) as! ContactsTVCell
        if(filterArr.count>0){
            searchActive = true
        }else{
            searchActive = false
        }
        if searchActive == false{
            cell.nameLbl.text = "\(personDetArr[indexPath.row].fName)"
            cell.mobNumLbl.text = "\(personDetArr[indexPath.row].mobNum)"
            let string = "\(personDetArr[indexPath.row].imageDownloadURL)"
            let url = URL.init(string: string)
            //  let data =  NSData(contentsOf: url!)
            //cell.contactImg.image = UIImage.init(data:data! as Data)
            cell.contactImg.kf.setImage(with: url!)
            // Configure the cell...
        }else{
            cell.nameLbl.text = "\(filterArr[indexPath.row].fName)"
            cell.mobNumLbl.text = "\(filterArr[indexPath.row].mobNum)"
            let string = "\(filterArr[indexPath.row].imageDownloadURL)"
            let url = URL.init(string: string)
            //  let data =  NSData(contentsOf: url!)
            //cell.contactImg.image = UIImage.init(data:data! as Data)
            cell.contactImg.kf.setImage(with: url!)
        }
        return cell
    }
   
    
}
extension DisplayContactsVC{
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar.text == ""{
            searchActive = false;
        }else{
            searchActive = true;
        }
       // self.contactsTV.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text == ""{
            searchActive = false;
        }else{
            searchActive = true;
        }
        searchBar.resignFirstResponder()
        //self.contactsTV.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text == ""{
            searchActive = false;
        }else{
            searchActive = true;
        }
        searchBar.resignFirstResponder()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filterArr = personDetArr.filter({ (text) -> Bool in
            let tmp: NSString = text.fName as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if(filterArr.count > 0){
            searchActive = true;
        } else {
            searchActive = false;
        }
        self.contactsTV.reloadData()
    }

    
}
