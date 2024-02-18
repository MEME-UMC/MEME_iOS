//
//  ArtistMyPageTableViewCell.swift
//  MEME
//
//  Created by 임아영 on 2/3/24.
//

import UIKit

class ArtistMyPageTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    let menuLabel = UILabel()
    
    //MARK: - Lifecycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier )
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        
        addSubview(menuLabel)
        menuLabel.translatesAutoresizingMaskIntoConstraints = false
        
        menuLabel.font = UIFont(name: "Pretendard-Medium", size: 14)
        
        NSLayoutConstraint.activate([
            menuLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            menuLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 24)
        ])
    }
    
}
