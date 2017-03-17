//
//  TimeLineTableVC.swift
//  GraduationProject
//
//  Created by 윤민섭 on 2017. 3. 17..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class TimeLineTableVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setUpView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - set Table

    func setTableView(){
        self.tableView.rframe(x: 0, y: 0, width: 375, height: 627)
        self.tableView.bounces = false
        self.tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func setUpView(){
     
    }
    
  
}

// MARK: - extension tableVC

extension TimeLineTableVC{

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row % 2 {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "timelineCell", for: indexPath) as! TimeLineCell
            cell.selectionStyle = .none
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "spaceCell", for: indexPath) as! SpaceCell
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row % 2 {
        case 0:
            let textHeight = UILabel()
            let picHeight = UIImageView()
            textHeight.rframe(x: 10, y: 60, width: 375, height: 0)
            textHeight.setLabel(text: "", align: .left, fontName: "AppleSDGothicNeo-Medium", fontSize: 11, color: UIColor.black)
            textHeight.text = "윤민섭"
            textHeight.sizeToFit()
            
            picHeight.rframe(x: 0, y: textHeight.y+textHeight.height+10, width: 375, height: 375)
            picHeight.image = UIImage(named: "gguggu")
            
            // indexPath.row 가 사진이 있으면 없으면 으로 구분한다.
            
            if indexPath.row == 0 {
                return picHeight.y+picHeight.height+50
            }
            return textHeight.y+textHeight.height+10
            
        default:
            return 7
        }
    }
    
}
