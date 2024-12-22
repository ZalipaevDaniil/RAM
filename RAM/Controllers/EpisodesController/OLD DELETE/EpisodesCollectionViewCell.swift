//
//  EpisodesCollectionViewCell.swift
//  RAM
//
//  Created by Aaa on 07.09.2024.
//

//import UIKit
//import Combine
//
//final class EpisodesCVCell: UICollectionViewCell {
//    
//    //MARK: ID
//    static let id = String(describing: EpisodesCVCell.self)
//    
//    //MARK: Properties
//    private var isLiked: Bool = false
//    private var currentEpisode: DetailEpisode?
//    
//    private var didTapOnLike:(_ sender: UIButton) -> Void = {sender in }
//    
//    
//    lazy var episodeImageView: UIImageView = {
//        let image = UIImageView()
//        image.contentMode = .scaleToFill
//        image.clipsToBounds = true
//        return image
//    }()
//    
//    private lazy var nameLabel: UILabel = {
//        let label = UILabel()
//        label.text = ""
//        label.textColor = .black
//        label.font = .systemFont(ofSize: 20, weight: .semibold)
//        label.textAlignment = .left
//        label.numberOfLines = 0
//        return label
//    }()
//    
//    private lazy var bottomView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .bottomViewColorEpisode
//        view.layer.cornerRadius = 10
//        return view
//    }()
//    
//    private lazy var videoImage: UIImageView = {
//        let image = UIImageView()
//        image.image = .monitorEpisode
//        image.contentMode = .scaleAspectFit
//        image.clipsToBounds = true
//        return image
//    }()
//    
//    private lazy var descriptionLabel: UILabel = {
//       let label = UILabel()
//        label.text = ""
//        label.textColor = .black
//        label.font = .systemFont(ofSize: 16)
//        label.textAlignment = .left
//        label.numberOfLines = 0
//        label.adjustsFontSizeToFitWidth = true
//        return label
//    }()
//    
//    private lazy var likeButton: UIButton = {
//        let button = UIButton()
//        button.setImage(.like, for: .normal)
//        //button.addTarget(self, action: , for: .touchUpInside)
//        return button
//    }()
//    
//    @available(*, unavailable)
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    //MARK:  Overide
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        contentView.backgroundColor = .white
//        contentView.addSubview(episodeImageView)
//        contentView.addSubview(nameLabel)
//        contentView.addSubview(bottomView)
//        bottomView.addSubview(videoImage)
//        bottomView.addSubview(descriptionLabel)
//        bottomView.addSubview(likeButton)
//        
//    }
//    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        episodeImageView.image = nil
//        likeButton.setImage(nil, for: .normal)
//        nameLabel.text = nil
//        descriptionLabel.text = nil
//    }
//    
//    func setupCell(with episode: DetailEpisode, and character: CharacterResponse?, _ networkService: INetworkService?, isLiked: Bool, tag: Int, buttonAction: @escaping (_ sender: UIButton) -> Void) {
//        
//        currentEpisode = episode
//        networkService?.getImage(with: character?.id ?? 0, for: episodeImageView)
//        DispatchQueue.main.async {
//            self.isLiked = isLiked
//            self.nameLabel.text = character?.name
//            self.descriptionLabel.text = "\(episode.name) | \(episode.episode)"
//            self.likeButton.setImage(self.isLiked ? .tappedLike : .like, for: .normal)
//            self.likeButton.tag = tag
//            self.didTapOnLike = buttonAction
//        }
//        
//    }
//    //MARK: UI
//    func layoutUI() {
//        
//    }
//    
//    //MARK:  ACtion
//    @objc private func didTapLikeButton(_ sender: UIButton) {
//        isLiked.toggle()
//        likeButton.setImage(isLiked ? .tappedLike : .like, for: .normal)
//        if isLiked {
//            UserDefaultsService().add(with: currentEpisode?.id ?? 1)
//        } else {
//            UserDefaultsService().delete(with: currentEpisode?.id ?? -1)
//        }
//        didTapOnLike(likeButton)
//        }
//    }
// 

