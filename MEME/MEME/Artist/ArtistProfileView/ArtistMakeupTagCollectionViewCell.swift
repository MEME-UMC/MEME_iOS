//
//  ArtistMakeupTagCollectionViewCell.swift
//  MEME
//
//  Created by 황채웅 on 1/18/24.
//

import UIKit

final class ArtistMakeupTagCollectionViewCell: UICollectionViewCell {
    @IBOutlet var makeupTagLabel: UILabel!
    @IBOutlet var makeupTagView: UIView!
    static let identifier = "ArtistMakeupTagCollectionViewCell"

    static func nib() -> UINib {
        return UINib(nibName: "ArtistMakeupTagCollectionViewCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        uiSet()
    }
    
    // 셀 재사용 문제... 카톡에서 카톡방 이미지 동일하게 쭈루룩 나오는 경우와 같은 경우
    override func prepareForReuse() {
        super.prepareForReuse()
        deSelected()
    }
    
    private func uiSet(){
        makeupTagView.layer.borderColor = UIColor(resource: .mainBold).cgColor
        makeupTagView.layer.cornerRadius = makeupTagView.frame.height/2
        makeupTagView.layer.borderWidth = 1
        makeupTagView.backgroundColor = .gray100
        makeupTagLabel.textColor = .gray500
    }
    func selected(){
        makeupTagView.backgroundColor = .mainBold
        makeupTagLabel.textColor = .gray100
    }
    func deSelected(){
        makeupTagView.backgroundColor = .gray100
        makeupTagLabel.textColor = .gray500
    }
    
}
