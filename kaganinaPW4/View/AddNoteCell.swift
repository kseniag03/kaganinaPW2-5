//
//  AddNoteCell.swift
//  kaganinaPW4
//

import Foundation
import UIKit

final class AddNoteCell: UITableViewCell, UITextViewDelegate {
    static let reuseIdentifier = "AddNoteCell"
    private var textView = UITextView()
    public var addButton = UIButton()
    
    public var delegate: AddNoteDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        textView.font = .systemFont(ofSize: 14, weight: .regular)
        textView.textColor = .tertiaryLabel
        textView.backgroundColor = .clear
        textView.setHeight(140)
        
        textView.delegate = self
        textView.text = "|"
        
        addButton.configuration = createAddButtonConfig()
        addButton.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [textView, addButton])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill
        
        contentView.addSubview(stackView)
        stackView.pinTop(to: contentView, 16)
        stackView.pinLeft(to: contentView, 16)
        stackView.pinRight(to: contentView, 16)
        stackView.pinBottom(to: contentView, 16)
        
        contentView.backgroundColor = .systemBackground
    }
    
    func createAddButtonConfig() -> UIButton.Configuration {
        var config: UIButton.Configuration = .filled()
        config.background.backgroundColor = .label
        config.baseBackgroundColor = .label
        config.baseForegroundColor = .systemBackground
        config.title = "Add new note"
        config.attributedTitle?.font = .systemFont(ofSize: 16, weight: .medium)
        config.buttonSize = .medium
        config.background.cornerRadius = 12
        return config
    }
    
    @objc
    private func addButtonTapped(_ sender: UIButton) {
        if !textView.text.elementsEqual("|") && !textView.text.isEmpty {
            self.delegate?.newNoteAdded(note: ShortNote(text: textView.text))
            textView.text = "|"
            textView.textColor = .tertiaryLabel
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .tertiaryLabel {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "|"
            textView.textColor = .tertiaryLabel
        }
    }
}
