//
//  NoteCell.swift
//  kaganinaPW4
//

import Foundation
import UIKit

final class NoteCell : UITableViewCell {
    static let reuseIdentifier = "NoteCell"
    private var textlabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        setupView()
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setupView() {
        textlabel.font = .systemFont(ofSize: 16, weight: .regular)
        textlabel.textColor = .label
        textlabel.numberOfLines = 0
        textlabel.backgroundColor = .clear
        
        contentView.backgroundColor = .systemBackground
        
        contentView.addSubview(textlabel)
        textlabel.pinTop(to: contentView, 16)
        textlabel.pinLeft(to: contentView, 16)
        textlabel.pinRight(to: contentView, 16)
        textlabel.pinBottom(to: contentView, 16)
    }
    
    public func configure(_ note: ShortNote) {
        textlabel.text = note.text
    }
}
