# Companies Collection

class Companies extends Backbone.Collection
  model: app.Company
  url: '/companies'

@app = window.app ? {}
@app.Companies = new Companies


