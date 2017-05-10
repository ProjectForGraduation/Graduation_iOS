//
//  WriteVC.swift
//  GraduationProject
//
//  Created by 윤민섭 on 2017. 3. 17..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit
import Fusuma

extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

class WriteVC: UIViewController, FusumaDelegate, UITextViewDelegate, UIScrollViewDelegate {
    
    var receivedImg : UIImage = UIImage(named : "defaultPhoto")!
    //var receivedMissionId : Int = 0
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    //var imageView : UIImageView!
    var containerView : UIView!
    //var inputText : UITextView!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var inputText: UITextView!
    
    var placeHolderText : String = "표현해주세요."
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var writeBtn: UIBarButtonItem!
    
    var change : CGFloat = 0.0
    
    var userId : Int = 8
    var apiManager = ApiManager2()
    
    let users = UserDefaults.standard
    
    var hasImage : Int = 0
    
    
    var locationManager = LocationManager()
    var locValue: Dictionary<String,Double> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "tvNEnjoystoriesM", size: 27)!]
        // Do any additional setup after loading the view.
        self.inputText.delegate = self
        

        setUpView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //imageView.image = receivedImg
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setUpView(){
        
        //containerView = UIView(frame: CGRect(x: 0*widthRatio, y: 0*heightRatio, width: 375*widthRatio, height: (UIScreen.main.bounds.size.height)))
        
        scrollView.frame = CGRect(x: (0*widthRatio), y: (0*heightRatio), width: 375*widthRatio, height: UIScreen.main.bounds.size.height)
        scrollView.contentSize = CGSize(width:375*widthRatio ,height:UIScreen.main.bounds.size.height)
        scrollView.delegate = self
        //scrollView.backgroundColor = UIColor.blue
        scrollView.bounces = false
        scrollView.isScrollEnabled = true
        scrollView.isPagingEnabled = true
        scrollView.isUserInteractionEnabled = true
        
        inputText.frame = CGRect(x: (23*widthRatio), y: (82*heightRatio), width: 330*widthRatio, height: (30)*heightRatio)
        inputText.font = UIFont(name: "tvn_light", size: 13*widthRatio)
        inputText.backgroundColor = UIColor.clear
        inputText.textColor = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        inputText.text = placeHolderText
        //inputText.layer.borderWidth = 0.3
        //inputText.isScrollEnabled = false
        
        //imageView = UIImageView(frame: CGRect(x: 20*widthRatio, y: 560*heightRatio, width: 335*widthRatio, height: (300*heightRatio)))
        
        
        imageView.frame = CGRect(x: 20*widthRatio, y: 250*heightRatio, width: 335*widthRatio, height: (300*heightRatio))
        imageView.image = receivedImg
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(imageTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        
    }
    
    func imageTapped(){
        
        // Show Fusuma
        let fusuma = FusumaViewController()
        
        fusuma.delegate = self
        fusuma.cropHeightRatio = 1.0
        fusumaCropImage = false
        fusumaTintColor = UIColor.darkGray
        fusumaBackgroundColor = UIColor.darkGray
        //
        self.present(fusuma, animated: false, completion: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with: UIEvent?) {
        inputText.endEditing(true) // textBox는 textFiled 오브젝트 outlet 연동할때의 이름.
        
        //self.view.frame.origin.y = 0
        //항상 일반 한글 키보드 시점으로 맞춰주어 emoji keyboard 끝나고 바깥 부분을 터치해도 문제가 없음.
        //self.emojiFlag = 0
    }
    
    //MARK: textView에 placeholder 넣기
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n"{
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == placeHolderText{
            textView.textColor = UIColor.black
            textView.text = ""
        }
        textView.becomeFirstResponder()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == ""{
            textView.textColor = UIColor.gray
            textView.text = placeHolderText
        }
        textView.resignFirstResponder()
    }
    func textViewDidChange(_ textView: UITextView) {
        
        var frame = self.inputText.frame
        change = self.inputText.contentSize.height
        frame.size.height = change
        self.inputText.frame = frame
        
        //self.inputText.contentSize.height
        //
        
        
        let imageWidth = CGFloat((imageView.image?.size.width)!)
        let imageHeight = CGFloat((imageView.image?.size.height)!)
        
        if imageWidth > imageHeight {
            imageView.frame = CGRect(x: 20*widthRatio, y: (change+200)*heightRatio, width: 335*widthRatio, height: (335*imageHeight/imageWidth)*heightRatio)
        }else if imageWidth < imageHeight{
            imageView.frame = CGRect(x: (view.frame.width/2 - (400*imageWidth/imageHeight/2))*widthRatio, y: (change+130)*heightRatio, width: (400*imageWidth/imageHeight)*widthRatio, height: 400*heightRatio)
        }else{
            imageView.frame = CGRect(x: 20*widthRatio, y: (change+170)*heightRatio, width: 335*widthRatio, height: 335*heightRatio)
        }
        
        scrollView.contentSize = CGSize(width:375*widthRatio ,height:(imageView.y+imageView.height+50)*heightRatio)
        
        
    }
    
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func writeBtnAction(_ sender: UIButton) {
        
        
        updateLocation()
        let lat = locValue["latitude"]
        let lng = locValue["longitude"]
        
        apiManager.setApi(path: "/contents", method: .post, parameters: [:], header: ["authorization":users.string(forKey: "token")!])
        
        apiManager.requestWrite(imageData: self.resizing(imageView.image!)!, text: inputText.text, share: 1, location: 1, hasImage: hasImage, lng: lng!, lat: lat!) { (resp) in
            
            if resp == 0{
                
                self.dismiss(animated: true, completion: nil)
            
            }else{
            
                self.basicAlert(title: "실패", message: "게시물 업로드에 실패하였습니다.")
                
            }
        }
        
        
        
        
    }
    
    func updateLocation(){
        
        locValue = locationManager.getUserLocation()
    }
    
    
    // MARK: FusumaDelegate Protocol
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        switch source {
        case .camera:
            print("Image captured from Camera")
        case .library:
            print("Image selected from Camera Roll")
        default:
            print("Image selected")
        }
        
        
        let imageWidth = CGFloat((image.size.width))
        let imageHeight = CGFloat((image.size.height))
        
        if imageWidth > imageHeight {
            imageView.frame = CGRect(x: 20*widthRatio, y: (change+200)*heightRatio, width: 335*widthRatio, height: (335*imageHeight/imageWidth)*heightRatio)
        }else if imageWidth < imageHeight{
            imageView.frame = CGRect(x: (view.frame.width/2 - (400*imageWidth/imageHeight/2))*widthRatio, y: (change+130)*heightRatio, width: (400*imageWidth/imageHeight)*widthRatio, height: 400*heightRatio)
        }else{
            imageView.frame = CGRect(x: 20*widthRatio, y: (change+170)*heightRatio, width: 335*widthRatio, height: 335*heightRatio)
        }
        
        scrollView.contentSize = CGSize(width:375*widthRatio ,height:(imageView.y+imageView.height+50)*heightRatio)
        
        imageView.image = image
        hasImage = 1
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        print("video completed and output to file: \(fileURL)")
        //self.fileUrlLabel.text = "file output to: \(fileURL.absoluteString)"
    }
    
    func fusumaDismissedWithImage(_ image: UIImage, source: FusumaMode) {
        switch source {
        case .camera:
            print("Called just after dismissed FusumaViewController using Camera")
            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
        case .library:
            print("Called just after dismissed FusumaViewController using Camera Roll")
        default:
            print("Called just after dismissed FusumaViewController")
        }
        
        //performSegue(withIdentifier: "writeSegue", sender: self)
    }
    
    func fusumaCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
        
        let alert = UIAlertController(title: "Access Requested", message: "Saving image needs to access your photo album", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (action) -> Void in
            
            if let url = URL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.shared.openURL(url)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func fusumaClosed() {
        
        print("Called when the close button is pressed")
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func resizing(_ image: UIImage) -> Data?{
        
        
        
        let resizedWidthImage = image.resized(toWidth: 1080)
        
        let resizedData = UIImageJPEGRepresentation(resizedWidthImage!, 0.25)
        
        
        
        return resizedData
        
    }
    
    func basicAlert(title : String,message : String){
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "네", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            alertView.dismiss(animated: true, completion: nil)
        })
        
        alertView.addAction(action)
        
        alertWindow(alertView: alertView)
    }
    
    func alertWindow(alertView: UIAlertController){
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindowLevelAlert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alertView, animated: true, completion: nil)
    }

    
}
