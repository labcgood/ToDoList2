//
//  ContentTableViewCell.swift
//  ToDoList
//
//  Created by Labe on 2024/6/17.
//

import UIKit

class ContentTableViewCell: UITableViewCell {

    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    var isOk = false
    
    let originalImage = UIImage(systemName: "circle")
    let okImage = UIImage(systemName: "checkmark.circle.fill")
    let originalColor = UIColor(red: 84/255, green: 51/255, blue: 16/255, alpha: 1)
    let okColor = UIColor.accent
    
    var currentContent: Content = Content(details: "", isFinish: false) {
        didSet {
            update()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    // 更新cell畫面
    func update() {
        detailsLabel.text = currentContent.details
        if currentContent.isFinish == false {
            checkButton.setImage(originalImage, for: .normal)
            checkButton.tintColor = originalColor
            detailsLabel.textColor = originalColor
        } else {
            checkButton.setImage(okImage, for: .normal)
            checkButton.tintColor = okColor
            detailsLabel.textColor = okColor
        }
    }
    
}
