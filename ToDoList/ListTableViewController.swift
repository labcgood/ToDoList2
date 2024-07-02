//
//  ListTableViewController.swift
//  ToDoList
//
//  Created by Labe on 2024/6/17.
//

import UIKit

class ListTableViewController: UITableViewController {

    var list:[ToDoItem] = [ToDoItem]() {
        didSet {
            ToDoItem.save(item: list)
        }
    }
    var editItem:ToDoItem = ToDoItem(title: "", content: [])
    var currentEditItemIndexPath:IndexPath = IndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items = ToDoItem.load() {
            self.list = items
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // 判斷目前點選的section，把要修改的清單存給editItem，在呼叫IBSegueAction時把資料設定給EditTableViewController的currentItem
    @IBAction func editItem(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) {
            currentEditItemIndexPath = indexPath // 存起修改的位置，在修改完才知道資料要設定給哪個section
            editItem = list[indexPath.section]
        }
    }

    // 判斷segue
    // 把相對應的資料傳給EditTableViewController的currentItem
    // 使用completeEdit在離開EditTableViewController時將編輯的清單設定回ListTableViewController（分新的清單跟編輯舊的清單）
    @IBSegueAction func toEditTableViewController(_ coder: NSCoder, sender: Any?, segueIdentifier: String?) -> EditTableViewController? {
        let controller = EditTableViewController(coder: coder)
        switch segueIdentifier {
        case "addNewItemToEditTVC":
            if let controller {
                let contnet = Content(details: "", isFinish: false)
                controller.currentItem.content.append(contnet)
                controller.completeEdit = { newItem in
                    self.list.insert(newItem, at: 0)
                    let indexSet = IndexSet(integer: 0)
                    self.tableView.insertSections(indexSet, with: .automatic)
                }
            }
        case "editItemToEditTVC":
            if let controller {
                controller.currentItem = editItem
                controller.completeEdit = { editItem in
                    self.list[self.currentEditItemIndexPath.section] = editItem
                    let indexSet = IndexSet(integer: self.currentEditItemIndexPath.section)
                    self.tableView.reloadSections(indexSet, with: .automatic)
                }
            }
        default:
            break
        }
        return controller
    }

    // 切換清單isFinish屬性
    @IBAction func check(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) {
            list[indexPath.section].content[indexPath.row - 1].isFinish.toggle() // 切換布林值的方法
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    // 刪除已完成清單，如果內容皆已完成會刪除整個ToDoItem
    @IBAction func deleteFinishList(_ sender: UIButton) {
        for i in 0...list.count - 1 {
            list[i].content = list[i].content.filter { !$0.isFinish }
        }
        list = list.filter { !$0.content.isEmpty }
        tableView.reloadData()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return list.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return list[section].content.count + 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let titleCell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell", for: indexPath) as? TitleTableViewCell else { fatalError() }
            titleCell.titleLabel.text = list[indexPath.section].title
            return titleCell
        } else {
            guard let contentCell = tableView.dequeueReusableCell(withIdentifier: "ContentTableViewCell", for: indexPath) as? ContentTableViewCell else { fatalError() }
            contentCell.currentContent = list[indexPath.section].content[indexPath.row - 1]
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
