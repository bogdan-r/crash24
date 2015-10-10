var util = require('util');
var _ = require('lodash');
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
    var invalidAttrs;
    var exsistErrorValidation = !_.isUndefined(errors.invalidAttributes) && !_.isEmpty(errors.invalidAttributes);
    var exsistRawErrorValidation = ('toJSON' in errors) && errors.toJSON().raw && errors.toJSON().raw.invalidAttributes;

    if(exsistErrorValidation){
        invalidAttrs = errors.invalidAttributes
    }else if(exsistRawErrorValidation){
        invalidAttrs = errors.toJSON().raw.invalidAttributes
    }else{
        return this.get();
    }

    for(var key in invalidAttrs){
        for(var i = 0; i < invalidAttrs[key].length; i++){

            switch (invalidAttrs[key][i].rule){
                case 'required':
                    this.add(key, 'Поле обязательно для заполнения');
                    break
                case 'email':
                    this.add(key, 'Неправильный формат поля email');
                    break
                case 'unique':
                    this.add(key, 'Поле должно быть уникальным');
                    break
                case 'isCurrentUsername':
                    this.add(key, 'Недопустимые символы');
                    break
                case 'uniqueVideo':
                    this.add(key, 'Такое видео уже есть');
                    break
            }
        }
    }
    return this.get();
}

ErrorStorage.prototype.hasError = function(){
    return !_.isEmpty(this._errors)
}


module.exports = ErrorStorage;