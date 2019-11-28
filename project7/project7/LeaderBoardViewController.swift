//
//  LeaderBoardViewController.swift
//  project5
//
//  Created by Joseph Daniel Ramli on 11/4/19.
//  Copyright © 2019 Joseph Daniel Ramli. All rights reserved.
//

import UIKit

//MyNotes:  DO NOT FORGET TO NAME THE VIEWCONTROLLER IN THE STORYBOARD. i.e. in this case I clicked the ID-badge-looking tab and entered "LeaderBoardViewController" in the UIViewController top field of that view.
class LeaderBoardViewController: UIViewController {
    weak var tableView: UITableView!
    var items : [String] = Singleton.shared.highscores
    override func loadView() {
          super.loadView()
          self.view!.backgroundColor = Singleton.shared.background_color
          let tableView = UITableView(frame: .zero, style: .plain)
          tableView.translatesAutoresizingMaskIntoConstraints = false
          self.view.addSubview(tableView)
          tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32.0).isActive = true
          tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
          tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32.0).isActive = true
          tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150).isActive = true
          tableView.backgroundColor = UIColor.lightGray
          
          items.insert("Bugs Busted last round: " + String(Singleton.shared.recent_bugs_busted), at: 0)

      self.tableView = tableView
      }
    override func viewDidLoad() {
           super.viewDidLoad()
           self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
           self.tableView.dataSource = self
       }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LeaderBoardViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        let item = self.items[indexPath.item]
        //cell.textLabel?.text = item
        cell.textLabel?.text = String(item)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print("You selected \(indexPath.row)")
    }
    
}

 
