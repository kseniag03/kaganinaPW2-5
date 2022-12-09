//
//  NewsListViewController.swift
//  kaganinaPW5
//

import Foundation
import UIKit

struct News: Codable {
    struct Article: Codable {
        let title: String
        let description: String
        let urlToImage: String
    }
    let articles: [Article]
}

class APIService {
    static let shared = APIService()
    
    enum APIError: Error {
        case error(_ errorString: String)
    }
    
    let source = "https://newsapi.org/v2/top-headlines?country=us&apiKey=514f26a474024d3d93cd9e4f2b72cf94"
    
    func getTopStories(completion: @escaping (Result<News,APIError>) -> Void) {
        guard let url = URL(string: source) else {
            completion(.failure(APIError.error("cannot get url")))
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(APIError.error(error.localizedDescription)))
                return
            }
            guard let data = data else {
                completion(.failure(APIError.error("bad data")))
                return
            }
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(News.self, from: data)
                completion(.success(decodedData))
            } catch let decodingError {
                completion(.failure(APIError.error("Error: \(decodingError.localizedDescription)")))
            }
        }.resume()
    }
}

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
        /*
         navigationItem.leftBarButtonItem = UIBarButtonItem(
         image: UIImage(systemName: "chevron.left"),
         style: .plain,
         target: self,
         action: #selector(goBack)
         )
     navigationItem.leftBarButtonItem?.tintColor = .label
        */
        
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
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        
        tableView.rowHeight = view.viewHeight / 10//120
        tableView.pinLeft(to: view)
        tableView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        tableView.pinRight(to: view)
        tableView.pinBottom(to: view, Int(view.viewHeight / 5))
        
        tableView.setHeight(Int(self.view.viewHeight))
    }
    
    private func setTableViewCell() {
        tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.reuseIdentifier)
    }

    private func fetchNews() {
        APIService.shared.getTopStories {
            [weak self] result in switch result {
            case .success(let articles):
                for i in articles.articles {
                    self?.newsViewModels.append(NewsViewModel(
                        title: i.title,
                        description: i.description,
                        imageURL: URL(string: i.urlToImage)
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
    
    // MARK: - Objc functions
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

final class NewsCell: UITableViewCell {
    static let reuseIdentifier = "NewsCell"
    
    private var newsImageView = UIImageView()
    private var newsTitleLabel = UILabel()
    private var newsDescriptionLabel = UILabel()
    
    // MARK: - Init
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
        setupImageView()
        setupTitleLabel()
        setupDescriptionLabel()
    }
    
    private func setupImageView() {
        newsImageView.image = UIImage(named: "landscape")
        newsImageView.layer.cornerRadius = 8
        newsImageView.layer.cornerCurve = .continuous
        newsImageView.clipsToBounds = true
        newsImageView.contentMode = .scaleAspectFill
        //newsImageView.backgroundColor = .secondarySystemBackground
        
        contentView.addSubview(newsImageView)
        //newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                           //constant: 12).isActive = true
        //newsImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor,
                                            //constant: 16).isActive = true
        //newsImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                             // constant: -12).isActive = true
        
        newsImageView.heightAnchor.constraint(equalToConstant:
                                                newsTitleLabel.font.lineHeight).isActive = true
        newsImageView.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: 12).isActive = true
        newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                            constant: 12).isActive = true
        newsImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                 constant: -12).isActive = true
        
        //newsImageView.setWidth(newsImageView.heightAnchor)
        //newsImageView.setWidth(Int(newsImageView.frame.height))
        //newsImageView.setHeight(16)
    }
    
    private func setupTitleLabel() {
        newsTitleLabel.text = "Hello"
        newsTitleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        newsTitleLabel.textColor = .label
        newsTitleLabel.numberOfLines = 1
        
        contentView.addSubview(newsTitleLabel)
        newsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        newsTitleLabel.heightAnchor.constraint(equalToConstant:
                                                newsTitleLabel.font.lineHeight).isActive = true
        newsTitleLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: 12).isActive = true
        newsTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                                            constant: 12).isActive = true
        newsTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                 constant: -12).isActive = true
        //newsTitleLabel.setHeight(16)
    }
    
    private func setupDescriptionLabel() {
        newsDescriptionLabel.text = "World"
        newsDescriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        newsDescriptionLabel.textColor = .secondaryLabel
        newsDescriptionLabel.numberOfLines = 5
        
        contentView.addSubview(newsDescriptionLabel)
        newsDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        newsDescriptionLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor,
                                                      constant: 12).isActive = true
        newsDescriptionLabel.topAnchor.constraint(equalTo: newsTitleLabel.bottomAnchor,
                                                  constant: 12).isActive = true
        newsDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                       constant: -16).isActive = true
        newsDescriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor,
                                                     constant: -12).isActive = true
        //newsDescriptionLabel.setHeight(16)
    }
    
    public func configure(with viewModel: NewsViewModel) {
        self.newsTitleLabel.text = viewModel.title
        self.newsDescriptionLabel.text = viewModel.description
        if let data = viewModel.imageData {
            self.newsImageView.image = UIImage(data: data)
        }
        else if let url = viewModel.imageURL {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data else {
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}

final class NewsViewModel {
    let title: String
    let description: String
    let imageURL: URL?
    var imageData: Data? = nil

    init(title: String, description: String, imageURL: URL?) {
        self.title = title
        self.description = description
        self.imageURL = imageURL
    }
}

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
        
        //imageView.pin(to: view, [.left: 0, .right: 0])
        imageView.pinLeft(to: view, 0)
        imageView.pinRight(to: view, 0)
        
        imageView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        //imageView.pinHeight(to: imageView.widthAnchor, 1)
        imageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 16).isActive = true
        imageView.setHeight(Int(view.viewWidth))
    }
    
    private func setTitleLabel() {
        titleLabel.text = "Hello"
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .label
        view.addSubview(titleLabel)
        titleLabel.pinTop(to: imageView.bottomAnchor, 12)
        
        //titleLabel.pin(to: view, [.left: 16, .right: 16])
        titleLabel.pinLeft(to: view, 16)
        titleLabel.pinRight(to: view, 16)
        
        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 16).isActive = true
        titleLabel.setHeight(16)
        
    }
            
    private func setDescriptionLabel() {
        descriptionLabel.text = "World"
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .secondaryLabel
        view.addSubview(descriptionLabel)
        
        //descriptionLabel.pin(to: view, [.left: 16, .right: 16])
        descriptionLabel.pinLeft(to: view, 16)
        //descriptionLabel.pinRight(to: view, 16)
        
        descriptionLabel.pinTop(to: titleLabel.bottomAnchor, 8)
        
        descriptionLabel.setHeight(16)
    }
    
    // MARK: - Public Methods
    public func configure(with viewModel: NewsViewModel) {
        self.titleLabel.text = viewModel.title
        self.descriptionLabel.text = viewModel.description
        if let data = viewModel.imageData {
            self.imageView.image = UIImage(data: data)
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
    
    // MARK: - Objc functions
    @objc
    private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
}
