//
//  Toast.swift
//  swift-cnode
//
//  Created by nswbmw on 16/4/3.
//  Copyright © 2016年 nswbmw. All rights reserved.
//

import JLToast

func showToast(str: String) {
    JLToast.makeText(str, duration: 3).show()
}