# README: #

iOS mobile application developed in objective-C in groups of 4. 

NOTE:
- repository only includes codebase and not the related UI images or libraries
	- libraries used: JTCalendar
	- Podfile:
		PODS:
			- OCMock (3.1.2)

		DEPENDENCIES:
		  - OCMock (~> 3.1.2)

		SPEC CHECKSUMS:
		  OCMock: a10ea9f0a6e921651f96f78b6faee95ebc813b92

		COCOAPODS: 0.37.2




## Screen Breakdown ##
* Action Items
* Status 
* Scheduled 
* Request New Process 
* Applications
* Environments
* Resources

## Drop down menu ##
* Settings
* About Us

## Resources/Links ##
### iOS ###
* [Learn Markdown](https://bitbucket.org/tutorials/markdowndemo)
* [Stanford iOS 7 class](https://www.youtube.com/playlist?list=PL9qPUrlLU4jSlonxFqhWKBu2c_sWY-mzg)
* [iOS tutorials raywenderlich](http://www.raywenderlich.com/tutorials), scroll down for Objective-c
* [customize UITableView cells](http://www.appcoda.com/customize-table-view-cells-for-uitableview/)
* [split view in half](http://stackoverflow.com/questions/26896844/in-autolayout-how-can-i-have-view-take-up-half-of-the-screen-regardless-of-ori)

### Objective-C ###
* http://www.tutorialspoint.com/objective_c/index.htm

- - - -

## How to get 
* `$ sudo gem install cocoapods`
* `$ pod setup` anywhere
* `$ pod install`, in the root project directory, where there's the Podfile
* Make sure to always open the Xcode workspace instead of the project file when building your project:
    * `open sda-mobile-app.xcworkspace`