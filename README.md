# BackboneSwift3.0
## Synopsis

BackboneSwift is a simple REST client inspired by Backbone JS. BackboneSwift offers a combination between alamoFire and PromiseKit. 

## Code Example
```swift
import BackboneSwift

// Declare your collection and its models.  
	class Repo : Model {
	    var name: String = ""
	    var html_url: String = ""
	    var score:Int = 0
	}


	class Repositories: BaseCollection <Repo> {
	}

And just use it:

```swift
//GET example 
	var githubRepos = Repositories(baseUrl:"https://api.github.com/search/repositories?q=language:swift&sort=stars&order=desc")

	override func viewDidLoad() {
		super.viewDidLoad()
		githubRepos.fetch().then { (repos:Repositories, _) -> Void in
			self.tableView.reloadData()
		}.catch { (error) in
			print(error)
		}
}
```
Other HTTP methods:
```swift
      // POST
        Repo().create().then { (repo:Repo, metadata:ResponseMetadata)  -> Void in
            // do whatever you want 
        }
        
        // Delete
        Repo().delete().then { (repo:Repo, metadata:ResponseMetadata)  -> Void in
            
        }
        // Update
        Repo().save().then { (repo:Repo, metadata:ResponseMetadata) -> Void in
            
        }
```

## Motivation

Swift is a strong typed lang that gets very complicated when creating an object from a json file. 
Backbone swift abstracts that complexity away . handly with the optionals unwraping , the parsing 
    Also backbone swift offers a promise oriented sintaxis to avoid the 'callback hell' 

## Installation
just copy this into your pod file 

	$ pod 'BackboneSwift'

## Tests

Download the code and install the pod file. 
 pod install

run the test target or use the Demo app included

## Contributors

Fer Canon , Miguel Martin , Mario Rosales

## License

Copyright 2017 Fer Canon 

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
