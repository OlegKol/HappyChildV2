//
//  AppCameraCollectionView.swift
//  HappyChild
//
//  Created by Евгений on 11/14/19.
//  Copyright © 2019 Oberon. All rights reserved.
//

import Foundation
import UIKit

public class AppCameraCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public var BindingContext: [BaseModel] = []{
        didSet{
            self.updateCollection()
        }
    }
    
    public var selectDelegate: SelectItemCollectionDelegateProtocol?
    
    init(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame:.zero, collectionViewLayout: layout)
        self.setUpCollection()
    }
    
    
    func setUpCollection() {
       delegate = self
       dataSource = self
       register(CameraViewCell.self, forCellWithReuseIdentifier: CameraViewCell.resueseId)
       showsHorizontalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return BindingContext.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: CameraViewCell.resueseId, for: indexPath)
        if let cameraViewCell = cell as? BaseViewCell{
            cameraViewCell.BindingContext = self.BindingContext[indexPath.item]
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: self.frame.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cameraViewCell = cell as? BaseViewCell{
            cameraViewCell.removeBindingProperties()
        }
    }
    
    func updateCollection(){
        self.reloadData()
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let item = self.BindingContext[indexPath.item]
        self.selectDelegate?.selectItem(item)
    }
    
}
