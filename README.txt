http://tomazy.github.io/angular-quiz/

Requirements:
  gem install haml

Installation:
  npm install
  bower install

Development
  cp config.json.template config.json
  vim config.json # configure the app
  grunt test:e2e
  grunt test:watch
  grunt server

Deployment
  grunt build
  # copy `dist` directory to your server
