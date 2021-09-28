//
//  EventDetailViewController.swift
//  Community Calendar
//
//  Created by Jordan Christensen on 1/11/20.
//  Copyright © 2020 Lambda School All rights reserved.
//

import UIKit
import EventKit

class EventDetailViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Properties
    
    var event: Event? {
        didSet {
            updateViews()
//            updateViewsHomeVC()
        }
    }
    
//    var userEvent: Event? {
//        didSet {
//            updateViews()
//        }
//    }

    var indexPath: IndexPath?
    let eventStore = EKEventStore()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var attendButton: UIButton!
    @IBOutlet weak var openInMapsButton: UIButton!
    @IBOutlet weak var addToCalendarButton: UIButton!
    @IBOutlet weak var hostImageView: UIImageView!
    @IBOutlet weak var hostShadowView: UIView!
    @IBOutlet weak var hostNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel! // Three lines
    @IBOutlet weak var priceLabel: UILabel! // Red if free
    @IBOutlet weak var eventDescTextView: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var descLabelHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        observeImage()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        checkForRSVP()
    }
    
    // MARK: - Functions
    private func setUp() {
        scrollView.delegate = self
        configureViews()
        updateViewsHomeVC()
        fetchProfileImage()
    }
    
    func fetchProfileImage() {
//        if let controller = controller, let event = event,
//            let key = event.profileImageURL {
//            controller.fetchImage(for: key)
//        }
    }
    
    func configureViews() {
        self.hostImageView.layer.cornerRadius = self.hostImageView.frame.height / 2
        self.hostShadowView.layer.cornerRadius = self.hostShadowView.frame.height / 2
        self.hostShadowView.layer.shadowColor = UIColor.darkGray.cgColor
        self.hostShadowView.layer.shadowOpacity = 1.0
        self.hostShadowView.layer.shadowRadius = 1.5
        self.hostShadowView.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.attendButton.layer.cornerRadius = 6
        self.attendButton.layer.borderWidth = 1
        self.attendButton.layer.borderColor = UIColor(red: 1, green: 0.404, blue: 0.408, alpha: 1).cgColor
        self.openInMapsButton.setTitleColor(.white, for: .normal)
        self.openInMapsButton.backgroundColor = UIColor(red: 0.129, green: 0.141, blue: 0.173, alpha: 1)
        self.openInMapsButton.layer.cornerRadius = 6
        
        self.addToCalendarButton.setTitleColor(.white, for: .normal)
        self.addToCalendarButton.backgroundColor = UIColor(red: 1, green: 0.404, blue: 0.408, alpha: 1)
        self.addToCalendarButton.layer.cornerRadius = 6
        titleLabel.font = UIFont(name: PoppinsFont.medium.rawValue, size: 20)
        eventDescTextView.textColor = .black
        timeLabel.textColor = .black
    }
    
    func updateViews() {
        guard
            let event = event,
            let urlString = event.image,
            let url = URL(string: urlString),
            let data = try? Data(contentsOf: url),
            let streetAddress = event.location?.streetAddress,
            let city = event.location?.city,
            let state = event.location?.state,
            let zipcode = event.location?.zipcode
            else { return }
        
        let startDate = event.startDate
        let endDate = event.endDate
        DispatchQueue.main.async {
            if let urlCreatorString = event.creator.profileImage, let urlCreator = URL(string: urlCreatorString), let imageData = try? Data(contentsOf: urlCreator) {
                self.hostImageView.image = UIImage(data: imageData)
            }
            if let hostFirstName = event.creator.firstName, let hostLastName = event.creator.lastName {
                self.hostNameLabel.text = "\(hostFirstName) \(hostLastName)"
            } else {
                self.hostNameLabel.text = "N/A"
            }
            self.eventImageView.image = UIImage(data: data)
            self.dateLabel.text = featuredEventDateFormatter.string(from: startDate)
            self.titleLabel.text = event.title
            self.eventDescTextView.text = event.description
            self.priceLabel.attributedText = event.ticketPrice == 0.0 ? (NSAttributedString(string: "Free", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 1, green: 0.404, blue: 0.408, alpha: 1)])) : (NSAttributedString(string: "$\(event.ticketPrice)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black]))
            self.timeLabel.text = "\(cellDateFormatter.string(from: startDate)) \n to \n \(cellDateFormatter.string(from: endDate))"
            
            self.addressLabel.text = "\(streetAddress) \(city), \(state) \(zipcode)"
            
            let height = event.description.height(with: self.view.frame.width - 32, font: UIFont(name: PoppinsFont.light.rawValue, size: 12)!)
            height < 100 ? (self.descLabelHeightConstraint.constant = height) : (self.descLabelHeightConstraint.constant = 100.0)
        }
    }
    
    private func updateViewsHomeVC() {
        guard
            let event = event,
//            let urlCreatorString = event.creator.profileImage,
//            let urlCreator = URL(string: urlCreatorString),
//            let imageData = try? Data(contentsOf: urlCreator),
            let urlString = event.image,
            let url = URL(string: urlString),
            let data = try? Data(contentsOf: url),
            let streetAddress = event.location?.streetAddress,
            let city = event.location?.city,
            let state = event.location?.state,
            let zipcode = event.location?.zipcode
            else { return }
        DispatchQueue.main.async {
            if let urlCreatorString = event.creator.profileImage, let urlCreator = URL(string: urlCreatorString), let imageData = try? Data(contentsOf: urlCreator) {
                self.hostImageView.image = UIImage(data: imageData)
            }
            
            if let hostFirstName = event.creator.firstName, let hostLastName = event.creator.lastName {
                self.hostNameLabel.text = "\(hostFirstName) \(hostLastName)"
            } else {
                self.hostNameLabel.text = "N/A"
            }
            self.eventImageView.image = UIImage(data: data)
//            if let startDate = event.startDate, let endDate = event.endDate {
            self.dateLabel.text = featuredEventDateFormatter.string(from: event.startDate)
            self.timeLabel.text = "\(cellDateFormatter.string(from: event.startDate)) \n to \n \(cellDateFormatter.string(from: event.endDate))"
//              }
            self.titleLabel.text = event.title
            self.eventDescTextView.text = event.description
            self.priceLabel.attributedText = event.ticketPrice == 0.0 ? (NSAttributedString(string: "Free", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 1, green: 0.404, blue: 0.408, alpha: 1)])) : (NSAttributedString(string: "$\(event.ticketPrice)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black]))
            
            
            self.addressLabel.text = "\(streetAddress), \(city), \(state) \(zipcode)"
            
            let height = event.description.height(with: self.view.frame.width - 32, font: UIFont(name: PoppinsFont.light.rawValue, size: 12)!)
            height < 100 ? (self.descLabelHeightConstraint.constant = height) : (self.descLabelHeightConstraint.constant = 100.0)
        }
//            "\(cellDateFormatter.string(from: startDate))\n-\n\(cellDateFormatter.string(from: endDate))".lowercased()
//        dateLabel.text =
//            todayDateFormatter.string(from: startDate)
        
//        timeLabel.text = "No time given"
        
        
        
        
//        checkForRSVP()
        
        
//        if let imageURL = event.images.first, !imageURL.isEmpty {
//            if controller?.cache.fetch(key: imageURL) == nil {
//                eventImageView.image = nil
//            }
//            controller?.fetchImage(for: imageURL)
//        } else {
//            if let indexPath = indexPath {
//                eventImageView.image = UIImage(named: "placeholder\(indexPath.row % 6)")
//            } else {
//                eventImageView.image = UIImage(named: "lambda")
//            }
//        }
    }
    
//    func checkForRSVP() {
//        if let bool = controller?.checkUserRsvps(with: event?.id) {
//            updateRSVP(with: bool)
//        } else {
//            updateRSVP(with: false)
//        }
//        
//        guard let event = event,
//            let controller = controller, let userToken = controller.userToken else { return }
//        do {
//            let decodedToken = try decode(jwt: userToken)
//            guard let userId = decodedToken.ccId else { return }
//            controller.fetchUserRsvps(with: userId) { ids, error  in
//                if let error = error {
//                    NSLog("\(#file):L\(#line): Configuration failed inside \(#function) with error: \(error)")
//                    return
//                }
//                if let ids = ids, ids.contains(event.id) {
//                    self.updateRSVP(with: true)
//                }
//            }
//        } catch {
//            NSLog("\(#file):L\(#line): Configuration failed inside \(#function) with error: \(error)")
//        }
//    }
    
    func updateRSVP(with bool: Bool) {
        DispatchQueue.main.async {
            self.attendButton.attrText(bool ? "Unattend" : "Attend")
            bool ? (self.addToCalendarButton.isHidden = false) : (self.addToCalendarButton.isHidden = true)
        }
    }
    
    func addToCalendar(event: Event, startDate: Date, endDate: Date?) {
        let calendarEvent = EKEvent(eventStore: eventStore)

        calendarEvent.title = event.title
        calendarEvent.startDate = startDate
        calendarEvent.endDate = endDate
        calendarEvent.notes = event.description
        calendarEvent.calendar = eventStore.defaultCalendarForNewEvents
        do {
            try eventStore.save(calendarEvent, span: .thisEvent)
        } catch let error {
            print("Failed to save event with error: \(error)")
            return
        }
        DispatchQueue.main.async {
            self.openCalendar(with: calendarEvent.startDate)
        }
    }
    
    func openCalendar(with date: Date) {
        let alert = UIAlertController(title: "Open Calendar", message: "The event has been added successfully. Would you like to view it in the Calendar?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            let interval = date.timeIntervalSinceReferenceDate
            let url = URL(string: "calshow:\(interval)")!
            UIApplication.shared.open(url)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0
    }
    
    func loginAlert(with message: String) {
        let alert = UIAlertController(title: "Please log in", message: "You must be logged in to \(message)", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let login = UIAlertAction(title: "Log in", style: .default) { action in
            if let tabVC = self.presentingViewController as? EventTabBarController {
                tabVC.selectedIndex = (tabVC.viewControllers?.count ?? 1) - 1
            }
            alert.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true)
        }
        alert.addAction(cancel)
        alert.addAction(login)
        self.present(alert, animated: true)
    }
    
//    @objc
//    func receiveImage(_ notification: Notification) {
//        guard let imageNot = notification.object as? ImageNotification else {
//            assertionFailure("Object type could not be inferred: \(notification.object as Any)")
//            return
//        }
//        if let eventImageUrl = event?.images.first {
//            if imageNot.url == eventImageUrl  {
//                DispatchQueue.main.async {
//                    self.eventImageView.image = imageNot.image
//                }
//            } else if let profileImage = event?.profileImageURL, profileImage == imageNot.url {
//                DispatchQueue.main.async {
//                    self.hostImageView.image = imageNot.image
//                }
//            }
//        }
//    }
    
//    func observeImage() {
//        NotificationCenter.default.addObserver(self, selector: #selector(receiveImage), name: .imageWasLoaded, object: nil)
//    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "EventsSegue" {
//            guard let eventVC = segue.destination as? EventViewController else { return }
////            eventVC.controller = controller
//        }
//    }
    
    // MARK: - IBActions
    @IBAction func followHost(_ sender: UIButton) {
        
    }
    
    @IBAction func attendEvent(_ sender: UIButton) {
        attendButton.backgroundColor = #colorLiteral(red: 1, green: 0.3987820148, blue: 0.4111615121, alpha: 1)
        attendButton.setTitle("Attending", for: .normal)
        attendButton.setTitleColor(UIColor.white, for: .normal)
//        self.dismiss(animated: true, completion: nil)
//        guard
//            let controller = controller,
//            let event = event
//            else { return }
//        controller.rsvpToEvent(with: event.id) { bool, error in
//            if let error = error {
//                var presentLogin = false
//                switch error {
//                case .ql(let errors):
////                    for qlrr in errors {
////                        if let errorMessage = qlrr.message, errorMessage.contains("No token was found in header") {
//                            presentLogin = true
////                        }
////                    }
//                case .rr(let singleError):
//                    NSLog("\(#file):L\(#line): Configuration failed inside \(#function) with error: \(singleError)")
//                }
//                if presentLogin {
//                    self.loginAlert(with: "rsvp to an event")
//                }
//            }
//            guard let bool = bool else {
//                // TODO: Handle error
//                return
//            }
//            self.updateRSVP(with: bool)
//        }
//        controller.myEvents.append(event)
//        self.performSegue(withIdentifier: "EventsSegue", sender: self)
    }
    
    @IBAction func showMore(_ sender: UIButton) {
        let height = event?.description.height(with: view.frame.width - 32, font: UIFont(name: PoppinsFont.light.rawValue, size: 12)!)
        if descLabelHeightConstraint.constant != height {
            descLabelHeightConstraint.constant = (height ?? 10) + 3
        }
        sender.isHidden = true
    }
    
    
    @IBAction func showInMaps(_ sender: UIButton) {
        if let event = event, let address = event.location?.streetAddress, let zip = event.location?.zipcode {
            let baseURL = URL(string: "http://maps.apple.com/")!
            var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
            let addressQuery = URLQueryItem(name: "address", value: "\(address), \(zip)")
            components?.queryItems = [addressQuery]
            UIApplication.shared.open(components?.url ?? baseURL)
        } else if event?.location == nil {
            print("Event has no location listed!")
        }
    }
    
    @IBAction func showInCalendar(_ sender: Any) {
        eventStore.requestAccess(to: .event) { (granted, error) in
            if let error = error {
                NSLog("\(#file):L\(#line): Unable to request access to calendar in \(#function) with error: \(error)")
                return
            }

            if granted {
            
                guard let event = self.event, let startDate = self.event?.startDate, let endDate = self.event?.endDate else {
                    var message = ""
                    if self.event?.startDate == nil && self.event?.endDate == nil {
                        message = "\(self.event?.title ?? "Event") has no start or end dates. It cannot be added to the calendar"
                    } else if self.event?.startDate == nil && self.event?.endDate != nil {
                        message = "\(self.event?.title ?? "Event") has no start date. It cannot be added to the calendar"
                    } else if self.event?.endDate == nil && self.event?.startDate != nil {
                        message = "\(self.event?.title ?? "Event") has no end date. It cannot be added to the calendar"
                    }
                    let alert = UIAlertController(title: "Unable to add to calendar", message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

                    return
                }
                if startDate > endDate {
                    let alert = UIAlertController(title: "Unable to add event to calendar", message: "The event's start date is after it's endDate. Would you like to add it to calendar with the start and end dates switched?", preferredStyle: .alert)
                    let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
                        self.addToCalendar(event: event, startDate: endDate, endDate: startDate)
                    }
                    alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
                    alert.addAction(yesAction)
                    DispatchQueue.main.sync {
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                self.addToCalendar(event: event, startDate: startDate, endDate: endDate)
            } else {
                print("Access to calendar is not granted on device!") // TODO: Alert user and link to settings to change permissions
            }
        }
    }
}
