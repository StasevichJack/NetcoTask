//
//  UserCell.swift
//  NetcoTask
//
//  Created by Jack on 3/18/18.
//  Copyright © 2018 Jack. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userIDLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    var user: User? {
        didSet {
            self.configureCell()
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
    
}

// MARK: - Private functions.

extension UserCell {
    
    private func configureCell() {
        
        if self.user?.avatar_url != nil {
            self.avatarImageView.sd_setImage(with: URL(string: (self.user?.avatar_url)!), placeholderImage: nil, options: .refreshCached, completed: nil)
        } else {
            self.avatarImageView.image = nil
        }
        
        self.userIDLabel.text = "#\(self.user?.user_id ?? 0)"
        self.userNameLabel.text = "\(self.user?.login ?? "unknown")"
    }
}
