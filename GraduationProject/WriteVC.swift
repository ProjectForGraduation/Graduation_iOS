//
//  WriteVC.swift
//  GraduationProject
//
//  Created by 윤민섭 on 2017. 3. 17..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit
import Fusuma

class WriteVC: UIViewController, FusumaDelegate, UITextViewDelegate, UIScrollViewDelegate {

    var receivedImg : UIImage = UIImage(named : "defaultPhoto")!
    var receivedMissionId : Int = 0
    
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

}
