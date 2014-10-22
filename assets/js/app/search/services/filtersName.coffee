angular.module('app.modules.search.services').factory('filtersNameServ', [
  ()->
    class FiltersName
      filterNameMapping = {
        dateFrom : "от"
        dateTo : "до"
        orderBy : "Сортировка по"
      }

      constructor : ()->

      getFiltersNamesList : (filters)->
        #TODO говно какое то, подумать что можно сделать
        outputFiltersName = []
        date = {
          name : "Даты:",
          values : []
        }

        for filter of filters

          if (filter == 'dateFrom' || filter == 'dateTo') && filters[filter]
            date.values.push("#{filterNameMapping[filter]} #{filters[filter]}")
            continue

          if filter == 'orderBy'
            continue if parseInt(filters[filter].value) == 0
            outputFiltersName.push("#{filterNameMapping[filter]} #{filters[filter].name}")
            continue

          if _.isNull(filters[filter]) || _.isUndefined(filters[filter])
            continue

          outputFiltersName.push("#{filterNameMapping[filter]} #{filters[filter]}")

        if date.values.length > 0
          outputFiltersName.push("#{date.name} #{date.values.join(' ')}")

        outputFiltersName


    new FiltersName()
])