# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).


## [2.0.0] - 2018-02-02
### Changed:
- The payment token can now be a string representing the card details in the case of Stripe, or a struct containing payment id and payer id in the case of PayPal
- The line that sets `I18n.enforce_available_locales = false`, and that is needed for the Money gem to work properly, was extracted out of the gem, and it is now the responsibility of the consumer to set it.
- The adapters now take both the input data and the payment data, and merge both into an adapted object that can be passed to Salesforce.
- The supporter and donation validators have been merged into one validator and moved one level up, to be used in the Salesforce database.

### Added:
- An implementation of PayPal one-off donations
- An extra parameter `method` in the donation data struct (and test structs), to specify if the payment method is Stripe or PayPal.
- An extra step for PayPal donations, hence the `donation_system/paypal_wrapper/payment_creator` is also exposed
- A Utils class to extract all generic operations like amount conversions or checking if a parameter is valid, which are independent of the gem business logic but used accross several classes.
- The payment gateway selction has been split into the pure business logic, which now lives in the `PaymentGateway` class, and what's purely configuration, which lives in a new `Selector` module, and allows to select gateway and adapter depending on the payment method and type.


## [1.0.0] - 2018-01-22
### Changed:
- Since now there are two types of Stripe payment, the validator was moved one level up
- The Stripe one-off class now uses the new template for Stripe resources
- The Stripe one-off class was renamed from Gateway to OneOff
- Separation of the Stripe validator into the validation part, which is the same for all Stripe objects, and the field-generation part, which is different per object.
- The donation validator in Salesforce checks if the payment is one-off or recurring, in order to generate the right fields to create a donation in Salesforce.
- Salesforce classes now use the upper level result struct.

### Added:
- An implementation of Stripe recurring donations
- A new class for a generic payment gateway that selects between Stripe one-off or recurring.
- A template for Stripe objects behavior which acts as a factory of Stripe objects
- An extra parameter, `type` in the donation data struct (and test structs), to specify if the payment is a one-off or recurring donation.
- An adapter to convert payment objects obtained from the different payment gateways into an object that Salesforce classes can use to generate the relevant fields
- A donation-fields generator in Salesforce, extracted out of the old validator. It generates the relevant fields for a one-off or recurring donation.

## [0.2.0] - 2017-12-13
### Changed:
* The tests now consistently use the same request object, which is equal to the one we are sending in the webapp
* The Salesforce classes now receive both the request data and the payment data returned by the payment gateway.
* The donation validator now takes the amount from the payment data and checks that it is an integer (Stripe returns an integer amount in cents)

### Added
* A new DonationData object to wrap the request data and payment data before sending them to the Salesforce classes.
* A stub for the mailer in the payment tests
* A new payment object for the tests
* Some of the Salesforce extra fields that the old site was sending. These were added to the supporter and donation validators
* Dependency tracking through gemnasium and depfu, so that we can keep gem versions up to date
* Codeclimate configuration file so that we can track code smells and maintainability.

### Bugfixes
* Fixed a bug in which emails were being sent in tests
* The donation validator converts the money into currency units, before it was sending amounts in cents, making it look like the donation was bigger in Salesforce.


## [0.1.0] - 2017-11-15

- Launched!
