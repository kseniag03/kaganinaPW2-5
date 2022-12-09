//
//  NewsViewController.swift
//  kaganinaPW5
//

import Foundation
import UIKit

final class NewsViewController: UIViewController {
    private var imageView = UIImageView()
    private var titleLabel = UILabel()
    private var descriptionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupNavbar()
        setImageView()
        setTitleLabel()
        setDescriptionLabel()
    }
    
    private func setupNavbar() {
        navigationItem.title = "News"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(goBack)
            )
        navigationItem.leftBarButtonItem?.tintColor = .label
    }
    
    private func setImageView() {
        imageView.image = UIImage(named: "landscape")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        view.addSubview(imageView)
        imageView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        imageView.pinLeft(to: view, 0)
        imageView.pinRight(to: view, 0)
        imageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 16).isActive = true
        imageView.pinHeight(to: view.widthAnchor)
    }
    
    private func setTitleLabel() {
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .label
        
        view.addSubview(titleLabel)
        titleLabel.pinTop(to: imageView.bottomAnchor, 12)
        titleLabel.pinLeft(to: view, 16)
        titleLabel.pinRight(to: view, 16)
        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 16).isActive = true
    }
            
    private func setDescriptionLabel() {
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .secondaryLabel
        
        view.addSubview(descriptionLabel)
        descriptionLabel.pinTop(to: titleLabel.bottomAnchor, 8)
        descriptionLabel.pinLeft(to: view, 16)
        descriptionLabel.pinRight(to: view, 16)
    }
    
    public func configure(with viewModel: NewsViewModel) {
        self.titleLabel.text = viewModel.title
        self.descriptionLabel.text = viewModel.description
        if let data = viewModel.imageData {
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = UIImage(data: data)
            }
        }
        else if let url = viewModel.imageURL {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data else {
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.imageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
    
    @objc
    private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
}
