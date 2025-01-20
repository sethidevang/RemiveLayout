//
//  ViewController.swift
//  History
//
//  Created by Devang IOS on 18/01/25.
//

import UIKit

class History: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var navBar: UINavigationItem!
    
    @IBOutlet weak var dateTimeRecord: UILabel!
    
    @IBOutlet weak var rating: UILabel!
    
    @IBOutlet weak var desc: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    

    
    var data : HistoryRecord?
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(data)
        tableView.delegate = self
        tableView.dataSource = self
        navBar.title = data?.condition
        name.text = "Remedy Suggested: \(data?.selectedRemedy.title ?? "null")"
        desc.text = data?.selectedRemedy.shortDescription
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY,MMM dd  h:mm a" 
        dateTimeRecord.text = formatter.string(from: data?.date ?? Date())
//        rating.text = 
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.selectedRemedy.steps.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CureTipTableViewCell
        cell.tableStep.text = data?.selectedRemedy.steps[indexPath.row]
        if let image = data?.selectedRemedy.images[indexPath.row] {
            cell.tablePhoto.image = UIImage(named: image)
            cell.tablePhoto.clipsToBounds = true
            cell.tablePhoto.contentMode = .scaleAspectFill
        } else {
            cell.tablePhoto.image = UIImage(systemName: "questionmark.circle")
            cell.tablePhoto.tintColor = UIColor(red: 1, green: 10/255, blue: 84/255, alpha: 1)
        }
        cell.tablePhoto.layer.cornerRadius =  10
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func shareButtonAction(_ sender: UIBarButtonItem) {
        UIApplication.shared.open(URL(string: data?.selectedRemedy.link ?? "")!)
    }
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        print("hello")
    }
    
}

