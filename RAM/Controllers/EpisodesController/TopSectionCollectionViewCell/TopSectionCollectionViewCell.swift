//
//  Untitled.swift
//  RAM
//
//  Created by Aaa on 04.11.2024.
//

import UIKit

final class TopSectionCollectionViewCell: UICollectionViewCell {
    //MARK: Outlets
    private let imageView = UIImageView()
    private let searchTextField = UITextField()
    private let filterButton = UIButton(type: .system)
    
    //MARK: Public Property
    static let reuseID: String = "TopSection"
    var viewModel: EpisodeViewModel?
    
    //MARK: Private Property
    //private var filterTypeHundler: ((SearchByEpisode) -> Void)?
    //private var selectedFilterType: SearchByEpisode = .byName
    
    //MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    //MARK: Delegate
    weak var delegateTopSection: TopSectionCollectionViewControllerDelegate?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Objc Methods
    @objc func searchButtonPressed () {
        guard let text = searchTextField.text, !text.isEmpty else {return}
        viewModel?.searchEpisodes(query: text.lowercased(), completion: {[weak self] in
            self?.delegateTopSection?.filterDidChose()
        })
    }
    
    //MARK: Overrited Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //при касании экрана завершается редактирование поля ввода(пропадает курсор)
        super.touchesBegan(touches, with: event)
        contentView.endEditing(true)
    }
    
}
    //MARK: - Private Methods
    private extension TopSectionCollectionViewCell {
        func setupUI() {
            contentView.backgroundColor = UIColor(named: "BackGroundColor")
            setupImageView()
            setupSearchTextField()
            setupFilterButton()
            setupMenu()
        }
        
        func setupImageView() {
            imageView.image = UIImage(named: "MainImageLaunch")
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            contentView.addSubview(imageView)
            setupConstraintImageView()
            
        }
        
        func setupSearchTextField() {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 24))
            let imageView = UIImageView(image: UIImage(named: "search"))
            imageView.tintColor = UIColor(named: "searchColor")
            imageView.contentMode = .scaleAspectFit
            imageView.frame = CGRect(x: 15, y: 0, width: 20, height: 20)
            view.addSubview(imageView)
            
            searchTextField.leftView = view
            searchTextField.leftViewMode = .always
            
            searchTextField.translatesAutoresizingMaskIntoConstraints = false
            searchTextField.clipsToBounds = true
            searchTextField.placeholder = "Name or episode (ex.S01E01)..."
            searchTextField.borderStyle = .roundedRect
            searchTextField.tintColor = .darkGray
            searchTextField.layer.cornerRadius = 8
            
            
            searchTextField.delegate = self
            searchTextField.returnKeyType = .search
            contentView.addSubview(searchTextField)
            setupConstraintSearchTextField()
        }
        
        func setupFilterButton() {
            let image = UIImageView(image: UIImage(named: "filter"))
            image.tintColor = .black
            image.contentMode = .scaleAspectFit
            filterButton.addSubview(image)
            image.frame = CGRect(x: 19, y: 20, width: 22, height: 14)
            
            filterButton.backgroundColor = UIColor(named: "backFilterButtonColor")
            filterButton.setTitle("ADVANCED FILTERS", for: .normal)
            filterButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
            filterButton.layer.cornerRadius = 4
            filterButton.translatesAutoresizingMaskIntoConstraints = false
            filterButton.clipsToBounds = true
            filterButton.contentMode = .scaleAspectFit
            
            contentView.addSubview(filterButton)
            setupConstraintFilterButton()
        }
        
        //MARK: - UIMenu
        func setupMenu() {
            let defaultAction = UIAction(title: "Default") { [weak self] _ in
                self?.viewModel?.fetchCharacters(from: "https://rickandmortyapi.com/api/character") { [weak self] in
                    self?.delegateTopSection?.filterDidChose()
                }
            }
            
            let aliveAction = UIAction(title: "Alive") { [weak self] _ in
                self?.viewModel?.statusSelected(status: .alive) {
                    self?.delegateTopSection?.filterDidChose()
                }
            }
            
            let deadAction = UIAction(title: "Dead") { [weak self] _ in
                self?.viewModel?.statusSelected(status: .dead){
                    self?.delegateTopSection?.filterDidChose()
                }
            }
            
            let unknownAction = UIAction(title: "Unknown") { [weak self] _ in
                self?.viewModel?.statusSelected(status: .unknown) {
                    self?.delegateTopSection?.filterDidChose()
                }
            }
            
            let femaleAction = UIAction(title: "Female") { [weak self] _ in
                self?.viewModel?.genderSelected(gender: .female) {
                    self?.delegateTopSection?.filterDidChose()
                }
            }
            
            let maleAction = UIAction(title: "Male") { [weak self] _ in
                self?.viewModel?.genderSelected(gender: .male) {
                    self?.delegateTopSection?.filterDidChose()
                }
            }
            
            let gendeerless = UIAction(title: "Genderless") { [weak self] _ in
                self?.viewModel?.genderSelected(gender: .genderless) {
                    self?.delegateTopSection?.filterDidChose()
                }
            }
            
            let unknownGAction = UIAction(title: "Unknown") {[ weak self ] _ in
                self?.viewModel?.genderSelected(gender: .unknown) {
                    self?.delegateTopSection?.filterDidChose()
                }
            }
            
            let statusMenu = UIMenu(title: "Status", children: [aliveAction, deadAction, unknownAction])
            let genderMenu = UIMenu(title: "Gender", children: [femaleAction, maleAction, gendeerless, unknownGAction])
            
            let mainMenu = UIMenu(children: [statusMenu, genderMenu, defaultAction])
            
            filterButton.menu = mainMenu
            filterButton.showsMenuAsPrimaryAction = true
        }
   
        func setupConstraintImageView() {
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
                imageView.heightAnchor.constraint(equalToConstant: 100)
            ])
            
        }
        
        func setupConstraintSearchTextField() {
            NSLayoutConstraint.activate([
                searchTextField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 60),
                searchTextField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                searchTextField.widthAnchor.constraint(equalTo: contentView.widthAnchor),
                searchTextField.heightAnchor.constraint(equalToConstant: 56)
                
            ])
        }
        
        func setupConstraintFilterButton() {
            NSLayoutConstraint.activate([
                filterButton.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 12),
                filterButton.widthAnchor.constraint(equalTo: contentView.widthAnchor),
                filterButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                filterButton.heightAnchor.constraint(equalToConstant: 56)
            ])
        }
    }
    
extension TopSectionCollectionViewCell : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //вызывается кри нажатии на поле ввода(при редактировании)
        let keyboardToolBar = UIToolbar() //добавляет toolBar с кнопкой Search
        keyboardToolBar.translatesAutoresizingMaskIntoConstraints = false
        let doneButton = UIBarButtonItem (
            title: "Search",
            style: .plain,
            target: self,
            action: #selector(searchButtonPressed)
        )
        
        let flexBarButton = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil)
            
        keyboardToolBar.sizeToFit()
        keyboardToolBar.items = [flexBarButton, doneButton]
        textField.inputAccessoryView = keyboardToolBar
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //вызывается при нажатии на Enter и ->
        searchTextField.resignFirstResponder()
        print("pressed")
        searchButtonPressed() //запускает поиск
        return true
    }
}
