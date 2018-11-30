//
//  CompostButton.swift
//  XHWeiBoPopDemo
//
//  Created by chenyk on 2018/11/30.
//  Copyright © 2018 陈宇科. All rights reserved.
//

import UIKit

class CompostButton: UIView {

    var imagev : UIImageView!
    var title : UILabel!
    
    class func initTypeButton(imageName:String,title:String) -> CompostButton {
        let button = CompostButton.init(frame: .zero)
        button.imagev.image = UIImage.init(named: imageName)
        button.title.text = title
        return button
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imagev = UIImageView.init()
        title  = UILabel.init()
        title.font = UIFont.systemFont(ofSize: 15)
        title.textColor = UIColor.white
        title.textAlignment = .center
        
        self.addSubview(imagev)
        self.addSubview(title)
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        
        imagev.frame = CGRect(x: self.frame.size.width / 2 - 35, y: 0, width: 70, height: 70)
        title.frame = CGRect(x: 0, y: imagev.frame.maxY + 5, width: self.frame.size.width, height: 20)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

}
