//
//  LocationViewController.swift
//  Locations
//
//  Created by AT on 06/07/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit
import CoreLocation

struct LocationModel {
    var id: String?
    var title: String = ""
    var latitude: Double = 0
    var longitude: Double = 0
    var notes: String = ""
}

protocol LocationViewControllerDelegate: class {
    func locationViewControllerDidSave(controller: LocationViewController)
}

class LocationViewController: UIViewController {

    weak var delegate: LocationViewControllerDelegate?
    @IBOutlet private(set) weak var titleTextField: UITextField!
    @IBOutlet private(set) weak var latitudeTextField: UITextField!
    @IBOutlet private(set) weak var longitudeTextField: UITextField!
    @IBOutlet private(set) weak var notesTextView: UITextView!
    @IBOutlet private(set) weak var saveButton: UIButton!
    @IBOutlet private(set) weak var saveBarButton: UIBarButtonItem!
    
    var coordinate: CLLocationCoordinate2D? {
        didSet {
            model.latitude = coordinate?.latitude ?? 0
            model.longitude = coordinate?.longitude ?? 0
            updateUI()
        }
    }
    
    var location: Location? {
        didSet {
            model.id = location?.id
            model.title = location?.title ?? ""
            model.notes = location?.notes ?? ""
            model.latitude = location?.latitude ?? 0
            model.longitude = location?.longitude ?? 0
            updateUI()
        }
    }
    
    private var model: LocationModel = LocationModel()
    private let validator: Validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        updateUI()
    }
    
    private func configure() {
        let layer = notesTextView.layer
        layer.borderWidth = 0.5
        layer.borderColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0).cgColor
        layer.cornerRadius = 5.0
    }

    private func updateUI() {
        guard isViewLoaded else {
            return
        }
        
        let editable = location == nil
        titleTextField.isEnabled = editable
        latitudeTextField.isEnabled = editable
        longitudeTextField.isEnabled = editable
        
        titleTextField.text = model.title
        latitudeTextField.text = "\(model.latitude)"
        longitudeTextField.text = "\(model.longitude)"
        notesTextView.text = model.notes
        
        updateSaveButton()
    }
    
    private func save() {
        LocationsManager.saveLocation(model: model)
    }
    
    private func updateSaveButton() {
        let enabled = hasChanges()
        saveBarButton.isEnabled = enabled
        saveButton.isEnabled = enabled
        saveButton.alpha = enabled ? 1 : 0.5
    }
    
    private func hasChanges() -> Bool {
        guard let location = location else {
            let enabled = (titleTextField.text?.count ?? 0) > 0
            return enabled
        }
        
        return location.notes != notesTextView.text
    }
    
    private func correct() {
        correctDecimalTextField(textField: latitudeTextField)
        model.latitude = latitudeTextField.text?.double() ?? 0
        correctDecimalTextField(textField: longitudeTextField)
        model.longitude = longitudeTextField.text?.double() ?? 0
    }
    
    private func correctAndSave() {
        correct()
        save()
    }
    
    @IBAction private func saveButtonPressed(sender: AnyObject?) {
        correctAndSave()
        dismiss(animated: true) {
            self.delegate?.locationViewControllerDidSave(controller: self)
        }
    }
    
    @IBAction private func cancelButtonPressed(sender: AnyObject?) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func titleChanged(sender: UITextField) {
        model.title = sender.text ?? ""
        updateSaveButton()
    }
    
    @IBAction private func longitudeChanged(sender: UITextField) {
        correctInputDecimalTextField(textField: sender)
    }
    
    @IBAction private func latitudeChanged(sender: UITextField) {
        correctInputDecimalTextField(textField: sender)
    }
    
    private func correctInputDecimalTextField(textField: UITextField) {
        textField.text = validator.correctInputDecimal(text: textField.text)
    }
    
    private func correctDecimalTextField(textField: UITextField) {
        textField.text = validator.correctDecimal(text: textField.text)
    }
}

extension LocationViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        correct()
    }
}
extension LocationViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        model.notes = textView.text
        updateSaveButton()
    }
}
