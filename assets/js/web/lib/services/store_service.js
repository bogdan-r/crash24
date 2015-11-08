'use strict'

class StoreService {
  constructor (){}

  fetch (){}

  get (){}

  add (record){}

  remove (id){}

  slice (begin, end){}

  static registerStore (){
    return new StoreService()
  }

}

export default StoreService