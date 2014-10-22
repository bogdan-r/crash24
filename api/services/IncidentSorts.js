
function IncidentSorts (){}

IncidentSorts.sortByDistance = function(incidents, location){
    return incidents.sort(function(a, b){
        var aCurrentLat = location.lat - a.lat;
        var aCurrentLong = location.long - a.long;
        var bCurrentLat = location.lat - b.lat;
        var bCurrentLong = location.long - b.long;

        var az = Math.sqrt(aCurrentLat * aCurrentLat + aCurrentLong * aCurrentLong);
        var bz = Math.sqrt(bCurrentLat * bCurrentLat + bCurrentLong * bCurrentLong);
        if(az == bz ) return 0;
        return (az < bz) ? -1 : 1;
    })
}

IncidentSorts.groupByLocation = function(incidents, boundLocation, boundUserCity){
    var ACCURACY = 0.0005;
    var incidentByGroup = {
        groupByLocation : [],
        groupByUserLocation : [],
        groupByOther : []
    }

    var checkIncludes = function(point, range, accuracy){
        if(accuracy === undefined){accuracy = 0}
        return (point + accuracy) >= parseFloat(range[0]) && point <= (parseFloat(range[1]) + accuracy);
    }

    for(var i = 0; i < incidents.length; i++){
        var hitInLat = checkIncludes(incidents[i].lat, [boundLocation[0][0], boundLocation[1][0]], ACCURACY)
        var hitInLong = checkIncludes(incidents[i].long, [boundLocation[0][1], boundLocation[1][1]], ACCURACY)

        if(hitInLat && hitInLong){
            incidentByGroup.groupByLocation.push(incidents[i])
        }else{
            var hitInUserLocationLat = checkIncludes(incidents[i].lat, [boundUserCity[0][0], boundUserCity[1][0]], ACCURACY)
            var hitInUserLocationLong = checkIncludes(incidents[i].long, [boundUserCity[0][1], boundUserCity[1][1]], ACCURACY)
            if(hitInUserLocationLat && hitInUserLocationLong){
                incidentByGroup.groupByUserLocation.push(incidents[i])
            }else{
                incidentByGroup.groupByOther.push(incidents[i])
            }
        }
    }


    return incidentByGroup
}

module.exports = IncidentSorts