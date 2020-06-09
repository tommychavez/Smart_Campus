

import UIKit
import Firebase

class UserCell: UITableViewCell {
   
    var buttonAct: ((Any) -> Void)?
    
    var message: Message? {
        didSet {
            setupNameAndProfileImage()
           // profileImageView.image = UIImage(named: "Unknown")
            guard var toid = message?.chatPartnerId() else { return }
            Database.database().reference().child("users").child(toid).observeSingleEvent(of: .value, with: { (snapshot) in
                //print(snapshot.value ?? "")
                
                let dictionary = snapshot.value as? [String: Any]
                let username = dictionary?[ "username"] as? String
                self.nameLabel.text = username
                guard let profileimageURL = dictionary?[ "ProfileImage"] as? String else {return}
                self.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileimageURL)
            //let newname = idtoname(toId: (message?.chatPartnerId())!)
            })
        
            
            detailTextLabel?.text = message?.text
            
            if let seconds = message?.timestamp?.doubleValue {
                let timestampDate = Date(timeIntervalSince1970: seconds)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                timeLabel.text = dateFormatter.string(from: timestampDate)
            }
            
            
        }
     
        
    }
    
    fileprivate func setupNameAndProfileImage() {
        
        if let id = message?.chatPartnerId() {
            let ref = Database.database().reference().child("users").child(id)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.textLabel?.text = dictionary["name"] as? String
                    
                    if let profileImageUrl = dictionary["profileImageUrl"] as? String {
                        self.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
                    }
                }
                
            }, withCancel: nil)
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var friendid = ""
    
    let nameLabel: UILabel = {
        let label = UILabel()
        //        label.text = "HH:MM:SS"
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let acceptButton: UIButton = {
        let buttonView = UIButton()
        buttonView.backgroundColor =
            UIColor.green; buttonView.translatesAutoresizingMaskIntoConstraints = false
        
    buttonView.layer.cornerRadius = 5
        buttonView.setTitle("Accept", for: .normal)
        buttonView.layer.masksToBounds = true
        return buttonView
    }()
    
    let declineButton: UIButton = {
        let buttonView = UIButton()
       buttonView.backgroundColor =
        UIColor.red; buttonView.translatesAutoresizingMaskIntoConstraints = false
          buttonView.layer.cornerRadius = 5
        buttonView.setTitle("Decline", for: .normal)
      //  buttonView.titleLabel?.text = "Decline"
        buttonView.layer.masksToBounds = true
        return buttonView
    }()
    
    
    let timeLabel: UILabel = {
        let label = UILabel()
        //        label.text = "HH:MM:SS"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let friendLabel: UILabel = {
        let label = UILabel()
        //        label.text = "HH:MM:SS"
         label.font = UIFont.boldSystemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(declineButton)
        addSubview(acceptButton)
        addSubview(profileImageView)
        addSubview(timeLabel)
        addSubview(nameLabel)
        addSubview(friendLabel)
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: detailTextLabel!.topAnchor).isActive = true
         nameLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
         nameLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        //ios 9 constraint anchors
        //need x,y,width,height anchors
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        //need x,y,width,height anchors
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
        
        acceptButton.rightAnchor.constraint(equalTo: declineButton.leftAnchor, constant: -10).isActive = true
       acceptButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        acceptButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        acceptButton.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -20).isActive = true
        
        declineButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
         declineButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
         declineButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
         declineButton.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -20).isActive = true
        
        friendLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        friendLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        friendLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        friendLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        acceptButton.addTarget(self, action: #selector(acceptFunc), for: .touchUpInside)
        
    }
    
    @objc func acceptFunc(sender: Any){
        self.buttonAct?(sender)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
