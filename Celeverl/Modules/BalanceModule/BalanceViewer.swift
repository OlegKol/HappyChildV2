//
//  BalanceViewer.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 1/19/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation
import UIKit

//MARK: - BalanceViewer
public class BalanceViewer: UIViewController, BalanceViewerProtocol, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    
    //MARK: - BalanceViewerProtocol implementation
    public var interactor: BalanceInteractorProtocol?
    
    public func changedStatePage(_ state: Bool) {
        DispatchQueue.main.async {
            if state {
                self.statePageView.startAnimating()
            }
            else {
                self.statePageView.stopAnimating()
            }
        }
    }
    
    public func updateView(_ data: BalanceModel) {
        
        DispatchQueue.main.async {
            let dataForrmater = DateFormatter()
            dataForrmater.dateFormat = "dd.MM.yyyy"
            if let date = dataForrmater.date(from: data.DateEndStr) {
                if date > Date() {
                    self.dataEndView.text = "Действует до \(data.DateEndStr)"
                    self.dataEndView.isHidden = false
                    self.balanceValueView.text = data.HappyChildAnalysisHours > 1 ? "\(data.HappyChildAnalysisHours) часов" : "\(data.HappyChildAnalysisHours) час"
                }
                else {
                    self.dataEndView.isHidden = true
                    self.balanceValueView.text = "Балланс: 0 часов"
                }
            }
            self.historyTitleView.text = "История платежей"
            self.tableHistoryItems = data.History
            self.tableHistoryView.reloadData()
        }
    }
    
    
    //MARK: - Properties
    
    private var balanceValueView: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: AppConstants.APP_ROBOTO_REGULAR, size: 22)
        label.textColor = AppConstants.APP_DEFAULT_TEXT_COLOR
        return label
    }()
    
    private var contentBalanceView: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.init(hex: "#F4F5F8", alpha: 1)
        return view
    }()
    
    private var historyTitleView: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: AppConstants.APP_ROBOTO_REGULAR, size: 16)
        label.textColor = AppConstants.APP_DEFAULT_TEXT_COLOR
        return label
    }()
    
    private var contentHistoryTitleView: ViewButtomLine = {
        var view = ViewButtomLine()
        return view
    }()
    
    private var dataEndView: UILabel = {
        var view = UILabel()
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    private var statePageView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3)
        view.style = .large
        view.color = .white
        return view
    }()
    
    private var tableHistoryItems: [HistoryBalanceModel] = []
    
    private var tableHistoryView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .white
        return view
    }()
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tableHistoryItems.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: BalanceHistoryViewCell.reuqseID, for: indexPath)
        guard let balanceCell = cell as? BalanceHistoryViewCell else { return cell }
        balanceCell.BindingContext = self.tableHistoryItems[indexPath.item]
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.tableHistoryView.bounds.width, height: 48)
    }

    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.interactor?.loadBalanceData()
    }
    
    public override func loadView() {
        super.loadView()
        self.view.backgroundColor = .white
        self.configuareViews()
    }
    
    private func configuareViews(){
        self.configuareTitleBalanceValueView()
        self.configuareHistoryTitleView()
        self.configuareTableHistoryView()
        self.configuareStateView()
    }
    
    private func configuareTitleBalanceValueView(){
        
        self.view.addSubview(self.contentBalanceView)
        
        self.contentBalanceView.translatesAutoresizingMaskIntoConstraints = false
        self.contentBalanceView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.contentBalanceView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.contentBalanceView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
        
        self.contentBalanceView.addSubview(self.balanceValueView)
    
        self.balanceValueView.translatesAutoresizingMaskIntoConstraints = false
        self.balanceValueView.leftAnchor.constraint(equalTo: self.contentBalanceView.leftAnchor, constant: 21).isActive = true
        self.balanceValueView.rightAnchor.constraint(equalTo: self.contentBalanceView.rightAnchor, constant: -21).isActive = true
        self.balanceValueView.topAnchor.constraint(equalTo: self.contentBalanceView.topAnchor, constant: 32).isActive = true
        
        
        self.contentBalanceView.addSubview(self.dataEndView)

        self.dataEndView.text = ""
        self.dataEndView.translatesAutoresizingMaskIntoConstraints = false
        self.dataEndView.topAnchor.constraint(equalTo: self.balanceValueView.bottomAnchor, constant: 1).isActive = true
        self.dataEndView.leftAnchor.constraint(equalTo: self.contentBalanceView.leftAnchor, constant: 21).isActive = true
        self.dataEndView.rightAnchor.constraint(equalTo: self.contentBalanceView.rightAnchor, constant: -21).isActive = true
        self.dataEndView.bottomAnchor.constraint(equalTo: self.contentBalanceView.bottomAnchor, constant: -16).isActive = true
        
    }
    
    private func configuareStateView(){
        
        self.view.addSubview(self.statePageView)
        
        self.statePageView.translatesAutoresizingMaskIntoConstraints = false
        self.statePageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.statePageView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.statePageView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.statePageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    private func configuareHistoryTitleView(){
        
        self.view.addSubview(self.contentHistoryTitleView)
        self.contentHistoryTitleView.translatesAutoresizingMaskIntoConstraints = false
        self.contentHistoryTitleView.heightLine = 2
        self.contentHistoryTitleView.colorLine = UIColor.init(hex: "#CCCCCC", alpha: 1)
        
        self.contentHistoryTitleView.topAnchor.constraint(equalTo: self.contentBalanceView.bottomAnchor, constant: 0).isActive = true
        self.contentHistoryTitleView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.contentHistoryTitleView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.contentHistoryTitleView.heightAnchor.constraint(equalToConstant:60).isActive = true
        
        
        self.contentHistoryTitleView.addSubview(self.historyTitleView)

        self.historyTitleView.translatesAutoresizingMaskIntoConstraints = false
        self.historyTitleView.topAnchor.constraint(equalTo: self.contentHistoryTitleView.topAnchor, constant: 32).isActive = true
        self.historyTitleView.leftAnchor.constraint(equalTo: self.contentHistoryTitleView.leftAnchor, constant: 22).isActive = true
        self.historyTitleView.rightAnchor.constraint(equalTo: self.contentHistoryTitleView.rightAnchor, constant: -22).isActive = true
        self.historyTitleView.bottomAnchor.constraint(equalTo: self.contentHistoryTitleView.bottomAnchor, constant: -5).isActive = true
        
    }
    
    private func configuareTableHistoryView(){

        self.view.addSubview(self.tableHistoryView)
        self.tableHistoryView.delegate = self
        self.tableHistoryView.dataSource = self
        self.tableHistoryView.register(BalanceHistoryViewCell.self, forCellWithReuseIdentifier: BalanceHistoryViewCell.reuqseID)

        self.tableHistoryView.translatesAutoresizingMaskIntoConstraints = false
        self.tableHistoryView.topAnchor.constraint(equalTo: self.contentHistoryTitleView.bottomAnchor, constant: 0).isActive = true
        self.tableHistoryView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.tableHistoryView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.tableHistoryView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true

    }
    
}
