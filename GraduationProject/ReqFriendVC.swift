//
//  ReqFriendVC.swift
//  GraduationProject
//
//  Created by 윤민섭 on 2017. 5. 21..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class ReqFriendVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var reqFriendList : [ReceivedFriendList] = []
    var reqProfileImage : [UIImage] = []
    var apiManager = ApiManager()
    var users = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "tvNEnjoystoriesM", size: 27)!]
        tableViewinit()
        viewInit()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableViewinit(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.bounces = false
        self.tableView.rframe(x: 0, y: 0, width: 375, height: 667)
        self.tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.showsVerticalScrollIndicator = false
    }
    
    func viewInit(){
        apiManager.setApi(path: "/relation/receive", method: .get, parameters: [:], header: ["authorization":users.string(forKey: "token")!])
        apiManager.requestReceiveFriend { (receivedFriendList) in
            self.reqFriendList = receivedFriendList
            for i in 0..<self.reqFriendList.count{
                self.reqProfileImage.append(UIImage(data: NSData(contentsOf: NSURL(string: self.reqFriendList[i].profile_dir!) as! URL)! as Data)!)
            }
            self.tableView.reloadData()
        }
    }
    
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }

}

extension ReqFriendVC {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reqFriendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reqFriendCell", for: indexPath) as! ReqFriendCell
        cell.selectionStyle = .default
        cell.imageView?.image = reqProfileImage[indexPath.row]
        cell.textLabel?.text = reqFriendList[indexPath.row].user_name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.multiplyHeightRatio()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
   
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let agree = UITableViewRowAction(style: .normal, title: "수락") { action, index in
            // 승낙했을 때
            self.apiManager.setApi(path: "/relation/receive", method: .post, parameters: ["opponent_id":self.reqFriendList[indexPath.row].req_user_id!], header: ["authorization":self.users.string(forKey: "token")!])
            self.apiManager.requestFriend(completion: { (code) in
                print(code)
                self.reqFriendList.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            })
        }
        let delete = UITableViewRowAction(style: .default, title: "삭제") { action, index in
            // 거절했을 때
            self.apiManager.setApi(path: "/relation", method: .post, parameters: ["opponent_id":self.reqFriendList[indexPath.row].req_user_id!], header: ["authorization":self.users.string(forKey: "token")!])
            self.apiManager.requestFriend(completion: { (code) in
                print(code)
                self.reqFriendList.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            })
            
        }
        return [delete, agree]
    }
}
