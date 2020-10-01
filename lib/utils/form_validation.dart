// returns true if password is between 6 and 30 characters
final validPassword = (String password) =>
    password.length >= 6 && password.length <= 30 ? true : false;
