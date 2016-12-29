//
//  FirstViewController.swift
//  NotificationTest
//
//  Created by The Coca Cola User on 12/28/16.
//  Copyright © 2016 foreignlegion. All rights reserved.
//

import UIKit
import UserNotificationsUI //framework to customize the notification
import  UserNotifications

class FirstViewController: UIViewController,UNUserNotificationCenterDelegate {

	let requestIdentifier = "SampleRequest" //identifier is to cancel the notification request

	let myNotification = Notification.Name(rawValue:"MyNotification")

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		triggerNotification()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction  func triggerNotification(){
		
		print("notification will be triggered in five seconds..Hold on tight")
		let content = UNMutableNotificationContent()
		content.title = "Intro to Notifications"
		content.subtitle = "Lets code,Talk is cheap"
		content.body = "Sample code from WWDC"
		content.sound = UNNotificationSound.default()
		
		//To Present image in notification
		if let path = Bundle.main.path(forResource: "monkey", ofType: "png") {
			let url = URL(fileURLWithPath: path)
			
			do {
				let attachment = try UNNotificationAttachment(identifier: "sampleImage", url: url, options: nil)
				content.attachments = [attachment]
			} catch {
				print("attachment not found.")
			}
		}
		
		// Deliver the notification in five seconds.
		let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 5.0, repeats: false)
		let request = UNNotificationRequest(identifier:requestIdentifier, content: content, trigger: trigger)
		
		UNUserNotificationCenter.current().delegate = self
		UNUserNotificationCenter.current().add(request){(error) in
			
			if (error != nil){
				
				print(error?.localizedDescription)
			}
		}
	}
	
	@IBAction func stopNotification(_ sender: AnyObject) {
		
		print("Removed all pending notifications")
		let center = UNUserNotificationCenter.current()
		center.removePendingNotificationRequests(withIdentifiers: [requestIdentifier])
		
	}
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		
		print("Tapped in notification")
		let id = response.notification.request.identifier
	}
	
	//This is key callback to present notification while the app is in foreground
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		
		print("Notification being triggered")
		//You can either present alert ,sound or increase badge while the app is in foreground too with ios 10
		//to distinguish between notifications
		if notification.request.identifier == requestIdentifier{
			
			completionHandler( [.alert,.sound,.badge])
			
		}
	}

}
