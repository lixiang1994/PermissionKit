//
//  ViewController.swift
//  Demo
//
//  Created by 李响 on 2019/3/30.
//  Copyright © 2019 swift. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var list: [String] = [
        "相机权限",
        "相册权限 (添加)",
        "相册权限 (读写)",
        "日历权限",
        "提醒权限",
        "联系人权限",
        "语音权限",
        "动作权限",
        "媒体权限",
        "Siri权限",
        "麦克风权限",
        "通知权限",
        "位置权限"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
        )
        cell.textLabel?.text = list[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let mode: Permission.Mode
        switch indexPath.row {
        case 0: // 相机权限
            mode = .camera
            
        case 1: // 相册权限 (添加)
            mode = .photos(.addOnly)
            
        case 2: // 相册权限 (读写)
            mode = .photos(.readWrite)
            
        case 3: // 日历权限
            mode = .calendar
            
        case 4: // 提醒权限
            mode = .reminder
            
        case 5: // 联系人权限
            mode = .contacts
            
        case 6: // 语音权限
            mode = .speech
            
        case 7: // 动作权限
            mode = .motion
            
        case 8: // 媒体权限
            mode = .media
            
        case 9: // Siri权限
            mode = .siri
            
        case 10: // 麦克风权限
            mode = .microphone
            
        case 11: // 通知权限
            mode = .notification([.alert, .badge, .sound, .provisional])
            
        case 12: // 位置权限
            mode = .location(.whenInUse)
            
        default:
            mode = .camera
        }
        
        print("isAuthorized: \(Permission.isAuthorized(mode))")
        print("request ============")
        Permission.request(mode) { (result) in
            print("isAuthorized: \(Permission.isAuthorized(mode))")
            print("end ================")
        }
    }
}
