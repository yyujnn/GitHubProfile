//
//  RepositoryTableViewCell.swift
//  GitHubProfile
//
//  Created by 정유진 on 2024/04/11.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setData(_ data: Repository) {
        nameLabel.text = data.name
        languageLabel.text = data.language
    }
    
}
