# BackboneSwift3.0
## Synopsis

BackboneSwift is a simple REST client inspired by Backbone JS. BackboneSwift offers a combination between [Alamofire](https://github.com/Alamofire/Alamofire) , [PromiseKit](https://github.com/mxcl/PromiseKit) and [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) that will allow you create models and collection easly. 

## Code Example
Declare your custom models and collections
```swift
import BackboneSwift

// Declare a model that inherits from BackboneSwit.  
	class Repo : Model {
	    var name: String = ""
	    var html_url: String = ""
	    var score:Int = 0
	}


	class Repositories: BaseCollection <Repo> { 
	}
```

And just use them:    
```swift
//GET example 
	var githubUrl = "https://api.github.com/search/repositories?q=language:swift&sort=stars&order=desc"
	var githubRepos = Repositories(baseUrl:)

	override func viewDidLoad() {
		super.viewDidLoad()
		//http GET
		githubRepos.fetch().then { (repos:Repositories, _) -> Void in
			self.tableView.reloadData()
		}.catch { (error) in
			// This will always get called if something goes wrong
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
        
        // DELETE
        Repo().delete().then { (repo:Repo, metadata:ResponseMetadata)  -> Void in
          // do whatever you want   
        }
        // UPDATE
        Repo().save().then { (repo:Repo, metadata:ResponseMetadata) -> Void in
           // do whatever you want  
        }
```

## Motivation

Swift is a strong typed lang that could get very tricky when creating an object from a json file. 
BackboneSwift abstracts that complexity away by handling with the optionals unwraping , the responses of http connections and the asynch of all of them.   BackboneSwift also offers a Promise oriented sintaxis to avoid the 'callback hell'. We are big fans of using promises in Swift.

## Installation
just copy this into your pod file 

	$ pod 'BackboneSwift'

## Tests

Download the code and install the pod file. 
 pod install

Run the test target or use the Demo app included

## Contributors
[Fer Canon ](https://github.com/supersabbath)
[Miguel Martin ](https://github.com/mikemm13)
[Mario Rosales](https://github.com/mariorosales)
## License

Copyright 2017 Fer Canon 

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
