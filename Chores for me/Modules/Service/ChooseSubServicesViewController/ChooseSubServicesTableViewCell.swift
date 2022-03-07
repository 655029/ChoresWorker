//
//  ChooseSubServicesTableViewCell.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 18/04/21.
//

import UIKit
import Designable


class ChooseSubServicesTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var ammountTextField: UITextField!
    @IBOutlet weak var ammoutBgView: UIView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var isSelectedButton: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var decreaseButton: DesignableButton!
    @IBOutlet weak var increaseButton: DesignableButton!
    @IBOutlet var serviceImage: UIImageView!
    
    //MARK: - Properties
    var count = 0 {
        didSet {
            ammountTextField.text = "\(count)"
        }
    }

    // MARK: - Variable

    private var ammountTextFieldWidthConstraint: NSLayoutConstraint!

    let gradientMaskLayer = GradientLayer(direction: .leftToRight, colors: [UIColor.clear, UIColor.clear, UIColor.white, UIColor.white], locations: [0, 0.1, 0.9, 1])

    override func awakeFromNib() {
        super.awakeFromNib()

        blurView.alpha = 0
        ammountTextField.delegate = self
        ammountTextFieldWidthConstraint = ammountTextField.widthAnchor.constraint(equalToConstant: 45)
        ammountTextFieldWidthConstraint.isActive = true
        ammountTextField.backgroundColor = AppColor.inputInavtiveBackgroundColor

        gradientMaskLayer.frame = blurView.bounds
        blurView.layer.mask = gradientMaskLayer
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func incrementButtonAction(_ sender: UIButton) {
        count += 5
    }

    @IBAction func decreamentButtonAction(_ sender: UIButton) {
        if count > 0 {
            count -= 5
        }
    }
    
}

// MARK: - UITextFieldDelegate

extension ChooseSubServicesTableViewCell: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.layoutIfNeeded() // call
        UIView.animate(withDuration: 1) { [weak self] in
            guard let self = self else { return }
            self.ammountTextFieldWidthConstraint.constant = 75
            self.ammountTextField.backgroundColor = AppColor.inputAvtiveBackgroundColor
            self.blurView.alpha = 1
            self.ammoutBgView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.layoutIfNeeded() // call
        }
    }

    func textFieldDidEndEditing(_ textFiel: UITextField) {
        self.layoutIfNeeded() // call
        UIView.animate(withDuration: 1) { [weak self] in
            guard let self = self else { return }
            self.ammountTextFieldWidthConstraint.constant = 45
            self.ammoutBgView.transform = .identity
            self.blurView.alpha = 0
            self.ammountTextField.backgroundColor = AppColor.inputInavtiveBackgroundColor
            
            self.layoutIfNeeded() // call
        }
    }
}
