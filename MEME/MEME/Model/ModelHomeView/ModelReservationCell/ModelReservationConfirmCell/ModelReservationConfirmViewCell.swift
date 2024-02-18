//
//  ModelReservationConfirmViewCell.swift
//  MEME
//
//  Created by 정민지 on 1/11/24.
//

import UIKit
import SnapKit

class ModelReservationConfirmViewCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifier = "ModelReservationConfirmViewCell"
    
    @IBOutlet weak var modelReservationDateLabel: UILabel!
    @IBOutlet weak var modelReservationLabel: UILabel!
    @IBOutlet weak var modelReservationMakeupNameLabel: UILabel!
    @IBOutlet weak var modelReservationArtistNameLabel: UILabel!
    @IBOutlet private weak var modelReservationLocationImageView: UIImageView!
    @IBOutlet weak var modelReservationLocationLabel: UILabel!
    @IBOutlet private weak var modelReservationWonLabel: UILabel!
    @IBOutlet weak var modelReservationPriceLabel: UILabel!
    
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        modelReservationLocationImageView.image = UIImage(named: "icon_location")
        
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
    
    func configure(with data: ReservationData) {
        let isoFormatter = ISO8601DateFormatter()
            isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

            if let date = isoFormatter.date(from: data.reservationDate) {
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "HH:mm"
                modelReservationDateLabel.text = timeFormatter.string(from: date)
            } else {
                modelReservationDateLabel.text = "날짜 오류"
            }
        
        modelReservationMakeupNameLabel.text = data.makeupName
        modelReservationArtistNameLabel.text = data.artistNickName
        modelReservationLocationLabel.text = data.shopLocation
        modelReservationPriceLabel.text = "\(data.price)원"
    }
    
}
