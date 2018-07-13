//
//  MapDetailsViewController.swift
//  Locations
//
//  Created by AT on 05/07/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

protocol MapDetailsViewControllerDelegate: class {
    func mapDetailsViewControllerDidOpen(controller: MapDetailsViewController)
}

class MapDetailsViewController: UIViewController {

    weak var delegate: MapDetailsViewControllerDelegate?
    
    @IBOutlet private(set) weak var titleLabel: UILabel?
    @IBOutlet private(set) weak var coordinateLabel: UILabel?
    @IBOutlet private(set) weak var notesTextView: UITextView?
    
    var location: Location? {
        didSet {
            updateUI()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    private func updateUI() {
        guard let location = location else {
            return
        }
        titleLabel?.text = location.title
        coordinateLabel?.text = "\(location.latitudeString), \(location.longitudeString)"
        notesTextView?.text = location.notes
    }
    
    @IBAction private func openButtonPressed(sender: AnyObject?) {
        delegate?.mapDetailsViewControllerDidOpen(controller: self)
    }
}
