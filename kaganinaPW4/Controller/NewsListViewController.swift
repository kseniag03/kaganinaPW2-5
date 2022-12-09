//
//  NewsListViewController.swift
//  kaganinaPW5
//

import Foundation
import UIKit

final class NewsListViewController: UIViewController {
    private var fetchButton = UIButton()
    private var tableView = UITableView(frame: .zero, style: .plain)
    private var isLoading = false
    private var newsViewModels = [NewsViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupFetchButton()
        configureTableView()
    }
    
    private func configureTableView() {
        setTableViewUI()
        setTableViewDelegate()
        setTableViewCell()
    }
    
    private func setupFetchButton() {
         navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.clockwise"),
            style: .plain,
            target: self,
            action: #selector(fetchButtonPressed)
         )
        navigationItem.rightBarButtonItem?.tintColor = .label
        
        fetchButton.configuration = createFetchButtonConfig()
        fetchButton.alpha = 0.75
        
        view.addSubview(fetchButton)
        fetchButton.pinLeft(to: view, 16)
        fetchButton.pinRight(to: view, 16)
        fetchButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
        
        fetchButton.addTarget(self, action: #selector(fetchButtonPressed(_:)), for: .touchUpInside)
    }
    
    func createFetchButtonConfig() -> UIButton.Configuration {
        var config: UIButton.Configuration = .filled()
        config.background.backgroundColor = .label
        config.baseBackgroundColor = .label
        config.baseForegroundColor = .systemBackground
        config.title = "Fetch new articles"
        config.attributedTitle?.font = .systemFont(ofSize: 16, weight: .medium)
        config.buttonSize = .medium
        config.background.cornerRadius = 12
        return config
    }

    private func setTableViewDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setTableViewUI() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        
        view.addSubview(tableView)
        tableView.rowHeight = view.viewHeight / 10
        tableView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        tableView.pinLeft(to: view)
        tableView.pinRight(to: view)
        tableView.pinBottom(to: view, Int(view.viewHeight / 10))
    }
    
    private func setTableViewCell() {
        tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.reuseIdentifier)
    }

    private func fetchNews() {
        ApiService.shared.getTopStories {
            [weak self] result in switch result {
            case .success(let articles):
                for i in articles.articles {
                    self?.newsViewModels.append(NewsViewModel(
                        title: i.title,
                        description: i.description,
                        imageURL: URL(string: i.urlToImage ?? "")
                    ))
                }
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc
    private func fetchButtonPressed(_ sender: UIButton) {
        fetchNews()
    }
    
    @objc
    private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension NewsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading { }
        else {
            return newsViewModels.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading {}
        else {
            let viewModel = newsViewModels[indexPath.row]
            if let newsCell = tableView.dequeueReusableCell(withIdentifier: NewsCell.reuseIdentifier,
                                                            for: indexPath) as? NewsCell {
                newsCell.configure(with: viewModel)
                return newsCell
            }
        }
        return UITableViewCell()
    }
}

extension NewsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isLoading {
            let newsVC = NewsViewController()
            newsVC.configure(with: newsViewModels[indexPath.row])
            navigationController?.pushViewController(newsVC, animated: true)
        }
    }
}
