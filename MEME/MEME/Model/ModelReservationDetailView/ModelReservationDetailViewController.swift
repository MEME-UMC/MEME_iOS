//
//  ModelReservationDetailViewController.swift
//  MEME
//
//  Created by 정민지 on 1/24/24.
//

import UIKit
import SnapKit
import FSCalendar

class ModelReservationDetailViewController: UIViewController, ModelReservationBothLocationViewDelegate {
    var portfolioID: Int? = 0
    var artistID: Int? = 0
    var makeupName: String?
    var artistName: String?
    var locationText: String?
    
    // MARK: - Properties
    var selectedMakeupName: String?
    var selectedLocation: String?
    
    var possibleTimeSlots: [TimeSlot] = []
    private var selectedDate: Date?
    private var selectedTime: String?
    private var selectedWeek: String?
    private var selectedLocationType: String?
    private var selectedVisitLocation: String?
    
    private let navigationBar = NavigationBarView()
    private let scrollView = UIScrollView()
    private let contentsView = UIView()
    private let selectLocationStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.spacing = 0
        
        return stack
    }()
    
    private var shopView: ModelReservationShopLocationView!
    private var visitView: ModelReservationVisitLocationView!
    private var bothView: ModelReservationBothLocationView!
    
    private var manualLabel: UILabel = {
        let label = UILabel()
        label.text = "예약 정보를 알려주세요."
        label.textColor = .black
        label.font = .pretendard(to: .semiBold, size: 18)
        
        return label
    }()
    private var selectDateLabel: UILabel = {
        let label = UILabel()
        label.text = "예약 날짜를 선택해주세요."
        label.textColor = .black
        label.font = .pretendard(to: .medium, size: 14)
        
        return label
    }()
    
    lazy var currentPage = calendarView.currentPage
    private let prevButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .black
        return button
    }()
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .black
        return button
    }()
    private var underLineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .gray400
        
        return lineView
    }()
    private lazy var calendarView: FSCalendar = {
        let calendar = FSCalendar()
        calendar.dataSource = self
        calendar.delegate = self
        
        calendar.firstWeekday = 2
        calendar.scope = .month
        calendar.backgroundColor = .white
        calendar.scrollEnabled = true
        calendar.scrollDirection = .horizontal
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.locale = Locale(identifier: "ko_KR")
        
        // 헤더뷰 설정
        calendar.headerHeight = 40
        calendar.appearance.headerDateFormat = "YYYY. M"
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.headerTitleFont = .pretendard(to: .semiBold, size: 20)
        calendar.appearance.headerTitleAlignment = .center
        
        // 요일 설정
        calendar.appearance.weekdayFont = .pretendard(to: .semiBold, size: 18)
        calendar.appearance.weekdayTextColor = .black
        
        // 날짜 설정
        calendar.appearance.titleFont = .pretendard(to: .regular, size: 18)
        calendar.appearance.selectionColor = UIColor(red: 67.0/255.0, green: 85.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        calendar.appearance.todayColor = .white
        calendar.appearance.titleTodayColor = .black
        calendar.calendarWeekdayView.weekdayLabels.last!.textColor = UIColor(red: 255.0/255.0, green: 48.0/255.0, blue: 48.0/255.0, alpha: 1.0)
        calendar.calendarWeekdayView.weekdayLabels[5].textColor = UIColor(red: 255.0/255.0, green: 48.0/255.0, blue: 48.0/255.0, alpha: 1.0)
        calendar.placeholderType = .none
        return calendar
    }()
    
    private var selectTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "예약 가능 시간을 입력해주세요."
        label.textColor = .black
        label.font = .pretendard(to: .medium, size: 14)
        
        return label
    }()
    private var selectedTimeButton: UIButton?
    private var morningLabel: UILabel = {
        let label = UILabel()
        label.text = "오전"
        label.textColor = .black
        label.font = .pretendard(to: .regular, size: 14)
        
        return label
    }()
    private let morningVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        return stackView
    }()
    private let morningStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        return stackView
    }()
    private var afternoonLabel: UILabel = {
        let label = UILabel()
        label.text = "오후"
        label.textColor = .black
        label.font = .pretendard(to: .regular, size: 14)
        
        return label
    }()
    private let afternoonVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        return stackView
    }()
    private let afternoonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        return stackView
    }()
    private let reservationButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = .pretendard(to: .regular, size: 14)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .mainBold
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.isEnabled = false
        button.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationBar.delegate = self
        navigationBar.configure(title: "예약하기")
        
        if let artistID = artistID {
            getPossibleTime(aristId: artistID)
            getPossibleLocation(aristId: artistID)
        }
        
        updateNextButtonState()
        setAction()
        configureSubviews()
        makeConstraints()
        updateWeekdayLabels()
        view.setupDismissKeyboardOnTapGesture()
    }
    
    // MARK: - configureSubviews
    func configureSubviews() {
        view.addSubview(navigationBar)
        view.addSubview(scrollView)
        scrollView.addSubview(contentsView)
        contentsView.addSubview(selectLocationStackView)
        contentsView.addSubview(manualLabel)
        contentsView.addSubview(selectDateLabel)
        contentsView.addSubview(calendarView)
        contentsView.addSubview(prevButton)
        contentsView.addSubview(nextButton)
        contentsView.addSubview(underLineView)
        contentsView.addSubview(selectTimeLabel)
        contentsView.addSubview(morningLabel)
        contentsView.addSubview(morningVerticalStackView)
        contentsView.addSubview(afternoonLabel)
        contentsView.addSubview(afternoonVerticalStackView)
        view.addSubview(reservationButton)
    }
    
    // MARK: - makeConstraints
    private func configureLocationStackView(with makeupLocationData: MakeupLocationData) {
        selectLocationStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        selectedLocationType = makeupLocationData.makeupLocation
        switch makeupLocationData.makeupLocation {
        case "SHOP":
            shopView = ModelReservationShopLocationView()
            shopView.configureModelReservationShopLocationView(with: makeupLocationData)
            selectedLocation = makeupLocationData.shopLocation
            selectLocationStackView.addArrangedSubview(shopView)
        case "VISIT":
            visitView = ModelReservationVisitLocationView()
            visitView.configureModelReservationVisitLocationView(with: makeupLocationData)
            visitView.delegate = self
            visitView.visitLocationTextField.delegate = self
            visitView.visitLocationTextField.addTarget(self, action: #selector(visitLocationTextFieldChanged(_:)), for: .editingChanged)
            selectLocationStackView.addArrangedSubview(visitView)
        case "BOTH":
            bothView = ModelReservationBothLocationView()
            bothView.configureModelReservationBothLocationView(with: makeupLocationData)
            bothView.delegate = self
            selectLocationStackView.addArrangedSubview(bothView)
        default:
            break
        }
        view.layoutIfNeeded()
        updateNextButtonState()
    }
    func makeConstraints() {
        navigationBar.snp.makeConstraints {make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        contentsView.snp.makeConstraints { (make) in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        selectLocationStackView.snp.makeConstraints { (make) in
            make.top.equalTo(contentsView.snp.top).offset(34)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-24)
        }
        manualLabel.snp.makeConstraints { (make) in
            make.top.equalTo(selectLocationStackView.snp.bottom).offset(40)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
        }
        selectDateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(manualLabel.snp.bottom).offset(21)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
        }
        calendarView.snp.makeConstraints { (make) in
            make.top.equalTo(selectDateLabel.snp.bottom).offset(22)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-24)
            make.height.equalTo(328)
        }
        prevButton.snp.makeConstraints { make in
            make.centerY.equalTo(calendarView.calendarHeaderView).multipliedBy(1.1)
            make.centerX.equalTo(calendarView.calendarHeaderView.snp.centerX).multipliedBy(0.6)
        }
        nextButton.snp.makeConstraints { make in
            make.centerY.equalTo(calendarView.calendarHeaderView).multipliedBy(1.1)
            make.centerX.equalTo(calendarView.calendarHeaderView.snp.centerX).multipliedBy(1.4)
        }
        underLineView.snp.makeConstraints { make in
            make.top.equalTo(calendarView.calendarWeekdayView.snp.bottom).offset(7)
            make.leading.equalTo(calendarView.calendarWeekdayView.snp.leading)
            make.trailing.equalTo(calendarView.calendarWeekdayView.snp.trailing)
            make.height.equalTo(1)
        }
        selectTimeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(calendarView.snp.bottom).offset(33)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
        }
        morningLabel.snp.makeConstraints { (make) in
            make.top.equalTo(selectTimeLabel.snp.bottom).offset(20)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
        }
        morningVerticalStackView.snp.makeConstraints { (make) in
            make.top.equalTo(morningLabel.snp.bottom).offset(13)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-24)
        }
        afternoonLabel.snp.makeConstraints { (make) in
            make.top.equalTo(morningVerticalStackView.snp.bottom).offset(32)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
        }
        afternoonVerticalStackView.snp.makeConstraints { (make) in
            make.top.equalTo(afternoonLabel.snp.bottom).offset(13)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-24)
            make.bottom.equalTo(contentsView.snp.bottom).offset(-150)
        }
        reservationButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-9)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(50)
        }
        
    }
    
    // MARK: - Action
    @objc private func visitLocationTextFieldChanged(_ textField: UITextField) {
        selectedLocation = textField.text
        updateNextButtonState()
    }
    
    private func setAction() {
        [prevButton, nextButton].forEach {
            ($0 as AnyObject).addTarget(self, action: #selector(moveMonthButtonDidTap(sender:)), for: .touchUpInside)
        }
    }
    
    @objc func moveMonthButtonDidTap(sender: UIButton) {
        moveMonth(next: sender == nextButton)
    }
    
    func moveMonth(next: Bool) {
        var dateComponents = DateComponents()
        dateComponents.month = next ? 1 : -1
        self.currentPage = Calendar.current.date(byAdding: dateComponents, to: self.currentPage)!
        calendarView.setCurrentPage(self.currentPage, animated: true)
    }
    @objc private func nextTapped() {
        guard let selectedDate = selectedDate else { return }
        guard let selectedTime = selectedTime else { return }
        guard let selectedWeek = selectedWeek else { return }
        guard let artistName = artistName else { return }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일"
        let formattedDate = formatter.string(from: selectedDate)
        
        let alert = UIAlertController(title: "", message: "\(formattedDate) \(selectedTime)시에 예약하시겠습니까?\n클릭하면 예약이 확정됩니다.", preferredStyle: .alert)
        let messageAttributes = [NSAttributedString.Key.font: UIFont.pretendard(to: .medium, size: 14), NSAttributedString.Key.foregroundColor: UIColor.black]
        
        let noAction = UIAlertAction(title: "아니요", style: .cancel) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        let yesAction = UIAlertAction(title: "예", style: .default) { _ in
            let reservationsVC = ModelReservationLastViewController()
            
            reservationsVC.portfolioID = self.portfolioID
            reservationsVC.makeupName = self.selectedMakeupName
            reservationsVC.selectedDate = self.selectedDate
            reservationsVC.selectedWeek = self.selectedWeek
            reservationsVC.selectedTime = self.selectedTime
            
            reservationsVC.artistName = self.artistName
            reservationsVC.locationText = self.selectedLocation
            
            reservationsVC.reservationDateText = "\(formattedDate) \(selectedTime)시"
            
            self.navigationController?.pushViewController(reservationsVC, animated: true)
        }
        
        alert.addAction(noAction)
        alert.addAction(yesAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Methods
    private func checkLocationValidity() -> Bool {
        switch selectedLocationType {
        case "SHOP":
            return true
        case "VISIT":
            return !(selectedVisitLocation?.isEmpty ?? true)
        case "BOTH":
            return true
        case .none:
            return false
        case .some(_):
            return false
        }
    }
    
    
    //MARK: -Helpers
    private func updateAvailableTimes(for selectedDate: Date) {
        let weekdayFormatter = DateFormatter()
        weekdayFormatter.dateFormat = "EEE"
        let selectedWeekday = weekdayFormatter.string(from: selectedDate).uppercased()
        
        let filteredTimes = possibleTimeSlots.filter { $0.availableDayOfWeek.uppercased() == selectedWeekday }
            .map { timeSlot -> String in
                let timeComponents = timeSlot.availableTime.components(separatedBy: "_")
                guard timeComponents.count == 3, let hour = Int(timeComponents[1]), let minute = Int(timeComponents[2]) else {
                    return ""
                }
                let formattedTime = String(format: "%02d:%02d", hour, minute)
                return formattedTime
            }
            .filter { !$0.isEmpty }
        
        DispatchQueue.main.async {
            self.setupTimeSelectionButtons(with: filteredTimes)
        }
    }
    
    
    private func updateWeekdayLabels() {
        let weekdayLabels = calendarView.calendarWeekdayView.weekdayLabels
        let customWeekdays = ["M", "T", "W", "T", "F", "S", "S"]
        
        for (index, label) in weekdayLabels.enumerated() {
            label.text = customWeekdays[index]
        }
    }
    private func maxNumberOfButtonsPerRow() -> Int {
        let viewWidth = self.view.bounds.width
        let buttonWidth: CGFloat = 69
        let buttonSpacing: CGFloat = 8
        let sidePadding: CGFloat = 24 * 2
        let availableWidth = viewWidth - sidePadding
        let maxButtons = Int(availableWidth / (buttonWidth + buttonSpacing))
        
        return maxButtons
    }
    
    private func setupTimeSelectionButtons(with availableTimes: [String]) {
        morningVerticalStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        afternoonVerticalStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        var morningTimeAvailable = false
        var afternoonTimeAvailable = false
        
        var currentMorningStackView = createNewHorizontalStackView()
        morningVerticalStackView.addArrangedSubview(currentMorningStackView)
        
        var currentAfternoonStackView = createNewHorizontalStackView()
        afternoonVerticalStackView.addArrangedSubview(currentAfternoonStackView)
        
        for time in availableTimes {
            let button = createButton(withTime: time)
            let hour = Int(time.split(separator: ":")[0])!
            
            if hour < 12 {
                if currentMorningStackView.arrangedSubviews.count >= maxNumberOfButtonsPerRow() {
                    currentMorningStackView = createNewHorizontalStackView()
                    morningVerticalStackView.addArrangedSubview(currentMorningStackView)
                }
                currentMorningStackView.addArrangedSubview(button)
                morningTimeAvailable = true
            } else {
                if currentAfternoonStackView.arrangedSubviews.count >= maxNumberOfButtonsPerRow() {
                    currentAfternoonStackView = createNewHorizontalStackView()
                    afternoonVerticalStackView.addArrangedSubview(currentAfternoonStackView)
                }
                currentAfternoonStackView.addArrangedSubview(button)
                afternoonTimeAvailable = true
            }
        }
        
        if !morningTimeAvailable {
            let noMorningTimeLabel = UILabel()
            noMorningTimeLabel.text = "예약 가능한 시간이 없어요"
            noMorningTimeLabel.textColor = .mainBold
            morningVerticalStackView.addArrangedSubview(noMorningTimeLabel)
        }
        if !afternoonTimeAvailable {
            let noAfternoonTimeLabel = UILabel()
            noAfternoonTimeLabel.text = "예약 가능한 시간이 없어요"
            noAfternoonTimeLabel.textColor = .mainBold
            afternoonVerticalStackView.addArrangedSubview(noAfternoonTimeLabel)
        }
        
        fillRemainingSpaceInLastStackView(currentMorningStackView)
        fillRemainingSpaceInLastStackView(currentAfternoonStackView)
    }
    private func fillRemainingSpaceInLastStackView(_ stackView: UIStackView) {
        let numberOfButtons = stackView.arrangedSubviews.count
        let maxButtonsPerRow = maxNumberOfButtonsPerRow()
        
        if numberOfButtons < maxButtonsPerRow {
            let numberOfEmptySpaces = maxButtonsPerRow - numberOfButtons
            for _ in 0..<numberOfEmptySpaces {
                let emptySpaceView = UIView()
                emptySpaceView.widthAnchor.constraint(equalToConstant: 69).isActive = true
                stackView.addArrangedSubview(emptySpaceView)
            }
        }
    }
    
    private func createNewVerticalStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }
    private func createNewHorizontalStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }
    private func createButton(withTime time: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(time, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(timeButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray400.cgColor
        button.widthAnchor.constraint(equalToConstant: 69).isActive = true
        
        return button
    }
    @objc private func timeButtonTapped(_ sender: UIButton) {
        selectedTimeButton?.layer.borderColor = UIColor.gray400.cgColor
        selectedTimeButton?.backgroundColor = .white
        
        sender.layer.borderColor = UIColor.mainBold.cgColor
        sender.backgroundColor = .mainBold
        sender.setTitleColor(.white, for: .normal)
        selectedTimeButton = sender
        
        selectedTime = sender.title(for: .normal)
        updateNextButtonState()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        updateAvailableTimes(for: date)
        updateNextButtonState()
    }
    
    func didSelectLocationType(_ type: String) {
        selectedLocationType = type
        if type == "SHOP" {
            selectedLocation = "샵의 위치"
        } else if type == "VISIT" {
            selectedLocation = selectedVisitLocation
        }
        updateNextButtonState()
    }
    func didSelectShopLocation(_ location: String) {
        selectedLocation = location
        updateNextButtonState()
    }
    
    func didSelectVisitLocation(_ location: String) {
        selectedVisitLocation = location
        updateNextButtonState()
    }
    
    
    private func updateNextButtonState() {
        let isDateAndTimeSelected = selectedDate != nil && selectedTime != nil
        let isLocationValid = checkLocationValidity()
        print(isLocationValid)
        
        DispatchQueue.main.async {
            self.reservationButton.isEnabled = isDateAndTimeSelected && isLocationValid
            self.reservationButton.backgroundColor = self.reservationButton.isEnabled ? .mainBold : .gray300
        }
    }
}
    
    
// MARK: - FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance
extension ModelReservationDetailViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints { (make) in
            make.height.equalTo(bounds.height)
        }
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let day = Calendar.current.component(.weekday, from: date) - 1
        let today = Date()
        
        if date < today {
            return .gray400
        } else if Calendar.current.shortWeekdaySymbols[day] == "Sun" {
            return UIColor(red: 255.0/255.0, green: 48.0/255.0, blue: 48.0/255.0, alpha: 1.0)
        } else if Calendar.current.shortWeekdaySymbols[day] == "Sat" {
            return UIColor(red: 255.0/255.0, green: 48.0/255.0, blue: 48.0/255.0, alpha: 1.0)
        } else {
            return .black
        }
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let today = Date()
        selectedDate = date
            updateAvailableTimes(for: date)
            updateNextButtonState()
        
        let weekday = Calendar.current.component(.weekday, from: date)
        let weekdaySymbol = Calendar.current.weekdaySymbols[weekday - 1]
        
        if let week = WeekdayToSelectedWeek(rawValue: weekdaySymbol) {
            switch week {
            case .sunday:
                selectedWeek = "SUN"
            case .monday:
                selectedWeek = "MON"
            case .tuesday:
                selectedWeek = "TUE"
            case .wednesday:
                selectedWeek = "WED"
            case .thursday:
                selectedWeek = "THU"
            case .friday:
                selectedWeek = "FRI"
            case .saturday:
                selectedWeek = "SAT"
            }
        } else {
            selectedWeek = nil
        }
        
        return date >= today
    }
    
    enum WeekdayToSelectedWeek: String {
        case sunday = "Sunday"
        case monday = "Monday"
        case tuesday = "Tuesday"
        case wednesday = "Wednesday"
        case thursday = "Thursday"
        case friday = "Friday"
        case saturday = "Saturday"
    }
}

// MARK: -BackButtonTappedDelegate
extension ModelReservationDetailViewController: BackButtonTappedDelegate  {
    func backButtonTapped() {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        }
    }
}

//MARK: -API 통신 메소드
extension ModelReservationDetailViewController {
    func getPossibleLocation(aristId: Int) {
        ReservationManager.shared.getPossibleLocation(aristId: aristId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let locationsDTO):
                    self?.configureLocationStackView(with: locationsDTO.data)
                case .failure(let error):
                    print("예약 가능 장소 정보 조회 실패: \(error.localizedDescription)")
                }
            }
        }
    }
    func getPossibleTime(aristId: Int) {
        ReservationManager.shared.getPossibleTime(aristId: aristId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let timesDTO):
                    self?.possibleTimeSlots = timesDTO.data
                    if let selectedDate = self?.selectedDate {
                        self?.updateAvailableTimes(for: selectedDate)
                    }
                case .failure(let error):
                    print("예약 가능 시간 정보 조회 실패: \(error.localizedDescription)")
                }
            }
        }
    }
}

extension ModelReservationDetailViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        selectedVisitLocation = textField.text
    }
}

extension ModelReservationDetailViewController: ModelReservationVisitLocationViewDelegate {
    func didEnterVisitLocation(_ location: String) {
        selectedLocation = location
        updateNextButtonState()
    }
}
