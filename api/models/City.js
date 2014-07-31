/**
 * City.js
 *
 * @description :: TODO: You might write a short summary of how this model works and what it represents here.
 * @docs        :: http://sailsjs.org/#!documentation/models
 */

module.exports = {

    attributes: {
        city_id : {
            type : 'int',
            autoIncrement : true,
            unique : true
        },
        country_id : {
            type : 'int'
        },
        important : {
            type : 'string',
            enum : ['t', 'f']
        },
        region_id : {
            type : 'int'
        },
        title_ru : {
            type : 'string'
        },
        area_ru : {
            type : 'string'
        },
        region_ru : {
            type : 'string'
        }

    }
};

