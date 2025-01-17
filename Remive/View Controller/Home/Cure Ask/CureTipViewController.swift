//
//  CureTipViewController.swift
//  cureAsk1
//
//  Created by Devang IOS on 18/12/24.
//

import UIKit

class CureTipViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var headingLabel: UILabel!
    
    @IBOutlet weak var headingTwoLabel: UILabel!
    
    @IBOutlet weak var headingThreeLabel: UILabel!
    
   
    
    
    var data : Remedy?
    var symptom : String?
    init?(coder: NSCoder, data: Remedy? = nil, symptom : String?) {
        self.data = data
        self.symptom = symptom
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var cureTipView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        cureTipView.backgroundColor = UIColor.blue
        cureTipView.layer.borderWidth = 0.5
        cureTipView.layer.cornerRadius = 20
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 15
        headingLabel.text = symptom
        headingTwoLabel.text = data?.title
        headingThreeLabel.text = data?.shortDescription
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data?.steps.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CureTipTableViewCell
        cell.tableStep.text = data?.steps[indexPath.row]
        if let image = data?.images[indexPath.row] {
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
    
    @IBAction func hyperlinkButtonPressed(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: data?.link ?? "")!)
    }

}
