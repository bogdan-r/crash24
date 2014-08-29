module.exports = function(incidents, location){
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