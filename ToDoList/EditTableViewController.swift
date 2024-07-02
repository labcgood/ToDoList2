//
//  EditTableViewController.swift
//  ToDoList
//
//  Created by Labe on 2024/6/18.
//

import UIKit

class EditTableViewController: UITableViewController {

    var currentItem: ToDoItem = ToDoItem(title: "", content: [])
    var newContent = Content(details: "", isFinish: false)
    
    // 編輯完成要離開頁面時呼叫執行要做的事情（傳入清單，讓清單可以被ListTableViewController使用）
    var completeEdit: (ToDoItem) -> () = { item in
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // 離開頁面時將畫面資料設定給currentItem，並呼叫completeEdit將資料再設定給ListTableViewController
    // 利用迴圈把每個row的值儲存起來，第0個row是title，其他是content的details
    override func viewDidDisappear(_ animated: Bool) {
        for row in 0...tableView.numberOfRows(inSection: 0) {
            if (row == 0) {
                if let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? EditTitleTableViewCell {
                    currentItem.title = cell.titleTextField.text ?? ""
                }
            } else {
                if let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? EditContentTableViewCell {
                    currentItem.content[row - 1].details = cell.detailsTextField.text ?? ""
                }
            }
        }
        completeEdit(currentItem)
    }
    
    // 把輸入的文字存到currentItem，並更新畫面
    @IBAction func editTitle(_ sender: UITextField) {
        currentItem.title = sender.text!
        tableView.reloadData()
    }

    @IBAction func editContent(_ sender: UITextField) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) {
            currentItem.content[indexPath.row - 1].details = sender.text!
        }
        tableView.reloadData()
    }
    
    // 增加新的content
    @IBAction func addNewContent(_ sender: Any) {
        currentItem.content.append(newContent)
        tableView.reloadData()
    }

    // 切換currentItem的isFinish屬性
    @IBAction func check(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) {
            currentItem.content[indexPath.row - 1].isFinish.toggle()
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (currentItem.content.count) + 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let titleCell = tableView.dequeueReusableCell(withIdentifier: "EditTitleTableViewCell", for: indexPath) as? EditTitleTableViewCell else { fatalError() }
            titleCell.titleTextField.text = currentItem.title
            return titleCell
        } else {
            guard let contentCell = tableView.dequeueReusableCell(withIdentifier: "EditContentTableViewCell", for: indexPath) as? EditContentTableViewCell else { fatalError() }
            contentCell.currentContent = currentItem.content[indexPath.row - 1]
            return contentCell
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
