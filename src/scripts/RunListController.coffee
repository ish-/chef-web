chef.controller 'RunListController', class RunListController
  constructor: (@$scope, @provision) ->
    ($scope.node || $scope.role).$promise.success @build
    
  build: (d) =>
    @$scope.runList = []
    angular.forEach d.run_list, (val) =>
      return unless matched = val.match /^([\S]*)\[([\S]*)\]/
      @$scope.runList.push
        name: matched[2]
        essence: matched[1]

  add: (essence, name) ->
    return if @$scope.runList.some (v) -> v.name is name
    @$scope.runList.$dirty = yes
    @$scope.runList.push {essence, name}

  # $scope.log = (a) -> console.log arguments

  reorder: (dropIndex, dragIndex) ->
    return if dropIndex is dragIndex
    @$scope.runList.$dirty = yes
    item = (@$scope.runList.splice dragIndex, 1)[0]
    @$scope.runList.splice (if dragIndex < dropIndex then dropIndex-1 else dropIndex), 0, item