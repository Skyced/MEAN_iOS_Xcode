//
//  AddFriendViewController.swift
//  meanios_xcode
//
//  Created by cedric jo on 11/17/15.
//  Copyright © 2015 cedric jo. All rights reserved.
//

import Foundation
import UIKit

class AddFriendViewController: UIViewController {
    
    @IBOutlet weak var newFriendNameText: UITextField!
    @IBOutlet weak var newFriendAgeText: UITextField!
    
    @IBAction func AddNewFriendButtonPressed(sender: UIButton) {
        print("ehhelO")
//        var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
//        var session = NSURLSession(configuration: configuration)
//         let urlToReq = NSURL(string: "http://localhost:8000/friends/create")
//            
//            let request: NSMutableURLRequest = NSMutableURLRequest(URL: urlToReq!)
////            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
//            request.HTTPMethod = "POST"
//        let name = "\(newFriendNameText.text)"
//        let age = "\(newFriendAgeText.text)"
//        let bodyData:[String: AnyObject] = [
//            "name" : name,
//            "age" : age ]
//        
//            print("BODY",bodyData)
//            request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
//            let task = session.dataTaskWithRequest(request) {
//                (data, response, error) in
//                print("REQUEST",request.HTTPBody)
//                print("DATA", data)
//                print("RESPONSE = \(response)")
//                print("DATA",NSString(data: data!, encoding: NSUTF8StringEncoding))
//                
//                }
//            task.resume()
//
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration)
        let name = "\(newFriendNameText.text!)"
        let age = "\(newFriendAgeText.text!)"
        let params:[String: AnyObject] = [
            "name" : name,
            "age" : age ]
        
        let url = NSURL(string: "http://localhost:8000/friends/create")
        let request = NSMutableURLRequest(URL: url!)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        let error: NSError?
        do{
            try request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions())
        }
        catch {
            print(error)
        }
        
        let task = session.dataTaskWithRequest(request) {
            data, response, error in
            
            if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    print("response was not 200: \(response)")
                    return
                }
            }
            if (error != nil) {
                print("error submitting request: \(error)")
                return
            }
            
            // handle the data of the successful response here
            do{
                var result = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as? NSDictionary
                print(result)
            }
            catch {
                print(error)
            }
            
        }
        task.resume()

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}