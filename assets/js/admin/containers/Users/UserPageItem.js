import React from 'react';
import _ from 'lodash';

import UserItemPage from '../../components/Users/ItemPage';

import {connect, createEnterTransitionHook} from "../../decorators";
import * as UserActions from '../../actions/user';

@createEnterTransitionHook(store => (state) => {
  const { dispatch } = store;
  const { UserReducer } = store.getState();
  const userList = UserReducer.get('userList');
  const { id } = state.params;

  console.log(userList.findIndex((item) => {
    return item.get('id') == id;
  }));

  dispatch(UserActions.fetchUser(id))
})

@connect((state, props)=> {
  const { UserReducer } = state;

  const userList = UserReducer.get('userList');

  return {
    userList
  }
})

export default class UserPageItem extends React.Component {
  render() {
    return <div className='row'>
      adasdad
    </div>
  }
}
