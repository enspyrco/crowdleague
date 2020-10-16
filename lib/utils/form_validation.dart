// Regex pattern from https://stackoverflow.com/questions/59646163/email-validation-not-working-in-flutter-display-message-even-if-email-address-is
final emailPattern =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
final validEmail = (String email) => RegExp(emailPattern).hasMatch(email);

// returns true if password is between 6 and 30 characters
final validPassword = (String password) =>
    password.length >= 6 && password.length <= 30 ? true : false;

// returns true if repeat password matches password
final validRepeatPassword = (String repeatPassword, String password) =>
    repeatPassword == password ? true : false;
