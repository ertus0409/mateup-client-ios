//
//  ProjectCell.swift
//  mateup-client
//
//  Created by Guner Babursah on 29/08/2018.
//  Copyright © 2018 Arthur Developments. All rights reserved.
//

import UIKit

class ProjectCell: UITableViewCell {
    
    //IBOutlets:
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var currentTeamLbl: UILabel!
    @IBOutlet weak var lookingForLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(project: Project) {
        titleLbl.text = project.title
        descriptionLbl.text = project.description
        currentTeamLbl.text = project.currentTeam
        lookingForLbl.text = project.lookingFor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
