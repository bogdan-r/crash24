var util = require('util');
var _ = require('underscore');
function ErrorStorage (errors){
    this._errors = {};
    if(typeof errors == 'object'){
        for(var key in errors){
            this.add(key, errors[key]);
        }
    }else if(typeof errors == 'number'){
        switch(errors) {
            case 400:
                this.add('error', 'Неверный запрос');
                break;
            case 403:
                this.add('error', 'Доступ запрещен');
                break;
            case 500:
                this.add('error', 'Ошибка сервера');
                break;
        }
    }
}

ErrorStorage.prototype.add = function(errName, value){
    if(util.isArray(this._errors[errName])){
        this._errors[errName].concat(value);
    }else{
        this._errors[errName] = [].concat(value);
    }
};

ErrorStorage.prototype.delete = function(errName, value){

    var errorsData = this._errors[errName];
    var isArrayErrData = util.isArray(errorsData);
    if(value && isArrayErrData && errorsData.length > 1){
        for(var i = 0; i < errorsData.length; i++){
            if (errorsData[i] === value) errorsData.splice(i, 1);
        }
    }else{
        delete this._errors[errName]
    }
};

ErrorStorage.prototype.get = function(errName){

    if(errName){
        return this._errors[errName]
    }else{
        return {errors : this._errors}
    }
}
ErrorStorage.prototype.transformValidateErrors = function(errors){

    if(errors.invalidAttributes && !_.isEmpty(errors.invalidAttributes)){
        for(var key in errors.invalidAttributes){
            for(var i = 0; i < errors.invalidAttributes[key].length; i++){

                switch (errors.invalidAttributes[key][i].rule){
                    case 'required':
                        this.add(key, 'Поле обязательно для заполнения');
                        break
                    case 'email':
                        this.add(key, 'Неправильный формат поля email');
                        break
                    case 'unique':
                        this.add(key, 'Поле должно быть уникальным');
                        break
                }
            }
        }
        return this.get();
    }
}

ErrorStorage.prototype.hasError = function(){
    return !_.isEmpty(this._errors)
}


module.exports = ErrorStorage;