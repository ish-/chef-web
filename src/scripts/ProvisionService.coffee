chef.config ($httpProvider) ->
  $httpProvider.interceptors.push -> 
    request: (config)-> 
      config.headers['X-Sel-Uid'] = localStorage['X-Sel-Uid']
      config

chef.service 'provision', class Provision
  constructor: (@$http) ->

  nodes: (opts) -> @wrap angular.extend url: '/api/nodes', opts

  roles: (opts) -> @wrap angular.extend url: '/api/roles', opts

  getCookbooks: (force) ->
    @cookbooks ?= {}
    @$http.get '/api/cookbooks', cache: !force
      .success (d) => angular.extend @cookbooks, d
    return @cookbooks

  getRecipes: (bookName, version, force) -> 
    version.$pending = yes
    @$http.get '/api/cookbooks/' + bookName + '/' + version.version, cache: !force
      .success (d) =>
        version.recipes = d.recipes
        version.$pending = no

  wrap: (opts) ->
    # w = if isArray then [] else {}
    if opts.data? and opts.data.name?
      opts.url += ('/' + opts.data.name)
    opts.cache = !opts.force

    w =
      $pending: yes
      $error: no

    http = @$http opts
    
    http.success (data) -> 
      angular.extend w, data
    http.error (err) -> w.$error = err
    http.finally -> w.$pending = no
    return w