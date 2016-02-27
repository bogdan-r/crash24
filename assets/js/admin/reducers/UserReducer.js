import Immutable, {Map, List} from "immutable";

import * as UserTypes from '../constants/UserTypes';
import createReducer from "../../lib/utils/createReducer";

const initialState = new Map({
  isFetching: false,
  userList: new List(),
  currentUser: new Map()
});

function fetchUsers(state, action) {
  const list = Immutable.fromJS(action.users);

  return state.withMutations(mutableState => {

    mutableState = mutableState.set('userList', list);

    return mutableState
  });
}

function fetchUser(state, action) {
  //TODO переписать с использованием currentUser
  const user = Immutable.fromJS(action.user);

  return state.withMutations(mutableState => {
    var userList = mutableState.get('userList');
    var userIndex = userList.findIndex(item => item.get('id') === user.get('id'));

    if(userIndex > 0) {

    }
    userList.update();

    /*list.update(
       list.findIndex(function(item) {
          return item.get("name") === "third";
       }), function(item) {
          return item.set("count", 4);
       }
     );*/
  })
}

function updateUser(state, action) {

}

const actionHandlers = {
  [UserTypes.FETCH_RECEIVE]: fetchUsers,
  [UserTypes.FETCH_ITEM_RECEIVE]: fetchUser
};

export default createReducer(initialState, actionHandlers)