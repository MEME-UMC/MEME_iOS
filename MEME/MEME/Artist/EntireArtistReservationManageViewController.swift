//
//  EntireArtistReservationManageViewController.swift
//  MEME
//
//  Created by 황채웅 on 1/19/24.
//

import UIKit

class EntireArtistReservationManageViewController: UIViewController {
    
    @IBOutlet var bottomBarView: UIView!
    @IBOutlet var artistReservationTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewConfigure()
        uiSet()
    }
    
    private func uiSet(){
        navigationController?.isNavigationBarHidden = true
        bottomBarView.layer.cornerRadius=10
    }
    
    private func tableViewConfigure(){
        artistReservationTableView.delegate = self
        artistReservationTableView.dataSource = self
        artistReservationTableView.register(ArtistReservationStatusTableViewCell.nib(), forCellReuseIdentifier: ArtistReservationStatusTableViewCell.identifier)
    }
    @IBAction private func backButtonDidTap(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func reservationManagedBtnTapped(){
        let vc = SingleArtistReservationManageViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension EntireArtistReservationManageViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resMakeUpNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = artistReservationTableView.dequeueReusableCell(withIdentifier: ArtistReservationStatusTableViewCell.identifier, for: indexPath) as? ArtistReservationStatusTableViewCell else { return UITableViewCell() }
        cell.makeUpNameLabel.text = resMakeUpNameArray[indexPath.row]
        cell.modelNameLabel.text = resModelNameArray[indexPath.row]
        cell.reservationDateLabel.text = resDateArray[indexPath.row]
        cell.reservationManageBtn.addTarget(self, action: #selector(reservationManagedBtnTapped), for: .touchUpInside)
        return cell

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(192)

    }
    
}
