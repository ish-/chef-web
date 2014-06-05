chef = angular.module 'chef', ['ngRoute', 'ngDragDrop']


chef.config ($routeProvider, $locationProvider) ->

  $routeProvider

    .when '/nodes/',
      controller: 'NodeListController'
      templateUrl: 'node-list.html'

    .when '/nodes/:name',
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
  # $scope.roles = provision.roles()
  # $scope.cookbooks = provision.getCookbooks()
  # $scope.getRecipes = provision.getRecipes.bind provision
  $scope.environments = provision.environments
  $scope.roles = provision.roles()