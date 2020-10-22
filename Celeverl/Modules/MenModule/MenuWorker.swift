//
//  MenuWorker.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 12/15/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation


public class MenuWorker: MenuWorkerProtocol {
    public func getMenuItemsList() -> [MenuModel] {
      let list = [
           MenuModel(id: 0, name: "Камеры", image: "", typePage: .Camera),
           MenuModel(id: 5, name: "Отчеты", image: "", typePage: .Documents),
           MenuModel(id: 1, name: "Задачи няне", image: "", typePage: .Tasks),
           MenuModel(id: 2, name: "Настройки", image: "", typePage: .Profile),
           MenuModel(id: 3, name: "Уведомления", image: "", typePage: .Setting),
           //MenuModel(id: 4, name: "Баланс", image: "", typePage: .Balance),
           //MenuModel(id: 7, name: "Промокоды", image: "", typePage: .PromoCode),
           MenuModel(id: 6, name: "Помощь", image: "", typePage: .Help),
           MenuModel(id:7, name: "Обратная связь", image: "", typePage: .FeedBack),
           MenuModel(id:7, name: "Выход", image: "", typePage: .Exit),
       ]
       return list
    }
}
