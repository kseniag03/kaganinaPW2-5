//
//  ColorPaletteView.swift
//  kaganinaPW3
//

import Foundation
import UIKit

final class ColorPaletteView: UIControl, ChangeColor {
    private let defaultColor = UIColor.systemGray6
    private let stackView = UIStackView()
    private(set) var chosenColor: UIColor = .systemGray6
    
    private var redControl = ColorSliderView(colorName: "R", value:
                                                Float(UIColor.systemGray6.rgba.red))
    private var greenControl = ColorSliderView(colorName: "G", value:
                                                Float(UIColor.systemGray6.rgba.green))
    private var blueControl = ColorSliderView(colorName: "B", value:
                                                Float(UIColor.systemGray6.rgba.blue))
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        redControl.tag = 0
        greenControl.tag = 1
        blueControl.tag = 2
        
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.addArrangedSubview(redControl)
        stackView.addArrangedSubview(greenControl)
        stackView.addArrangedSubview(blueControl)
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 12
        
        [redControl, greenControl, blueControl].forEach {
            $0.addTarget(self, action:
                            #selector(sliderMoved(slider:)), for: .touchDragInside)
        }
        
        addSubview(stackView)
        stackView.pinTop(to: self, 8)
        stackView.pinLeft(to: self, 8)
        stackView.pinRight(to: self, 8)
        stackView.pinBottom(to: self, 8)
    }
    
    @objc
    private func sliderMoved(slider: ColorSliderView) {
        switch slider.tag {
        case 0:
            self.chosenColor = UIColor(
                red: CGFloat(slider.value),
                green: chosenColor.rgba.green,
                blue: chosenColor.rgba.blue,
                alpha: 1
            )
        case 1:
            self.chosenColor = UIColor(
                red: chosenColor.rgba.red,
                green: CGFloat(slider.value),
                blue: chosenColor.rgba.blue,
                alpha: 1
            )
        default:
            self.chosenColor = UIColor(
                red: chosenColor.rgba.red,
                green: chosenColor.rgba.green,
                blue: CGFloat(slider.value),
                alpha: 1
            )
        }
        sendActions(for: .touchDragInside)
    }
    
    func colorChange(to newColor: UIColor) {
        self.chosenColor = newColor
        self.redControl.colorChange(to: Float(newColor.rgba.red))
        self.greenControl.colorChange(to: Float(newColor.rgba.green))
        self.blueControl.colorChange(to: Float(newColor.rgba.blue))
    }
}

extension ColorPaletteView {
    private final class ColorSliderView: UIControl {
        private let slider = UISlider()
        private let colorLabel = UILabel()
        
        private(set) var value: Float
        
        init(colorName: String, value: Float) {
            self.value = value
            super.init(frame: .zero)
            
            slider.value = value
            colorLabel.text = colorName
            setupView()
            slider.addTarget(self, action: #selector(sliderMoved(_:)), for: .touchDragInside)
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setupView() {
            let stackView = UIStackView(arrangedSubviews: [colorLabel, slider])
            stackView.axis = .horizontal
            stackView.spacing = 8
            
            addSubview(stackView)
            stackView.pinTop(to: self, 8)
            stackView.pinLeft(to: self, 8)
            stackView.pinRight(to: self, 8)
            stackView.pinBottom(to: self, 8)
        }
        
        @objc
        private func sliderMoved(_ slider: UISlider) {
            self.value = slider.value
            sendActions(for: .touchDragInside)
        }
        
        func colorChange(to value: Float) {
            self.value = value
            self.slider.value = value
            sendActions(for: .touchDragInside)
        }
    }
}
