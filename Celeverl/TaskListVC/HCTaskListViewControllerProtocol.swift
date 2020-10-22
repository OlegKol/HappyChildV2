//
//  HCTaskListViewControllerProtocol.swift
//  HappyChild (mobile)
//
//  Created by Anna on 04.12.2019.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation

protocol HCTaskListViewControllerProtocol: AnyObject {
    func updateUI()
    func scrollTableViewToBottom()
    func showActivityIndicator(_ show: Bool)
}
