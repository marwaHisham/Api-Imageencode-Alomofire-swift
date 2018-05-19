//
//  Form.swift
//  task
//
//  Created by mino on 5/8/18.
//  Copyright © 2018 marwa. All rights reserved.
//

import UIKit
import DropDown
import Alamofire

class Form:UIViewController,MapDelegate ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var dep: UITextField!
    @IBOutlet weak var adStatus: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var duration: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var loc: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var decrip: UITextField!
    @IBOutlet weak var stat_dur: UITextField!
    @IBOutlet weak var map: UITextField!
    var imgDir:String!
  //  var title:String=""
    var Add:String = ""
    var status:Int = 0
    var delegate : MapDelegate!
    var images:[UIImage]!
    var lat:String="" ,lng :String=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
          self.title="اضف اعلان"
    
        images = []
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        // Get the Document directory path
        let documentDirectorPath:String = paths[0]
        // Create a new path Dfor the new images folder
        imgDir = documentDirectorPath.appending("/ImagePicker")
        var objcBool:ObjCBool = true
        let isExist = FileManager.default.fileExists(atPath: imgDir, isDirectory: &objcBool)
        if isExist == false{
            do{
                try FileManager.default.createDirectory(atPath: imgDir,
                withIntermediateDirectories: true, attributes: nil)
            }catch{
                print("Something went wrong while creating a new folder")
            }
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Form.dismissKeyboard))
        view.addGestureRecognizer(tap)
         self.decrip.frame=CGRect(x: self.decrip.frame.minX, y: self.decrip.frame.minY - self.stat_dur.frame.height, width: self.decrip.frame.width, height: self.decrip.frame.height)
        }
         func dismissKeyboard() {
            view.endEditing(true)
        }
    
    
    @IBAction func uploadImag(_ sender: UIButton) {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType =  UIImagePickerControllerSourceType.photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imgData=info[UIImagePickerControllerOriginalImage] as? UIImage
        let imagData:Data = UIImagePNGRepresentation(imgData!)!
        self.img.image=imgData
        let imgStr = imagData.base64EncodedData()
        self.dismiss(animated: true, completion: nil)
        var path=NSData().description
        path=path.replacingOccurrences(of: "", with: "")
        path=imgDir.appending("/\(path).png")
        
        let data=UIImagePNGRepresentation(imgData!)!
        let success=FileManager.default.createFile(atPath: path, contents: data, attributes: nil)
    }


    @IBAction func save(_ sender: AnyObject) {
        if ((name.text! == "")||(dep.text == "")||(price.text == "")||(duration.text == "")||(email.text == "")||(loc.text == "")||(phone.text == "") || decrip.text==""||adStatus.text==""||img == nil){
            print("empty data")
            
            if(status==2){
                if(stat_dur.text! == ""){
                    print("empty data")
                    if(self.stat_dur.text! > "5"){
                        print("days must be lass than 5")
                        
                    }
                }
            }
        }else{
            let parameters = ["title": name.text!, "description": decrip.text! ,"phone":phone.text!,"email":email.text!,"city_name":loc.text!,"price":price.text!,"status":status,"duration":Int(duration.text!)!,"openingsoon_max_days":Int(stat_dur.text!)!,"lat":lat,"lng":lng] as Dictionary<String, Any>

            let url = URL(string: "http://discounts-today-sa.com/api/add-ad")!
            let session = URLSession.shared
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
            }
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                
                guard error == nil else {
                    return
                }
                
                guard let data = data else {
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        print(json)
                    
                    }
                    
                } catch let error {
                    print(error.localizedDescription)
                }
            })
            task.resume()
        
        }
        
        
    
    }
    
    
    @IBAction func depart(_ sender: AnyObject) {
        let dropDown = DropDown()
        dropDown.anchorView = view // UIView or UIBarButtonItem
        dropDown.dataSource = ["ترفية", "العاب"]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.dep.text=item
            self.title="▽"
        }
        dropDown.show()
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!/2)
    }
    
    
    
    @IBAction func ad_status(_ sender: UIButton) {
        let dropDown = DropDown()
        dropDown.anchorView = view
        dropDown.dataSource = ["سيقتح قريبا", "الان"]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if index == 0{
                self.stat_dur.isHidden=false
                self.status=2
                  self.decrip.frame=CGRect(x: self.decrip.frame.minX, y: self.decrip.frame.minY + self.stat_dur.frame.height, width: self.decrip.frame.width, height: self.decrip.frame.height)
              
            }
            else{
                 self.stat_dur.isHidden=true
                  self.decrip.frame=CGRect(x: self.decrip.frame.minX, y: self.decrip.frame.minY -
                    self.stat_dur.frame.height + 10, width: self.decrip.frame.width, height: self.decrip.frame.height)
                }
            print("Selected item: \(self.status) at index: \(index)")
            self.adStatus.text=item
            
        }
        dropDown.show()
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!/2)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
    
    @IBAction func mapv(_ sender: AnyObject) {
        let pvc = storyboard?.instantiateViewController(withIdentifier: "map") as! mapViewController
        pvc.delegate = self
        self.navigationController?.pushViewController(pvc, animated: true)
    }
    
    
    func messageData(data coor: String,lat:String,lng:String){
        self.lng=lng
        self.lat=lat
        Alamofire.request("https://maps.googleapis.com/maps/api/geocode/json?latlng=\(coor.utf8)&key=AIzaSyBoFuIsuiqN3KQlMOXXMshFtXoFAX17KdM").responseJSON { response in
                if let json = response.result.value as? [String:Any]{
                 if let arr = json["results"] as? [Any]{
                    if let dic = arr.first as? [String:Any]{
                        if let address = dic["formatted_address"] as? String{
                            self.Add = address
                        }
                    }
                }
            }
        }
       loc.text=Add
    }
    
    
    
}

