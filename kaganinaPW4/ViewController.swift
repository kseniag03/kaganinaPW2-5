//
//  ViewController.swift
//  kaganinaPW3
//

import UIKit

extension UIView {
    public var viewWidth: CGFloat {
        return self.frame.size.width
    }
    
    public var viewHeight: CGFloat {
        return self.frame.size.height
    }
    
    @discardableResult
    func pin(to superview: UIView) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = leadingAnchor.constraint(
            equalTo: superview.leadingAnchor
        )
        constraint.isActive = true
        return constraint
    }

    @discardableResult
    func pinLeft(to superview: UIView, _ const: Int = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = leadingAnchor.constraint(
            equalTo: superview.leadingAnchor,
            constant: CGFloat(const)
        )
        constraint.isActive = true
        return constraint
    }

    @discardableResult
    func pinRight(to superview: UIView, _ const: Int = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = trailingAnchor.constraint(
            equalTo: superview.trailingAnchor,
            constant: CGFloat(const * -1)
        )
        constraint.isActive = true
        return constraint
    }

    @discardableResult
    func pinTop(to superview: UIView, _ const: Int = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = topAnchor.constraint(
            equalTo: superview.topAnchor,
            constant: CGFloat(const)
        )
        constraint.isActive = true
        return constraint
    }

    @discardableResult
    func pinTop(to side: NSLayoutYAxisAnchor, _ const: Int = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = topAnchor.constraint(
            equalTo: side,
            constant: CGFloat(const)
        )
        constraint.isActive = true
        return constraint
    }

    @discardableResult
    func pinBottom(to superview: UIView, _ const: Int = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = bottomAnchor.constraint(
            equalTo: superview.bottomAnchor,
            constant: CGFloat(const * -1)
        )
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func pinBottom(to side: NSLayoutYAxisAnchor, _ const: Int = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = bottomAnchor.constraint(
            equalTo: side,
            constant: CGFloat(const)
        )
        constraint.isActive = true
        return constraint
    }

    @discardableResult
    func pinCenterX(to superview: UIView, _ const: Int = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = centerXAnchor.constraint(
            equalTo: superview.centerXAnchor,
            constant: CGFloat(const)
        )
        constraint.isActive = true
        return constraint
    }

    @discardableResult
    func pinCenterY(to superview: UIView, _ const: Int = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = centerYAnchor.constraint(
            equalTo: superview.centerYAnchor,
            constant: CGFloat(const)
        )
        constraint.isActive = true
        return constraint
    }

    @discardableResult
    func setHeight(_ const: Int) -> NSLayoutConstraint {
        let constraint = heightAnchor.constraint(equalToConstant: CGFloat(const))
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func setWidth(_ const: Int) -> NSLayoutConstraint {
        let constraint = widthAnchor.constraint(equalToConstant: CGFloat(const))
        constraint.isActive = true
        return constraint
    }

    func pinCenter(to superview: UIView) {
        pinCenterX(to: superview)
        pinCenterY(to: superview)
    }
}

extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red, green, blue, alpha)
    }
}

protocol ChangeColor {
    func colorChange(to newColor: UIColor)
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

final class WelcomeViewController: UIViewController {
    private let commentLabel = UILabel()
    private let valueLabel = UILabel()

    private let incrementButton = UIButton()

    private let commentView = UIView()

    private var value: Int = 0
    
    private var buttonsSV = UIStackView()
    
    private let colorPaletteView = ColorPaletteView()
    
    //private let notesViewController = NotesViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.backgroundColor = .systemGray6
        setupIncrementButton()
        setupValueLabel()
        setupCommentView()
        setupMenuButtons()
        setupColorControlSV()
    }

    private func setupIncrementButton() {
        incrementButton.setTitle("Increment", for: .normal)
        incrementButton.setTitleColor(.black, for: .normal)
        incrementButton.layer.cornerRadius = 12
        incrementButton.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .medium)
        incrementButton.backgroundColor = .white

        incrementButton.layer.shadowColor = CGColor(
            red: 0,
            green: 0,
            blue: 0,
            alpha: 1
        )
        incrementButton.layer.shadowOffset = CGSize(width: 0.25, height: 0.5)
        incrementButton.layer.shadowOpacity = 0.25

        self.view.addSubview(incrementButton)
        incrementButton.setHeight(Int(self.view.viewHeight / 20))
        incrementButton.pinTop(to: self.view.centerYAnchor)
        incrementButton.pinLeft(to: self.view, Int(self.view.viewWidth / 10))
        incrementButton.pinRight(to: self.view, Int(self.view.viewWidth / 10))
        
        incrementButton.addTarget(self, action: #selector(incrementButtonPressed), for: .touchUpInside)
    }

    private func setupValueLabel() {
        valueLabel.font = .systemFont(ofSize: 40.0, weight: .bold)
        valueLabel.textColor = .black
        valueLabel.text = "\(value)"

        self.view.addSubview(valueLabel)
        valueLabel.setHeight(Int(self.view.viewHeight / 20))
        valueLabel.pinBottom(to: self.view,
                             Int(self.view.viewHeight / 2 + incrementButton.viewHeight + 10))
        valueLabel.pinCenter(to: self.view)
    }

    private func setupCommentView() {
        commentView.backgroundColor = .white
        commentView.layer.cornerRadius = 12

        self.view.addSubview(commentView)
        commentView.setHeight(Int(self.view.viewHeight / 30))
        commentView.pinTop(to: self.view.safeAreaLayoutGuide.topAnchor)
        commentView.pinLeft(to: self.view, Int(self.view.viewWidth / 10))
        commentView.pinRight(to: self.view, Int(self.view.viewWidth / 10))

        commentLabel.font = .systemFont(ofSize: 14.0, weight: .regular)
        commentLabel.textColor = .systemGray
        commentLabel.numberOfLines = 0
        commentLabel.textAlignment = .center

        commentView.addSubview(commentLabel)
        commentLabel.pinTop(to: commentView, 5)
        commentLabel.pinLeft(to: commentView, 5)
        commentLabel.pinRight(to: commentView, 5)
        commentLabel.pinBottom(to: commentView, 5)
    }

    @objc
    private func incrementButtonPressed() {
        value += 1
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        updateUI()
    }

    func updateUI() {
        UIView.transition(
            with: self.view,
            duration: 0.5,
            options: .transitionCrossDissolve,
            animations: {
                self.valueLabel.text = "\(self.value)"
                self.updateCommentLabel(value: self.value)
                self.incrementButton.layer.shadowOffset = CGSize(width: 1, height: 2)
                self.incrementButton.layer.shadowOpacity = 0.5
            }
        )
        UIView.transition(
            with: self.view,
            duration: 0.5,
            options: .transitionCrossDissolve,
            animations: {
                self.incrementButton.layer.shadowOffset = CGSize(width: 0.25, height: 0.5)
                self.incrementButton.layer.shadowOpacity = 0.25
            }
        )
    }

    func updateCommentLabel(value: Int) {
        switch value {
        case 0...10:
            commentLabel.text = "1"
        case 10...20:
            commentLabel.text = "2"
        case 20...30:
            commentLabel.text = "3"
        case 30...40:
            commentLabel.text = "4"
        case 40...50:
            commentLabel.text = "! ! ! ! ! ! ! ! ! "
        case 50...60:
            commentLabel.text = "big boy"
        case 60...70:
            commentLabel.text = "70 70 70 moreeeee"
        case 70...80:
            commentLabel.text = "⭐ ⭐ ⭐ ⭐ ⭐ ⭐ ⭐ ⭐ ⭐ "
        case 80...90:
            commentLabel.text = "80+\n go higher!"
        case 90...100:
            commentLabel.text = "100!! to the moon!!"
        default:
            commentLabel.text = ". . ."
            break
        }
    }

    private func makeMenuButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .medium)
        button.backgroundColor = .white
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        return button
    }

    private func setupMenuButtons() {
        let colorsButton = makeMenuButton(title: "🎨")
        colorsButton.addTarget(self, action: #selector(paletteButtonPressed), for: .touchUpInside)
        
        let notesButton = makeMenuButton(title: "✏")
        notesButton.addTarget(self, action: #selector(notesButtonPressed), for: .touchUpInside)
        
        let newsButton = makeMenuButton(title: "📰")
        newsButton.addTarget(self, action: #selector(newsButtonPressed), for: .touchUpInside)

        buttonsSV = UIStackView(arrangedSubviews: [colorsButton, notesButton, newsButton])
        buttonsSV.spacing = 12
        buttonsSV.axis = .horizontal
        buttonsSV.distribution = .fillEqually

        self.view.addSubview(buttonsSV)
        buttonsSV.pinLeft(to: self.view, Int(self.view.viewWidth / 10))
        buttonsSV.pinRight(to: self.view, Int(self.view.viewWidth / 10))
        buttonsSV.pinBottom(to: self.view, Int(self.view.viewHeight / 10))
    }
    
    private func setupColorControlSV() {
        colorPaletteView.isHidden = true
        view.addSubview(colorPaletteView)
        
        colorPaletteView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colorPaletteView.topAnchor.constraint(equalTo: incrementButton.bottomAnchor, constant: 5),
            colorPaletteView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: self.view.viewWidth / 30),
            colorPaletteView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -self.view.viewWidth / 30),
            colorPaletteView.bottomAnchor.constraint(equalTo: buttonsSV.topAnchor, constant: -1)
            ])
        colorPaletteView.addTarget(self, action: #selector(changeColor(_:)), for: .touchDragInside)
    }
    
    @objc
    private func notesButtonPressed() {
        let notesViewController = NotesViewController()
        notesViewController.view.backgroundColor = view.backgroundColor ?? .systemBackground
        /*if let sheet = self.notesViewController.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        self.present(self.notesViewController, animated: true, completion: nil)*/
        
        navigationController?.pushViewController(notesViewController, animated: true)
    }
    
    @objc private func newsButtonPressed() {
        let newsListController = NewsListViewController()
        newsListController.view.backgroundColor = view.backgroundColor ?? .systemBackground
        navigationController?.pushViewController(newsListController, animated: true)
    }
    
    @objc
    private func paletteButtonPressed() {
        colorPaletteView.isHidden.toggle()
        colorPaletteView.colorChange(to: self.view.backgroundColor ?? .systemGray6)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    @objc
    private func changeColor(_ slider: ColorPaletteView) {
        UIView.animate(withDuration: 0.5) {
            self.view.backgroundColor = slider.chosenColor
        }
    }
}
