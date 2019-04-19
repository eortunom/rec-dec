//
//  ShowDataViewController.swift
//  Rec Dec
//
//  Created by Eduardo on 4/19/19.
//  Copyright © 2019 Eduardo. All rights reserved.
//

import UIKit

class ShowDataViewController: UIViewController {

    var show : Show?
    
    @IBOutlet weak var showTitle: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var showSummary: UILabel!
    
    
    //Thanks to Paul B https://stackoverflow.com/questions/25879837/how-to-display-html-formatted-text-in-ios-label/33394209
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showTitle.text = self.show?.name
        showSummary.text = self.show?.summary
        
        if ((self.show?.summary) != nil) {
            let htmlString = self.show?.summary
            // works even without <html><body> </body></html> tags, BTW
            let data = htmlString!.data(using: String.Encoding.unicode)! // mind "!"
            let attrStr = try? NSAttributedString( // do catch
                data: data,
                options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil)
            // suppose we have an UILabel, but any element with NSAttributedString will do
            showSummary.attributedText = attrStr
        }
        
        if let url = show?.getImageURL() {
            showImage!.image = #imageLiteral(resourceName: "placeholderposter")  //Shows a placeholder that will stay there until image loads
            
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    self.showImage!.image = UIImage(data: data!)
                }
            }
        }
        else {
            showImage!.image = #imageLiteral(resourceName: "placeholderposter")
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        performSegue(withIdentifier: "showDataUnwindSegue", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
