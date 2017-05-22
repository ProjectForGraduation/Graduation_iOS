//
//  SearchVC.swift
//  GraduationProject
//
//  Created by 윤민섭 on 2017. 3. 18..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class SearchVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    var tableClickIndex : Int = 0
    var searchActive : Bool = false
    var filtered: [(String,UIImage,Int)] = []
    var userInfo : [UserInfo] = []
    
    var datas : [(name: String,image: UIImage,uid: Int)] = []
    var apiManager = ApiManager()
    var users = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        viewinit()
        tableViewinit()
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "tvNEnjoystoriesM", size: 27)!]
       // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableClickIndex = -1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableViewinit(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.bounces = false
        self.tableView.frame = CGRect(x: 0, y: self.searchBar.y+self.searchBar.height, width: 375.multiplyWidthRatio(), height: 667.multiplyHeightRatio() - (self.searchBar.y+self.searchBar.height))
        self.tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.showsVerticalScrollIndicator = false
    }
    
    func viewinit(){
        apiManager.setApi(path: "/users", method: .get, parameters: [:], header: ["authorization":users.string(forKey: "token")!])
        apiManager.requestAllUsers { (UserInfo) in
            self.userInfo = UserInfo
            for i in 0..<self.userInfo.count{
                let data = (name: self.userInfo[i].user_name!,image: UIImage(data: NSData(contentsOf: NSURL(string: self.userInfo[i].profile_dir!) as! URL)! as Data)!, uid: self.userInfo[i].user_id!)
                self.datas.append(data)
            }
            self.tableView.reloadData()
        }
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.endEditing(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension SearchVC{
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        filtered = datas.filter({ ( text : (name: String, image: UIImage, uid: Int)) -> Bool in
            let tmp: NSString = text.name as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        
        
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        
        self.tableView.reloadData()
    }
    

}

extension SearchVC{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return datas.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FriendCell
        cell.selectionStyle = .default

        if searchActive {
            cell.imageView?.image = filtered[indexPath.row].1
            cell.textLabel?.text = filtered[indexPath.row].0
        } else {
            cell.imageView?.image = datas[indexPath.row].image
            cell.textLabel?.text = datas[indexPath.row].name
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableClickIndex = indexPath.row
        performSegue(withIdentifier: "showUserInfo", sender: self)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showUserInfo"{
            let destination = segue.destination as! UINavigationController
            let targetView = destination.topViewController as! UserTimeLineVC
            if !filtered.isEmpty, searchActive{
                targetView.user_id = filtered[tableClickIndex].2
            }else{
                targetView.user_id = datas[tableClickIndex].uid
            }
        }
    }
}
