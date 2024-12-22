//
//  Untitled.swift
//  RAM
//
//  Created by Aaa on 27.10.2024. 4
//

import UIKit
import Combine

protocol DetailViewControllerDelegate: AnyObject {
    func didTappedOnCharacter(_ character: CharacterResponse, _ dependencies: Dependencies)
    func didTappedOnFavoritesCharacter(_ character: CharacterResponse, _ dependencies: Dependencies)
}

protocol TopSectionCollectionViewControllerDelegate: AnyObject {
    func filterDidChose()
}


class EpisodesCollectionViewController: UICollectionViewController {
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    let eventPublisher = PassthroughSubject<Event, Never>()
    let baseURL = "https://rickandmortyapi.com/api/character"
    
    //MARK: Public Propertie
    var viewModel: EpisodeViewModel!{
    
        didSet {
            guard let viewModel = viewModel else { return }
            viewModel.fetchCharacters(from: baseURL) { [weak self] in
                guard let self = self else { return }
                guard !viewModel.characters.isEmpty else { return }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                }
            }
        }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var detailsViewControllerDelegate: DetailViewControllerDelegate?
    
    //MARK: Private Properties
    private var isShowMoreEpisode: Bool = false
    private let logoImageView = UIImageView(image: UIImage(named: "MainImageLaunch"))
    //CombineSubscription
    private var cancellables = Set<AnyCancellable>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("EpisodesCollectionViewController - viewDidLoad")
        
        eventPublisher.send(.episodesComplete)
        setUpCollectionView()
    }

    //Обновляет данные в коллекции перед появлением экрана.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }

    enum Event {
        case episodesComplete
    }
    
}


//MARK: - Private methods
private extension EpisodesCollectionViewController {
    func setUpCollectionView() {

        
        
        collectionView.backgroundView = UIView()
        collectionView.backgroundView?.backgroundColor = UIColor(named: "backgroundColor")
        
        collectionView.backgroundColor = .white
        
        
        collectionView.register(EpisodesCell.self, forCellWithReuseIdentifier: EpisodesCell.reuseID)
        
        collectionView.register(TopSectionCollectionViewCell.self, forCellWithReuseIdentifier: TopSectionCollectionViewCell.reuseID)
        
        collectionView.register(FooterLoadingCollectionResableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterLoadingCollectionResableView.reuseID)
        
    }

    
    
}
//MARK: - Collection View Data Source
extension EpisodesCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else {return 0}
        switch section {
        case 0:
            return 1
        case 1:
            return viewModel.characters.count
        default:
            return 0
        }
    }//Для секции 0 возвращается 1 элемент (фильтр). Для секции 1 — количество персонажей из viewModel.characters.count.
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("cellForItemAt called for section: \(indexPath.section), row: \(indexPath.row)")
        
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopSectionCollectionViewCell.reuseID, for: indexPath) as? TopSectionCollectionViewCell else { return UICollectionViewCell()}
            cell.delegateTopSection = self
            cell.viewModel = viewModel
            return cell
            
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EpisodesCell.reuseID, for: indexPath) as? EpisodesCell else{ return  UICollectionViewCell()} 
            
            let episode = viewModel.characters[indexPath.row]
            let cellViewModel = EpisodesCellViewModel(dependency: viewModel.dependencies, character: episode)
            
            cell.viewModel = cellViewModel
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            break
        default:
            if let character = viewModel?.characters[indexPath.row] { detailsViewControllerDelegate?.didTappedOnCharacter(character, viewModel.dependencies)}
        }
    }
}

//MARK: Collection View Delegate
extension EpisodesCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionInset: CGFloat = 16 // Отступы, если применимы
        //let interIteemSpacing: CGFloat = 8 // Межъячеечное пространство, если применимо
        
        //ширина коллекции за минусом отступов
        let width = collectionView.bounds.width - 2 * sectionInset
        
        //высота для ячеек
        let height : CGFloat
        if indexPath.section == 0 {
            height = 330
        } else {
            height = 390
        }
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // Расстояние между строками ячеек
        return 16
    }
    
}

//MARK: Footer
extension EpisodesCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        switch indexPath.section {
        case 1:
            guard kind == UICollectionView.elementKindSectionFooter,
                  let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FooterLoadingCollectionResableView.reuseID, for: indexPath) as? FooterLoadingCollectionResableView else {
                 return UICollectionReusableView() }
            
            footer.startIndicator()
            
            footer.isHidden = viewModel.pageModel?.info.next == nil ? true : false
            
            return footer
        default:
           return UICollectionReusableView()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return section == 1 ? CGSize(width: collectionView.bounds.width, height: 50) : .zero
    }
}
//MARK: Scroll View
extension EpisodesCollectionViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        guard let page = viewModel.pageModel,
              let nextPage = page.info.next,
              !isShowMoreEpisode,
              offsetY >= (contentHeight - height + 90) else {return}
        
        isShowMoreEpisode = true
        viewModel.updateCharacters(from: nextPage) {[ weak self ] newCount in
            guard let self = self else { return }
            
            self.isShowMoreEpisode = false
            
            let totalCount = self.viewModel.characters.count //общее количество элементов после загрузки
            let startingIndex = totalCount - newCount //индекс, с которого начинаются все элементы
            let indexPathToAdd = Array(startingIndex..<totalCount).compactMap { IndexPath(row: $0, section: 1)
            }
            
            
            self.collectionView.performBatchUpdates { //Анимировано обновляет коллекцию, добавляя новые элементы.
                self.collectionView.insertItems(at: indexPathToAdd)
            }
            
        }

    }
}

extension EpisodesCollectionViewController: TopSectionCollectionViewControllerDelegate {
    func filterDidChose(){
        collectionView.reloadData()
    }
}

