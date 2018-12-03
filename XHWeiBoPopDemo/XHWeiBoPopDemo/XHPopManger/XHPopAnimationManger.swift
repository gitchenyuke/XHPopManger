//
//  XHPopAnimationManger.swift
//  XHWeiBoPopDemo
//
//  Created by chenyk on 2018/11/30.
//  Copyright © 2018 陈宇科. All rights reserved.
//

import UIKit
import pop

fileprivate let kAnimationDelay = 0.025
fileprivate let kSpringFactor: CGFloat = 6
fileprivate let ScreenWidth:CGFloat  = UIScreen.main.bounds.size.width
fileprivate let ScreenHeight:CGFloat = UIScreen.main.bounds.size.height

//当前视图的view
let kRootView = UIApplication.shared.keyWindow?.rootViewController?.view

enum XHPopStyle {
    case XHPopFromTop  // 从下往下弹出
    case XHPopFromBottom // 从下往上弹出
}

enum XHDissMissStyle {
    case XHDissMissToTop  // 往上移除
    case XHDissMissToBottom // 往下移除
}

class XHPopAnimationManger: UIView {
    
    private let buttonsInfo = [["imageName": "tabbar_compose_idea", "title": "文字" ],
                               ["imageName": "tabbar_compose_photo", "title": "照片/视频"],
                               ["imageName": "tabbar_compose_weibo", "title": "长微博"],
                               ["imageName": "tabbar_compose_lbs", "title": "签到"],
                               ["imageName": "tabbar_compose_review", "title": "点评"],
                               ["imageName": "tabbar_compose_more", "title": "更多"]]

    var popstyle: XHPopStyle = .XHPopFromTop
    
    var dissmissstyle: XHDissMissStyle = .XHDissMissToTop
    
    var labTitle: UILabel!
    
    class func initWithStyle(popStyle: XHPopStyle,dissMissStyle: XHDissMissStyle) -> XHPopAnimationManger {
        
        let view = XHPopAnimationManger.init(frame: UIScreen.main.bounds)
        view.popstyle = popStyle
        view.dissmissstyle = dissMissStyle
        view.initUI()
        return view
    }
    
    func initUI() {
        /// 添加毛玻璃效果
        let blur = UIBlurEffect.init(style: .light)
        /// 毛玻璃视图
        let visual = UIVisualEffectView.init(effect: blur)
        visual.frame = self.bounds
        self.addSubview(visual)
        initTitle()
        initButtons()
        setFrameTitle()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hideButtons()
    }
    
    /// 添加button
    func initButtons() {
        
        let buttonSize = CGSize.init(width: 100, height: 100)
        let margin = (ScreenWidth - 3 * buttonSize.width)/4
        
        for i in 0..<buttonsInfo.count {
            
            let dict = buttonsInfo[i]
            guard let imageName = dict["imageName"],
                let title = dict["title"] else {
                    continue
            }
            
            let button = CompostButton.initTypeButton(imageName:imageName,title:title)
            self.addSubview(button)
            
            let col = i % 3
            let row = i / 3
            
            let margin2 = col>0 ? margin : 0
            
            let x = margin + (buttonSize.width + margin2) * CGFloat(col)
            var y: CGFloat = 0
            /// + 70 是labTitle的高度30 + 距离button间隔 40
            if popstyle == .XHPopFromBottom {
                y = row > 0 ? (ScreenHeight + 70 + (buttonSize.height + 20) * CGFloat(row)) : ScreenHeight + 70
            }else{
                y = row > 0 ? ( -100 - (buttonSize.height + 20) * CGFloat(row)) : -100
            }
            button.frame = CGRect(x: x, y: y, width: buttonSize.width, height: buttonSize.height)
        }
    }
    
    /// 标题
    func initTitle() {
        labTitle = UILabel.init()
        labTitle.textColor = UIColor.white
        labTitle.textAlignment = .center
        labTitle.font = UIFont.boldSystemFont(ofSize: 18)
        labTitle.text = "让精彩填满生活"
        self.addSubview(labTitle)
    }
    
    func setFrameTitle() {
        if popstyle == .XHPopFromBottom {
            labTitle.frame = CGRect(x: 0, y: ScreenHeight, width: ScreenWidth, height: 30)
        }else{
            labTitle.frame = CGRect(x: 0, y: -220 - 70, width: ScreenWidth, height: 30)
            self.insertSubview(labTitle, aboveSubview: self)
        }
    }
    
    /// 弹出按钮
    func showButtons() {
        
        let window = UIApplication.shared.keyWindow
        window?.addSubview(self)
        
        /// 正向遍历
        for (i , btn) in self.subviews.enumerated() {
            
            if btn.isKind(of: CompostButton.self) || btn.isKind(of: UILabel.self) {
                // 创建动画 根据Y轴
                let anim: POPSpringAnimation = POPSpringAnimation.init(propertyNamed: kPOPLayerPositionY)
                // 弹力系数，取值范围 0~20，数值越大，弹性越大，默认数值为4
                anim.springBounciness = kSpringFactor
                // 弹力速度，取值范围 0~20，数值越大，速度越快，默认数值为12
                anim.springSpeed = kSpringFactor
                
                // 设置动画启动时间
                anim.beginTime = CACurrentMediaTime() + CFTimeInterval.init(i) * kAnimationDelay
                
                btn.pop_add(anim, forKey: nil)
                anim.fromValue = btn.center.y
                if popstyle == .XHPopFromBottom {
                    anim.toValue = btn.center.y - ScreenHeight / 2 - 290 / 2
                }else{
                    anim.toValue = btn.center.y + ScreenHeight / 2 + 290 / 2
                }
            }
        }
    }
    
    
    /// 隐藏按钮
    func hideButtons() {
        /// 执行动画时设置相关view不能被点击
        kRootView?.isUserInteractionEnabled = false
        self.isUserInteractionEnabled = false
        
        if dissmissstyle == .XHDissMissToTop {
            self.insertSubview(labTitle, aboveSubview: self)
        }
        
        // 反向遍历
        for (i , btn) in self.subviews.enumerated().reversed() {
            
            if btn.isKind(of: CompostButton.self) || btn.isKind(of: UILabel.self) {
                // 创建动画
                let anim: POPSpringAnimation = POPSpringAnimation.init(propertyNamed: kPOPLayerPositionY)
                
                anim.fromValue = btn.center.y
                
                if dissmissstyle == .XHDissMissToBottom {
                    anim.toValue = btn.center.y + ScreenHeight / 2 + 290 / 2
                }else{
                    anim.toValue = btn.center.y - ScreenHeight / 2 - 290 / 2
                }
                
                // 弹力系数，取值范围 0~20，数值越大，弹性越大，默认数值为4
                anim.springBounciness = kSpringFactor
                // 弹力速度，取值范围 0~20，数值越大，速度越快，默认数值为12
                anim.springSpeed = kSpringFactor
                
                // 设置动画时间
                anim.beginTime = CACurrentMediaTime() + CFTimeInterval(self.subviews.count - i) * kAnimationDelay
                
                btn.layer.pop_add(anim, forKey: nil)
                
                if i == 1 { // 因为添加了visual毛玻璃 所以self.subviews.count 多了1
                    anim.completionBlock = { [weak self] _, _ in
                        /// 动画执行完毕 当前view设为可点击
                        kRootView?.isUserInteractionEnabled = true
                        self?.removeFromSuperview()
                    }
                }
            }
        }
    }
}
