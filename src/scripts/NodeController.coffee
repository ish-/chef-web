chef.controller 'NodeController', ($scope, provision, $routeParams) ->

  node = null
  do $scope.getNode = (force = false) -> 
    # setRunListDirty = (n) ->
    #   return unless n
    #   console.log arguments
    #   node.$runList.$dirty = yes 

    $scope.node = node = provision.nodes
      data:
        name: $scope.name or $routeParams.name
      force: force
    
    # setRunListDirty.unwatch?()

    node.$promise.success ->
      node.$runList = []
      angular.forEach node.run_list, (val) ->
        return unless matched = val.match /^([\S]*)\[([\S]*)\]/
        node.$runList.push
          name: matched[2]
          essence: matched[1]
      # setRunListDirty.unwatch = $scope.$watch 'node.$runList', setRunListDirty


  $scope.$on 'node:reload', -> $scope.getNode yes

  $scope.addToRunList = (essence, name) ->
    return if node.$runList.some (v) -> v.name is name
    node.$runList.$dirty = yes
    node.$runList.push {essence, name}

  $scope.log = (a) -> console.log arguments

  $scope.reorderRunList = (dropIndex, dragIndex) ->
    return if dropIndex is dragIndex
    node.$runList.$dirty = yes
    item = (node.$runList.splice dragIndex, 1)[0]
    node.$runList.splice (if dragIndex < dropIndex then dropIndex-1 else dropIndex), 0, item

  $scope.updateRunList = ->
    run_list = node.$runList.map (v) ->
      v.essence + '[' + v.name + ']'
    node = provision.nodes
      method: 'PUT'
      data:
        name: node.name
        run_list: run_list