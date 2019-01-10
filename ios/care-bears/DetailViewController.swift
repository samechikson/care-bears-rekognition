//
//  DetailViewController.swift
//  care-bears
//
//  Created by Samuel Echikson on 12/25/18.
//  Copyright © 2018 Samuel Echikson. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    let guageShape = CAShapeLayer()
    @IBOutlet weak var tasksPicker: UIPickerView!
    
    var taskData: [Task] = [
        Task(title: "Task 1", timeLeft: 10000),
        Task(title: "Task 2", timeLeft: 50000),
        Task(title: "Task 3", timeLeft: 1000),
        Task(title: "Task 4", timeLeft: 1000)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasksPicker.delegate = self
        tasksPicker.dataSource = self
        
        guageShape.path = UIBezierPath(rect: CGRect(x: self.view.frame.width - tasksPicker.frame.width - 100, y: self.view.center.y - 150, width: 10, height: 300)).cgPath
        view.layer.addSublayer(guageShape)
        guageShape.fillColor = UIColor.white.cgColor
        
        
        tasksPicker.reloadAllComponents()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return taskData.count
    }
    
//    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
//        return UIFont.systemFont(ofSize: 56).lineHeight + 10
//    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return taskData[row].title
    }
    
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//        var label = UILabel()
//        if let v = view as? UILabel { label = v }
//        label.font = UIFont.systemFont(ofSize: 56)
//        label.text =  taskData[row].title
//        label.textColor = UIColor.white
//        label.textAlignment = .center
//        return label
//    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("picked")
    }

}

class Task {
    var title: String = ""
    var timeLeft: Int = 100000000
    var color: UIColor!
    
    var possibleColors: [UIColor] = [
        UIColor(red: 94/255, green: 199/255, blue: 175/255, alpha: 1),
        UIColor(red: 186/255, green: 225/255, blue: 148/255, alpha: 1),
        UIColor(red: 232/255, green: 242/255, blue: 85/255, alpha: 1),
        UIColor(red: 221/255, green: 171/255, blue: 79/255, alpha: 1),
        UIColor(red: 203/255, green: 106/255, blue: 67/255, alpha: 1)
    ]
    
    init(title: String, timeLeft: Int) {
        self.title = title
        self.timeLeft = timeLeft
        
        self.color = possibleColors.first
    }
    
    
}
