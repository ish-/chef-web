chef.config ($httpProvider) ->
  $httpProvider.interceptors.push -> 
    request: (config)-> 
      config.headers['X-Sel-Uid'] = localStorage['X-Sel-Uid']
      config

chef.service 'provision', class Provision
  constructor: (@$http) ->
    @environments = []
    @environments.$xhr = $http.get '/api/environments'
      .success (d) =>
        angular.forEach d, (env, name) =>
          @environments.push env = 
            name: name
            recipes: []
          if env.name is '_default'
            @environments.current = env
      .then @_getRecipes



  nodes: (opts) -> @wrap angular.extend url: '/api/nodes', opts
  roles: (opts) -> @wrap angular.extend url: '/api/roles', opts

  _getRecipes: (force) => 
    env = @environments.current
    @$http.get '/api/environments/' + env.name + '/recipes', cache: !force
      .success (d) -> env.recipes = d

  wrap: (opts) ->
    w = if opts.isArray then [] else {}
    if opts.data? and opts.data.name?
      opts.url += ('/' + opts.data.name)
    opts.cache = !opts.method and !opts.force

    w.$pending = yes
    w.$error = no

    w.$promise = http = @$http opts
    
    http.success (data) -> 
      angular.extend w, data
      w.$success = yes
    http.error (err) -> w.$error = err
    http.finally -> w.$pending = no
    return w