# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).


## master (unreleased)
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
