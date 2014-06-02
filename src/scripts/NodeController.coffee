chef.controller 'NodeController', ($scope, provision, $routeParams) ->
  do $scope.getNode = (force = false) -> 
    $scope.node = provision.getNode($scope.name or $routeParams.name, force)

  $scope.$on 'node:reload', -> $scope.getNode yes