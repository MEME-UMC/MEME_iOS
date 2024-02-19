//
//  ArtistReservationStatusTableViewCell.swift
//  MEME
//
//  Created by 황채웅 on 1/13/24.
//

import UIKit

class ArtistReservationStatusTableViewCell: UITableViewCell {
    @IBOutlet private var reservationFrameView: UIView!
    @IBOutlet var reservationDateLabel: UILabel!
    @IBOutlet var makeUpNameLabel: UILabel!
    @IBOutlet var modelNameLabel: UILabel!
    @IBOutlet var reservationTimeLabel: UILabel!
    @IBOutlet var reservationPlaceIconImage: UIImageView!
    @IBOutlet var reservationPriceIconLabel: UILabel!
    @IBOutlet weak var reservationPriceLabel: UILabel!
    @IBOutlet weak var reservationPlaceLabel: UILabel!
    private var reservationData: ReservationData?
    
    static let identifier = "ArtistReservationStatusTableViewCell"

    static func nib() -> UINib {
        return UINib(nibName: "ArtistReservationStatusTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        uiSet()
    }
    
    func configure(_ data: ReservationData) {
        reservationData = data
    }
    
    func getData() -> ReservationData? {
        return reservationData
    }
    
    @IBAction private func reservationManageBtnTapped(_ sender: UIButton) {
//        delegate?.cellTapped()
    }
    
    private func uiSet() {
        reservationFrameView.layer.cornerRadius = 10
        selectionStyle = .none
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
