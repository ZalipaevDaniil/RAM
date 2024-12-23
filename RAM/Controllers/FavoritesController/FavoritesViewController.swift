//
//  Untitled.swift
//  RAM
//
//  Created by Aaa on 26.10.2024.
//
import UIKit
import Combine

final class FavoritesCollectionViewController: UICollectionViewController {
    
    let eventPublisher = PassthroughSubject<Event, Never>()
    //MARK: Private Property
    private var baseURL = "https://rickandmortyapi.com/api/character"
    var viewModel: EpisodeViewModel! {
        didSet {
            viewModel.getAllCharacters(from: baseURL) { [ weak self] in
                self?.viewModel.filterFavoritesCharacters()
                print("Favorites(viewModel) in  FavCVC: \(String(describing: self?.viewModel.filterFavoritesCharacters()))")
                self?.collectionView.reloadData()
            }
        }
    }
    
    init(viewModel:EpisodeViewModel, collectionViewLayout layout: UICollectionViewLayout) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: layout)
    }
    
    weak var detailsControllerDelegate: DetailViewControllerDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewModel.filterFavoritesCharacters()
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshFavorites), name: .favoritesDidUpdate, object: nil)
        collectionView.delegate = self
        setupCollectionView()
        setupNavigationTitle()
        
        collectionView.backgroundView = UIView()
        collectionView.backgroundView?.backgroundColor = .backGround
        eventPublisher.send(.episodesComplete)
    }
    
    @objc private func refreshFavorites() {
        viewModel.filterFavoritesCharacters()
        collectionView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: Collection View Data Source
extension FavoritesCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.favoritesCharacters.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EpisodesCell.reuseID, for: indexPath) as? EpisodesCell else{ return UICollectionViewCell()}
        
        let characters = viewModel.favoritesCharacters[indexPath.row]
        let cellViewModel = EpisodesCellViewModel(dependency: self.viewModel.dependencies, character: characters)
        cell.viewModel = cellViewModel
        
        cellViewModel.didChange = { [weak self ] viewModel in
            guard let self = self else { return }
            if !viewModel.isFavorite {
                if let index = self.viewModel.favoritesCharacters.firstIndex(where: {$0.id == viewModel.character.id}) {
                    self.viewModel.favoritesCharacters.remove(at: index)
                    self.collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
                }
            } else {
                self.viewModel.favoritesCharacters.append(viewModel.character)
                self.collectionView.reloadData()
            }
        }
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("cell pressed \(indexPath.row)")
        if let character = viewModel?.favoritesCharacters[indexPath.row] {
            detailsControllerDelegate?.didTappedOnFavoritesCharacter(character, viewModel.dependencies)
        }
    }
}
//MARK: Collection View Delegate Flow Layout
extension FavoritesCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionInset : CGFloat = 16
        let width = collectionView.bounds.width - sectionInset * 2
        let height: CGFloat = 390
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets.init(top: 12, left: 0, bottom: 0, right: 0)
    }
}


//MARK: Private Methods
private extension FavoritesCollectionViewController {
    func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(EpisodesCell.self, forCellWithReuseIdentifier: EpisodesCell.reuseID)
    }
    
    func setupNavigationTitle() {
        let titleLable = UILabel()
        titleLable.text = "Favourites episodes"
        titleLable.font = .systemFont(ofSize: 24, weight: .bold)
        titleLable.textColor = .black
        titleLable.textAlignment = .center
        titleLable.translatesAutoresizingMaskIntoConstraints = false
       
        navigationItem.titleView? = titleLable
    }
}


extension FavoritesCollectionViewController {
    enum Event {
        case episodesComplete
    }
}

