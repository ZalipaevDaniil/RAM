//
//  EpisodesController.swift
//  RAM
//
//  Created by Aaa on 06.09.2024.
//

//import UIKit
//
//
//final class EpisodesController: UIViewController, UICollectionViewDelegate, UIScrollViewDelegate {
//    
//    enum EpisodesSection {
//        case main
//    }
//    
//    typealias DataSource = UICollectionViewDiffableDataSource<EpisodesSection, DetailEpisode>
//    typealias Snapshot = NSDiffableDataSourceSnapshot<EpisodesSection, DetailEpisode>
//    
//    
//    //MARK: UI Elements
////    private lazy var activityIndicator: UIActivityIndicatorView
////    private lazy var makeRickAndMortyImage: UIImageView
////    private lazy var searchTF: UITextField
////    private var episodesCollection: UICollectionView
//    
//    //MARK: DataSource
//    var dataSource: DataSource?
//    
//    //MARK: ViewModel
//    private var viewModel: EpisodesViewModel
//    
//    //MARK: Constructor
//    init(viewModel: EpisodesViewModel) {
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    
//    //MARK: LifeCycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//    }
//    
//    
//    
//    
//}
//
//
////MARK: Collection Diffable DataSource
//private extension EpisodesController {
//    
//}
//
//
//
////MARK: CollectionDelegate
//extension EpisodesController {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: false)
//        viewModel.didTapOnCharacter(viewModel.showCharacters[indexPath.row])
//    }
//}
//   
//
//
//// MARK: Preview
////#Preview {
////    let vc = EpisodesController()
////    return vc
////}
//
//
