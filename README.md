# Template App with [flutter_bloc](https://pub.dev/packages/flutter_bloc)

<p>This project provides an application template using the bloc state management method with Flutter. The project includes user CRUD (Create, Read, Update, Delete) operations and authentication, serving as a realistic example for real-world scenarios. In order to prove that native-looking applications can be developed with Flutter if desired, Cupertino widgets were preferred instead of Material widgets in the user interface of the project.<br>The current latest version of Flutter [3.24.3] was used during the development process.</p>

![TEMPLATE APP](https://github.com/durgas/budgetai/assets/76053138/89196cba-4119-48fb-a1c3-8b32e712da73)

## Getting Started

### API Integration
<p>A Rest API is used for user operations, and the API code is not included in this repository. You can develop API endpoints according to the UserModel class in the project to make it suitable for use. You need to update the BASE_URL value in the '.env' file content to match your API structure. You can find the naming used for CRUD and authentication endpoints in the UserService class, and you may need to revise it according to your API structure.</p>

#
### Firebase Integration
<p>The project uses Storage for uploading images and accessing them via URL, Extensions and Firestore Database for email infrastructure and Functions for triggering email sending. Therefore, you will need a Firebase project. Since the firebase_options.dart file is not included in the Template App project content, it will throw an error when you clone the repo. Perform Firebase integration to add this file to the project.</p>

#
### Firebase Trigger Email Extension Integration
<p>For email verification, a verification code is sent to the email address provided by the user. The Firebase Trigger Email extension is used for email infrastructure. You need to activate this extension via the Firebase console. Besides verification code sending, the email infrastructure is used for different scenarios as well. Email sending is triggered by Firebase Cloud Functions.</p>

#
### Firebase Cloud Functions Integration
<p>The project already includes the functions folder and firebase.json file to be added with Cloud Functions. If you specify that the functions/index.js file should be overwritten while integrating cloud functions, you will delete the cloud functions that you need to deploy for the email infrastructure from the file. You can skip the overwrite step with the "No" option, or if it is overwritten, you can copy and deploy the functions again from the relevant file in this Github repo.</p>

#
## Screenshoots
###### Hover the mouse cursor over the images for explanations.
<img src="https://github.com/durgas/budgetai/assets/76053138/0c261807-6554-4296-83ba-ca2007fd81e1" title="Login Screen" height="500">
<img src="https://github.com/durgas/budgetai/assets/76053138/f2ca64dd-1c0e-4cab-917b-10422d5152ad" title="Forgot Password Screen" height="500">
<img src="https://github.com/durgas/budgetai/assets/76053138/c9b5879d-d167-47d1-aee2-c2ea1b04e828" title="Register Screen" height="500">
<img src="https://github.com/durgas/budgetai/assets/76053138/4af3da17-a98c-409b-a5d2-ab70384948c6" title="Verificaton Code Screen" height="500">
<img src="https://github.com/durgas/budgetai/assets/76053138/78905109-f0b5-489c-a07d-77a46c16a7a9" title="Verification code and welcome emails" height="500">
<img src="https://github.com/durgas/budgetai/assets/76053138/c290e25a-38af-405f-a2a8-cea9cd27d8b5" title="Update Profile Screen" height="500">
<img src="https://github.com/durgas/budgetai/assets/76053138/681425e4-9848-4892-9b4a-eeac1a9f1b44" title="View/Edit Profile Photo Screen" height="500">
<img src="https://github.com/durgas/budgetai/assets/76053138/74a98cd5-9317-4889-b168-6d4be3086ce6" title="Home Screen" height="500">
<img src="https://github.com/durgas/budgetai/assets/76053138/4f0c7aed-be1e-4239-9893-6b8632367544" title="Settings Screen" height="500">
<img src="https://github.com/durgas/budgetai/assets/76053138/dd0145be-f13c-4043-a096-5d63132750a9" title="Change app theme" height="500">
<img src="https://github.com/durgas/budgetai/assets/76053138/40b2e5e8-84c4-424f-a94f-67bc9ad8d599" title="Change app language" height="500">

## Problems you may encounter
<p>To prevent [...lowerCamelCase identifier] problems caused by the easy_localization package, it will be sufficient to add the [constant_identifier_names: false] definition under the [rules:] statement in the analysis_options.yaml file in the project directory.</p>

![problem_1](https://github.com/durgas/budgetai/assets/76053138/d1ca7d89-4067-432d-8c01-7c0a3b72f232)

## Things to know
<p>After adding new string definitions to the [language-code].json (such as en.json, tr.json) file, run the following codes in the terminal one by one so that the easy_localization structure can recognize these changes:</p>

```
dart run easy_localization:generate --source-dir assets/translations
```

```
dart run easy_localization:generate -S assets/translations -f keys -o locale_keys.g.dart
```
