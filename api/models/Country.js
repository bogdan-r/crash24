/**
 * Country.js
 *
 * @description :: TODO: You might write a short summary of how this model works and what it represents here.
 * @docs        :: http://sailsjs.org/#!documentation/models
 */

module.exports = {

    attributes: {
        country_id: {
            type : 'int',
            autoIncrement : true,
            unique : true
        },
        title_ru : {
            type : 'string'
        }
    }
};
