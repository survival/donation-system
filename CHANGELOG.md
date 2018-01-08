# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).


## master - (unreleased)
### Changed:
- Since now there are two types of Stripe payment, the validator was moved one level up
- The Stripe one-off class now uses the new template for Stripe resources
- The Stripe one-off class was renamed from Gateway to OneOff
- Separation of the Stripe validator into the validation part, which is the same for all Stripe objects, and the field-generation part, which is different per object.

### Added:
- An implementation of Stripe recurring donations
- A new class for a generic payment gateway that selects between Stripe one-off or recurring.
- A template for Stripe objects behavior which acts as a factory of Stripe objects
- An extra parameter, `type` in the donation data struct (and test structs), to specify if the payment is a one-off or recurring donation.

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
