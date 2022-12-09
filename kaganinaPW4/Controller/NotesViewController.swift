//
//  NotesViewController.swift
//  kaganinaPW4
//

import Foundation
import UIKit

final class NotesViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let button = UIButton()
    
    // file for current simulation (different list of notes for different devices)
    private let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        .appendingPathComponent("notes.json")
    
    private var dataSource: [ShortNote] {
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                do {
                    let notes = String(data: data, encoding: .utf8)
                    try notes?.write(to: path, atomically: false, encoding: .utf8)
                } catch {
                    print("Could not save new data")
                }
            }
        }
        get {
            if let data = try? Data(contentsOf: path) {
                if let notes = try? JSONDecoder().decode([ShortNote].self, from: data) {
                    return notes
                }
            }
            return [ShortNote]()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    }
     
    private func setupView() {
        setupTableView()
        setupNavBar()
    }
    
    private func setupNavBar() {
        self.title = "Notes"
        let closeButton = UIButton(type: .close)
        closeButton.layer.cornerRadius = 8
        closeButton.setHeight(10)
        closeButton.addTarget(self, action: #selector(dismissViewController(_:)), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
    }
    
    private func setupTableView() {
        tableView.register(NoteCell.self, forCellReuseIdentifier: NoteCell.reuseIdentifier)
        tableView.register(AddNoteCell.self, forCellReuseIdentifier: AddNoteCell.reuseIdentifier)
        
        self.view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.keyboardDismissMode = .onDrag
        tableView.dataSource = self
        tableView.delegate = self
        
        self.view.addSubview(self.tableView)
        tableView.setHeight(Int(self.view.viewHeight))
        tableView.pinTop(to: self.view.topAnchor)
        tableView.pinLeft(to: self.view, Int(self.view.viewWidth / 10))
        tableView.pinRight(to: self.view, Int(self.view.viewWidth / 10))
    }

    private func handleDelete(indexPath: IndexPath) {
        dataSource.remove(at: indexPath.row)
        tableView.reloadData()
    }

    @objc
    private func dismissViewController(_ sender: UIViewController) {
        self.dismiss(animated: true)
    }
}

extension NotesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch section {
        case 0:
            return 1
        default:
            return dataSource.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if let addNewCell = tableView.dequeueReusableCell(withIdentifier: AddNoteCell.reuseIdentifier, for: indexPath) as? AddNoteCell {
                addNewCell.delegate = self
                return addNewCell
            }
        default:
            let note = dataSource[indexPath.row]
            if let noteCell = tableView.dequeueReusableCell(withIdentifier: NoteCell.reuseIdentifier, for: indexPath) as? NoteCell {
                noteCell.configure(note)
                return noteCell
            }
        }
        return UITableViewCell()
    }
}

extension NotesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: .none
        ) {
            [weak self] (action, view, completion) in
            self?.handleDelete(indexPath: indexPath)
            completion(true)
        }
        deleteAction.image = UIImage(
            systemName: "trash.fill",
            withConfiguration: UIImage.SymbolConfiguration(weight: .bold)
        )?.withTintColor(.white)
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension NotesViewController: AddNoteDelegate {
    func newNoteAdded(note: ShortNote) {
        dataSource.insert(note, at: 0)
        tableView.reloadData()
    }
}
