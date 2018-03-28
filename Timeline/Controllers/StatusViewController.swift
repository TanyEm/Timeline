//
//  ViewController.swift
//  Timeline
//
//  Created by Tanya Tomchuk on 26/02/2018.
//  Copyright © 2018 Tanya Tomchuk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class StatusViewController: UIViewController {

    // Getted from TimelineTVC
    var statusID = ""
    
    var statusData = TimelineData()
    let activityIndicator = UIActivityIndicatorView()

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(statusID)
        obtainStatus()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = view.center
        activityIndicator.activityIndicatorViewStyle = .gray
        view.addSubview(activityIndicator)


        avatarImage.layer.cornerRadius = avatarImage.frame.size.width * 0.5
        avatarImage.layer.borderWidth = 1.0
        avatarImage.layer.borderColor = UIColor.white.cgColor
        avatarImage.clipsToBounds = true
    }

    func obtainStatus() {
        guard let apiURL = URL(string: "https://mastodon.social/api/v1/statuses/\(statusID)") else {
            return
        }

        activityIndicator.startAnimating()
        Alamofire.request(apiURL).responseJSON { [weak self] (response) in
            let result = response.data
            let json = JSON(result as Any)
            self?.statusData = TimelineData().setFields(json)
            DispatchQueue.main.async { [weak self] in
                self?.setData()
                self?.activityIndicator.stopAnimating()
            }
        }
    }

    // Adding data in view
    func setData() {
        contentLabel.text = self.statusData.content
        nicknameLabel.text = self.statusData.username
        usernameLabel.text = self.statusData.displayName

        guard let avatarURL = statusData.avatar else {
            return
        }
        DispatchQueue.global(qos: .background).async {
            guard
                let url = URL(string: avatarURL),
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data) else {
                    return
            }
            self.avatarImage.image = image
           // self.activityIndicator.stopAnimating()
        }

        if statusData.imageType == "image" || statusData.imageType == "gifv"{
            guard let previewURL = statusData.previewUrl else {
                return
            }

            DispatchQueue.global(qos: .background).async {
                guard
                    let url = URL(string: previewURL),
                    let data = try? Data(contentsOf: url),
                    let image = UIImage(data: data)
                    else {
                    return
                }

            let imageView = UIImageView(image: image)
            self.view.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.leadingAnchor.constraint(equalTo: self.contentLabel.leadingAnchor).isActive = true
                imageView.rightAnchor.constraint(equalTo: self.contentLabel.rightAnchor).isActive = true
                imageView.topAnchor.constraint(equalTo: self.contentLabel.bottomAnchor,
                                               constant: 8).isActive = true
            imageView.contentMode = UIViewContentMode.center
            }
        }
    }
}
