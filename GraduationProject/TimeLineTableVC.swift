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
    
    final let hasImage :String = "http://0"
    
    // MARK: - location
    var locationManager = LocationManager()
    var locValue: Dictionary<String,Double> = [:]
    var locationTimer = Timer()
    static var index: Int = 0
    
    // temp
    var liked : [Bool] = [true,false,true,true,true,true,true,false,false,true]
    
    //Api
    
    var apiManager = ApiManager()
    var timeLineContent: [ContentList] = []
    
    // userdefaults
    let users = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        print(users.string(forKey: "token")!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpView()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - set Table

    func setTableView(){
        self.tableView.rframe(x: 0, y: 0, width: 375, height: 625)
        self.tableView.bounces = false
        self.tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func setUpView(){
        //locationTimer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(updateLocation), userInfo: nil, repeats: true)
        // 일단 15초
        apiManager.setApi(path: "/contents/all", method: .get, parameters: [:], header: [:])
        apiManager.requestContents { (ContentList) in

            self.timeLineContent = ContentList
            
            self.tableView.reloadData()
        }
        

    }
    
    func updateLocation(){
        // 로그인한 사람의 아이디 값을 받는다.
        let userId: String = ""
        locValue = locationManager.getUserLocation()
        print(locValue)
        locationManager.setLocationDB(userId)
    }
    
    func openMap(){
        // index/2에 해당하는 lati 와 longi 를 받아서 넘긴다.
        print(TimeLineTableVC.index)
        MapVC.latitude = 37.676357
        MapVC.longitude = 126.773339
        performSegue(withIdentifier: "MapSegue", sender: self)
    }
    
    func userBtnAction(){
        print("1")
    }
    
}


// MARK: - extension tableVC

extension TimeLineTableVC{

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeLineContent.count*2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row % 2 {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "timelineCell", for: indexPath) as! TimeLineCell
            cell.selectionStyle = .none
            cell.index = indexPath.row
            cell.content_id = timeLineContent[indexPath.row/2].contentId!
            cell.user_id = timeLineContent[indexPath.row/2].userId!
   
            
            // 좋아요
            cell.isLiked = liked[indexPath.row/2]
            
            
            cell.userName.setTitle(timeLineContent[indexPath.row/2].userName!, for: .normal)
            cell.userName.contentHorizontalAlignment = .left
            cell.userName.addTarget(self, action: #selector(userBtnAction), for: .touchUpInside)
            if timeLineContent[indexPath.row/2].contentImage! != hasImage{
                //cell.contentPic.image = UIImage(data: NSData(contentsOf: NSURL(string: timeLineContent[indexPath.row/2].contentImage!) as! URL)! as Data)!
            }else{
                //cell.contentPic.image = nil
            }
            cell.contentText.text = timeLineContent[indexPath.row/2].contentText!
            cell.contentText.sizeToFit()
            
            cell.mapBtn.addTarget(self, action: #selector(openMap), for: .touchUpInside)
            
            if (timeLineContent[indexPath.row/2].contentImage! == hasImage){
                cell.anotherBtnUp()
            }else{
                cell.anotherBtnDown()
            }
            
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
            
            picHeight.rframe(x: 0, y: (textHeight.y+textHeight.height+10).remultiplyHeightRatio(), width: 375, height: 375)
            picHeight.image = UIImage(named: "gguggu")
            
            // indexPath.row 가 사진이 있으면 없으면 으로 구분한다.
           
            if timeLineContent[indexPath.row/2].contentImage! == hasImage {
                return (textHeight.y+textHeight.height+50.multiplyHeightRatio())
            }else{
                return (picHeight.y+picHeight.height+50.multiplyHeightRatio())
            }
            
        default:
            return 7.multiplyHeightRatio()
        }
    }
    
}
