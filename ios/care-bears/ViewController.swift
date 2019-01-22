//
//  ViewController.swift
//  care-bears
//
//  Created by Samuel Echikson on 12/24/18.
//  Copyright © 2018 Samuel Echikson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, FaceDetectDelegate, RekognizeDelegate, WebServerDelegate {
    @IBOutlet weak var timeDisplay: UILabel!
    @IBOutlet weak var backgroundTintView: UIView!
    @IBOutlet weak var tasksPicker: UIPickerView!
    @IBOutlet weak var gaugeView: UIView!
    var isDetailView = false
    let gauge = CAShapeLayer()
    @IBOutlet weak var eyeScannerButton: UIButton!
    @IBOutlet weak var userName: UILabel!
    
    var popoverVC: UIViewController!
    var popoverLabel: UILabel!
    
    let displayDateFormatString = "HH:mm"
    let displayDateFormatter = DateFormatter()
    
    var faceDetection: FaceDetect!
    var rekognition: Rekognize!
    let handSanitizerRPi = RaspberryPiConnect(connectionString: "http://192.168.163.194:5000/handsanitizer")
//    let handSanitizerRPi = RaspberryPiConnect(connectionString: "http://192.168.1.228:3000/handsanitizer")
    @IBOutlet weak var hospitalLogo: UIImageView!
    var hospitalLogoInitialPosition: CGPoint!
    @IBOutlet weak var roomNumberLabel: UILabel!
    var roomNumberLabelInitialPosition: CGPoint!
    
    var webServer: WebServer!

    var tasks: [Task] = [
        Task(title: "Change wound dressing", dueDate: Date().addingTimeInterval(-100000)),
        Task(title: "Electrocardiogram test", dueDate: Date().addingTimeInterval(-50000)),
        Task(title: "Echocardiogram test", dueDate: Date().addingTimeInterval(-10000)),
        Task(title: "Install IV line", dueDate: Date().addingTimeInterval(300)),
        Task(title: "Change wound dressing", dueDate: Date().addingTimeInterval(600)),
        Task(title: "X-ray: chest area", dueDate: Date().addingTimeInterval(28000)),
        Task(title: "CPK test", dueDate: Date().addingTimeInterval(30000)),
        Task(title: "Change wound dressing", dueDate: Date().addingTimeInterval(310000))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.animateSeconds()
        
        tasksPicker.delegate = self
        tasksPicker.dataSource = self
        self.tasksPicker.isHidden = true
        
        self.userName.isHidden = true
        
        self.initGauge()
        
        self.faceDetection = FaceDetect()
        self.faceDetection.delegate = self
        
        self.initPopoverVC()
        
        self.rekognition = Rekognize()
        self.rekognition.delegate = self
        
        self.webServer = WebServer()
        self.webServer.delegate = self
        
        self.displayDateFormatter.dateFormat = self.displayDateFormatString
        
        self.hospitalLogoInitialPosition = CGPoint(x: self.hospitalLogo.center.x, y: self.hospitalLogo.center.y)
        self.roomNumberLabelInitialPosition = CGPoint(x: self.roomNumberLabel.center.x, y: self.roomNumberLabel.center.y)
        
        self.tasksPicker.selectRow(3, inComponent: 0, animated: false)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeRight
    }
    
    func initGauge() {
        self.gauge.path = UIBezierPath(rect: CGRect(x: 0, y: -150, width: 10, height: 300)).cgPath
        self.gauge.fillColor = tasks[3].color.cgColor
        self.gauge.shadowColor = self.tasks[3].color.cgColor
        self.gauge.shadowOffset = .zero
        self.gauge.shadowRadius = 5
        self.gauge.shadowOpacity = 0.85
        self.gauge.shadowPath = self.gauge.path
        self.gaugeView.layer.addSublayer(self.gauge)
        self.view.addSubview(self.gaugeView)
        self.gaugeView.alpha = 0
    }
    
    func initPopoverVC() {
        self.popoverVC = UIViewController()
        self.popoverVC.modalPresentationStyle = UIModalPresentationStyle.popover
        self.popoverVC.preferredContentSize = CGSize(width: 430, height: 60)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        self.popoverVC.view.addSubview(loadingIndicator)
        
        self.popoverLabel = UILabel(frame: CGRect(x: 80, y: 5, width: 270, height: 50))
        self.popoverLabel.text = "Place yourself in front of camera"
        self.popoverLabel.textAlignment = .center
        self.popoverVC.view.addSubview(popoverLabel)
        
    }
    
    func didDetectFace(_ sender: FaceDetect) {
        present(self.popoverVC, animated: true, completion: nil)
        
        let popoverPresentationController = self.popoverVC.popoverPresentationController
        popoverPresentationController?.sourceView = self.eyeScannerButton
        popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: self.eyeScannerButton.frame.size.width, height: self.eyeScannerButton.frame.size.height)
    }
    
    func didDetectFaceInCenter(_ sender: FaceDetect, selfie: UIImage) {
        print("Face in Center! from ViewController.swift")
        self.popoverLabel.text = "Identifying you"
        
        self.rekognition.saveImageToS3(image: selfie)
    }
    
    func didUploadToS3(_ sender: Rekognize) {
        print("Uploaded image to S3! in ViewController.swift")
    }
    
    func didRecognizeFace(_ sender: Rekognize, name: String, confidence: Double) {
        print("Recognized \(name) with confidence \(confidence)")
        self.userName.text = name
        
        self.popoverVC.dismiss(animated: false, completion: nil)
        self.animateDetailsIn()
//        self.lambda.checkIn()
    }
    
    func didNotRecognizeFace(_ sender: Rekognize) {
        DispatchQueue.main.async {
            self.popoverLabel.text = "Could not Identify you"
        }
    }
    
    func taskDone(_ sender: WebServer) {
        self.tasksPicker.selectRow(self.tasksPicker.selectedRow(inComponent: 0) + 1, inComponent: 0, animated: true)
    }
    
    @IBAction func logIn(_ sender: Any) {
        if (self.isDetailView) {
            animatDetailsOut()
        } else {
            animateDetailsIn()
        }
    }
    
    func animateDetailsIn() {
        UIView.animate(withDuration: 1, animations: {
            self.view.layoutIfNeeded()

            self.timeDisplay.center.x -= 250
            self.timeDisplay.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            self.backgroundTintView.alpha = 1
            
            self.hospitalLogo.center = CGPoint(x: 200, y: 80)
            self.roomNumberLabel.center = CGPoint(x: 150, y: self.view.frame.height - 80)
        }) { (_) in
            self.tasksPicker.isHidden = false
            self.isDetailView = true
            self.userName.isHidden = false
            self.handSanitizerRPi.notifyLogIn()
        }
        UIView.animate(withDuration: 0.5, delay: 1, options: [], animations: {
            self.gaugeView.alpha = 1
        })
    }
    
    func animatDetailsOut() {
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.gaugeView.alpha = 0
        }) { (_) in
            self.tasksPicker.isHidden = true
            self.isDetailView = false
            self.userName.isHidden = true
            
            // Reinitialize face detection
            self.faceDetection = FaceDetect()
            self.faceDetection.delegate = self
        }
        
        UIView.animate(withDuration: 1, delay: 0.5, animations: {
            self.timeDisplay.center.x = self.view.center.x
            self.timeDisplay.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.backgroundTintView.alpha = 0.85
            
            self.hospitalLogo.center = self.hospitalLogoInitialPosition
            self.roomNumberLabel.center = self.roomNumberLabelInitialPosition
        })
    }
    
    func animateSeconds() {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        self.timeDisplay.font = UIFont.monospacedDigitSystemFont(ofSize: 154, weight: .light)
        self.timeDisplay.sizeToFit()
        self.timeDisplay.center.x = self.view.center.x
        self.timeDisplay.center.y = self.view.center.y
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (time) in
            self.timeDisplay.text = timeFormatter.string(from: Date())
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tasks.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return UIFont.systemFont(ofSize: 44).lineHeight
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        let titleData = self.displayDateFormatter.string(from: tasks[row].dueDate) + " - " + tasks[row].title
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 34), NSAttributedString.Key.foregroundColor:UIColor.white])
        pickerLabel.attributedText = myTitle
        pickerLabel.textAlignment = .left
        pickerLabel.adjustsFontSizeToFitWidth = true
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("picked \(tasks[row].title)!")
        self.gauge.fillColor = tasks[row].color.cgColor
        self.gauge.shadowColor = self.tasks[row].color.cgColor
    }

}

