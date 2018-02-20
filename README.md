# NetronixMeasurements
Test application for Netronix job application. It shows values from sensor in realtime.
Red cell means data is not correct and you need to check corresponging sensor.
[https://github.com/netronixgroup/ios-dev/blob/master/TestTask.md]{https://github.com/netronixgroup/ios-dev/blob/master/TestTask.md}

# Environment
* Xcode 7.3.1
* macOS High Sierra Version 10.13.3

# How to check
* Download
* Open NetronixMeasurements/NetronixMeasurements.xcworkspace
* Build
* Check

# 3rd party libraries
* https://github.com/neilco/EventSource Copyright (c) 2013 Neil Cowburn (http://github.com/neilco/) MIT License

# Known issues
* ~Some repeated code (ILMeasurement object creation)~
* No tests
* Not optimized UITableView inserting (just reloadData). It can increase memory consuption
* Not optimized errors messages. Need to use one source for error codes and messages
* Not use l10n and i18n


# Roadmap
* ~Use single ILMeasurement initializer~
* ~Use single set of helpers for sanitizing and mapping JSONObject and ILMeasurement properties~
* ~Use queue of last 50 elements for show values in table.~
* Use DB (Realm) for storing values
* Use library for plot rendering instead of UITableView