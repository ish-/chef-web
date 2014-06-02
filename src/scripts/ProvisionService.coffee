chef.config ($httpProvider) ->
  $httpProvider.interceptors.push -> 
    request: (config)-> 
      config.headers['X-Sel-Uid'] = localStorage['X-Sel-Uid']
      config

chef.service 'provision', class Provision
  constructor: (@$http) ->
    # wrapper = 
    #   Nodes: $resource '/api/nodes', name: '@name',
    #     query:
    #       isArray: no
    #     update:
    #       url: '/api/nodes/:name'
    #       method: 'PUT'

    # angular.each wrapper, (res, name) =>
    #   angular.extend this, name


  getNode: (name, force) -> @wrap 
    method: 'GET'
    url: '/api/nodes/' + name
    cache: !force

  getNodes: (force) -> @wrap 
    method: 'GET'
    url: '/api/nodes'
    cache: !force

  getRoles: (force) -> @wrap
    method: 'GET'
    url: '/api/roles'
    cache: !force

  wrap: (config, isArray) ->
    w = if isArray then [] else {}
    angular.extend w,
      $pending: yes
      $error: no

    http = @$http config
    
    http.success (data) -> 
      angular.extend w, data
    http.error (err) -> w.$error = err
    http.finally -> w.$pending = no
    return w