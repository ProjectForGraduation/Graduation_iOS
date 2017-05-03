//
//  ReplyVC.swift
//  GraduationProject
//
//  Created by 전한경 on 2017. 5. 3..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class ReplyVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    
    var replyContent: [ReplyList] = [ReplyList(profileImg: "",userName: "한경이",reply: "안녕하세요1",writeTime: "20160726"),ReplyList(profileImg: "",userName: "한경이2",reply: "안녕하세요2",writeTime: "20160727"),ReplyList(profileImg: "",userName: "한경이3",reply: "안녕하세요3",writeTime: "20160728")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableView()
        
    }
    
    func setTableView(){
        self.tableView.rframe(x: 0, y: 355, width: 375, height: 312)
        self.tableView.bounces = false
        self.tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    

}

// MARK: - extension tableVC

extension ReplyVC{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "replyCell", for: indexPath) as! ReplyCell
        
        cell.profileImg.image = UIImage(named:"default")
        cell.userName.text = replyContent[indexPath.row].userName
        cell.writeTime.text = replyContent[indexPath.row].writeTime
        cell.reply.text = replyContent[indexPath.row].reply
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return 100
    }
    
}
