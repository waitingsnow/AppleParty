//
//  APRootVC.swift
//  AppleParty
//
//  Created by HTC on 2022/3/11.
//  Copyright © 2022 37 Mobile Games. All rights reserved.
//

import Cocoa
import SwiftDate

class APRootVC: NSViewController {

    fileprivate var adapter: APRootCollectionAdapter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        if UserCenter.shared.isAutoLogin {
            let wc = self.view.window?.windowController as! APRootWC
            wc.clickedAccountItem(nil)
        }
    }
    
    /// 配置显示的功能列表
    func configureCollectionView() {
        let colview = APCollectionView()
        colview.configure(superView: view)
        
        adapter = APRootCollectionAdapter(collectionView: colview.collectionView)
        let handler = { (isShow: Bool, name: String) in
            if isShow {
                let mainStoryBoard = NSStoryboard(name: name, bundle: nil)
                let windowController = mainStoryBoard.instantiateController(withIdentifier: name) as! NSWindowController
                windowController.showWindow(self)
                
            } else {
//                APHUD.hide(message: "功能暂未开源，敬请期待~", delayTime: 2)
                let startTime = (Date().dateAtStartOf(.day) - 31.days).toString(.iso(ISOFormatter.Options.withInternetDateTime))
                let endTime = (Date().dateAtStartOf(.day) - 1.days).toString(.iso(ISOFormatter.Options.withInternetDateTime))

                APClient.appSalestrends(appid: "1548184995", measures: "measureDisplay", frequency: "day", startTime: startTime, endTime: endTime, measuresKey: "total_tax_usd_utc").request { result, response, error in
                    print(response as Any)
                }
            }
        }
        
        let items = [
            APRootCollectionModel(name: "我的 App", icon: "Apps", handler: { handler(true, "AppList") }),
            APRootCollectionModel(name: "App 分析报表", icon: "AppAnalytics", handler: { handler(false, "") }),
            APRootCollectionModel(name: "财务报表", icon: "FinancialReports", handler: { handler(false, "") }),
            APRootCollectionModel(name: "邮件工具", icon: "SendEmail", handler: { handler(true, "EmailTool") }),
            APRootCollectionModel(name: "二维码工具", icon: "QRcode", handler: { handler(true, "APQRcode")})
        ]
        adapter?.set(items: items)
    }
    
}
