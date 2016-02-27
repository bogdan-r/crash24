import _ from 'lodash';

export default function createReducer(initialState, actionHandlers){
  return (state = initialState, action) => {
    const reduceFn = actionHandlers[action.type];
    if (_.isFunction(reduceFn)) {
      return reduceFn(state, action)
    } else {
      return state
    }
  }
}