chef.controller 'NodeController', ($scope, provision, $routeParams) ->
  do $scope.getNode = (force = false) -> 
    $scope.node = provision.nodes
      data:
        name: $scope.name or $routeParams.name
      force: force

  $scope.$on 'node:reload', -> $scope.getNode yes