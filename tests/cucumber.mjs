export default {
  paths: ['features/**/*.feature'],
  require: ['features/step_definitions/**/*.js', 'features/support/**/*.js'],
  format: [
    'progress-bar',
    'json:reports/cucumber-report.json',
    'html:reports/cucumber-report.html'
  ],
  publishQuiet: true
};
