import { combineReducers } from 'redux';
import { routeReducer } from 'redux-simple-router';

import UserReducer from './UserReducer';

const rootReducer = combineReducers({
  routing: routeReducer,
  UserReducer
});

export default rootReducer;
