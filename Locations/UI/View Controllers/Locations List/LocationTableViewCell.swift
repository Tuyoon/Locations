//
//  LocationTableViewCell.swift
//  Locations
//
//  Created by AT on 12/07/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

protocol LocationTableViewCellDelegate: class {
    func locationTableViewCellDidSelectMap(_ cell: LocationTableViewCell)
}
class LocationTableViewCell: UITableViewCell {
    
    weak var delegate: LocationTableViewCellDelegate?
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var notesLabel: UILabel!
    
    var location: Location! {
        didSet {
            updateUI()
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

    private func updateUI() {
        titleLabel?.text = location?.title
        notesLabel?.text = location?.notes
    }
    
    @IBAction private func mapButtonPressed(sender: UIButton) {
        delegate?.locationTableViewCellDidSelectMap(self)
    }
}
