chef = angular.module 'chef', ['ngRoute', 'ui.buttons']


chef.config ($routeProvider, $locationProvider) ->

  $routeProvider

    .when '/nodes/',
      controller: 'NodeListController'
      templateUrl: 'node-list.html'

    .when '/nodes/:name',
      controller: 'NodeController'
      templateUrl: 'node.html'

    .when '/roles/:name',
      controller: 'RoleListController',
      templateUrl: 'role-list.html'

  # $routeProvider.otherwise '/nodes/'
  $locationProvider.html5Mode true

chef.run -> console.log 'App started!'

chef.controller 'BodyController', ($scope, provision) ->
  # $scope.roles = provision.roles()
  $scope.cookbooks = provision.getCookbooks()
  $scope.getRecipes = provision.getRecipes.bind provision