//
//  Untitled.swift
//  RAM
//
//  Created by Aaa on 14.12.2024.
//
import UIKit

final class DetailsInfoTableView: UIView {
    
    var character: CharacterResponse!
    private let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .backGround
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Table View Data Source

extension DetailsInfoTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        switch indexPath.item {
        case 0:
            content.attributedText = setAtributedText("Gender")
            content.secondaryAttributedText = setSecondaryAtributedText(character.gender)
        case 1:
            content.attributedText = setAtributedText("Status")
            content.secondaryAttributedText = setSecondaryAtributedText(character.status)
        case 2:
            content.attributedText = setAtributedText("Specie")
            content.secondaryAttributedText = setSecondaryAtributedText(character.species)
        case 3:
            content.attributedText = setAtributedText("Origin")
            content.secondaryAttributedText = setSecondaryAtributedText(character.origin.name)
        case 4:
            content.attributedText = setAtributedText("Type")
            content.secondaryAttributedText = setSecondaryAtributedText(character.type)
        case 5:
            content.attributedText = setAtributedText("Location")
            content.secondaryAttributedText = setSecondaryAtributedText(character.location.name)
        default: break
        }
        
        cell.selectionStyle = .none
        cell.contentConfiguration = content
        return cell
    }
    
}

//MARK: Private Methods
private extension DetailsInfoTableView {
    private func setupTableView() {
        self.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "detailCell")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        setupInformationLogo()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant:  20),
            tableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupInformationLogo() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 24))
        let label = UILabel()
        
        view.addSubview(label)
        
        label.attributedText = NSAttributedString(string: "Information", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        label.sizeToFit()
        tableView.tableHeaderView = view
    }
    
    func setAtributedText(_ text: String) -> NSAttributedString {
        NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .semibold)])
    }
    
    
    func setSecondaryAtributedText(_ text: String) -> NSAttributedString {
        NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.gray])
    }
    
}
