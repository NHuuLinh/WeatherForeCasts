//
//  SldeMenuViewController.swift
//  WeatherForeCasts
//
//  Created by LinhMAC on 12/11/2023.
//

import UIKit

protocol MenuDelegate: AnyObject {
    func selectMenuItem(with title: MenuTitle)
}

class SideMenuViewController: UIViewController {
    @IBOutlet weak var menuTableView: UITableView!
    weak var delegate: MenuDelegate?
    private var titles : [MenuTitle] = [.addLocation, .setting, .notification, .aboutUs, .privatePolicy, .termsOfUse]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    func setUpView() {
        menuTableView.dataSource = self
        menuTableView.delegate = self
        let menuCell = UINib(nibName: "MenuTableViewCell", bundle: nil)
        menuTableView.register(menuCell, forCellReuseIdentifier: "MenuTableViewCell")
    }
}
extension SideMenuViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
        cell.getMenuTitle(title: titles[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectMenuItem(with: titles[indexPath.row])
    }
}

