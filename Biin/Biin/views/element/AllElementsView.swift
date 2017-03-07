//  AllElementsView.swift
//  biin
//  Created by Esteban Padilla on 10/8/15.
//  Copyright © 2015 Esteban Padilla. All rights reserved.

import Foundation
import UIKit

class AllElementsView: BNView {
    
    var delegate:AllElementsView_Delegate?
    var title:UILabel?
    var backBtn:BNUIButton_Back?
    var scroll:BNScroll?
    var category:BNCategory?
    var spacer:CGFloat = 1

    override init(frame: CGRect, father:BNView?) {
        super.init(frame: frame, father:father )
    }
    
    convenience init(frame:CGRect, father:BNView?, site:BNSite?){
        self.init(frame: frame, father:father )
    }
    
    convenience init(frame: CGRect, father: BNView?, showBiinItBtn:Bool) {
        
        self.init(frame: frame, father:father )
        
        self.backgroundColor = UIColor.whiteColor()
        
        let screenWidth = SharedUIManager.instance.screenWidth
        let screenHeight = SharedUIManager.instance.screenHeight
        
        var ypos:CGFloat = 10
        title = UILabel(frame: CGRectMake(6, ypos, screenWidth, 16))
        let titleText = "All elements"
        let attributedString = NSMutableAttributedString(string:titleText)
        attributedString.addAttribute(NSKernAttributeName, value: CGFloat(3), range: NSRange(location: 0, length:(titleText.characters.count)))
        title!.attributedText = attributedString
        title!.font = UIFont(name:"Lato-Regular", size:13)
        title!.textColor = UIColor.blackColor()
        title!.textAlignment = NSTextAlignment.Center
        self.addSubview(title!)
        
        backBtn = BNUIButton_Back(frame: CGRectMake(0, 0, 35, 35))
        backBtn!.addTarget(self, action: #selector(self.backBtnAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        backBtn!.icon!.color = UIColor.whiteColor()//site!.media[0].vibrantDarkColor!
        backBtn!.layer.borderColor = UIColor.darkGrayColor().CGColor
        backBtn!.layer.backgroundColor = UIColor.darkGrayColor().CGColor
        self.addSubview(backBtn!)
        
        ypos = 35
        let line = UIView(frame: CGRectMake(0, ypos, screenWidth, 0.5))
        line.backgroundColor = UIColor.darkGrayColor()
        
        scroll = BNScroll(frame: CGRectMake(0, ypos, screenWidth, (screenHeight - (ypos + 20))), father: self, direction: BNScroll_Direction.VERTICAL, space: 1, extraSpace: 0, color: UIColor.darkGrayColor(), delegate: nil)
        self.addSubview(scroll!)
        self.addSubview(line)
        
        addFade()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func transitionIn() {
        UIView.animateWithDuration(0.3, animations: {()->Void in
            self.frame.origin.x = 0
        })
    }
    
    override func transitionOut( state:BNState? ) {
        state!.action()
        if state!.stateType != BNStateType.ElementState || state!.stateType == BNStateType.SiteState {
            UIView.animateWithDuration(0.3, animations: {()->Void in
                self.frame.origin.x = SharedUIManager.instance.screenWidth
                }, completion: {(completed:Bool)->Void in
                    self.scroll!.scroll!.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            })
        }
    }
    
    override func setNextState(goto:BNGoto){
        //Start transition on root view controller
        father!.setNextState(goto)
    }
    
    override func showUserControl(value:Bool, son:BNView, point:CGPoint){
        if father == nil {
            
        }else{
            father!.showUserControl(value, son:son, point:point)
        }
    }
    
    override func updateUserControl(position:CGPoint){
        if father == nil {
            
        }else{
            father!.updateUserControl(position)
        }
    }
    
    //Instance Methods
    func backBtnAction(sender:UIButton) {
        delegate!.hideAllElementsView!(self.category)
    }
    
    func isSameCategory(category:BNCategory?) -> Bool {
        if self.category != nil {
            if self.category!.identifier! == category!.identifier! {
                return true
            }
        }
        
        self.category = category
        return false
    }
    
    func isElementAdded(identifier:String) -> Bool {
        for view in scroll!.children {
            if (view as! ElementMiniView).element!.identifier! == identifier {
                return true
            }
        }
        return false
    }
    
    func updateCategoryData(category:BNCategory?) {
        
        if !isSameCategory(category) {

            SharedAnswersManager.instance.logContentView_Category(category)
            
            scroll!.clean()
            let titleText = category!.name!//.uppercaseString
            let attributedString = NSMutableAttributedString(string:titleText)
            attributedString.addAttribute(NSKernAttributeName, value: CGFloat(3), range: NSRange(location: 0, length:(titleText.characters.count)))
            title!.attributedText = attributedString
            
            let miniViewHeight:CGFloat = SharedUIManager.instance.miniView_height
            
            var elementView_width:CGFloat = 0
            
            if category!.elements.count == 1 {
                elementView_width = SharedUIManager.instance.screenWidth
            } else {
                elementView_width = ((SharedUIManager.instance.screenWidth - 1) / 2)
            }
            
            elementView_width = SharedUIManager.instance.screenWidth
            
            var elements = Array<ElementMiniView>()
            
            for element_data  in category!.elements {
                
                if !isElementAdded(element_data.identifier) {
                    if let element = BNAppSharedManager.instance.dataManager.elements[element_data.identifier] {
                        
                        
                        element.showcase = BNAppSharedManager.instance.dataManager.showcases[element_data.showcase]
                    
                    
                    
                        element.showcase!.site = BNAppSharedManager.instance.dataManager.sites[element_data.site]
                    
                        
                        let elementView = ElementMiniView(frame: CGRectMake(0, 0, elementView_width, miniViewHeight), father: self, element:element, elementPosition:0, showRemoveBtn:false, isNumberVisible:false, showlocation:true)
                        
                        elementView.requestImage()
                        elementView.delegate = father! as! MainView
                        elements.append(elementView)
                    }
                }
            }
            
            self.scroll!.addMoreChildren(elements)

        } else {
            
            let miniViewHeight:CGFloat = SharedUIManager.instance.miniView_height
            
            var elementView_width:CGFloat = 0
            
            if category!.elements.count == 1 {
                elementView_width = SharedUIManager.instance.screenWidth
            } else {
                elementView_width = ((SharedUIManager.instance.screenWidth - 1) / 2)
            }
            
            var elements = Array<ElementMiniView>()
            
            for element_data  in category!.elements {
                
                if !isElementAdded(element_data.identifier) {
                    if let element = BNAppSharedManager.instance.dataManager.elements[element_data.identifier] {
                        
                        element.showcase = BNAppSharedManager.instance.dataManager.showcases[element_data.showcase]
                    
                    
                        element.showcase!.site = BNAppSharedManager.instance.dataManager.sites[element_data.site]
                        
                        
                        let elementView = ElementMiniView(frame: CGRectMake(0, 0, elementView_width, miniViewHeight), father: self, element:element, elementPosition:0, showRemoveBtn:false, isNumberVisible:false, showlocation:true)
                        
                        elementView.requestImage()
                        elementView.delegate = father! as! MainView
                        elements.append(elementView)
                    }
                }
            }

            self.scroll!.addMoreChildren(elements)
        }
    }
    
    
    override func clean(){

        delegate = nil
        title?.removeFromSuperview()
        backBtn?.removeFromSuperview()
        category = nil
        scroll?.clean()
    }
    
    override func refresh() {
        updateCategoryData(category)
    }
    
    override func request() {
        BNAppSharedManager.instance.dataManager.requestElementsForCategory(self.category!, view: self)
    }
    
    override func requestCompleted() {
        updateCategoryData(category)
        self.scroll!.requestCompleted()
    }
}

@objc protocol AllElementsView_Delegate:NSObjectProtocol {
    ///Update categories icons on header
    optional func hideAllElementsView(category:BNCategory?)
}
