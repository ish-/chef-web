chef.controller 'RoleListController', ($scope, $location, provision) ->
  do $scope.getRoles = (force = false) ->
    if force
      $scope.$broadcast 'role:reload'
    $scope.roles = provision.roles force: force

  $scope.showRole = (name) -> $location.path '/roles/' + name
