//
//  MailView.swift
//  CongoMasolo
//
//  Created by Cédric Bahirwe on 05/09/2023.
//

import SwiftUI
import MessageUI

struct MailView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let mailComposer = MFMailComposeViewController()
        mailComposer.navigationBar.prefersLargeTitles = false
        mailComposer.mailComposeDelegate = context.coordinator
        
        mailComposer.setToRecipients([Config.email])
        mailComposer.setSubject(Config.emailSubject)
        mailComposer.setMessageBody("", isHTML: false)
        
        return mailComposer
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
    
    func makeCoordinator() -> Coordinator { Coordinator() }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {

        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {

            controller.dismiss(animated: true)
        }
    }
}

