//
//  AppTextField.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 18/04/21.
//

import UIKit

@IBDesignable open class AppTextField: UITextField {

    // MARK: - Properties

    @IBInspectable open var activeBorderColor: UIColor = AppColor.defaultBorderColor {
        didSet {
            updateControl()
        }
    }

    @IBInspectable open var inactiveBorderColor: UIColor = UIColor.clear {
        didSet {
            updateControl()
        }
    }

    @IBInspectable open var activeBackgroundColor: UIColor = AppColor.inputAvtiveBackgroundColor {
        didSet {
            updateControl()
        }
    }

    @IBInspectable open var inactiveBackgroundColor: UIColor = AppColor.inputInavtiveBackgroundColor {
        didSet {
            updateControl()
        }
    }

    // Determines whether the field is selected. When selected, the title floats above the textbox.
    open override var isSelected: Bool {
        didSet {
            updateControl(true)
        }
    }

    /// A Boolean value that determines whether the textfield is being edited or is selected.
    open var editingOrSelected: Bool {
        return super.isEditing || isSelected
    }

    /// The backing property for the highlighted property
    fileprivate var _highlighted: Bool = false

    /**
     A Boolean value that determines whether the receiver is highlighted.
     When changing this value, highlighting will be done with animation
     */
    override open var isHighlighted: Bool {
        get {
            return _highlighted
        }set {
            _highlighted = newValue
            updateControl()
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)

        commonInit()
    }

    private func commonInit() {
        layer.cornerRadius = 5
        layer.borderWidth = 2
        updateColors()
        addEditingChangedObserver()
    }

    fileprivate func addEditingChangedObserver() {
        self.addTarget(self, action: #selector(editingChanged(_ :)), for: .editingChanged)
    }

    /**
     Invoked when the editing state of the textfield changes. Override to respond to this change.
     */
    @objc open func editingChanged(_ textField: UITextField) {
        updateControl(true)
    }

    // MARK: - View updates

    fileprivate func updateControl(_ animated: Bool = false) {
        updateColors()
    }

    // MARK: - Color updates

    /// Update the colors for the control. Override to customize colors.
    open func updateColors() {
        updateBackgroundColor()
    }

    fileprivate func updateBackgroundColor() {
        if editingOrSelected || isHighlighted {
            self.layoutIfNeeded() // call
            UIView.animate(withDuration: 1) { [weak self] in
                guard let self = self else { return }
                self.backgroundColor = self.activeBackgroundColor
                self.layer.borderColor = self.activeBorderColor.cgColor
                self.layoutIfNeeded() // call
            }
        } else {
            self.layoutIfNeeded() // call
            UIView.animate(withDuration: 1) { [weak self] in
                guard let self = self else { return }
                self.backgroundColor = self.inactiveBackgroundColor
                self.layer.borderColor = self.inactiveBorderColor.cgColor
                self.layoutIfNeeded() // call
            }
        }
    }

    // MARK: Responder handling

    /**
     Attempt the control to become the first responder
     - returns: True when successfull becoming the first responder
     */
    @discardableResult
    override open func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        updateControl(true)
        return result
    }

    /**
     Attempt the control to resign being the first responder
     - returns: True when successfull resigning being the first responder
     */
    @discardableResult
    override open func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        updateControl(true)
        return result
    }

    // MARK: - Layout

    /// Invoked when the interface builder renders the control
    override open func prepareForInterfaceBuilder() {
        if #available(iOS 8.0, *) {
            super.prepareForInterfaceBuilder()
        }

        isSelected = true
        updateControl(false)
        invalidateIntrinsicContentSize()
    }
}
