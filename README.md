
# Shopping List App

An App written with Flutter based on this [course](https://www.udemy.com/user/academind/).

What I implement in this app:
* maintain a state to manipulating widget when processing async (ex: to disable a submit button)
* check whether a widget `BuildContext` is still valid after async process by checking `BuildContext.mounted`
* use `Form` widget to process user input
* use `GlobalKey` for Form key
* use `GlobalKey` `currentState!.reset()` function to reset inputted value
* use `GlobalKey` `currentState!.validate()` function to validating `Form` value
* use `TextFormField` for text based input
* use `DropdownButtonFormField` for dropdown based input
* use `DropdownMenuItem` as to show every item in list as dropdown
* use validator function to validate form field
* use onSaved function whenever submit button is pressed
* There is no such library like Jackson or Gson in Flutter to automatically transform JSON to an object or vice versa. Instead, it is suggested to manually encode or decode the JSON.
* use `http` package to handle HTTP POST and GET request
* use `flutter_dotenv` package to handle environment variable
* use `dynamic` type to handle different type (ex: use as Map value type when decode JSON to an object)
* use `CircularProgressIndicator` to display circular loading animation
* to display an error message, create a field as state. Whenever this field has a value then override the main body widget to show the error message
* use `ListView.builder` with `ListTile` to build a list.
* use `Dismissible` to make a `ListTile` be able to remove by a drag direction
