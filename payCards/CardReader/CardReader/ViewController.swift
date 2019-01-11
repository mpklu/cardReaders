//
//  ViewController.swift
//  CardReader
//
//  Created by Kun Lu on 1/6/19.
//  Copyright © 2019 Kun Lu. All rights reserved.
//

import UIKit
import PayCardsRecognizer

class ViewController: UIViewController, PayCardsRecognizerPlatformDelegate {
	@IBOutlet var cardNumber: UILabel!
	@IBOutlet var cardHolder: UILabel!
	@IBOutlet var expiration: UILabel!

	var recognizer: PayCardsRecognizer!
	var card: CreditCard? {
		didSet {
			if let myCard = card {
				cardNumber.text = myCard.number
				cardHolder.text = myCard.holderName
				expiration.text = myCard.expMon + "/" + myCard.expYear
			} else {
				cardNumber.text = ""
				cardHolder.text = ""
				expiration.text = ""
			}
		}
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		recognizer = PayCardsRecognizer(delegate: self, resultMode: .sync, container: self.view, frameColor: .green)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		recognizer.startCamera()
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)

		recognizer.stopCamera()
	}

	// PayCardsRecognizerPlatformDelegate

	func payCardsRecognizer(_ payCardsRecognizer: PayCardsRecognizer, didRecognize result: PayCardsRecognizerResult) {
		card = CreditCard(number: result.recognizedNumber ?? "xxxx xxxx xxxx xxxx",
						  holderName: result.recognizedHolderName ?? "unknown",
						  expMon: result.recognizedExpireDateMonth ?? "00",
						  expYear: 	result.recognizedExpireDateYear ?? "00")

		Swift.print("Card Number: \(card!.number)")
	}
}

struct CreditCard {
	var number: String
	var holderName: String
	var expMon: String
	var expYear: String
}
