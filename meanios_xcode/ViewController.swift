//
//  ViewController.swift
//  meanios_xcode
//
//  Created by cedric jo on 11/13/15.
//  Copyright © 2015 cedric jo. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITableViewDataSource {
    let socket = SocketIOClient(socketURL: "localhost:8000")
    var friends = [Friend]()
    @IBAction func insertNewFriendAndGoBack(segue:UIStoryboardSegue) {
        let sourceVC = segue.sourceViewController as! AddFriendViewController
        let name = sourceVC.newFriendNameText.text
        let age:Int? = Int(sourceVC.newFriendAgeText.text!)
        let newFriend = Friend(name: name!, age: age!)
        friends.append(newFriend)
        socket.emit("NewFriendAdded")
        // create new instance of Friend and append to the Friend Array
        // your code here
        tableView.reloadData()
    }
    @IBOutlet weak var tableView: UITableView!
    //DISPLAYING THE LIST
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        print("HELLO")
        // dequeue the cell from our storyboard
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell")!
        // if the cell has a text label, set it to the model that is corresponding to the row in array
//        print(friends[indexPath.row])
        cell.textLabel?.text = "\(friends[indexPath.row].name! as String) \(friends[indexPath.row].age! as Int)"
        // return cell so that Table View knows 'what to draw in each row
        return cell
    }
    //NUMBER OF ROWS
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        socket.connect()
        socket.on("connect") { data, ack in
            print("iOS SOCKETS")
        }
        // Do any additional setup after loading the view, typically from a nib.
        func parseJSON(inputData: NSData) -> NSArray? {
            do {
                let arrOfObjects = try NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers)
//                print("ARRAY?", arrOfObjects as? NSArray)
                return arrOfObjects as? NSArray
            }
            catch {
                print("Error")
                return nil
            }
            
        }
        if let urlToReq = NSURL(string: "http://localhost:8000/friends") {
            if let data = NSData(contentsOfURL: urlToReq) {
                let arrOfObjects = parseJSON(data)
                for friendz in arrOfObjects! {
                    let object = friendz as! NSDictionary
                    let friendName = object["name"]! as! String
                    let friendAge = object["age"]! as! Int
                    let friend = Friend(name: friendName, age: friendAge)
                    friends.append(friend)
//                    print("SDF", friend)
//                    print("FrieND",friend.age!)
//                    print("OBJECTNAME",object["name"]!)
//                    print("IN LOOP", friends[0].name)
                    
                }
//                print("FRIENDS", friends[0])
//                print(parseJSON(data))
            }
        }
        tableView.dataSource = self
        
        socket.on("NewWebFriendAdded") { data, ack in
            print(data[0])
            if let d = data as Optional {
                let name = d[0]["name"] as! String
                let age = (d[0]["age"] as! NSString).doubleValue
                let newFriend = Friend(name: name, age: Int(age))
                self.friends.append(newFriend)
            }
            self.tableView.reloadData()
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}




