import React from 'react';
import _ from 'lodash';

import UserListPage from '../../components/Users/ListPage';

import {connect, createEnterTransitionHook} from "../../decorators";
import * as UserActions from '../../actions/user';

@createEnterTransitionHook(store => (state) => {
  const {dispatch} = store;

  dispatch(UserActions.fetchUsers())
})

@connect((state, props)=> {
  const { UserReducer } = state;

  const userList = UserReducer.get('userList');

  return {
    userList
  }
})

export default class UserPageList extends React.Component {

  render() {
    return <div className='row'>
      <UserListPage userList={this.props.userList}/>
    </div>
  }
}

