//
//  ViewController.swift
//  XHWeiBoPopDemo
//
//  Created by chenyk on 2018/11/30.
//  Copyright © 2018 陈宇科. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cover = UIImageView.init(frame: UIScreen.main.bounds)
        cover.image = UIImage.init(named: "iv_bg.jpg")
        cover.isUserInteractionEnabled = true
        view.addSubview(cover)
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let pop =  XHPopAnimationManger.initWithStyle(popStyle: .XHPopFromBottom, dissMissStyle: .XHDissMissToBottom)
        pop.showButtons()
    }
}

