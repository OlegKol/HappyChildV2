//
//  ContainerViewController.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 11/22/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

public class ContainerViewer: UIViewController, SelectedMenuItemDelegate, ContainerViewerProtocol, ContainerMenuProtocol {
    
    //MARK: - ContainerViewerProtocol implementation
    public var interactor: ContainerInteractorProtocol?
    public var router: ContainerRouterProtocol?
      
    @objc dynamic public var IsOpenMenu: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.toggleMenu(self.IsOpenMenu)
            }
        }
    }
    
    //MARK: - SelectedMenuItemDelegate implementation
    func selectedMenuItemDelegate(_ item: BaseModel) {
        if let menuItem = item as? MenuModel {
            self.IsOpenMenu = false
            self.checkCurrentMenuItem(menuItem)
        }
    }
    
    //MARK: - Properties
    lazy var barView: AppBarPanel = {
        var bar = AppBarPanel()
        bar.backgroundColor = AppConstants.APP_DEFAULT_PINK_COLOR
        return bar
    }()
    
    var currentControler: UIViewController!
    
    var menuViewController: MenuViewer = {
        var menu = MenuViewer()
        return menu
    }()
    
    //MARK: - Controllers
    var mainViewController: CommonCameraViewer!
    var taskViewController: HCTaskListViewController!
    var settingViewController: ReminderViewer!
    var ballanceViewController: BalanceViewer!
    var documentViewController: DocumentViewer!
    var helpViewController: HelpViewer!
    var settingsViewerController: SettingsViewer!
    var promoCodeViewerController: PromoCodeViewer!
    var homeViewControler: UIViewController!
    var feedBackController: FeedBackViewer!
    
    var observers:[NSKeyValueObservation] = []
    
    override public func loadView() {
        super.loadView()
        self.configuareBarView()
        self.configuareMainViewer()
        self.configuareMenuViewer()
        self.configuareSettingViewer()
        self.configuareBallanceViewer()
        self.configuareDocumentsViewer()
        self.configuareHelpViewer()
        self.configuareSettingsViewer()
        self.configuarePromoCodeViewer()
        self.configuareHomeViewController()
        self.configaureFeedBackController()
    
        self.currentControler = self.homeViewControler
        
        let listenTouches = UIPanGestureRecognizer( target: self,action: #selector(handleTouch))
        self.view.addGestureRecognizer(listenTouches)
        
        self.view.backgroundColor = .black
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.registerListenNotification()
        self.interactor?.loadDefaultData()
        NotificationCenter.default.addObserver(self, selector: #selector(self.openactivity), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.openactivity), name: NSNotification.Name.init("NEW_NOTIFICATION"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.fullscreen), name: NSNotification.Name.init("FULL_SCREEN"), object: nil)
    }

    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @objc func fullscreen(_ notification: NSNotification) {
         if let full_flag = notification.userInfo?["SelectedIndex"] as? Bool {
//            if full_flag == true{
//                barView.heightConstaint?.constant = 0
//            }
//            else{
//                barView.heightConstaint?.constant = UIScreen.main.bounds.height * 0.08
//            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.001){
               NotificationCenter.default.post(name: NSNotification.Name.init("FULL_SCREEN_SUCCESS"), object: nil, userInfo: nil)
            }
         }
     }
  
    
    @objc func openactivity()  {

        //view should reload the data.
      //  ws_get_unread_pushCount()
        let badgeCount = UIApplication.shared.applicationIconBadgeNumber
        if(badgeCount == 0){
            barView.showBadgeView(flag: false)
        }
        else{
            barView.showBadgeView(flag: true)
        }
    }
      
   
    //MARK: - Listen Notification functions
    private func registerListenNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleNotification), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    
    @objc private func handleNotification(_ notification: NSNotification) {
        if notification.name == UIApplication.willEnterForegroundNotification {
            self.toggleMenu(self.IsOpenMenu)
        }
    }
    
    //MARK: - configuare Views
    func configuareBarView(){
        self.view.addSubview(self.barView)
        self.barView.translatesAutoresizingMaskIntoConstraints = false
        self.barView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.barView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.barView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.barView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.08).isActive = true
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(openNotificationView))
        self.barView.rightView.isUserInteractionEnabled = true
        self.barView.rightView.addGestureRecognizer(recognizer)
        self.barView.Toggled = {(_) in
            self.IsOpenMenu = !self.IsOpenMenu
        }
        self.observers.append(self.observe(\.IsOpenMenu, changeHandler: {(container,options) in
            self.barView.IsOpen = container.IsOpenMenu
        }))
    }
    
    func configuareMenuViewer(){
        
        MenuBuilder.createBuilder(viewer: menuViewController)
        
        self.menuViewController.selectMenuDelegate = self
        self.view.insertSubview(self.menuViewController.view, at: 0)
        
        if let view = menuViewController.view {
            view.translatesAutoresizingMaskIntoConstraints = false
            view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
            view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
            view.widthAnchor.constraint(equalToConstant: self.menuWidth).isActive = true
            view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        }
    }
    
    func configuareMainViewer(){
        if self.mainViewController == nil{
            self.mainViewController = CommonCameraViewer()
            let router = CommonCameraRouter()
            let worker = CommonCameraWorker()
            let presenter = CommonCameraPresenter()
            let interactor = CommonCameraInteractor()
            interactor.setCustomData(source: self.interactor!)
            CommonBuilder.createBuilder(viewer: self.mainViewController, router: router, interactor: interactor, worker: worker, presenter: presenter)
        }
    }
    
    func configuareSettingViewer(){
        if self.settingViewController == nil{
            self.settingViewController = ReminderViewer()
            ReminderBuilder.createBudiler(viewer: self.settingViewController)
        }
    }
    
    func configuareTasksViewer(){
        if self.taskViewController == nil {
            self.taskViewController = HCTaskListViewController()
        }
    }
    
    func configuareBallanceViewer(){
        if self.ballanceViewController == nil{
            self.ballanceViewController = BalanceViewer()
            self.ballanceViewController.view.backgroundColor = .white
            BalanceBuilder.createBuilder(self.ballanceViewController)
        }
    }
    
    func configuareDocumentsViewer(){
        if self.documentViewController == nil{
            self.documentViewController = DocumentViewer()
            self.documentViewController.view.backgroundColor = .white
            DocumentBuilder.createBuilder(self.documentViewController)
        }
    }
    
    func configuareHelpViewer(){
       if self.helpViewController == nil{
           self.helpViewController = HelpViewer()
           self.helpViewController.view.backgroundColor = .white
           HelpBuilder.createBuilder(self.helpViewController)
       }
    }
    
    func configuareSettingsViewer(){
        if self.settingsViewerController == nil {
          self.settingsViewerController = SettingsViewer()
            SettingsBuilder.createBuilder(viewer: self.settingsViewerController)
        }
    }
    
    func configuarePromoCodeViewer(){
        if self.promoCodeViewerController == nil {
            self.promoCodeViewerController = PromoCodeViewer()
            self.promoCodeViewerController.view.backgroundColor = .white
            PromoBuilder.createBuilder(viewer: self.promoCodeViewerController)
        }
    }
    
    func configuareHomeViewController(){
        if self.homeViewControler == nil {
//            let storyboard = UIStoryboard(name: "Second", bundle: nil)
//            self.homeViewControler = storyboard.instantiateViewController(withIdentifier: "HomeView")
            let viewer = CameraViewer()
            let interactor = CameraInteractor()
            let worker = CameraWorker()
            CameraBuilder.createBuilder(viewer: viewer, interactor: interactor, worker: worker)
            viewer.view.backgroundColor = .white
            self.homeViewControler = viewer
        }
    }
    
    func configaureFeedBackController(){
        if self.feedBackController == nil {
           self.feedBackController = FeedBackViewer()
       }
    }
    
    func configuareObservations(){
        
    }
    
    func setCurrentViewer(_ controller:UIViewController){
        
        self.currentControler = controller
        
        self.addChild(controller)
        self.view.addSubview(self.currentControler.view)
        
        if let view = self.currentControler.view {
            view.translatesAutoresizingMaskIntoConstraints = false
            view.topAnchor.constraint(equalTo: self.barView.bottomAnchor).isActive = true
            view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
            view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        }
    }
    
    
    private func toggleMenu(_ value: Bool) -> Void {
        value == true ?  self.showMenu() : self.hideMenu()
        self.view.endEditing(true)
    }
    
    private func hideMenu(){
        UIView.animate(withDuration: 0.4, animations: {
            self.currentControler?.view.frame.origin.x = 0
            self.barView.frame.origin.x = 0
        }, completion: nil)
    }
    
    private func showMenu(){
        UIView.animate(withDuration: 0.4, animations: {
            self.currentControler?.view.frame.origin.x = self.menuWidth
            self.barView.frame.origin.x = self.menuWidth
        }, completion: nil)
    }
    
    
    private func checkCurrentMenuItem(_ newValue: MenuModel){
        self.goToViewer(newValue.typePage)
    }
    
    private func goToViewer(_ menuItem: TypePage){
        
        self.currentControler?.view.removeFromSuperview()
        
        let frame = self.currentControler?.view.frame
        var controller: UIViewController?
        
        switch menuItem {
            case .Camera:
                if self.homeViewControler == nil {
                    self.configuareHomeViewController()
                }
                controller = self.homeViewControler
            case .Setting:
                controller = self.settingViewController
            case .Profile:
                let newController =  SettingsViewer()
                SettingsBuilder.createBuilder(viewer: newController)
                controller = newController
            case .Documents:
                controller = self.documentViewController
            case .Tasks:
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                controller = storyboard.instantiateViewController(withIdentifier: "TaskView")
            case .Balance:
                controller = self.ballanceViewController
            case .Help:
                controller = self.helpViewController
            case .PromoCode:
                controller = self.promoCodeViewerController
            case .FeedBack:
                controller = self.feedBackController
        default:
            print("unknown menu Item")
        }
        if let window = frame, let newControl = controller {
            newControl.view?.frame = window
        }
        if let newControl = controller {
            self.setCurrentViewer(newControl)
        }
    }
    
    @objc private func openNotificationView(){
        barView.showBadgeView(flag: false)
        self.interactor?.goToNotificationPage()
    }
   
    
    //MARK: - ContainermenuProtocol
    public var startTouchPoint: CGPoint = .zero
    public var currentTouchPoint: CGPoint = .zero
    public var startViewPoint: CGPoint = .zero

    public var IsListenTouchChanged: Bool = false
    public var menuWidth: CGFloat = 250.0
    
    @objc public func handleTouch(_ touch: UIPanGestureRecognizer) {
        if touch.state == .began && abs(touch.location(in: self.view).x - self.currentControler.view.frame.origin.x) < self.view.bounds.width * 0.08 {
            self.startTouchPoint = touch.location(in: self.view)
            self.startViewPoint = self.currentControler.view.frame.origin
            self.IsListenTouchChanged = true
        }
        else if touch.state == .changed && self.IsListenTouchChanged {
             self.currentTouchPoint = touch.location(in: self.view)
             let deltaX = self.currentTouchPoint.x - self.startViewPoint.x
             if self.currentTouchPoint.x < self.menuWidth {
                 self.changeViewPositionX(deltaX)
             }
        }
        else if touch.state == .ended && self.IsListenTouchChanged {
            let lastPoint = touch.location(in: self.view)
            if lastPoint.x >= CGFloat(self.menuWidth) {
                self.openMenu()
            }
            else if lastPoint.x < 0  {
                self.closeMenu()
            }
            else {
                if lastPoint.x <= self.menuWidth/2 {
                    self.closeMenu()
                }
                else if lastPoint.x > self.menuWidth/2 {
                    self.openMenu()
                }
            }
            self.IsListenTouchChanged = false
            self.startViewPoint = self.currentControler.view.frame.origin
        }
    }
    
    public func openMenu() {
        UIView.animate(withDuration: 0.5, animations: {
              self.currentControler.view.frame.origin = CGPoint(x: CGFloat(self.menuWidth), y: self.currentControler.view.frame.origin.y)
              self.barView.frame.origin = CGPoint(x: CGFloat(self.menuWidth), y: self.barView.frame.origin.y)
        })
        self.IsOpenMenu = true
    }
    
    public func closeMenu() {
        UIView.animate(withDuration: 0.5, animations: {
        self.currentControler.view.frame.origin = CGPoint(x: 0, y: self.currentControler.view.frame.origin.y)
          self.barView.frame.origin = CGPoint(x: 0, y: self.barView.frame.origin.y)
        })
        self.IsOpenMenu = false
    }
    
    public func changeViewPositionX(_ deltaX: CGFloat) {
        UIView.animate(withDuration: 0, animations: {
         self.currentControler.view.frame.origin.x = self.startViewPoint.x + deltaX
         self.barView.frame.origin.x = self.startViewPoint.x + deltaX
        })
    }
    
    func ws_get_unread_pushCount(){
             self.barView.showBadgeView(flag: false)
             if Connectivity.isConnectedToInternet {
                 var paramDict = [String:Any]()
                 
               paramDict["userId"] = AccountService.shared.currentAccount?.Id
            
                 print(paramDict)
                 
                 guard let url = URL(string: unreadPushCount) else {return}
               
                 
                 
               Alamofire.request(url,method: .get,parameters: paramDict).responseJSON{ (response) in
             
                     switch response.result {
                     case .success:
                         print(response)
                         let dictResponse = response.result.value as! NSInteger
                         if (dictResponse == 0) {
                            self.barView.showBadgeView(flag: false)
                         }else{
                            self.barView.showBadgeView(flag: true)
                         }
                         
                         
                         break
                     case .failure(let error):
                    
                         print(error)
                     }
                     
                 }
             } else {
                 
             }
    }
}
