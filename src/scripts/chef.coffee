chef = angular.module 'chef', ['ngRoute', 'ngDragDrop']


chef.config ($routeProvider, $locationProvider) ->

  $routeProvider

    .when '/nodes/',
      controller: 'NodeListController'
      templateUrl: 'node-list.html'

    .when '/nodes/:name',
      redirectTo: (p) -> '/nodes/' + p.name + '/info'

    .when '/nodes/:name/:act',
      reloadOnSearch: no
      controller: 'NodeController'
      controllerAs: 'ctrl'
      templateUrl: 'node.html'

    .when '/roles/',
      controller: 'RoleListController',
      templateUrl: 'role-list.html'

    .when '/roles/:name',
      controller: 'RoleController',
      templateUrl: 'role.html'

  # $routeProvider.otherwise '/nodes/'
  $locationProvider.html5Mode true

chef.run -> console.log 'App started!'

chef.controller 'BodyController', ($scope, provision) ->
  $scope.environments = provision.environments
  $scope.roles = provision.roles()

chef.filter 'durationTime', -> 
  SEC = 1
  MIN = SEC * 60
  HOUR = MIN * 60
  DAY = HOUR * 24

  (time) ->
    return unless time?
    _a = [[DAY, 'd'], [HOUR, 'h'], [MIN, 'm']].reduce (str, dimension) ->
      time -= (value = time / dimension[0] | 0) * dimension[0]
      if value isnt 0 or str.length
        str += ' ' + value + dimension[1]
      return str
    , ''
