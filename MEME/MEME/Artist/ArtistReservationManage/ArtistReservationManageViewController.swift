//
//  ArtistReservationManageViewController.swift
//  MEME
//
//  Created by 황채웅 on 1/18/24.
//

import UIKit

class ArtistReservationManageViewController: UIViewController {
    @IBOutlet private var artistReservationTableView: UITableView!
    @IBOutlet private var onComingButton: UIButton!
    @IBOutlet private var completeButton: UIButton!
    private var showOnComing : Bool = true
    @IBOutlet private var noReservationLabel: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewConfigure()
        uiSet()
    }
    private func uiSet(){
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = true
        noReservationLabel.isHidden = !resMakeUpNameArray.isEmpty
    }
    private func tableViewConfigure(){
        artistReservationTableView.delegate = self
        artistReservationTableView.dataSource = self
        artistReservationTableView.register(ArtistReservationStatusTableViewCell.nib(), forCellReuseIdentifier: ArtistReservationStatusTableViewCell.identifier)
    }
    @IBAction private func onComingButtonTapped(_ sender: UIButton) {
        showOnComing = true
        onComingButton.setImage(.icCheckFill, for: .normal)
        completeButton.setImage(.icCheckEmpty, for: .normal)
        artistReservationTableView.reloadData()
    }
    
    @IBAction private func completeButtonTapped(_ sender: UIButton) {
        showOnComing = false
        completeButton.setImage(UIImage(resource: .icCheckFill), for: .normal)
        onComingButton.setImage(UIImage(resource: .icCheckEmpty), for: .normal)
        artistReservationTableView.reloadData()
    }
}


extension ArtistReservationManageViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resMakeUpNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = artistReservationTableView.dequeueReusableCell(withIdentifier: ArtistReservationStatusTableViewCell.identifier, for: indexPath) as? ArtistReservationStatusTableViewCell else { return UITableViewCell() }
        cell.makeUpNameLabel.text = resMakeUpNameArray[indexPath.row]
        cell.modelNameLabel.text = resModelNameArray[indexPath.row]
        cell.reservationDateLabel.text = resDateArray[indexPath.row]
        if !onComingArray[indexPath.row]{
            cell.reservationTimeLabel.textColor = UIColor(resource: .gray500)
            cell.reservationPlaceIconImage.image = UIImage(resource: .icMapNotAvilable)
            cell.reservationPriceIconLabel.textColor = UIColor(resource: .gray500)
        }
        if (showOnComing && onComingArray[indexPath.row]) || (!showOnComing && !onComingArray[indexPath.row]) {
            return cell
        } else {
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArtistReservationStatusTableViewCell.className, for: indexPath) as! ArtistReservationStatusTableViewCell
        
        let vc = SingleArtistReservationManageViewController(receivedData: cell.getData()!)
        if cell.getData()?.status == "EXPECTED" {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (showOnComing == onComingArray[indexPath.row]) ? CGFloat(192) : CGFloat(0)
    }
    
}
