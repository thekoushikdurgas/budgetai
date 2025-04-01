enum Routes {
  splash('/splash'),
  onboard('/onboard'),
  login('/login'),
  register('/register'),
  forgot_password('/forgot_password'),
  update_password('/update_password'),
  sms('/sms'),
  budget('/budget'),
  initial('/'),
  navigation('/navigation'),
  verify('/verify'),
  profile('/profile'),
  settings('/settings'),
  ;

  final String path;
  const Routes(this.path);
}
